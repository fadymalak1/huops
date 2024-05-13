class VendorImages {
  String? message;
  Panorama? panorama;
  List<Images>? images;

  VendorImages({this.message, this.panorama, this.images});

  VendorImages.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    panorama = json['panorama'] != null
        ? new Panorama.fromJson(json['panorama'])
        : null;
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.panorama != null) {
      data['panorama'] = this.panorama!.toJson();
    }
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Panorama {
  String? panorama;
  int? id;

  Panorama({this.panorama, this.id});

  Panorama.fromJson(Map<String, dynamic> json) {
    panorama = json['panorama'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['panorama'] = this.panorama;
    data['id'] = this.id;
    return data;
  }
}

class Images {
  String? image;
  int? id;

  Images({this.image, this.id});

  Images.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['id'] = this.id;
    return data;
  }
}
