#!/usr/bin/env python3
"""Fetch public furniture image URLs from official image APIs.

The script reads API credentials from .env, keeps the original RTDB export
read-only, and writes tools/image_url_mapping.json for the RTDB update step.
"""

from __future__ import annotations

import json
import os
import sys
import time
import urllib.error
import urllib.parse
import urllib.request
from collections import Counter
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
ORIGINAL_JSON = ROOT / "tools" / "house-server-rtdb-original.json"
MAPPING_JSON = ROOT / "tools" / "image_url_mapping.json"
ENV_FILE = ROOT / ".env"

PEXELS_SEARCH_URL = "https://api.pexels.com/v1/search"
UNSPLASH_SEARCH_URL = "https://api.unsplash.com/search/photos"


STYLE_TERMS = {
    "classic": "classic luxury",
    "industrial": "industrial style",
    "modern": "modern minimalist",
    "natural": "natural wood",
    "zen": "japanese zen natural",
}

TYPE_TERMS = {
    "bed": "bed bedroom furniture",
    "chair": "chair furniture",
    "dresser": "dresser chest of drawers furniture",
    "sofa": "sofa living room furniture",
    "table": "dining table furniture",
}


def load_env(path: Path) -> dict[str, str]:
    values: dict[str, str] = {}
    if not path.exists():
        return values

    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        value = value.strip().strip('"').strip("'")
        values[key.strip()] = value
    return values


def iter_products(data: dict[str, Any]) -> list[dict[str, Any]]:
    products: list[dict[str, Any]] = []
    root = data.get("all", data)
    if not isinstance(root, dict):
        return products

    for style, type_map in root.items():
        if not isinstance(type_map, dict):
            continue
        for furniture_type, item_map in type_map.items():
            if not isinstance(item_map, dict):
                continue
            for item_key, item in item_map.items():
                if not isinstance(item, dict):
                    continue
                products.append(
                    {
                        "path": f"all/{style}/{furniture_type}/{item_key}",
                        "style": str(style),
                        "type": str(furniture_type),
                        "itemKey": str(item_key),
                        "item": item,
                    }
                )
    return products


def build_query(style: str, furniture_type: str, name: str) -> str:
    style_term = STYLE_TERMS.get(style, style)
    type_term = TYPE_TERMS.get(furniture_type, f"{furniture_type} furniture")
    room_term = {
        "bed": "interior",
        "chair": "interior",
        "dresser": "bedroom interior",
        "sofa": "interior",
        "table": "interior",
    }.get(furniture_type, "interior")

    return f"{style_term} {type_term} {room_term} no people"


def request_json(url: str, headers: dict[str, str]) -> tuple[int, dict[str, Any] | None, str | None]:
    request = urllib.request.Request(url, headers=headers)
    try:
        with urllib.request.urlopen(request, timeout=20) as response:
            body = response.read().decode("utf-8")
            return response.status, json.loads(body), None
    except urllib.error.HTTPError as error:
        message = f"HTTP {error.code}"
        if error.code == 429:
            message = "RATE_LIMIT"
        return error.code, None, message
    except urllib.error.URLError as error:
        return 0, None, f"REQUEST_ERROR: {error.reason}"
    except TimeoutError:
        return 0, None, "REQUEST_TIMEOUT"


def fetch_pexels(query: str, api_key: str) -> tuple[list[dict[str, Any]], str | None]:
    params = urllib.parse.urlencode(
        {
            "query": query,
            "orientation": "landscape",
            "per_page": 15,
        }
    )
    status, data, error = request_json(
        f"{PEXELS_SEARCH_URL}?{params}",
        {"Authorization": api_key, "User-Agent": "my-home-catalog-image-mapper/1.0"},
    )
    if error is not None:
        return [], error
    if status < 200 or status >= 300 or data is None:
        return [], f"HTTP {status}"

    photos = data.get("photos", [])
    if not isinstance(photos, list):
        return [], "INVALID_RESPONSE"

    results: list[dict[str, Any]] = []
    for photo in photos:
        if not isinstance(photo, dict):
            continue
        src = photo.get("src")
        if not isinstance(src, dict):
            continue
        image_url = src.get("large2x") or src.get("large") or src.get("original")
        if not isinstance(image_url, str) or not image_url.startswith("https://"):
            continue
        results.append(
            {
                "newImage": image_url,
                "source": "pexels",
                "photographer": str(photo.get("photographer", "")),
                "sourcePage": str(photo.get("url", "")),
                "imageId": str(photo.get("id", "")),
            }
        )
    return results, None


def fetch_unsplash(query: str, access_key: str) -> tuple[list[dict[str, Any]], str | None]:
    params = urllib.parse.urlencode(
        {
            "query": query,
            "orientation": "landscape",
            "per_page": 15,
            "content_filter": "high",
        }
    )
    status, data, error = request_json(
        f"{UNSPLASH_SEARCH_URL}?{params}",
        {
            "Authorization": f"Client-ID {access_key}",
            "Accept-Version": "v1",
            "User-Agent": "my-home-catalog-image-mapper/1.0",
        },
    )
    if error is not None:
        return [], error
    if status < 200 or status >= 300 or data is None:
        return [], f"HTTP {status}"

    photos = data.get("results", [])
    if not isinstance(photos, list):
        return [], "INVALID_RESPONSE"

    results: list[dict[str, Any]] = []
    for photo in photos:
        if not isinstance(photo, dict):
            continue
        urls = photo.get("urls")
        user = photo.get("user")
        links = photo.get("links")
        if not isinstance(urls, dict):
            continue
        image_url = urls.get("regular") or urls.get("full")
        if not isinstance(image_url, str) or not image_url.startswith("https://"):
            continue
        results.append(
            {
                "newImage": image_url,
                "source": "unsplash",
                "photographer": str(user.get("name", "") if isinstance(user, dict) else ""),
                "sourcePage": str(links.get("html", "") if isinstance(links, dict) else ""),
                "imageId": str(photo.get("id", "")),
            }
        )
    return results, None


def analyze_products(products: list[dict[str, Any]]) -> dict[str, Any]:
    images = [p["item"].get("image", "") for p in products if p["item"].get("image")]
    duplicate_images = {url: count for url, count in Counter(images).items() if count > 1}
    missing_fields = []
    for product in products:
        for field in ("image", "name", "price", "link"):
            if not product["item"].get(field):
                missing_fields.append({"path": product["path"], "field": field})

    return {
        "totalProducts": len(products),
        "styleCounts": dict(Counter(p["style"] for p in products)),
        "typeCounts": dict(Counter(p["type"] for p in products)),
        "existingImageUrlCount": len(images),
        "duplicateImageUrlCount": sum(count - 1 for count in duplicate_images.values()),
        "duplicateImageUrls": duplicate_images,
        "missingFields": missing_fields,
    }


def main() -> int:
    env = load_env(ENV_FILE)
    pexels_key = env.get("PEXELS_API_KEY", "")
    unsplash_key = env.get("UNSPLASH_ACCESS_KEY", "")

    if pexels_key:
        provider = "pexels"
    elif unsplash_key:
        provider = "unsplash"
    else:
        provider = ""

    data = json.loads(ORIGINAL_JSON.read_text(encoding="utf-8"))
    products = iter_products(data)
    mapping: dict[str, dict[str, str]] = {}
    analysis = analyze_products(products)

    used_image_ids: set[str] = set()
    success_count = 0
    duplicate_excluded_count = 0
    api_failure_count = 0
    failures: list[dict[str, str]] = []

    if not provider:
        for product in products:
            query = build_query(product["style"], product["type"], str(product["item"].get("name", "")))
            mapping[product["path"]] = {
                "query": query,
                "currentImage": str(product["item"].get("image", "")),
                "newImage": "",
                "source": "",
                "photographer": "",
                "sourcePage": "",
                "imageId": "",
            }
            failures.append({"path": product["path"], "reason": "NO_API_KEY"})
        MAPPING_JSON.write_text(
            json.dumps(mapping, ensure_ascii=False, indent=2) + "\n",
            encoding="utf-8",
        )
        print("API key not found. Set PEXELS_API_KEY or UNSPLASH_ACCESS_KEY in .env.")
        print(f"전체 상품 수: {len(products)}")
        print("매핑 성공 수: 0")
        print(f"매핑 실패 수: {len(products)}")
        print("중복으로 제외한 이미지 수: 0")
        print("API 요청 실패 수: 0")
        print(f"매핑 파일: {MAPPING_JSON}")
        print("매핑 실패 목록:")
        for failure in failures:
            print(f"- {failure['path']}: {failure['reason']}")
        return 1

    for index, product in enumerate(products, start=1):
        query = build_query(product["style"], product["type"], str(product["item"].get("name", "")))
        current_image = str(product["item"].get("image", ""))

        if provider == "pexels":
            candidates, error = fetch_pexels(query, pexels_key)
        else:
            candidates, error = fetch_unsplash(query, unsplash_key)

        selected: dict[str, Any] | None = None
        if error is not None:
            api_failure_count += 1
            failures.append({"path": product["path"], "reason": error})
        elif not candidates:
            failures.append({"path": product["path"], "reason": "NO_RESULTS"})
        else:
            for candidate in candidates:
                image_id = f"{candidate['source']}:{candidate['imageId']}"
                if image_id in used_image_ids:
                    duplicate_excluded_count += 1
                    continue
                selected = candidate
                used_image_ids.add(image_id)
                break
            if selected is None:
                failures.append({"path": product["path"], "reason": "ONLY_DUPLICATE_RESULTS"})

        mapping[product["path"]] = {
            "query": query,
            "currentImage": current_image,
            "newImage": str(selected.get("newImage", "") if selected else ""),
            "source": str(selected.get("source", provider) if selected else provider),
            "photographer": str(selected.get("photographer", "") if selected else ""),
            "sourcePage": str(selected.get("sourcePage", "") if selected else ""),
            "imageId": str(selected.get("imageId", "") if selected else ""),
        }

        if selected:
            success_count += 1

        if index < len(products):
            time.sleep(0.25)

    MAPPING_JSON.write_text(
        json.dumps(mapping, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    print(f"API provider: {provider}")
    print(f"전체 상품 수: {analysis['totalProducts']}")
    print(f"매핑 성공 수: {success_count}")
    print(f"매핑 실패 수: {len(products) - success_count}")
    print(f"중복으로 제외한 이미지 수: {duplicate_excluded_count}")
    print(f"API 요청 실패 수: {api_failure_count}")
    print(f"매핑 파일: {MAPPING_JSON}")
    if failures:
        print("매핑 실패 목록:")
        for failure in failures:
            print(f"- {failure['path']}: {failure['reason']}")

    return 0 if success_count == len(products) else 2


if __name__ == "__main__":
    sys.exit(main())
