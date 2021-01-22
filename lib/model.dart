import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  final String id, description, name, userId;
  final bool active, deleted, featured;

  ItemModel(
      {this.name,
      this.active,
      this.deleted,
      this.description,
      this.featured,
      this.id,
      this.userId});

  factory ItemModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data();
    return ItemModel(
      id: doc.id,
      name: data["name"] ?? null,
      active: data["active"] ?? false,
      deleted: data["deleted"] ?? false,
      description: data["description"] ?? null,
      featured: data["featured"] ?? false,
      userId: data['userId'] ?? null,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "active": active,
      "description": description,
      "featured": featured,
    };
  }
}
