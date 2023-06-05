import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/branch_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class BranchCartView extends StatelessWidget {
  final BranchValue branchModel;
  final List<BranchValue> branchModelList;
  final VoidCallback onTap;
  const BranchCartView({
    Key key, this.branchModel, this.onTap, this.branchModelList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Consumer<BranchProvider>(
        builder: (context, branchProvider, _) {
          return GestureDetector(onTap: branchModel.branches.status ?  () {
            branchProvider.updateBranchId(branchModel.branches.id);
            onTap();
          } : null, child: Container(
            width: 320,
            margin: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL).copyWith(bottom: Dimensions.PADDING_SIZE_EXTRA_LARGE),
            decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
                border: branchProvider.selectedBranchId == branchModel.branches.id
                    ? Border.all(color: Theme.of(context).primaryColor.withOpacity(0.6)) : null,
                boxShadow: [BoxShadow(
                  color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(0.1),
                  blurRadius: 30, offset: Offset(0, 3),
                )]
            ),
            padding: EdgeInsets.all(Dimensions.PADDING_SIZE_DEFAULT),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: Images.placeholder_rectangle,
                      image: '${Provider.of<SplashProvider>(context, listen: false).baseUrls.branchImageUrl}/${branchModel.branches.image}',
                      width: 60, fit: BoxFit.cover, height: 60,
                      imageErrorBuilder: (c, o, s) => Image.asset(
                        Images.placeholder_rectangle, width: 60, height: 60, fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: Dimensions.PADDING_SIZE_SMALL),

                  Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                    Text(branchModel.branches.name ?? '', style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE)),
                    SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    Row(children: [
                      Image.asset(Images.branch_icon, width: 20, height: 20),
                      SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                      Text(
                        branchModel.branches.address != null ? branchModel.branches.address.length > 25 ? '${branchModel.branches.address.substring(0, 25)}...' : branchModel.branches.address : branchModel.branches.name,
                        style: rubikMedium.copyWith(color: Theme.of(context).primaryColor),
                        maxLines: 2, overflow: TextOverflow.ellipsis,
                      ),

                    ]),

                  ]),

                ]),

                SizedBox(height: Dimensions.PADDING_SIZE_LARGE,),



                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Row(crossAxisAlignment: CrossAxisAlignment.end,children: [
                    Icon(
                      Icons.schedule_outlined,
                      color:branchModel.branches.status ? Theme.of(context).secondaryHeaderColor : Theme.of(context).errorColor,
                      size: Dimensions.PADDING_SIZE_LARGE,
                    ),
                    SizedBox(width: Dimensions.PADDING_SIZE_EXTRA_SMALL),

                    Text(
                      getTranslated(branchModel.branches.status ? 'open_now' : 'close_now', context),
                      style: rubikRegular.copyWith(
                        fontSize: Dimensions.FONT_SIZE_DEFAULT,
                        color:branchModel.branches.status ? Theme.of(context).secondaryHeaderColor : Theme.of(context).errorColor,
                      ),
                    ),

                  ],),

                if(branchModel.distance != -1)  Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    Text('${branchModel.distance.toStringAsFixed(3)} ${getTranslated('km', context)}',
                      style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),),
                    SizedBox(width: 3),

                    Text(getTranslated('away', context), style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL)),
                  ],),


                ]),



              ],
            ),
          ));
        }
    );
  }
}