class OnBoarding {
  int? id;
  int? inOrder;
  String? title;
  String? description;
  String? type;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  String? formattedDateTime;
  String? formattedDate;
  String? formattedUpdatedDate;
  String? photo;

  OnBoarding(
      {this.id,
        this.inOrder,
        this.title,
        this.description,
        this.type,
        this.isActive,
        this.createdAt,
        this.updatedAt,
        this.formattedDateTime,
        this.formattedDate,
        this.formattedUpdatedDate,
        this.photo});

  OnBoarding.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    inOrder = json['in_order'];
    title = json['title'];
    description = json['description'];
    type = json['type'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    formattedDateTime = json['formatted_date_time'];
    formattedDate = json['formatted_date'];
    formattedUpdatedDate = json['formatted_updated_date'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['in_order'] = this.inOrder;
    data['title'] = this.title;
    data['description'] = this.description;
    data['type'] = this.type;
    data['is_active'] = this.isActive;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['formatted_date_time'] = this.formattedDateTime;
    data['formatted_date'] = this.formattedDate;
    data['formatted_updated_date'] = this.formattedUpdatedDate;
    data['photo'] = this.photo;
    return data;
  }
}
