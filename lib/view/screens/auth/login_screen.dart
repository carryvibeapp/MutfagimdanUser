import 'package:country_code_picker/country_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/user_log_data.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/auth/widget/code_picker_widget.dart';
import 'package:flutter_restaurant/view/screens/auth/widget/social_login_widget.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  FocusNode _emailNumberFocus = FocusNode();
  FocusNode _passwordFocus = FocusNode();
  TextEditingController _emailController;
  TextEditingController _passwordController;
  GlobalKey<FormState> _formKeyLogin;
  String _countryDialCode;

  @override
  void initState() {
    super.initState();
    _formKeyLogin = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    UserLogData _userData = Provider.of<AuthProvider>(context, listen: false).getUserData();

    if(_userData != null) {
      _emailController.text = _userData.phoneNumber;
      _passwordController.text = _userData.password;
      _countryDialCode = _userData.countryCode;
    }else{
      _countryDialCode = CountryCode.fromCountryCode(Provider.of<SplashProvider>(context, listen: false).configModel.countryCode).dialCode;

    }


  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   final double _width = MediaQuery.of(context).size.width;
   final _socialStatus = Provider.of<SplashProvider>(context,listen: false).configModel.socialLoginStatus;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) : null,
      body: SafeArea(
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
                      builder: (context, authProvider, child) => Form(
                        key: _formKeyLogin,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  Images.logo,
                                  height: MediaQuery.of(context).size.height / 4.5,
                                  fit: BoxFit.scaleDown,
                                  matchTextDirection: true,
                                ),
                              ),
                            ),
                            Center(
                                child: Text(
                              getTranslated('login', context),
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
                              focusNode: _emailNumberFocus,
                              nextFocus: _passwordFocus,
                              controller: _emailController,
                              inputType: TextInputType.emailAddress,
                            ):
                            Row(children: [
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
                                focusNode: _emailNumberFocus,
                                nextFocus: _passwordFocus,
                                controller: _emailController,
                                inputType: TextInputType.phone,
                              )),
                            ]),
                            SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                            Text(
                              getTranslated('password', context),
                              style: Theme.of(context).textTheme.headline2.copyWith(color: ColorResources.getHintColor(context)),
                            ),
                            SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                            CustomTextField(
                              hintText: getTranslated('password_hint', context),
                              isShowBorder: true,
                              isPassword: true,
                              isShowSuffixIcon: true,
                              focusNode: _passwordFocus,
                              controller: _passwordController,
                              inputAction: TextInputAction.done,
                            ),
                            SizedBox(height: 22),

                            // for remember me section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Consumer<AuthProvider>(
                                    builder: (context, authProvider, child) => InkWell(
                                          onTap: () {
                                            authProvider.toggleRememberMe();
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 18,
                                                height: 18,
                                                decoration: BoxDecoration(
                                                    color: authProvider.isActiveRememberMe ? Theme.of(context).primaryColor : ColorResources.COLOR_WHITE,
                                                    border:
                                                        Border.all(color: authProvider.isActiveRememberMe ? Colors.transparent : Theme.of(context).primaryColor),
                                                    borderRadius: BorderRadius.circular(3)),
                                                child: authProvider.isActiveRememberMe
                                                    ? Icon(Icons.done, color: ColorResources.COLOR_WHITE, size: 17)
                                                    : SizedBox.shrink(),
                                              ),
                                              SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                              Text(
                                                getTranslated('remember_me', context),
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline2
                                                    .copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: ColorResources.getHintColor(context)),
                                              )
                                            ],
                                          ),
                                        )),
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, Routes.getForgetPassRoute());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      getTranslated('forgot_password', context),
                                      style:
                                          Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getHintColor(context)),
                                    ),
                                  ),
                                )
                              ],
                            ),

                            SizedBox(height: 22),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                authProvider.loginErrorMessage.length > 0
                                    ? CircleAvatar(backgroundColor: Theme.of(context).primaryColor, radius: 5)
                                    : SizedBox.shrink(),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    authProvider.loginErrorMessage ?? "",
                                    style: Theme.of(context).textTheme.headline2.copyWith(
                                          fontSize: Dimensions.FONT_SIZE_SMALL,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                  ),
                                )
                              ],
                            ),

                            // for login button
                            SizedBox(height: 10),
                            !authProvider.isLoading
                                ? CustomButton(
                              btnTxt: getTranslated('login', context),
                              onTap: () async {
                                String _email = _emailController.text.trim();
                                if(!Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification){
                                  _email = _countryDialCode +_emailController.text.trim();
                                }

                                String _password = _passwordController.text.trim();
                                if (_emailController.text.isEmpty) {
                                  if(Provider.of<SplashProvider>(context, listen: false).configModel.emailVerification){
                                    showCustomSnackBar(getTranslated('enter_email_address', context), context);
                                  }else {
                                    showCustomSnackBar(getTranslated('enter_phone_number', context), context);
                                  }
                                }else if (_password.isEmpty) {
                                  showCustomSnackBar(getTranslated('enter_password', context), context);
                                }else if (_password.length < 6) {
                                  showCustomSnackBar(getTranslated('password_should_be', context), context);
                                }else {
                                  authProvider.login(_email, _password).then((status) async {
                                    if (status.isSuccess) {

                                      if (authProvider.isActiveRememberMe) {
                                        authProvider.saveUserNumberAndPassword(UserLogData(
                                          countryCode: _countryDialCode,
                                          phoneNumber: _emailController.text,
                                          password: _password,
                                        ));

                                      } else {
                                        authProvider.clearUserLogData();
                                      }
                                      Navigator.pushNamedAndRemoveUntil(context, Routes.getMainRoute(), (route) => false);
                                    }
                                  });
                                }
                              },
                            )
                                : Center(
                                child: CircularProgressIndicator(
                                  valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                                )),

                            // for create an account
                            SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, Routes.getSignUpRoute());
                              },
                              child: Padding(
                                padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getTranslated('create_an_account', context),
                                      style:
                                      Theme.of(context).textTheme.headline2.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getGreyColor(context)),
                                    ),
                                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                                    Text(
                                      getTranslated('signup', context),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3
                                          .copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getGreyBunkerColor(context)),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            if(_socialStatus.isFacebook || _socialStatus.isGoogle)
                              Center(child: SocialLoginWidget()),

                            Center(child: Text(getTranslated('OR', context), style: poppinsRegular.copyWith(fontSize: 12))),

                            Center(
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushReplacementNamed(context, Routes.getDashboardRoute('home'));
                                },
                                child: RichText(text: TextSpan(children: [
                                  TextSpan(text: '${getTranslated('continue_as_a', context)} ',  style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: ColorResources.getHintColor(context))),
                                  TextSpan(text: getTranslated('guest', context), style: poppinsRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge.color)),
                                ])),
                              ),
                            ),
                          ],
                        ),
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
    );
  }
}
