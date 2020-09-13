
class Sneackers {
  String id;
  String modelName;
  double size;
  String typeSize;
  double width;
  double length;
  double price;
  String material;
  String description;
  List<String> images;
  String authorId;

  Sneackers({ 
    this.id,
    this.modelName, 
    this.material, 
    this.price, 
    this.size, 
    this.typeSize, 
    this.length, 
    this.width, 
    this.description,
    this.images, 
    this.authorId
  });

  Sneackers copy () {
    return Sneackers(
      id: id,
      modelName: modelName,
      size: size,
      typeSize: typeSize,
      width: width,
      length: length,
      price: price,
      material: material,
      description: description,
      images: images,
      authorId: authorId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'modelName': modelName,
      'size': size,
      'typeSize': typeSize,
      'width': width,
      'length': length,
      'price': price,
      'material': material,
      'description': description,
      'images': images,
      'authorId': authorId,
    };
  }

  Map<String, dynamic> idToJson() {
    return {
      'id': id
    };
  }

  Sneackers.fromJson(String uid, Map<String, dynamic> data) {
    id = uid;
    modelName = data['modelName'];
    size = data['size'];
    typeSize = data['typeSize'];
    width = data['width'];
    length = data['length'];
    price = data['price'];
    material = data['material'];
    description = data['description'];
    images = data['images'].cast<String>();
    authorId = data['authorId'];
  }
}