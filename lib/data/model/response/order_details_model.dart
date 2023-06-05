import 'package:flutter_restaurant/data/model/response/product_model.dart';

class OrderDetailsModel {
  int _id;
  int _productId;
  int _orderId;
  double _price;
  Product _productDetails;
  List<Variation> _variations;
  List<OldVariation> _oldVariations;
  double _discountOnProduct;
  String _discountType;
  int _quantity;
  double _taxAmount;
  String _createdAt;
  String _updatedAt;
  List<int> _addOnIds;
  List<int> _addOnQtys;

  OrderDetailsModel(
      {int id,
        int productId,
        int orderId,
        double price,
        Product productDetails,
        List<Variation> variations,
        List<OldVariation> oldVariations,
        double discountOnProduct,
        String discountType,
        int quantity,
        double taxAmount,
        String createdAt,
        String updatedAt,
        List<int> addOnIds,
        List<int> addOnQtys,
      }) {
    this._id = id;
    this._productId = productId;
    this._orderId = orderId;
    this._price = price;
    this._productDetails = productDetails;
    this._oldVariations = oldVariations;
    this._variations = variations;
    this._discountOnProduct = discountOnProduct;
    this._discountType = discountType;
    this._quantity = quantity;
    this._taxAmount = taxAmount;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._addOnIds = addOnIds;
    this._addOnQtys = addOnQtys;
  }

  int get id => _id;
  int get productId => _productId;
  int get orderId => _orderId;
  double get price => _price;
  Product get productDetails => _productDetails;
  List<Variation> get variations => _variations;
  List<OldVariation> get oldVariations => _oldVariations;
  double get discountOnProduct => _discountOnProduct;
  String get discountType => _discountType;
  int get quantity => _quantity;
  double get taxAmount => _taxAmount;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  List<int> get addOnIds => _addOnIds;
  List<int> get addOnQtys => _addOnQtys;

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productId = json['product_id'];
    _orderId = json['order_id'];
    _price = json['price'].toDouble();
    try{
      _productDetails = Product.fromJson(json['product_details']);
    }catch(error) {
      _productDetails = null;
    }

    if (json['variation'] != null && json['variation'].isNotEmpty) {
      if(json['variation'][0]['values'] != null) {
        _variations = [];
        json['variation'].forEach((v) {
          _variations.add(Variation.fromJson(v));
        });
      }else{
        _oldVariations = [];
        json['variation'].forEach((v) {
          _oldVariations.add(new OldVariation.fromJson(v));
        });
      }
    }

    _discountOnProduct = json['discount_on_product'].toDouble();
    _discountType = json['discount_type'];
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'].toDouble();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _addOnIds = json['add_on_ids'].cast<int>();
    if(json['add_on_qtys'] != null) {
      _addOnQtys = [];
      json['add_on_qtys'].forEach((qun) {
        try {
          _addOnQtys.add( int.parse(qun));
        }catch(e) {
          _addOnQtys.add(qun);
        }

      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['product_id'] = this._productId;
    data['order_id'] = this._orderId;
    data['price'] = this._price;
    data['variation'] = this._variations;
    data['discount_on_product'] = this._discountOnProduct;
    data['discount_type'] = this._discountType;
    data['quantity'] = this._quantity;
    data['tax_amount'] = this._taxAmount;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['add_on_ids'] = this._addOnIds;
    data['add_on_qtys'] = this._addOnQtys;
    if (this._variations != null) {
      data['variations'] = this._variations.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OldVariation {
  String type;
  double price;

  OldVariation({this.type, this.price});

  OldVariation.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    price = json['price'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['price'] = this.price;
    return data;
  }
}
