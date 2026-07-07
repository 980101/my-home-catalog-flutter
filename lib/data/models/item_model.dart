class ItemModel {
  const ItemModel({
    required this.image,
    required this.name,
    required this.price,
    required this.link,
    required this.style,
    required this.type,
  });

  final String image;
  final String name;
  final String price;
  final String link;
  final String style;
  final String type;

  factory ItemModel.fromFirebaseMap({
    required Map<Object?, Object?> data,
    required String style,
    required String type,
  }) {
    return ItemModel(
      image: data['image']?.toString() ?? '',
      name: data['name']?.toString() ?? '',
      price: data['price']?.toString() ?? '',
      link: data['link']?.toString() ?? '',
      style: style,
      type: type,
    );
  }

  factory ItemModel.fromSavedItemJson(Map<String, dynamic> data) {
    return ItemModel(
      image: data['Image']?.toString() ?? '',
      name: data['Name']?.toString() ?? '',
      price: data['Price']?.toString() ?? '',
      link: data['Link']?.toString() ?? '',
      style: 'all',
      type: 'all',
    );
  }

  Map<String, String> toSavedItemJson() {
    return {'Image': image, 'Name': name, 'Price': price, 'Link': link};
  }
}
