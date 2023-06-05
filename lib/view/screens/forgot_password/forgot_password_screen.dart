import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/auth/widget/code_picker_widget.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController _emailController;
  TextEditingController _phoneNumberController;
  String _countryDialCode;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
    Provider.of<AuthProvider>(context, listen: false).clearVerificationMessage();
    _countryDialCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel.countryCode).dialCode;
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) : CustomAppBar(context: context, title: getTranslated('forgot_password', context)),
      body: Center(
        child: Scrollbar(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                    child: Container(
                      width: _width > 700 ? 700 : _width,
                      padding: _width > 700 ? EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT) : null,
                      decoration: _width > 700 ? BoxDecoration(
                        color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 5, spreadRadius: 1)],
                      ) : null,
                      child: Consumer<AuthProvider>(
                        builder: (context, auth, child) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 55),
                              Center(
                                child: Image.asset(
                                  Images.close_lock,
                                  width: 142,
                                  height: 142,
                                ),
                              ),
                              SizedBox(height: 40),
                              Provider.of<SplashProvider>(context, listen: false).configModel.phoneVerification?
                              Center(
                                  child: Text(
                                    getTranslated('please_enter_your_mobile_number_to', context),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                                  )):Center(
                                  child: Text(
                                    getTranslated('please_enter_your_number_to', context),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                                  )),
                              Provider.of<SplashProvider>(context, listen: false).configModel.phoneVerification?
                              Padding(
                                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 80),
                                    Text(
                                      getTranslated('mobile_number', context),
                                      style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                                    ),
                                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                    Row(children: [
                                      CodePickerWidget(
                                        onChanged: (CountryCode countryCode) {
                                          _countryDialCode = countryCode.dialCode;
                                        },
                                        initialSelection: _countryDialCode,
                                        favorite: [_countryDialCode],
                                        showDropDownButton: true,
                                        padding: EdgeInsets.zero,
                                        textStyle: TextStyle(color: Theme.of(context).textTheme.headline1.color),
                                        showFlagMain: true,

                                      ),
                                      Expanded(child: CustomTextField(
                                        hintText: getTranslated('number_hint', context),
                                        isShowBorder: true,
                                        controller: _phoneNumberController,
                                        inputType: TextInputType.phone,
                                        inputAction: TextInputAction.done,
                                      ),),
                                    ]),

                                    SizedBox(height: 24),
                                    !auth.isForgotPasswordLoading ? CustomButton(
                                      btnTxt: getTranslated('send', context),
                                      onTap: () {
                                        if (_phoneNumberController.text.isEmpty) {
                                          showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                        }else {
                                          Provider.of<AuthProvider>(context, listen: false).forgetPassword(_countryDialCode+_phoneNumberController.text).then((value) {
                                            if (value.isSuccess) {
                                              Navigator.pushNamed(context, Routes.getVerifyRoute('forget-password', _countryDialCode+_phoneNumberController.text));
                                            } else {
                                              showCustomSnackBar(value.message, context);
                                            }
                                          });
                                        }
                                      },
                                    ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                                  ],
                                ),
                              )
                                  :Padding(
                                padding: const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 80),
                                    Text(
                                      getTranslated('email', context),
                                      style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                                    ),
                                    SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                    CustomTextField(
                                      hintText: getTranslated('demo_gmail', context),
                                      isShowBorder: true,
                                      controller: _emailController,
                                      inputType: TextInputType.emailAddress,
                                      inputAction: TextInputAction.done,
                                    ),
                                    SizedBox(height: 24),
                                    !auth.isForgotPasswordLoading ? CustomButton(
                                      btnTxt: getTranslated('send', context),
                                      onTap: () {
                                        print(Provider.of<SplashProvider>(context, listen: false).configModel.phoneVerification);
                                        if(Provider.of<SplashProvider>(context, listen: false).configModel.phoneVerification){
                                          if (_phoneNumberController.text.isEmpty) {
                                            showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                          }else {
                                            Provider.of<AuthProvider>(context, listen: false).forgetPassword(_countryDialCode+_phoneNumberController.text.trim()).then((value) {
                                              if (value.isSuccess) {
                                                Navigator.pushNamed(context, Routes.getVerifyRoute('forget-password', _countryDialCode+_phoneNumberController.text.trim()));
                                              } else {
                                                showCustomSnackBar(value.message, context);
                                              }
                                            });
                                          }
                                        }else{
                                          if (_emailController.text.isEmpty) {
                                            showCustomSnackBar(getTranslated('enter_email_address', context), context);
                                          }else if (!_emailController.text.contains('@')) {
                                            showCustomSnackBar(getTranslated('enter_valid_email', context), context);
                                          }else {
                                            Provider.of<AuthProvider>(context, listen: false).forgetPassword(_emailController.text).then((value) {
                                              if (value.isSuccess) {
                                                Navigator.pushNamed(context, Routes.getVerifyRoute('forget-password', _emailController.text));
                                              } else {
                                                showCustomSnackBar(getTranslated('customer_not_found', context), context);
                                              }
                                            });
                                          }
                                        }

                                      },
                                    ) : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if(ResponsiveHelper.isDesktop(context)) FooterView()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
