import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/body/review_body_model.dart';
import 'package:flutter_restaurant/data/model/response/order_details_model.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/product_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/custom_snackbar.dart';
import 'package:flutter_restaurant/view/base/custom_text_field.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:provider/provider.dart';

class ProductReviewWidget extends StatelessWidget {
  final List<OrderDetailsModel> orderDetailsList;
  ProductReviewWidget({@required this.orderDetailsList});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        return Scrollbar(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: ResponsiveHelper.isDesktop(context) ? MediaQuery.of(context).size.height - 400 : MediaQuery.of(context).size.height),
                    child: SizedBox(
                      width: 1170,
                      child: ListView.builder(
                        itemCount: orderDetailsList.length,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                        itemBuilder: (context, index) {
                          return Container(
                            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_SMALL),
                            margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_SMALL),
                            decoration: BoxDecoration(
                              boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), spreadRadius: 1, blurRadius: 2, offset: Offset(0, 1))],
                              color: Theme.of(context).cardColor,
                              borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                            ),
                            child: Column(
                              children: [

                                // Product details
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: FadeInImage.assetNetwork(
                                        placeholder: Images.placeholder_image, height: 70, width: 85, fit: BoxFit.cover,
                                        image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.productImageUrl}/${orderDetailsList[index].productDetails.image}',
                                        imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, height: 70, width: 85, fit: BoxFit.cover),
                                      ),
                                    ),
                                    SizedBox(width: Dimensions.PADDING_SIZE_SMALL),
                                    Expanded(child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(orderDetailsList[index].productDetails.name, style: rubikMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                                        SizedBox(height: 10),
                                        Text(PriceConverter.convertPrice(context, orderDetailsList[index].productDetails.price), style: rubikBold),
                                      ],
                                    )),
                                    Row(children: [
                                      Text(
                                        '${getTranslated('quantity', context)}: ',
                                        style: rubikMedium.copyWith(color: ColorResources.getGreyBunkerColor(context)), overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        orderDetailsList[index].quantity.toString(),
                                        style: rubikMedium.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.FONT_SIZE_SMALL),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ]),
                                  ],
                                ),
                                Divider(height: 20),

                                // Rate
                                Text(
                                  getTranslated('rate_the_food', context),
                                  style: rubikMedium.copyWith(color: ColorResources.getGreyBunkerColor(context)), overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                                SizedBox(
                                  height: 30,
                                  child: ListView.builder(
                                    itemCount: 5,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, i) {
                                      return InkWell(
                                        child: Icon(
                                          productProvider.ratingList[index] < (i + 1) ? Icons.star_border : Icons.star,
                                          size: 25,
                                          color: productProvider.ratingList[index] < (i + 1)
                                              ? ColorResources.getGreyColor(context)
                                              : Theme.of(context).primaryColor,
                                        ),
                                        onTap: () {
                                          if(!productProvider.submitList[index]) {
                                            Provider.of<ProductProvider>(context, listen: false).setRating(index, i + 1);
                                          }
                                        },
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                Text(
                                  getTranslated('share_your_opinion', context),
                                  style: rubikMedium.copyWith(color: ColorResources.getGreyBunkerColor(context)), overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
                                CustomTextField(
                                  maxLines: 3,
                                  capitalization: TextCapitalization.sentences,
                                  isEnabled: !productProvider.submitList[index],
                                  hintText: getTranslated('write_your_review_here', context),
                                  fillColor: ColorResources.getSearchBg(context),
                                  onChanged: (text) {
                                    productProvider.setReview(index, text);
                                  },
                                ),
                                SizedBox(height: 20),

                                // Submit button
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
                                  child: Column(
                                    children: [
                                      !productProvider.loadingList[index] ? CustomButton(
                                        btnTxt: getTranslated(productProvider.submitList[index] ? 'submitted' : 'submit', context),
                                        backgroundColor: productProvider.submitList[index] ? ColorResources.getGreyColor(context) : Theme.of(context).primaryColor,
                                        onTap: () {
                                          if(!productProvider.submitList[index]) {
                                            if (productProvider.ratingList[index] == 0) {
                                              showCustomSnackBar('Give a rating', context);
                                            } else if (productProvider.reviewList[index].isEmpty) {
                                              showCustomSnackBar('Write a review', context);
                                            } else {
                                              FocusScopeNode currentFocus = FocusScope.of(context);
                                              if (!currentFocus.hasPrimaryFocus) {
                                                currentFocus.unfocus();
                                              }
                                              ReviewBody reviewBody = ReviewBody(
                                                productId: orderDetailsList[index].productId.toString(),
                                                rating: productProvider.ratingList[index].toString(),
                                                comment: productProvider.reviewList[index],
                                                orderId: orderDetailsList[index].orderId.toString(),
                                              );
                                              productProvider.submitReview(index, reviewBody).then((value) {
                                                if (value.isSuccess) {
                                                  showCustomSnackBar(value.message, context, isError: false);
                                                  productProvider.setReview(index, '');
                                                } else {
                                                  showCustomSnackBar(value.message, context);
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
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                if(ResponsiveHelper.isDesktop(context)) Padding(
                  padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
                  child: FooterView(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
