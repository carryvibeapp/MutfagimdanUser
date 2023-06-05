import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/notification_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/utill/routes.dart';
import 'package:flutter_restaurant/utill/styles.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/screens/order/order_details_screen.dart';

class NotificationPopUpDialog extends StatefulWidget {
  final PayloadModel payloadModel;
  NotificationPopUpDialog(this.payloadModel);

  @override
  State<NotificationPopUpDialog> createState() => _NewRequestDialogState();
}

class _NewRequestDialogState extends State<NotificationPopUpDialog> {

  @override
  void initState() {
    super.initState();

    _startAlarm();
  }

  void _startAlarm() async {
    AudioCache _audio = AudioCache();
    _audio.play('notification.wav');
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT)),
      //insetPadding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
      child: Container(
        width: 500,
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_LARGE),
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          Icon(Icons.notifications_active, size: 60, color: Theme.of(context).primaryColor),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
            child: Text(
              '${widget.payloadModel.title} ${widget.payloadModel.orderId != '' ? '(${widget.payloadModel.orderId})': ''}',
              textAlign: TextAlign.center,
              style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
            ),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_SMALL),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE),
            child: Column(
              children: [
                Text(
                  widget.payloadModel.body, textAlign: TextAlign.center,
                  style: poppinsRegular.copyWith(fontSize: Dimensions.FONT_SIZE_LARGE),
                ),
                if(widget.payloadModel.image != 'null')
                  SizedBox(height: Dimensions.PADDING_SIZE_EXTRA_SMALL,),

                if(widget.payloadModel.image != 'null')
                  Builder(
                    builder: (context) {
                      print('image :${widget.payloadModel.image}');
                      print('type : ${widget.payloadModel.image.runtimeType }');
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: FadeInImage.assetNetwork(
                          image: widget.payloadModel.image,
                          height: 100,
                          width: 500,
                          placeholder: Images.placeholder_image,
                          imageErrorBuilder: (c, o, s) => Image.asset(Images.placeholder_image, height: 70, width: 80, fit: BoxFit.cover),
                        ),
                      );
                    }
                  ),


              ],
            ),
          ),
          SizedBox(height: Dimensions.PADDING_SIZE_LARGE),

          Row(mainAxisAlignment: MainAxisAlignment.center, children: [

            Flexible(
              child: SizedBox(width: 120, height: 40,child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).disabledColor.withOpacity(0.3), padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.RADIUS_DEFAULT)),
                ),
                child: Text(
                  getTranslated('cancel', context), textAlign: TextAlign.center,
                  style: poppinsRegular.copyWith(color: Theme.of(context).textTheme.bodyLarge.color),
                ),
              )),
            ),


            SizedBox(width: 20),

            if(widget.payloadModel.orderId != null || widget.payloadModel.type == 'message') Flexible(
              child: SizedBox(
                width: 120,
                height: 40,
                child: CustomButton(
                  // textColor: Colors.white,
                  btnTxt: getTranslated('go', context),
                  onTap: () {
                    Navigator.pop(context);
                    print('order id : ${widget.payloadModel.orderId} && ${widget.payloadModel.orderId.runtimeType}');

                    try{
                      if(widget.payloadModel.orderId == null
                          ||  widget.payloadModel.orderId == ''
                          || widget.payloadModel.orderId == 'null') {
                        Navigator.pushNamed(context, Routes.getChatRoute(orderModel: null));
                      }else{
                        Get.navigator.push(MaterialPageRoute(
                          builder: (context) => OrderDetailsScreen(
                              orderModel: null,
                              orderId:  int.tryParse(widget.payloadModel.orderId),
                          ),
                        ));
                      }

                    }catch (e) {}

                  },
                ),
              ),
            ),

          ]),

        ]),
      ),
    );
  }
}
