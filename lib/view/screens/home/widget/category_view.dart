import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/title_widget.dart';
import 'package:flutter_restaurant/view/screens/home/widget/category_pop_up.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Consumer<CategoryProvider>(
      builder: (context, category, child) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(10, 20, 0, 10),
              child: TitleWidget(title: getTranslated('all_categories', context)),
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 80,
                    child: category.categoryList != null ? category.categoryList.length > 0 ? ListView.builder(
                      itemCount: category.categoryList.length,
                      padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        String _name = '';
                        category.categoryList[index].name.length > 15  ? _name = category.categoryList[index].name.substring(0, 15)+' ...' : _name = category.categoryList[index].name;
                        return Padding(
                          padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                          child: InkWell(
                            onTap: () => Navigator.pushNamed(
                              context, Routes.getCategoryRoute(category.categoryList[index]),
                            ),
                            child: Column(children: [
                              ClipOval(
                                child: FadeInImage.assetNetwork(
                                  placeholder: Images.placeholder_image, width: 65, height: 65, fit: BoxFit.cover,
                                  image: Provider.of<SplashProvider>(context, listen: false).baseUrls != null
                                      ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${category.categoryList[index].image}':'',
                                  imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, width: 65, height: 65, fit: BoxFit.cover),
                                  // width: 100, height: 100, fit: BoxFit.cover,
                                ),
                              ),

                              Flexible(
                                child: Text(
                                  _name,
                                  style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),

                            ]),
                          ),
                        );
                      },
                    ) : Center(child: Text(getTranslated('no_category_available', context))) : CategoryShimmer(),
                  ),
                ),
               ResponsiveHelper.isMobile(context)? SizedBox(): category.categoryList != null ? Column(
                  children: [
                    InkWell(
                      onTap: (){
                        showDialog(context: context, builder: (con) => Dialog(
                          child: Container(height: 550, width: 600, child: CategoryPopUp())
                        ));
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
                        child: CircleAvatar(
                          radius: 35,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(getTranslated('view_all', context), style: TextStyle(fontSize: 14,color: Colors.white)),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,)
                  ],
                ): CategoryAllShimmer()
              ],
            ),

          ],
        );
      },
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        itemCount: 14,
        padding: EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL),
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
            child: Shimmer(
              duration: Duration(seconds: 2),
              enabled: Provider.of<CategoryProvider>(context).categoryList == null,
              child: Column(children: [
                Container(
                  height: 65, width: 65, 
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(height: 5),
                Container(height: 10, width: 50, color: Colors.grey[300]),
              ]),
            ),
          );
        },
      ),
    );
  }
}

class CategoryAllShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: EdgeInsets.only(right: Dimensions.PADDING_SIZE_SMALL),
        child: Shimmer(
          duration: Duration(seconds: 2),
          enabled: Provider.of<CategoryProvider>(context).categoryList == null,
          child: Column(children: [
            Container(
              height: 65, width: 65,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(height: 5),
            Container(height: 10, width: 50, color: Colors.grey[300]),
          ]),
        ),
      ),
    );
  }
}

