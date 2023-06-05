import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/category_provider.dart';
import 'package:provider/provider.dart';

import '../../../../../provider/splash_provider.dart';
import '../../../../../utill/color_resources.dart';
import '../../../../../utill/dimensions.dart';
import '../../../../../utill/images.dart';
import '../../../../../utill/routes.dart';
import '../../../../../utill/styles.dart';
import '../../../../base/on_hover.dart';

class CategoryPageView extends StatelessWidget {
  final CategoryProvider categoryProvider;
  final PageController pageController;
  const CategoryPageView({Key key, @required this.categoryProvider, @required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int _totalPage = (categoryProvider.categoryList.length / 7).ceil();

    return Container(
      child: PageView.builder(
          controller: pageController,
          itemCount: _totalPage,
          onPageChanged: (index) {
            categoryProvider.updateProductCurrentIndex(index, _totalPage);
          },
          itemBuilder: (context, index) {
            int _initialLength = 7;
            int currentIndex = 7 * index;

            // ignore: unnecessary_statements
            (index + 1 == _totalPage) ? _initialLength = categoryProvider.categoryList.length - (index * 7)  : 7;
            return ListView.builder(
              itemCount: _initialLength, scrollDirection: Axis.horizontal, physics: NeverScrollableScrollPhysics(), shrinkWrap: true,
              itemBuilder: (context, item) {
                int _currentIndex = item  + currentIndex;
                String _name = '';
                categoryProvider.categoryList[_currentIndex].name.length > 15 ? _name = categoryProvider.categoryList[_currentIndex].name.substring(0, 15)+'...' : _name = categoryProvider.categoryList[_currentIndex].name;
                return OnHover(
                    builder: (isHover) {
                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 15.0),
                        child: InkWell(
                          hoverColor: Colors.transparent,
                          onTap: () => Navigator.pushNamed(
                            context, Routes.getCategoryRoute(categoryProvider.categoryList[_currentIndex]),
                          ),// arguments:  category.categoryList[index].name),
                          child: Column(children: [
                            ClipOval(
                              child: FadeInImage.assetNetwork(
                                placeholder: Images.placeholder_image, width: 125, height: 125, fit: BoxFit.cover,
                                image: Provider.of<SplashProvider>(context, listen: false).baseUrls != null
                                    ? '${Provider.of<SplashProvider>(context, listen: false).baseUrls.categoryImageUrl}/${categoryProvider.categoryList[_currentIndex].image}':'',
                                imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, width: 125, height: 125, fit: BoxFit.cover),
                                // width: 100, height: 100, fit: BoxFit.cover,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: FittedBox(
                                  child: Text(
                                      _name, style: rubikMedium.copyWith(color: isHover ? Theme.of(context).primaryColor : ColorResources.getWhiteAndBlack(context)), maxLines: 1, overflow: TextOverflow.ellipsis),
                                ),
                              ),
                            ),

                          ]),
                        ),
                      );
                    }
                );
              }
            );
        },
      ),
    );
  }
}
