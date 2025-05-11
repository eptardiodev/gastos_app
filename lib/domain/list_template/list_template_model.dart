class ListTemplateModel {
  final int? id;
  final String userId;
  final String name;
  final int? createdFromListId;

  ListTemplateModel({
    this.id,
    required this.userId,
    required this.name,
    this.createdFromListId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'created_from': createdFromListId,
    };
  }

  factory ListTemplateModel.fromMap(Map<String, dynamic> map) {
    return ListTemplateModel(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      createdFromListId: map['created_from'],
    );
  }
}