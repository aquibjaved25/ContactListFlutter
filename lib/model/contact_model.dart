class ContactModel {

  int _id;
  String _name;
  String _mobile;
  String _landline;
  int _favorite;
  String _imagePath;

  ContactModel(this._name, this._landline, this._favorite, this._mobile,this._imagePath);

  ContactModel.withId(this._id, this._name, this._landline, this._favorite, this._mobile,this._imagePath);

  int get id => _id;

  String get name => _name;

  String get mobile => _mobile;

  int get favorite => _favorite;

  String get landline => _landline;

  String get imagePath => _imagePath;

  set name(String newTitle) {
    if (newTitle.length <= 255) {
      this._name = newTitle;
    }
  }

  set imagePath(String newPath){
    this._imagePath = newPath ;
  }

  set mobile(String newDescription) {
    if (newDescription.length <= 255) {
      this._mobile = newDescription;
    }
  }

  set favorite(int newPriority) {
    if (newPriority >= 1 && newPriority <= 2) {
      this._favorite = newPriority;
    }
  }

  set landline(String newlandline) {
    this._landline = newlandline;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['name'] = _name;
    map['mobile'] = _mobile;
    map['favorite'] = _favorite;
    map['landline'] = _landline;
    map['imgpath'] = _imagePath;

    return map;
  }

  // Extract a Note object from a Map object
  ContactModel.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._mobile = map['mobile'];
    this._favorite = map['favorite'];
    this._landline = map['landline'];
    this._imagePath = map['imgpath'];
  }
}