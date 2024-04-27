class GroupCreatorDto {
  int id;

  GroupCreatorDto({required this.id});

  factory GroupCreatorDto.fromJson(Map<String, dynamic> json) =>
      GroupCreatorDto(id: json['id']);

  Map<String, dynamic> toJson() => {'id': id};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupCreatorDto &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
