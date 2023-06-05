import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/email_checker.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _emailController;
  TextEditingController _numberController;
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  String _countryDialCode;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _numberController = TextEditingController();
    Provider.of<AuthProvider>(context, listen: false).clearVerificationMessage();
    _countryDialCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel.countryCode).dialCode;
  }


  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) : null,
      body: SafeArea(
        child: Center(
          child: Scrollbar(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                    child: Center(
                      child: Container(
                        width: _width > 700 ? 700 : _width,
                        padding: _width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                        decoration: _width > 700 ? BoxDecoration(
                          color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 5, spreadRadius: 1)],
                        ) : null,
                        child: Consumer<AuthProvider>(
                          builder: (context, authProvider, child) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 30),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: ResponsiveHelper.isWeb() ? Consumer<SplashProvider>(
                                    builder:(context, splash, child) => FadeInImage.assetNetwork(
                                      placeholder: Images.placeholder_rectangle, height: MediaQuery.of(context).size.height / 4.5,
                                      image: splash.baseUrls != null ? '${splash.baseUrls.restaurantImageUrl}/${splash.configModel.restaurantLogo}' : '',
                                      imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_rectangle, height: MediaQuery.of(context).size.height / 4.5),
                                    ),
                                  ) : Image.asset(Images.logo, matchTextDirection: true, height: MediaQuery.of(context).size.height / 4.5),
                                ),
                              ),
                              SizedBox(height: 20),
                              Center(
                                  child: Text(
                                getTranslated('signup', context),
                                style: Theme.of(context).textTheme.headline3.copyWith(fontSize: 24, color: ColorResources.getGreyBunkerColor(context)),
                              )),
                              SizedBox(height: 35),


                              Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification?
                              Text(
                                getTranslated('email', context),
                                style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                              ):Text(
                                getTranslated('mobile_number', context),
                                style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                              ),
                              SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                              Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification?
                              CustomTextField(
                                hintText: getTranslated('demo_gmail', context),
                                isShowBorder: true,
                                focusNode: _emailFocus,
                                nextFocus: _numberFocus,
                                inputAction: TextInputAction.next,
                                inputType: TextInputType.emailAddress,
                                controller: _emailController,
                              ):Row(children: [
                                CodePickerWidget(
                                  onChanged: (CountryCode countryCode) {
                                    _countryDialCode = countryCode.dialCode;
                                  },
                                  initialSelection: _countryDialCode,
                                  favorite: [_countryDialCode],
                                  showDropDownButton: true,
                                  padding: EdgeInsets.zero,
                                  showFlagMain: true,
                                  textStyle: TextStyle(color: Theme.of(context).textTheme.headline1.color),

                                ),
                                Expanded(child: CustomTextField(
                                  hintText: getTranslated('number_hint', context),
                                  isShowBorder: true,
                                  controller: _numberController,
                                  focusNode: _numberFocus,
                                  inputType: TextInputType.phone,
                                  inputAction: TextInputAction.done,
                                )),
                              ]),



                              SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  authProvider.verificationMessage.length > 0
                                      ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                                      : SizedBox.shrink(),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      authProvider.verificationMessage ?? "",
                                      style: Theme.of(context).textTheme.headline2.copyWith(
                                            fontSize: Dimensions.FONT_SIZE_SMALL,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                    ),
                                  )
                                ],
                              ),
                              // for continue button
                              SizedBox(height: 12),
                              !authProvider.isPhoneNumberVerificationButtonLoading
                                  ? CustomButton(
                                      btnTxt: getTranslated('continue', context),
                                      onTap: () {
                                        if(Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification){
                                          // String countryCode;
                                          String _email = _emailController.text.trim();


                                          if (_email.isEmpty) {
                                            showCustomSnackBar(getTranslated('enter_email_address', context), context);
                                          }else if (EmailChecker.isNotValid(_email)) {
                                            showCustomSnackBar(getTranslated('enter_valid_email', context), context);
                                          }
                                          else {
                                            authProvider.checkEmail(_email).then((value) async {
                                              if (value.isSuccess) {
                                                authProvider.updateEmail(_email);
                                                if (value.message == 'active') {

                                                  Navigator.pushNamed(context, Routes.getVerifyRoute('sign-up', _email));
                                                } else {
                                                  Navigator.pushNamed(context, Routes.getCreateAccountRoute(_email,));
                                                }
                                              }
                                            });

                                          }
                                        }else{
                                          // String countryCode;
                                          String _number = _countryDialCode+_numberController.text.trim();
                                          String _numberChk = _numberController.text.trim();

                                          if (_numberChk.isEmpty) {
                                            showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                          }
                                          else {
                                            authProvider.checkPhone(_number).then((value) async {
                                              if (value.isSuccess) {
                                                authProvider.updatePhone(_number);
                                                if (value.message == 'active') {
                                                  Navigator.pushNamed(context, Routes.getVerifyRoute('sign-up', _number));
                                                } else {
                                                  Navigator.pushNamed(context, Routes.getCreateAccountRoute(_number));
                                                }
                                              }
                                            });


                                          }

                                        }

                                      },
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                      valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                    )),

                              // for create an account
                              SizedBox(height: 10),
                              InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(context, Routes.getLoginRoute());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        getTranslated('already_have_account', context),
                                        style: Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getGreyColor(context)),
                                      ),
                                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                      Text(
                                        getTranslated('login', context),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3
                                            .copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getGreyBunkerColor(context)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if(ResponsiveHelper.isDesktop(context)) FooterView(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
