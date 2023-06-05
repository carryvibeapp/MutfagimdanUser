import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/branch_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class BranchItemView extends StatelessWidget {
  final BranchValue branchesValue;

  const BranchItemView({Key key, this.branchesValue}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;
    return Consumer<BranchProvider>(
      builder: (context, branchProvider, _) {
        return GestureDetector(
          onTap: ()=> branchProvider.updateBranchId(branchesValue.branches.id),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(branchProvider.selectedBranchId == branchesValue.branches.id ? 0.8 : 0.1),width: 2),
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
            ),

            child: Stack(
              children: [

                Column(children: [
                  Expanded(child: ClipRRect(
                    borderRadius: BorderRadius.only(topRight: Radius.circular(Dimensions.RADIUS_DEFAULT), topLeft: Radius.circular(Dimensions.RADIUS_DEFAULT)),
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.branch_banner,
                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.branchImageUrl}/${branchesValue.branches.coverImage}',
                      fit: BoxFit.cover,
                      width: Dimensions.WEB_SCREEN_WIDTH,
                      imageErrorBuilder:(c, o, s)=> Image.asset(Images.branch_banner, width: Dimensions.WEB_SCREEN_WIDTH,),
                    ),
                  )),

                  Expanded(child: Container(
                    padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_SMALL),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(Dimensions.RADIUS_DEFAULT), bottomRight: Radius.circular(Dimensions.RADIUS_DEFAULT),
                      ),
                    ),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Image.asset(Images.branch_icon, width: 20, height: 20),
                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                          Text(branchesValue.branches.name, style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),

                        ]),
                        SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

                        Row(children: [
                          Icon(Icons.location_on_outlined, size: 20, color: Theme.of(context).primaryColor),
                          SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                          Text(
                            branchesValue.branches.address != null
                                ? branchesValue.branches.address.length > 25
                                ? '${branchesValue.branches.address.substring(0, 25)}...'
                                : branchesValue.branches.address : branchesValue.branches.name,
                            style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),
                            maxLines: 2, overflow: TextOverflow.ellipsis,
                          ),

                        ]),
                      ]),

                     if(branchesValue.distance != -1) Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Text('${branchesValue.distance.toStringAsFixed(3)} ${getTranslated('km', context)}',
                          style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
                        SizedBox(width: 3),

                        Text(getTranslated('away', context), style: rubikMedium.copyWith(
                          fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor,
                        )),

                      ],),
                    ]),

                  )),
                  SizedBox(height: Dimensions.PADDING_SIZE_SMALL),
                ]),

                Positioned(right: 10, top: 20,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
                      border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
                      child: FadeInImage.assetNetwork(
                        placeholder: Images.placeholder_image,
                        image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.branchImageUrl}/${branchesValue.branches.image}',
                        height: _size.width < 400 ? 38 : 50, width: _size.width < 400 ? 38 : 50,
                        fit: BoxFit.cover,
                        imageErrorBuilder:(c, o, s)=> Image.asset(Images.placeholder_image, width: _size.width < 400 ? 38 : 50),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ),
        );
      }
    );
  }
}