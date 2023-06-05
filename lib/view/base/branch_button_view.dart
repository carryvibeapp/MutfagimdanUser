import 'package:flutter/material.dart';
import 'package:flutter_restaurant/provider/branch_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:provider/provider.dart';

class BranchButtonView extends StatelessWidget {
  final isRow;
  const BranchButtonView({
    Key key, this.isRow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<BranchProvider>(
        builder: (context, branchProvider, _) {
          return branchProvider.getBranchId() != -1 ? InkWell(
              onTap: ()=>  Navigator.pushNamed(context, Routes.getBranchListScreen()),
              child: isRow ? Row(children: [
                Row(children: [
                  Image.asset(
                    Images.branch_icon, color: Colors.white, height: Dimensions.PADDING_SIZE_DEFAULT,
                  ),

                  RotatedBox(quarterTurns: 1,child: Icon(Icons.sync_alt, color: Colors.white, size: Dimensions.PADDING_SIZE_DEFAULT)),
                  SizedBox(width: 2),

                  Text(
                    branchProvider.getBranch().name,
                    style:  poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_EXTRA_SMALL, color: Colors.white),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                ]),
              ]) : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(children: [
                    Image.asset(
                      Images.branch_icon, color: Theme.of(context).textTheme.bodyLarge.color, height: Dimensions.PADDING_SIZE_DEFAULT,
                    ),
                    RotatedBox(quarterTurns: 1,child: Icon(Icons.sync_alt, color: Theme.of(context).textTheme.bodyLarge.color, size: Dimensions.PADDING_SIZE_DEFAULT))
                  ]),
                  SizedBox(height: 2),


                  Text(
                    branchProvider.getBranch().name,
                    style: robotoRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge.color, fontSize: Dimensions.FONT_SIZE_SMALL),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  )
                ],
              )) : SizedBox();
        }
    );
  }
}