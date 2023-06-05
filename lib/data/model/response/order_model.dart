import 'package:flutter_restaurant/data/model/response/product_model.dart';

class OrderModel {
  int _id;
  int _userId;
  double _orderAmount;
  double _couponDiscountAmount;
  String _couponDiscountTitle;
  String _paymentStatus;
  String _orderStatus;
  double _totalTaxAmount;
  String _paymentMethod;
  String _transactionReference;
  int _deliveryAddressId;
  String _createdAt;
  String _updatedAt;
  int _deliveryManId;
  double _deliveryCharge;
  String _orderNote;
  List<int> _addOnIds;
  List<Details> _details;
  DeliveryMan _deliveryMan;
  int _detailsCount;
  String _orderType;
  String _deliveryTime;
  String _deliveryDate;
  double _extraDiscount;
  DeliveryAddress _deliveryAddress;
  String _preparationTime;
  bool _isProductAvailable;


  OrderModel(
      {int id,
        int userId,
        double orderAmount,
        double couponDiscountAmount,
        String couponDiscountTitle,
        String paymentStatus,
        String orderStatus,
        double totalTaxAmount,
        String paymentMethod,
        String transactionReference,
        int deliveryAddressId,
        String createdAt,
        String updatedAt,
        String checked,
        int deliveryManId,
        double deliveryCharge,
        String orderNote,
        List<int> addOnIds,
        List<Details> details,
        DeliveryMan deliveryMan,
        int detailsCount,
        String deliveryTime,
        String deliveryDate,
        String orderType,
        double extraDiscount,
        DeliveryAddress deliveryAddress,
        String preparationTime,
        bool isProductAvailable,

      }) {
    this._id = id;
    this._userId = userId;
    this._orderAmount = orderAmount;
    this._couponDiscountAmount = couponDiscountAmount;
    this._couponDiscountTitle = couponDiscountTitle;
    this._paymentStatus = paymentStatus;
    this._orderStatus = orderStatus;
    this._totalTaxAmount = totalTaxAmount;
    this._paymentMethod = paymentMethod;
    this._transactionReference = transactionReference;
    this._deliveryAddressId = deliveryAddressId;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._deliveryManId = deliveryManId;
    this._deliveryCharge = deliveryCharge;
    this._orderNote = orderNote;
    this._addOnIds = addOnIds;
    this._details = details;
    this._deliveryMan = deliveryMan;
    this._detailsCount = detailsCount;
    this._orderType = orderType;
    this._deliveryTime = deliveryTime;
    this._deliveryDate = deliveryDate;
    this._extraDiscount = extraDiscount;
    this._deliveryAddress = deliveryAddress;
    this._preparationTime = preparationTime;
    this._isProductAvailable = isProductAvailable;

  }

  int get id => _id;
  int get userId => _userId;
  double get orderAmount => _orderAmount;
  double get couponDiscountAmount => _couponDiscountAmount;
  String get couponDiscountTitle => _couponDiscountTitle;
  String get paymentStatus => _paymentStatus;
  String get orderStatus => _orderStatus;
  double get totalTaxAmount => _totalTaxAmount;
  // ignore: unnecessary_getters_setters
  String get paymentMethod => _paymentMethod;
  // ignore: unnecessary_getters_setters
  set paymentMethod(String method) => _paymentMethod = method;
  String get transactionReference => _transactionReference;
  int get deliveryAddressId => _deliveryAddressId;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  int get deliveryManId => _deliveryManId;
  double get deliveryCharge => _deliveryCharge;
  String get orderNote => _orderNote;
  List<int> get addOnIds => _addOnIds;
  List<Details> get details => _details;
  DeliveryMan get deliveryMan => _deliveryMan;
  int get detailsCount => _detailsCount;
  String get orderType => _orderType;
  String get deliveryTime => _deliveryTime;
  String get deliveryDate => _deliveryDate;
  double get extraDiscount => _extraDiscount;
  DeliveryAddress get deliveryAddress => _deliveryAddress;
  String get preparationTime => _preparationTime;
  bool get isProductAvailable => _isProductAvailable;


  OrderModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _orderAmount = json['order_amount'].toDouble();
    _couponDiscountAmount = json['coupon_discount_amount'].toDouble();
    _couponDiscountTitle = json['coupon_discount_title'];
    _paymentStatus = json['payment_status'];
    _orderStatus = json['order_status'] == 'cooking' ||
        json['order_status'] == 'done'? 'processing' : json['order_status'];
    _totalTaxAmount = json['total_tax_amount'].toDouble();
    _paymentMethod = json['payment_method'];
    _transactionReference = json['transaction_reference'];
    _deliveryAddressId = json['delivery_address_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deliveryManId = json['delivery_man_id'];
    _deliveryCharge = json['delivery_charge'].toDouble();
    _orderNote = json['order_note'];
    _detailsCount = json['details_count'];
    if(json['add_on_ids'] != null) {
      _addOnIds = json['add_on_ids'].cast<int>();
    }
    if (json['details'] != null) {
      _details = [];
      json['details'].forEach((v) {
        _details.add(new Details.fromJson(v));
      });
    }
    _deliveryMan = json['delivery_man'] != null
        ? new DeliveryMan.fromJson(json['delivery_man'])
        : null;
    _orderType = json['order_type'];
    _deliveryTime = json['delivery_time'];
    _deliveryDate = json['delivery_date'];
    if(json['extra_discount'] != null){
      try{
        _extraDiscount = double.parse(json['extra_discount']);
      }catch(e){
        _extraDiscount = json['extra_discount'];
      }
    }
    _deliveryAddress = json['delivery_address'] != null
        ? new DeliveryAddress.fromJson(json['delivery_address'])
        : null;
    _preparationTime = json['preparation_time'].toString() ?? '0';
   // print('order pre time -- $_preparationTime');
    _isProductAvailable = int.tryParse('${json['is_product_available']}') == 1 ? true : false;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['user_id'] = this._userId;
    data['order_amount'] = this._orderAmount;
    data['coupon_discount_amount'] = this._couponDiscountAmount;
    data['coupon_discount_title'] = this._couponDiscountTitle;
    data['payment_status'] = this._paymentStatus;
    data['order_status'] = this._orderStatus;
    data['total_tax_amount'] = this._totalTaxAmount;
    data['payment_method'] = this._paymentMethod;
    data['transaction_reference'] = this._transactionReference;
    data['delivery_address_id'] = this._deliveryAddressId;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['delivery_man_id'] = this._deliveryManId;
    data['delivery_charge'] = this._deliveryCharge;
    data['order_note'] = this._orderNote;
    data['add_on_ids'] = this._addOnIds;
    data['details_count'] = this._detailsCount;
    if (this._details != null) {
      data['details'] = this._details.map((v) => v.toJson()).toList();
    }
    if (this._deliveryMan != null) {
      data['delivery_man'] = this._deliveryMan.toJson();
    }
    data['order_type'] = this._orderType;
    data['delivery_time'] = this._deliveryTime;
    data['delivery_date'] = this._deliveryDate;
    data['extra_discount'] = this._extraDiscount;
    if (this._deliveryAddress != null) {
      data['delivery_address'] = this._deliveryAddress.toJson();
    }
    return data;
  }
}
class DeliveryAddress {
  int _id;
  String _addressType;
  String _contactPersonNumber;
  String _address;
  String _latitude;
  String _longitude;
  String _createdAt;
  String _updatedAt;
  int _userId;
  String _contactPersonName;

  DeliveryAddress(
      {int id,
        String addressType,
        String contactPersonNumber,
        String address,
        String latitude,
        String longitude,
        String createdAt,
        String updatedAt,
        int userId,
        String contactPersonName}) {
    this._id = id;
    this._addressType = addressType;
    this._contactPersonNumber = contactPersonNumber;
    this._address = address;
    this._latitude = latitude;
    this._longitude = longitude;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._userId = userId;
    this._contactPersonName = contactPersonName;
  }

  int get id => _id;
  String get addressType => _addressType;
  String get contactPersonNumber => _contactPersonNumber;
  String get address => _address;
  String get latitude => _latitude;
  String get longitude => _longitude;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  int get userId => _userId;
  String get contactPersonName => _contactPersonName;

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _addressType = json['address_type'];
    _contactPersonNumber = json['contact_person_number'];
    _address = json['address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _userId = json['user_id'];
    _contactPersonName = json['contact_person_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['address_type'] = this._addressType;
    data['contact_person_number'] = this._contactPersonNumber;
    data['address'] = this._address;
    data['latitude'] = this._latitude;
    data['longitude'] = this._longitude;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['user_id'] = this._userId;
    data['contact_person_name'] = this._contactPersonName;
    return data;
  }
}

class Details {
  int _id;
  int _productId;
  int _orderId;
  double _price;
  double _discountOnProduct;
  String _discountType;
  int _quantity;
  double _taxAmount;
  String _createdAt;
  String _updatedAt;

  Details(
      {int id,
        int productId,
        int orderId,
        double price,
        String productDetails,
        double discountOnProduct,
        String discountType,
        int quantity,
        double taxAmount,
        String createdAt,
        String updatedAt,
        String addOnIds,
        String variant}) {
    this._id = id;
    this._productId = productId;
    this._orderId = orderId;
    this._price = price;
    this._discountOnProduct = discountOnProduct;
    this._discountType = discountType;
    this._quantity = quantity;
    this._taxAmount = taxAmount;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  int get id => _id;
  int get productId => _productId;
  int get orderId => _orderId;
  double get price => _price;
  double get discountOnProduct => _discountOnProduct;
  String get discountType => _discountType;
  int get quantity => _quantity;
  double get taxAmount => _taxAmount;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;

  Details.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productId = json['product_id'];
    _orderId = json['order_id'];
    _price = json['price'].toDouble();
    _discountOnProduct = json['discount_on_product'].toDouble();
    _discountType = json['discount_type'];
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'].toDouble();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['product_id'] = this._productId;
    data['order_id'] = this._orderId;
    data['price'] = this._price;
    data['discount_on_product'] = this._discountOnProduct;
    data['discount_type'] = this._discountType;
    data['quantity'] = this._quantity;
    data['tax_amount'] = this._taxAmount;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}

class DeliveryMan {
  int _id;
  String _fName;
  String _lName;
  String _phone;
  String _email;
  String _identityNumber;
  String _identityType;
  String _identityImage;
  String _image;
  String _password;
  String _createdAt;
  String _updatedAt;
  String _authToken;
  String _fcmToken;
  List<Rating> _rating;

  DeliveryMan(
      {int id,
        String fName,
        String lName,
        String phone,
        String email,
        String identityNumber,
        String identityType,
        String identityImage,
        String image,
        String password,
        String createdAt,
        String updatedAt,
        String authToken,
        String fcmToken,
        List<Rating> rating}) {
    this._id = id;
    this._fName = fName;
    this._lName = lName;
    this._phone = phone;
    this._email = email;
    this._identityNumber = identityNumber;
    this._identityType = identityType;
    this._identityImage = identityImage;
    this._image = image;
    this._password = password;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._authToken = authToken;
    this._fcmToken = fcmToken;
    this._rating = rating;
  }

  int get id => _id;
  String get fName => _fName;
  String get lName => _lName;
  String get phone => _phone;
  String get email => _email;
  String get identityNumber => _identityNumber;
  String get identityType => _identityType;
  String get identityImage => _identityImage;
  String get image => _image;
  String get password => _password;
  String get createdAt => _createdAt;
  String get updatedAt => _updatedAt;
  String get authToken => _authToken;
  String get fcmToken => _fcmToken;
  List<Rating> get rating => _rating;

  DeliveryMan.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _fName = json['f_name'];
    _lName = json['l_name'];
    _phone = json['phone'];
    _email = json['email'];
    _identityNumber = json['identity_number'];
    _identityType = json['identity_type'];
    _identityImage = json['identity_image'];
    _image = json['image'];
    _password = json['password'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _authToken = json['auth_token'];
    _fcmToken = json['fcm_token'];
    if (json['rating'] != null) {
      _rating = [];
      json['rating'].forEach((v) {
        _rating.add(new Rating.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['f_name'] = this._fName;
    data['l_name'] = this._lName;
    data['phone'] = this._phone;
    data['email'] = this._email;
    data['identity_number'] = this._identityNumber;
    data['identity_type'] = this._identityType;
    data['identity_image'] = this._identityImage;
    data['image'] = this._image;
    data['password'] = this._password;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['auth_token'] = this._authToken;
    data['fcm_token'] = this._fcmToken;
    if (this._rating != null) {
      data['rating'] = this._rating.map((v) => v.toJson()).toList();
    }
    return data;
  }
}