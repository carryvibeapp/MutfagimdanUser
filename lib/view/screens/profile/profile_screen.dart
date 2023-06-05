
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/response_model.dart';
import 'package:flutter_restaurant/data/model/response/userinfo_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/profile_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/not_logged_in_screen.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/profile/profile_screen_web.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class  ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  FocusNode _firstNameFocus;
  FocusNode _lastNameFocus;
  FocusNode _emailFocus;
  FocusNode _phoneNumberFocus;
  FocusNode _passwordFocus;
  FocusNode _confirmPasswordFocus;
  TextEditingController _firstNameController;
  TextEditingController _lastNameController;
  TextEditingController _emailController;
  TextEditingController _phoneNumberController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;

  File file;
  XFile data;
  final picker = ImagePicker();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  bool _isLoggedIn;

  void _choose() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 500, maxWidth: 500);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
      }
    });
  }

  _pickImage() async {
    data = await picker.pickImage(source: ImageSource.gallery, imageQuality: 60);
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    if(_isLoggedIn) {
      Provider.of<ProfileProvider>(context, listen: false).getUserInfo(context);
    }

    _firstNameFocus = FocusNode();
    _lastNameFocus = FocusNode();
    _emailFocus = FocusNode();
    _phoneNumberFocus = FocusNode();
    _passwordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    if (Provider.of<ProfileProvider>(context, listen: false).userInfoModel != null) {
      UserInfoModel _userInfoModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;
      _firstNameController.text = _userInfoModel.fName ?? '';
      _lastNameController.text = _userInfoModel.lName ?? '';
      _phoneNumberController.text = _userInfoModel.phone ?? '';
      _emailController.text = _userInfoModel.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) : CustomAppBar(context: context, title: getTranslated('my_profile', context)),
      body: _isLoggedIn ? Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          if(ResponsiveHelper.isDesktop(context)) {
            return ProfileScreenWeb(
              file: data,
              pickImage: _pickImage,
              confirmPasswordController: _confirmPasswordController,
              confirmPasswordFocus: _confirmPasswordFocus,
              emailController: _emailController,
              firstNameController: _firstNameController,
              firstNameFocus: _firstNameFocus,
              lastNameController: _lastNameController,
              lastNameFocus: _lastNameFocus,
              emailFocus: _emailFocus,
              passwordController: _passwordController,
              passwordFocus: _passwordFocus,
              phoneNumberController: _phoneNumberController,
              phoneNumberFocus: _phoneNumberFocus
            );
          }
          return profileProvider.userInfoModel != null ? Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  child: Center(
                    child: Container(
                      width: _width > 700 ? 700 : _width,
                      padding: _width > 700 ? EdgeInsets.symmetric( horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: Dimensions.PADDING_SIZE_SMALL) : null,
                      decoration: _width > 700 ? BoxDecoration(
                        color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 5, spreadRadius: 1)],
                      ) : null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // for profile image
                          Container(
                            margin: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_LARGE),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: ColorResources.BORDER_COLOR,
                              border: Border.all(color: ColorResources.COLOR_GREY_CHATEAU, width: 3),
                              shape: BoxShape.circle,
                            ),
                            child: InkWell(
                              onTap: ResponsiveHelper.isMobilePhone() ? _choose : _pickImage,
                              child: Stack(
                                clipBehavior: Clip.none, children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: file != null ? Image.file(file, width: 80, height: 80, fit: BoxFit.fill) : data != null
                                        ? Image.network(data.path, width: 80, height: 80, fit: BoxFit.fill)
                                        : FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder_user, width: 80, height: 80, fit: BoxFit.cover,
                                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.customerImageUrl}/${profileProvider.userInfoModel.image}',
                                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_user, width: 80, height: 80, fit: BoxFit.cover,),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 15,
                                    right: -10,
                                    child: InkWell(onTap: ResponsiveHelper.isMobilePhone() ? _choose : _pickImage, child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(2),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorResources.BORDER_COLOR,
                                        border: Border.all(width: 2, color: ColorResources.COLOR_GREY_CHATEAU),
                                      ),
                                      child: Icon(Icons.edit, size: 13),
                                    )),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          // for name
                          Center(
                              child: Text(
                                '${profileProvider.userInfoModel.fName} ${profileProvider.userInfoModel.lName}',
                                style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                              )),

                          SizedBox(height: 28),
                          // for first name section
                          Text(
                            getTranslated('first_name', context),
                            style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: 'John',
                            isShowBorder: true,
                            controller: _firstNameController,
                            focusNode: _firstNameFocus,
                            nextFocus: _lastNameFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          // for last name section
                          Text(
                            getTranslated('last_name', context),
                            style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: 'Doe',
                            isShowBorder: true,
                            controller: _lastNameController,
                            focusNode: _lastNameFocus,
                            nextFocus: _phoneNumberFocus,
                            inputType: TextInputType.name,
                            capitalization: TextCapitalization.words,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          // for email section
                          Text(
                            getTranslated('email', context),
                            style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: getTranslated('demo_gmail', context),
                            isShowBorder: true,
                            controller: _emailController,
                            isEnabled: false,
                            focusNode: _emailFocus,
                            nextFocus: _phoneNumberFocus,

                            inputType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                          // for phone Number section
                          Text(
                            getTranslated('mobile_number', context),
                            style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: getTranslated('number_hint', context),
                            isShowBorder: true,
                            controller: _phoneNumberController,
                            focusNode: _phoneNumberFocus,
                            nextFocus: _passwordFocus,
                            inputType: TextInputType.phone,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          Text(
                            getTranslated('password', context),
                            style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: getTranslated('password_hint', context),
                            isShowBorder: true,
                            controller: _passwordController,
                            focusNode: _passwordFocus,
                            nextFocus: _confirmPasswordFocus,
                            isPassword: true,
                            isShowSuffixIcon: true,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                          Text(
                            getTranslated('confirm_password', context),
                            style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                          CustomTextField(
                            hintText: getTranslated('password_hint', context),
                            isShowBorder: true,
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocus,
                            isPassword: true,
                            isShowSuffixIcon: true,
                            inputAction: TextInputAction.done,
                          ),
                          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

                        ],
                      ),
                    ),
                  ),
                ),
              ),

              !profileProvider.isLoading ? Center(
                child: Container(
                  width: _width > 700 ? 700 : _width,
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  margin: ResponsiveHelper.isDesktop(context) ? EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL) : EdgeInsets.zero,
                  child: CustomButton(
                    btnTxt: getTranslated('update_profile', context),
                    onTap: () async {
                      String _firstName = _firstNameController.text.trim();
                      String _lastName = _lastNameController.text.trim();
                      String _phoneNumber = _phoneNumberController.text.trim();
                      String _password = _passwordController.text.trim();
                      String _confirmPassword = _confirmPasswordController.text.trim();
                      if (profileProvider.userInfoModel.fName == _firstName &&
                          profileProvider.userInfoModel.lName == _lastName &&
                          profileProvider.userInfoModel.phone == _phoneNumber &&
                          profileProvider.userInfoModel.email == _emailController.text && file == null && data == null
                          && _password.isEmpty && _confirmPassword.isEmpty) {
                        showCustomSnackBar(getTranslated('change_something_to_update', context), context);
                      }else if (_firstName.isEmpty) {
                        showCustomSnackBar(getTranslated('enter_first_name', context), context);
                      }else if (_lastName.isEmpty) {
                        showCustomSnackBar(getTranslated('enter_last_name', context), context);
                      }else if (_phoneNumber.isEmpty) {
                        showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                      } else if((_password.isNotEmpty && _password.length < 6)
                          || (_confirmPassword.isNotEmpty && _confirmPassword.length < 6)) {
                        showCustomSnackBar(getTranslated('password_should_be', context), context);
                      } else if(_password != _confirmPassword) {
                        showCustomSnackBar(getTranslated('password_did_not_match', context), context);
                      } else {
                        UserInfoModel updateUserInfoModel = UserInfoModel();
                        updateUserInfoModel.fName = _firstName ?? "";
                        updateUserInfoModel.lName = _lastName ?? "";
                        updateUserInfoModel.phone = _phoneNumber ?? '';
                        String _pass = _password ?? '';

                        ResponseModel _responseModel = await profileProvider.updateUserInfo(
                          updateUserInfoModel, _pass, file, data,
                          Provider.of<AuthProvider>(context, listen: false).getUserToken(),
                        );

                        if(_responseModel.isSuccess) {
                          profileProvider.getUserInfo(context);
                          showCustomSnackBar(getTranslated('updated_successfully', context), context, isError: false);
                        }else {
                          showCustomSnackBar(_responseModel.message, context);
                        }
                        setState(() {});
                      }
                    },
                  ),
                ),
              ) : Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),

            ],
          ) : Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor)));
        },
      ) : NotLoggedInScreen(),
    );
  }
}
