import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/category_model.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/localization_provider.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/filter_button_widget.dart';
import 'package:flutter_restaurant/view/base/no_data_screen.dart';
import 'package:flutter_restaurant/view/base/product_shimmer.dart';
import 'package:flutter_restaurant/view/base/product_widget.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_web_card_shimmer.dart';
import 'package:flutter_restaurant/view/screens/home/web/widget/product_widget_web.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryScreen extends StatefulWidget {
  final CategoryModel categoryModel;
  CategoryScreen({@required this.categoryModel});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with TickerProviderStateMixin {
  int _tabIndex = 0;
  CategoryModel _categoryModel;
  String _type = 'all';

 @override
  void initState() {
    super.initState();

    _loadData();
  }

  void _loadData() async {
    _categoryModel = widget.categoryModel;
    Provider.of<CategoryProvider>(context, listen: false).getCategoryList(context,false,Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,);
    Provider.of<CategoryProvider>(context, listen: false).getSubCategoryList(context, _categoryModel.id.toString(),Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,);
      }

  @override
  Widget build(BuildContext context) {
   final double _height = MediaQuery.of(context).size.height;
   final double xyz = MediaQuery.of(context).size.width-1170;
   final double realSpaceNeeded =xyz/2;

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context) ? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(100)) : null,
      body: Consumer<CategoryProvider>(
        builder: (context, category, child) {
          return category.isLoading || category.categoryList == null ?
          categoryShimmer(context, _height, category) :
          CustomScrollView(
            physics: BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                backgroundColor: Theme.of(context).cardColor,
                expandedHeight: 200,
                toolbarHeight: 50 + MediaQuery.of(context).padding.top,
                pinned: true,
                floating: false,
                leading: ResponsiveHelper.isDesktop(context)?SizedBox():Container(width:ResponsiveHelper.isDesktop(context) ? 1170: MediaQuery.of(context).size.width,
                    child: IconButton(icon: Icon(Icons.chevron_left, color: ColorResources.COLOR_WHITE), onPressed: () => Navigator.pop(context))),
                flexibleSpace: Container(color:Theme.of(context).canvasColor,margin:ResponsiveHelper.isDesktop(context)?
                EdgeInsets.symmetric(horizontal: realSpaceNeeded):EdgeInsets.symmetric(horizontal: 0),width: ResponsiveHelper.isDesktop(context) ? 1170: MediaQuery.of(context).size.width,
                  child: FlexibleSpaceBar(
                    title: Text(_categoryModel.name??'', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE, color: ColorResources.getWhiteAndBlack(context))),
                    titlePadding: EdgeInsets.only(
                      bottom: 54 + (MediaQuery.of(context).padding.top/2),
                      left: 50,
                      right: 50,
                    ),
                    background: Container(height: 50,width : ResponsiveHelper.isDesktop(context) ? 1170: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(bottom: 50),
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.placeholder_rectangle, fit: BoxFit.cover,
                        image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryBannerImageUrl}/${_categoryModel.bannerImage.isNotEmpty ? _categoryModel.bannerImage : ''}',
                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_rectangle, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(30.0),
                  child: category.subCategoryList != null?Container(
                    width:  ResponsiveHelper.isDesktop(context) ? 1170: MediaQuery.of(context).size.width,
                    color: Theme.of(context).cardColor,
                    child: TabBar(
                      controller: TabController(initialIndex: _tabIndex,
                          length: category.subCategoryList.length+1, vsync: this),
                      isScrollable: true,
                      unselectedLabelColor: ColorResources.getGreyColor(context),
                      indicatorWeight: 3,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicatorColor: Theme.of(context).primaryColor,
                      labelColor: Theme.of(context).textTheme.bodyLarge.color,
                      tabs: _tabs(category),
                      onTap: (int index) {
                        _type = 'all';
                        _tabIndex = index;
                        if(index == 0) {
                          category.getCategoryProductList(context, _categoryModel.id.toString(),Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,);
                        }else {
                          category.getCategoryProductList(context, category.subCategoryList[index-1].id.toString(),Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,);
                        }
                      },
                    ),
                  ):SizedBox(),
                ),
              ),

              SliverToBoxAdapter(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [

                    FilterButtonWidget(
                      type: _type,
                      items: Provider.of<ProductProvider>(context).productTypeList,
                      onSelected: (selected) {
                        _type = selected;
                       category.getCategoryProductList(
                         context, category.selectedSubCategoryId,
                         Provider.of<LocalizationProvider>(context, listen: false).locale.languageCode,
                         type: _type,
                       );

                      },
                    ),

                    ConstrainedBox(
                      constraints: new BoxConstraints(
                        minHeight: _height < 600 ?  _height : _height - 600,
                      ),
                      child: SizedBox(
                        width: 1170,
                        child: category.categoryProductList != null ? category.categoryProductList.length > 0 ?
                        GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 13,
                              mainAxisSpacing: 13,
                              childAspectRatio: ResponsiveHelper.isDesktop(context) ? 0.7 : 4,
                              crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 2 : 1),
                          itemCount: category.categoryProductList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          itemBuilder: (context, index) {
                            return ResponsiveHelper.isDesktop(context) ? ProductWidgetWeb(product: category.categoryProductList[index]): ProductWidget(product: category.categoryProductList[index]);
                          },
                        ) : NoDataScreen(isFooter: false) :
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: 10,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: ResponsiveHelper.isDesktop(context) ? 0.7: 4,
                            crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 2 : 1,
                          ),
                          itemBuilder: (context, index) {
                            return ResponsiveHelper.isDesktop(context)? ProductWidgetWebShimmer ():ProductShimmer(isEnabled: category.categoryProductList == null);
                          },
                        ),
                      ),
                    ),
                    if(ResponsiveHelper.isDesktop(context)) FooterView(),
                  ],
                ),
              ),

            ],
          );
        },
      ),
    );
  }

  SingleChildScrollView categoryShimmer(BuildContext context, double _height, CategoryProvider category) {
    return SingleChildScrollView(
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(minHeight: !ResponsiveHelper.isDesktop(context) && _height < 600 ? _height : _height - 400),
                child: Center(
                  child: SizedBox(
                    width: 1170,
                    child: Column(
                      children: [
                        Shimmer(
                            duration: Duration(seconds: 2),
                            enabled: true,
                            child: Container(height: 200,width: double.infinity,color: Colors.grey[300])),
                        GridView.builder(
                          shrinkWrap: true,
                          itemCount: 10,
                          physics: NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: ResponsiveHelper.isDesktop(context) ? 0.7: 4,
                            crossAxisCount: ResponsiveHelper.isDesktop(context) ? 6 : ResponsiveHelper.isTab(context) ? 2 : 1,
                          ),
                          itemBuilder: (context, index) {
                            return ResponsiveHelper.isDesktop(context)? ProductWidgetWebShimmer ():ProductShimmer(isEnabled: category.categoryProductList == null);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if(ResponsiveHelper.isDesktop(context)) FooterView(),
            ],
          ),
        );
  }

  List<Tab> _tabs(CategoryProvider category) {
    List<Tab> tabList = [];
    tabList.add(Tab(text: 'All'));
    category.subCategoryList.forEach((subCategory) => tabList.add(Tab(text: subCategory.name)));
    return tabList;
  }
}
