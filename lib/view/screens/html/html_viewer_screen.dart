import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/html_type.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fwfh_selectable_text/fwfh_selectable_text.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'package:universal_ui/universal_ui.dart';
import 'package:url_launcher/url_launcher.dart';


class HtmlViewerScreen extends StatelessWidget {
  final HtmlType htmlType;
  HtmlViewerScreen({@required this.htmlType});

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
    final _policyModel = Provider.of<SplashProvider>(context, listen: false).policyModel;
    String _data = 'no_data_found';
    String _appBarText = '';

    switch (htmlType) {
      case HtmlType.TERMS_AND_CONDITION :
        _data = _configModel.termsAndConditions ?? '';
        _appBarText = 'terms_and_condition';
        break;
      case HtmlType.ABOUT_US :
        _data = _configModel.aboutUs ?? '';
        _appBarText = 'about_us';
        break;
      case HtmlType.PRIVACY_POLICY :
        _data = _configModel.privacyPolicy ?? '';
        _appBarText = 'privacy_policy';
        break;
      case HtmlType.CANCELLATION_POLICY :
        _data = _policyModel.cancellationPage.content ?? '';
        _appBarText = 'cancellation_policy';
        break;
      case HtmlType.REFUND_POLICY :
        _data = _policyModel.refundPage.content ?? '';
        _appBarText = 'refund_policy';
        break;
      case HtmlType.RETURN_POLICY :
        _data = _policyModel.returnPage.content ?? '';
        _appBarText = 'return_policy';
        break;
    }

    if(_data != null && _data.isNotEmpty) {
      _data = _data.replaceAll('href=', 'target="_blank" href=');
    }

    String _viewID = htmlType.toString();
    if(ResponsiveHelper.isWeb()) {
      try{
        ui.platformViewRegistry.registerViewFactory(_viewID, (int viewId) {
          html.IFrameElement _ife = html.IFrameElement();
          _ife.width = '1170';
          _ife.height = MediaQuery.of(context).size.height.toString();
          _ife.srcdoc = _data;
          _ife.contentEditable = 'false';
          _ife.style.border = 'none';
          _ife.allowFullscreen = true;
          return _ife;
        });
      }catch(e) {}
    }
    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) :  CustomAppBar(
        title: getTranslated(_appBarText, context),
        context: context,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                width: 1170,
                child:  ResponsiveHelper.isDesktop(context) ? Column(
                  children: [
                    Container(
                      height: 100, alignment: Alignment.center,
                      child: SelectableText(getTranslated(_appBarText, context),
                        style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE, color: ColorResources.getWhiteAndBlack(context)),
                      ),
                    ),
                    SizedBox(height: 30),
                    ConstrainedBox(
                      constraints: BoxConstraints(minHeight:  _height < 600 ? _height : _height - 400),
                      child: HtmlWidget(_data ?? '',
                        factoryBuilder: () => MyWidgetFactory(),
                        key: Key(htmlType.toString()),
                        onTapUrl: (String url) {
                          return launchUrl(Uri.parse(url));
                        },),
                    ),
                    SizedBox(height: 30),
                  ],
                ) : SingleChildScrollView(
                  padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                  physics: BouncingScrollPhysics(),
                  child: HtmlWidget(
                    _data ?? '',
                    key: Key(htmlType.toString()),
                    onTapUrl: (String url) {
                      return launchUrl(Uri.parse(url));
                    },
                  ),
                ),
              ),
            ),
            if(ResponsiveHelper.isDesktop(context)) FooterView(

            )
          ],
        ),
      ),
    );


  }
}

class MyWidgetFactory extends WidgetFactory with SelectableTextFactory {

  @override
  SelectionChangedCallback  get selectableTextOnChanged => (selection, cause) {};


}