class Group {
  String? id;
  String? name;
  String? image;
  String? createAt;
  String? createdBy;
  String? aboutGroup;
  List<String>? members;

  Group({
    this.id,
    this.name,
    this.members,
    this.image,
    this.createAt,
    this.createdBy,
    this.aboutGroup,
  });

  factory Group.fromMap(Map<String, dynamic> data, String documentId) {
    return Group(
      id: documentId,
      name: data['groupName'] ?? "",
      image: data['image'] ?? '',
      createAt: data['createAt'] ?? "",
      createdBy: data['createdBy'] ?? "",
      aboutGroup: data['aboutGroup'] ?? "",
      members: List<String>.from(
        data['members'] ?? <String>[],
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'createAt': createAt,
      'createdBy': createdBy,
      'groupName': name,
      'members': members,
      'aboutGroup': aboutGroup,
    };
  }
}
