class CategoryModel {
  int _id;
  String _name;
  int _parentId;
  int _position;
  int _status;
  String _createdAt;
  String _updatedAt;
  String _image;
  String _bannerImage;

  CategoryModel(
      {int id,
        String name,
        int parentId,
        int position,
        int status,
        String createdAt,
        String updatedAt,
        String image,
        String bannerImage,
      }) {
    this._id = id;
    this._name = name;
    this._parentId = parentId;
    this._position = position;
    this._status = status;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._image = image;
    this._bannerImage = bannerImage;
  }

  int get id => _id;
  String get name => _name;
  int get parentId => _parentId;
  int get position => _position;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get image => _image;
  String get bannerImage => _bannerImage;

  CategoryModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'] ?? 0;
    _name = json['name'] ?? '';
    _parentId = json['parent_id'] ?? 0;
    _position = json['position'] ?? 0;
    _status = json['status'] ?? 0;
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _image = json['image'] ?? '';
    _bannerImage = json['banner_image'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['parent_id'] = this._parentId;
    data['position'] = this._position;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['image'] = this._image;
    data['banner_image'] = this._bannerImage;
    return data;
  }
}
