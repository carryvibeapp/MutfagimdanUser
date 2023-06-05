class ProductModel {
  int _totalSize;
  String _limit;
  String _offset;
  List<Product> _products;

  ProductModel(
      {int totalSize, String limit, String offset, List<Product> products}) {
    this._totalSize = totalSize;
    this._limit = limit;
    this._offset = offset;
    this._products = products;
  }

  int get totalSize => _totalSize;
  String get limit => _limit;
  String get offset => _offset;
  List<Product> get products => _products;

  ProductModel.fromJson(Map<String, dynamic> json) {
    _totalSize = json['total_size'];
    _limit = json['limit'].toString();
    _offset = json['offset'].toString();
    if (json['products'] != null) {
      _products = [];
      json['products'].forEach((v) {
        _products.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_size'] = this._totalSize;
    data['limit'] = this._limit;
    data['offset'] = this._offset;
    if (this._products != null) {
      data['products'] = this._products.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int _id;
  String _name;
  String _description;
  String _image;
  double _price;
  List<Variation> _variations;
  List<AddOns> _addOns;
  double _tax;
  String _availableTimeStarts;
  String _availableTimeEnds;
  int _status;
  String _createdAt;
  String _updatedAt;
  List<String> _attributes;
  List<CategoryId> _categoryIds;
  List<ChoiceOption> _choiceOptions;
  double _discount;
  String _discountType;
  String _taxType;
  int _setMenu;
  List<Rating> _rating;
  BranchProduct _branchProduct;
  double _mainPrice;

  Product(
      {int id,
        String name,
        String description,
        String image,
        double price,
        List<Variation> variations,
        List<AddOns> addOns,
        double tax,
        String availableTimeStarts,
        String availableTimeEnds,
        int status,
        String createdAt,
        String updatedAt,
        List<String> attributes,
        List<CategoryId> categoryIds,
        List<ChoiceOption> choiceOptions,
        double discount,
        String discountType,
        String taxType,
        int setMenu,
        List<Rating> rating,
        BranchProduct branchProduct,
        double mainPrice,
      }) {
    this._id = id;
    this._name = name;
    this._description = description;
    this._image = image;
    this._price = price;
    this._variations = variations;
    this._addOns = addOns;
    this._tax = tax;
    this._availableTimeStarts = availableTimeStarts;
    this._availableTimeEnds = availableTimeEnds;
    this._status = status;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._attributes = attributes;
    this._categoryIds = categoryIds;
    this._choiceOptions = choiceOptions;
    this._discount = discount;
    this._discountType = discountType;
    this._taxType = taxType;
    this._setMenu = setMenu;
    this._rating = rating;
    this._branchProduct = branchProduct;
    this._mainPrice = mainPrice;
  }

  int get id => _id;
  String get name => _name;
  String get description => _description;
  String get image => _image;
  double get price => _price;
  List<Variation> get variations => _variations;
  List<AddOns> get addOns => _addOns;
  double get tax => _tax;
  String get availableTimeStarts => _availableTimeStarts;
  String get availableTimeEnds => _availableTimeEnds;
  int get status => _status;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  List<String> get attributes => _attributes;
  List<CategoryId> get categoryIds => _categoryIds;
  // List<ChoiceOption> get choiceOptions => _choiceOptions;
  double get discount => _discount;
  String get discountType => _discountType;
  String get taxType => _taxType;
  int get setMenu => _setMenu;
  List<Rating> get rating => _rating;
  String productType;
  BranchProduct get branchProduct => _branchProduct;


  Product.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _image = json['image'];
    _price = json['price'].toDouble();
    if (json['variations'] != null) {
      _variations = [];
      json['variations'].forEach((v) {
        if(!v.containsKey('price')){
          _variations.add(new Variation.fromJson(v));
        }

      });
    }
    if (json['add_ons'] != null) {
      _addOns = [];
      json['add_ons'].forEach((v) {
        _addOns.add(new AddOns.fromJson(v));
      });
    }
    _tax = json['tax'].toDouble();
    _tax = json['tax'].toDouble();
    _availableTimeStarts = json['available_time_starts'] ?? '';
    _availableTimeEnds = json['available_time_ends'] ?? '' ;
    _status = json['status'] ?? 0;
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _attributes = json['attributes'].cast<String>();
    if (json['category_ids'] != null) {
      _categoryIds = [];
      json['category_ids'].forEach((v) {
        _categoryIds.add(new CategoryId.fromJson(v));
      });
    }
    if (json['choice_options'] != null) {
      _choiceOptions = [];
      json['choice_options'].forEach((v) {
        _choiceOptions.add(new ChoiceOption.fromJson(v));
      });
    }
    _discount = json['discount'].toDouble();
    _discountType = json['discount_type'];
    _taxType = json['tax_type'];
    _setMenu = json['set_menu'];
    if (json['rating'] != null) {
      _rating = [];
      json['rating'].forEach((v) {
        _rating.add(new Rating.fromJson(v));
      });
    }
    productType=  json["product_type"];
    if(json['branch_product'] != null) {
      _branchProduct =  new BranchProduct.fromJson(json['branch_product']);
      _price = _branchProduct.price;
      _discount = _branchProduct.discount;
      _discountType = _branchProduct.discountType;

    }else{
      _branchProduct = null;
    }
    _mainPrice = double.tryParse('${json['price']}');

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['description'] = this._description;
    data['image'] = this._image;
    data['price'] = this._price;
    if (this._variations != null) {
      data['variations'] = this._variations.map((v) => v.toJson()).toList();
    }


    if (this._addOns != null) {
      data['add_ons'] = this._addOns.map((v) => v.toJson()).toList();
    }
    data['tax'] = this._tax;
    data['available_time_starts'] = this._availableTimeStarts;
    data['available_time_ends'] = this._availableTimeEnds;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['attributes'] = this._attributes;
    if (this._categoryIds != null) {
      data['category_ids'] = this._categoryIds.map((v) => v.toJson()).toList();
    }
    if (this._choiceOptions != null) {
      data['choice_options'] =
          this._choiceOptions.map((v) => v.toJson()).toList();
    }
    data['discount'] = this._discount;
    data['discount_type'] = this._discountType;
    data['tax_type'] = this._taxType;
    data['set_menu'] = this._setMenu;
    data['main_price'] = this._mainPrice;
    if (this._rating != null) {
      data['rating'] = this._rating.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class BranchProduct {
  int id;
  int productId;
  int branchId;
  double price;
  bool isAvailable;
  List<Variation> variations;
  double discount;
  String discountType;


  BranchProduct(
      {this.id,
        this.productId,
        this.branchId,
        this.isAvailable,
        this.variations,
        this.price,
        this.discount,
        this.discountType,
        });

  BranchProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    branchId = json['branch_id'];
    price = double.tryParse('${json['price']}');
    isAvailable = '${json['is_available']}' == '1';
    if (json['variations'] != null) {
      variations = [];
      json['variations'].forEach((v) {
        if(!v.containsKey('price')){
          variations.add(new Variation.fromJson(v));
        }

      });
    }
    discount = json['discount'].toDouble();
    discountType = json['discount_type'];


  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['branch_id'] = this.branchId;
    data['is_available'] = this.isAvailable;
    data['variations'] = this.variations;
    data['price'] = this.price;
    data['discount'] = this.discount;
    data['discount_type'] = this.discountType;
    return data;
  }
}
class VariationValue {
  String level;
  double optionPrice;

  VariationValue({this.level, this.optionPrice});

  VariationValue.fromJson(Map<String, dynamic> json) {
    level = json['label'];
    optionPrice = double.parse(json['optionPrice'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['label'] = this.level;
    data['optionPrice'] = this.optionPrice;
    return data;
  }
}



class Variation {
  String name;
  int min;
  int max;
  bool isRequired;
  bool isMultiSelect;
  List<VariationValue> variationValues;


  Variation({
    this.name, this.min, this.max,
    this.isRequired, this.variationValues,
    this.isMultiSelect,
  });

  Variation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isMultiSelect = '${json['type']}' == 'multi';
    min =  isMultiSelect ? int.parse(json['min'].toString()) : 0;
    max = isMultiSelect ? int.parse(json['max'].toString()) : 0;
    isRequired = '${json['required']}' == 'on';
    if (json['values'] != null) {
      variationValues = [];
      json['values'].forEach((v) {
        variationValues.add(new VariationValue.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.isMultiSelect ? 'multi' : 'single';
    data['min'] = this.min;
    data['max'] = this.max;
    data['required'] = this.isRequired ? 'on' : 'off';
    if (this.variationValues != null) {
      data['values'] = this.variationValues.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

class AddOns {
  int _id;
  String _name;
  double _price;
  String _createdAt;
  String _updatedAt;

  AddOns({int id, String name, double price, String createdAt, String updatedAt}) {
    this._id = id;
    this._name = name;
    this._price = price;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int get id => _id;
  String get name => _name;
  double get price => _price;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  AddOns.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _price = json['price'].toDouble();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['price'] = this._price;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}

class CategoryId {
  String _id;

  CategoryId({String id}) {
    this._id = id;
  }

  String get id => _id;

  CategoryId.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    return data;
  }
}

class ChoiceOption {
  String _name;
  String _title;
  List<String> _options;

  ChoiceOption({String name, String title, List<String> options}) {
    this._name = name;
    this._title = title;
    this._options = options;
  }

  String get name => _name;
  String get title => _title;
  List<String> get options => _options;

  ChoiceOption.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _title = json['title'];
    _options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['title'] = this._title;
    data['options'] = this._options;
    return data;
  }
}

class Rating {
  String _average;
  int _productId;

  Rating({String average, int productId}) {
    this._average = average;
    this._productId = productId;
  }

  String get average => _average;
  int get productId => _productId;

  Rating.fromJson(Map<String, dynamic> json) {
    _average = json['average'];
    _productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['average'] = this._average;
    data['product_id'] = this._productId;
    return data;
  }
}