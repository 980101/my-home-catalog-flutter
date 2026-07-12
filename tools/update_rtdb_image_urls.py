#!/usr/bin/env python3
"""Apply public image URL mapping to an RTDB export without editing source data."""

from __future__ import annotations

import copy
import json
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
ORIGINAL_JSON = ROOT / "tools" / "house-server-rtdb-original.json"
MAPPING_JSON = ROOT / "tools" / "image_url_mapping.json"
OUTPUT_JSON = ROOT / "tools" / "house-server-rtdb-public-images.json"


def iter_product_refs(data: dict[str, Any]) -> list[tuple[str, dict[str, Any]]]:
    products: list[tuple[str, dict[str, Any]]] = []
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
                products.append((f"all/{style}/{furniture_type}/{item_key}", item))
    return products


def strip_images(value: Any) -> Any:
    if isinstance(value, dict):
        return {key: strip_images(inner) for key, inner in value.items() if key != "image"}
    if isinstance(value, list):
        return [strip_images(inner) for inner in value]
    return value


def validate_only_images_changed(original: dict[str, Any], updated: dict[str, Any]) -> None:
    if strip_images(original) != strip_images(updated):
        raise ValueError("Validation failed: fields other than image changed.")


def main() -> int:
    original = json.loads(ORIGINAL_JSON.read_text(encoding="utf-8"))
    mapping = json.loads(MAPPING_JSON.read_text(encoding="utf-8"))
    updated = copy.deepcopy(original)

    converted_count = 0
    missing: list[str] = []

    for path, item in iter_product_refs(updated):
        entry = mapping.get(path)
        new_image = entry.get("newImage", "") if isinstance(entry, dict) else ""
        if isinstance(new_image, str) and new_image.startswith("https://"):
            item["image"] = new_image
            converted_count += 1
        else:
            missing.append(path)

    validate_only_images_changed(original, updated)
    OUTPUT_JSON.write_text(
        json.dumps(updated, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    print(f"출력 파일: {OUTPUT_JSON}")
    print(f"변환된 상품 수: {converted_count}")
    print(f"누락된 상품 수: {len(missing)}")
    print("검증 결과: image 이외 필드는 원본과 동일합니다.")

    if missing:
        print("완성본 아님: newImage가 비어 있거나 HTTPS가 아닌 상품이 있습니다.")
        print("누락 목록:")
        for path in missing:
            print(f"- {path}")
        return 2

    print("완성본: 모든 상품의 image 필드가 공개 HTTPS URL로 교체되었습니다.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
