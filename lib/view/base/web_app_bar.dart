import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/data/model/response/language_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/auth_provider.dart';
import 'package:flutter_restaurant/provider/cart_provider.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/language_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/order_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/search_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/app_constants.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/branch_button_view.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/on_hover.dart';
import 'package:flutter_restaurant/view/screens/home/home_screen.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/cetegory_hover_widget.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/languageHover_widget.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/status_widget.dart';
import 'package:flutter_restaurant/view/screens/menu/widget/sign_out_confirmation_dialog.dart';
import 'package:provider/provider.dart';


class WebAppBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  State<WebAppBar> createState() => _WebAppBarState();

  @override
  Size get preferredSize => throw UnimplementedError();
}

class _WebAppBarState extends State<WebAppBar> {

  List<PopupMenuEntry<Object>> popUpMenuList(BuildContext context) {
    List<PopupMenuEntry<Object>> list = <PopupMenuEntry<Object>>[];
    List<CategoryModel> _categoryList =  Provider.of<CategoryProvider>(context, listen: false).categoryList;
    list.add(
        PopupMenuItem(
          padding: EdgeInsets.zero,
          value: _categoryList,
          child: MouseRegion(
            onExit: (_)=> Navigator.of(context).pop(),
            child: CategoryHoverWidget(categoryList: _categoryList),
          ),
        ));
    return list;
  }

  List<PopupMenuEntry<Object>> popUpLanguageList(BuildContext context) {
    List<PopupMenuEntry<Object>> _languagePopupMenuEntryList = <PopupMenuEntry<Object>>[];
    List<LanguageModel> _languageList =  AppConstants.languages;
    _languagePopupMenuEntryList.add(
        PopupMenuItem(
          padding: EdgeInsets.zero,
          value: _languageList,
          child: MouseRegion(
            onExit: (_)=> Navigator.of(context).pop(),
            child: LanguageHoverWidget(languageList: _languageList),
          ),
        ));
    return _languagePopupMenuEntryList;
  }



  _showPopupMenu(Offset offset, BuildContext context, bool isCategory) async {
    double left = offset.dx;
    double top = offset.dy;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    await showMenu(
      context: context,
      position: RelativeRect.fromLTRB(left, top, overlay.size.width, overlay.size.height),
      items: isCategory ? popUpMenuList(context) : popUpLanguageList(context),
      elevation: 8.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      
    );

  }

  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();
    Provider.of<LanguageProvider>(context, listen: false).initializeAllLanguages(context);
    final LanguageModel _currentLanguage = AppConstants.languages.firstWhere((language) => language.languageCode == Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode);
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: ColorResources.getWhiteAndBlack(context).withOpacity(0.10), blurRadius: 10, offset: Offset(0,10))]
      ),
      child: Column(
        children: [
          Container(
            color: ColorResources.APPBAR_HEADER_COL0R,
            child: Center(
              child: SizedBox( width: 1170,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      !Provider.of<SplashProvider>(context, listen: false).isRestaurantOpenNow(context) ? Consumer<OrderProvider>(
                       builder: (context, orderProvider, child) {
                        return  Text(
                          '${'${getTranslated('restaurant_is_close_now', context)}'}',
                          style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: Colors.white),
                        );
                      }) : Consumer<LocationProvider>(
                        builder: (context, locationProvider, _) {
                          return locationProvider.address.length > 0 ? InkWell(
                            onTap: ()=>  Navigator.pushNamed(context, Routes.getAddressRoute()),
                            child: locationProvider.isLoading ? SizedBox() : Row(
                              children: [
                                Text(
                                  locationProvider.address,
                                  style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Colors.white),
                                  maxLines: 1, overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),

                                Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ) : SizedBox();
                        }
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          BranchButtonView(isRow: true),
                          SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                            child: Text(getTranslated('dark_theme', context), style: poppinsRegular.copyWith(color: ColorResources.COLOR_WHITE, fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)),
                          ),
                          StatusWidget(),
                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_LARGE),

                          SizedBox(
                            height: Dimensions.PADDING_SIZE_LARGE,
                            child: OnHover(
                              builder: (isHovered) {
                                final color = isHovered ? Colors.black : Colors.white;
                                return MouseRegion(
                                  onHover: (details) {
                                    _showPopupMenu(details.position, context, false);
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(_currentLanguage.imageUrl, height: Dimensions.PADDING_SIZE_LARGE, fit: BoxFit.cover,),
                                      SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                                      Text('${_currentLanguage.languageName}',style: poppinsRegular.copyWith(color: color, fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL)),
                                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                                      Icon(Icons.expand_more, color: color, size: Dimensions.PADDING_SIZE_LARGE)
                                    ],
                                  ),
                                );
                              }
                            ),

                          ),
                          SizedBox(width: Dimensions.PADDING_SIZE_DEFAULT),

                          InkWell(
                            onTap: () {
                              if(_isLoggedIn) {
                                showDialog(context: context, barrierDismissible: false, builder: (context) => SignOutConfirmationDialog());
                              }else {
                                Navigator.pushNamed(context, Routes.getLoginRoute());
                              }
                            },
                            child: OnHover(
                              builder: (isHover) {
                                return Row(children: [
                                  Icon(Icons.lock_outlined, color: ColorResources.COLOR_WHITE, size: Dimensions.PADDING_SIZE_DEFAULT),
                                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                  Text(getTranslated(_isLoggedIn ? 'logout' : 'login', context), style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: ColorResources.COLOR_WHITE))
                                ],
                                );
                              }
                            ),
                          ),

                      ],
                ),
                    ],
                  ),
              ),
            ),
          ),
        ),
          Expanded(
          child: Center(
            child: SizedBox(
                width: 1170,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Provider.of<ProductProvider>(context, listen: false).latestOffset = 1;
                        Navigator.pushNamed(context, Routes.getMainRoute());
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Provider.of<SplashProvider>(context).baseUrls != null?  Consumer<SplashProvider>(
                                builder:(context, splash, child) => FadeInImage.assetNetwork(
                                  placeholder: Images.placeholder_rectangle,
                                  image:  '${splash.baseUrls.restaurantImageUrl}/${splash.configModel.restaurantLogo}',
                                  width: 120, height: 80,
                                  imageErrorBuilder: (c, o, s) => Image.asset(Images.logo, width: 120, height: 80),
                                )): SizedBox(),
                          ),
                        ],
                      ),
                    ),
                    OnHover(builder: (isHover) {
                      return InkWell(
                        onTap: () {
                            Navigator.pushNamed(context, Routes.getHomeRoute(fromAppBar: 'true'));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                          child: Text(getTranslated('home', context),maxLines: 1,overflow: TextOverflow.ellipsis, style: rubikRegular.copyWith(  color: isHover ? Theme.of(context).primaryColor : ColorResources.getWhiteAndBlack(context),
                              fontSize: Dimensions.FONT_SIZE_LARGE)),
                        ),
                      );
                    }),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                      child: MouseRegion(
                        onHover: (details) {
                          if(Provider.of<CategoryProvider>(context, listen: false).categoryList != null)
                            _showPopupMenu(details.position, context, true);
                          },
                        child: OnHover(
                            builder: (isHover) {
                              return Text(getTranslated('category', context),maxLines: 1,overflow: TextOverflow.ellipsis, style: rubikRegular.copyWith(color: isHover ? Theme.of(context).primaryColor : ColorResources.getWhiteAndBlack(context),
                                  fontSize: Dimensions.FONT_SIZE_LARGE));
                            }
                          ),
                        ),
                      ),
                    OnHover(
                      builder: (isHover){
                        return InkWell(
                        onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('favourite')),
                            child: Container(
                              width: 120,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                                child: Text(getTranslated('favourite', context),maxLines: 1,overflow: TextOverflow.ellipsis, style: rubikRegular.copyWith(color: isHover ? Theme.of(context).primaryColor : ColorResources.getWhiteAndBlack(context),
                                fontSize: Dimensions.FONT_SIZE_LARGE)
                        ),
                              ),
                            ));
                      },
                    ),
                    Spacer(),
                    Container(
                      width: 450,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      child: Consumer<SearchProvider>(
                        builder: (context,search,_) {

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 10),
                            child: CustomTextField(
                              hintText: getTranslated('search_items_here', context),
                              isShowBorder: true,
                              fillColor: Theme.of(context).canvasColor,
                              isShowSuffixIcon: true,
                              suffixIconUrl: search.searchController.text.length > 0? Images.close : Images.search,
                              onChanged: (str){
                                str.length = 0;
                                search.getSearchText(str);
                                // print('===>${search.searchController.text.toString()}');

                              },
                              
                              onSuffixTap: () {
                                  // if (search.searchController.text.length > 0) {
                                  //   search.searchController.clear();
                                  //   search.getSearchText('');
                                  // }
                                if(search.searchController.text.length > 0 && search.isSearch == true){
                                  // Provider.of<SearchProvider>(context,listen: false).saveSearchAddress(search.searchController.text);
                                  // Provider.of<SearchProvider>(context,listen: false).searchProduct(search.searchController.text, context);
                                  Navigator.pushNamed(context, Routes.getSearchResultRoute(search.searchController.text),
                                     // arguments: SearchResultScreen(searchString: search.searchController.text),
                                  );

                                  search.searchDone();

                                }
                                else if (search.searchController.text.length > 0 && search.isSearch == false) {
                                  search.searchController.clear();
                                  search.getSearchText('');

                                  search.searchDone();
                                }
                              },
                              controller: search.searchController,
                              inputAction: TextInputAction.search,
                              isIcon: true,
                              onSubmit: (text) {
                                  if (search.searchController.text.length > 0) {
                                    // Provider.of<SearchProvider>(context,listen: false).saveSearchAddress(search.searchController.text);
                                    // Provider.of<SearchProvider>(context,listen: false).searchProduct(search.searchController.text, context);
                                    Navigator.pushNamed(context, Routes.getSearchResultRoute(search.searchController.text));
                                    //Navigator.pushNamed(context, Routes.getSearchResultRoute(_searchController.text.replaceAll(' ', '-')));

                                    search.searchDone();
                                  }

                              },),
                          );

                        }
                      ),
                    ),

                 InkWell(
                   onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('cart')),
                   child: OnHover(
                     builder: (isHover) {
                       return Padding(
                         padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE),
                         child: Stack(
                          clipBehavior: Clip.none, children: [
                          Icon(Icons.shopping_cart, size: Dimensions.PADDING_SIZE_EXTRA_LARGE,color: isHover ? Theme.of(context).primaryColor : ColorResources.getWhiteAndBlack(context)),
                          Positioned(
                            top: -7, right: -7,
                            child: Container(
                              padding: EdgeInsets.all(4),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(shape: BoxShape.circle, color: ColorResources.APPBAR_HEADER_COL0R),
                              child: Center(
                                child: Text(
                                  Provider.of<CartProvider>(context).cartList.length.toString(),
                                  style: rubikMedium.copyWith(color: ColorResources.COLOR_WHITE, fontSize: 8),
                                ),
                              ),
                            ),
                          )]),
                       );
                     }
                   )
                 ),
                    OnHover(
                      builder: (isHover) {
                        return InkWell(
                          onTap: () => Navigator.pushNamed(context, Routes.getDashboardRoute('menu')),
                          child: Icon(Icons.menu, size: Dimensions.PADDING_SIZE_EXTRA_LARGE, color: isHover ? Theme.of(context).primaryColor : ColorResources.getWhiteAndBlack(context)),
                        );
                      }
                    )
                    ],
                  )
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  // ignore: override_on_non_overriding_member
  Size get preferredSize => Size(double.maxFinite, 50);
}
