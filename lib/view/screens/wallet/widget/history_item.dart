import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/wallet_model.dart';
import 'package:flutter_restaurant/helper/date_converter.dart';
import 'package:flutter_restaurant/helper/price_converter.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_divider.dart';

class HistoryItem extends StatelessWidget {
  final int index;
  final bool formEarning;
  final List<Transaction> data;
  const HistoryItem({Key key, @required this.index, @required this.formEarning, @required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: Dimensions.PADDING_SIZE_EXTRA_SMALL),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(0.08))
      ),
      padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_EXTRA_SMALL, horizontal: Dimensions.PADDING_SIZE_DEFAULT),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            Image.asset(formEarning ? Images.earning_image : Images.converted_image,
              width: 20, height: 20,color: Theme.of(context).secondaryHeaderColor,
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),

            Text(
              getTranslated(data[index].transactionType, context),
              style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Theme.of(context).disabledColor), maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),

           if(data[index].createdAt != null) Text(DateConverter.formatDate(data[index].createdAt,context),
              style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,color: Theme.of(context).disabledColor),
              maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL),
            ],
          ),

          Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
             '${formEarning ? data[index].credit : data[index].debit}',
              style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE,), maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
            Text(
              getTranslated('points', context),
              style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: Theme.of(context).disabledColor), maxLines: 1, overflow: TextOverflow.ellipsis,
            ),
            ],
          ),

        ],),
    );
  }
}

class WalletHistory extends StatelessWidget {
  final Transaction transaction;
  const WalletHistory({Key key, this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _id;
    if(transaction.transactionId != null && transaction.transactionId.length > 15 ) {
      _id = transaction.transactionId.substring(0, 15)+ '...';
    }
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
        Text( 'XID $_id' ?? '',
          style: rubikMedium.copyWith(fontSize: Dimensions.FONT_SIZE_DEFAULT,
            color: Theme.of(context).textTheme.bodyLarge.color,
          ),
        ),
        if(transaction.createdAt != null) Text(DateConverter.formatDate(transaction.createdAt,context, isSecond: false),
          style: robotoRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL,color: Theme.of(context).disabledColor),
          maxLines: 1, overflow: TextOverflow.ellipsis,
        ),
      ]),
      Row(children: [
        SizedBox(height:90 ,width: 13,child: CustomLayoutDivider(height: 6,dashWidth: .7,axis: Axis.vertical,color: Theme.of(context).primaryColor.withOpacity(0.5),)),
        SizedBox(width: Dimensions.PADDING_SIZE_SMALL,),

        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT),
                  border: Border.all(color: Theme.of(context).textTheme.bodyLarge.color.withOpacity(0.08))),

                padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE,vertical: Dimensions.PADDING_SIZE_DEFAULT),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
                  Text(
                    getTranslated(transaction.transactionType, context),
                    style: rubikRegular.copyWith(fontSize: Dimensions.FONT_SIZE_SMALL, color: Theme.of(context).disabledColor), maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  Text(PriceConverter.convertPrice(context, transaction.debit > 0 ? transaction.debit : transaction.credit),style: rubikBold.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE,color: Colors.green),),
                ]),
              ),
              SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT,),

              Container(height: 1,  color: Theme.of(context).disabledColor.withOpacity(0.06)),

            ],
          ),
        ),

      ],),
    ]);
  }
}



class CustomLayoutDivider extends StatelessWidget {
  final double height;
  final double dashWidth;
  final Color color;
  final Axis axis;
  const CustomLayoutDivider({Key key, this.height = 1, this.dashWidth = 5, this.color = Colors.black, this.axis = Axis.horizontal});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: axis,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
