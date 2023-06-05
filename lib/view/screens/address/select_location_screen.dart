import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_restaurant/helper/responsive_helper.dart';
import 'package:flutter_restaurant/localization/language_constrants.dart';
import 'package:flutter_restaurant/provider/location_provider.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/utill/color_resources.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:flutter_restaurant/utill/images.dart';
import 'package:flutter_restaurant/view/base/custom_button.dart';
import 'package:flutter_restaurant/view/base/footer_view.dart';
import 'package:flutter_restaurant/view/base/web_app_bar.dart';
import 'package:flutter_restaurant/view/screens/address/widget/location_search_dialog.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'widget/permission_dialog.dart';

class SelectLocationScreen extends StatefulWidget {
  final GoogleMapController googleMapController;
  SelectLocationScreen({@required this.googleMapController});

  @override
  _SelectLocationScreenState createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  GoogleMapController _controller;
  TextEditingController _locationController = TextEditingController();
  CameraPosition _cameraPosition;
  LatLng _initialPosition;

  @override
  void initState() {
    super.initState();
    _initialPosition = LatLng(
      double.parse(Provider.of<SplashProvider>(context, listen: false).configModel.branches[0].latitude ),
      double.parse(Provider.of<SplashProvider>(context, listen: false).configModel.branches[0].longitude),
    );
    if(Provider.of<LocationProvider>(context, listen: false).position != null ) {
      Provider.of<LocationProvider>(context, listen: false).setPickData();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _openSearchDialog(BuildContext context, GoogleMapController mapController) async {
    showDialog(context: context, builder: (context) => LocationSearchDialog(mapController: mapController));
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    if (Provider.of<LocationProvider>(context).address != null) {
      // _locationController.text = '${Provider.of<LocationProvider>(context).address.name ?? ''}, '
      //     '${Provider.of<LocationProvider>(context).address.subAdministrativeArea ?? ''}, '
      //     '${Provider.of<LocationProvider>(context).address.isoCountryCode ?? ''}';
      _locationController.text = Provider.of<LocationProvider>(context).address ?? '';
    }

    return Scaffold(
      appBar: ResponsiveHelper.isDesktop(context)? PreferredSize(child: WebAppBar(), preferredSize: Size.fromHeight(120)) :  AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        leading: SizedBox.shrink(),
        centerTitle: true,
        title: Text(getTranslated('select_delivery_address', context)),
      ),
      body: SingleChildScrollView(
        physics: ResponsiveHelper.isDesktop(context) ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_SMALL : 0 ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(ResponsiveHelper.isDesktop(context) ? Dimensions.PADDING_SIZE_SMALL : 0 ),
                  decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
                    color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10),
                    boxShadow: [BoxShadow(color: Colors.grey[300], blurRadius: 5, spreadRadius: 1)],
                  ) : null,
                  width: Dimensions.WEB_SCREEN_WIDTH,
                  height: ResponsiveHelper.isDesktop(context) ?   _height * 0.7 : _height * 0.9,
                  child: Consumer<LocationProvider>(
                    builder: (context, locationProvider, child) => Stack(
                      clipBehavior: Clip.none, children: [
                      SafeArea(
                        child: GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition:  CameraPosition(
                            target:  _initialPosition,
                            zoom: 16,
                          ),
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                          minMaxZoomPreference: MinMaxZoomPreference(0, 16),
                          compassEnabled: false,
                          indoorViewEnabled: true,
                          mapToolbarEnabled: true,
                          onCameraIdle: () {
                            locationProvider.updatePosition(_cameraPosition, false, null, context, false);
                          },
                          onCameraMove: ((_position) => _cameraPosition = _position),
                          // markers: Set<Marker>.of(locationProvider.markers),
                          onMapCreated: (GoogleMapController controller) {
                            Future.delayed(Duration(milliseconds: 500)).then((value) {
                              _controller = controller;
                              _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: locationProvider.pickPosition.longitude.toInt() == 0 &&  locationProvider.pickPosition.latitude.toInt() == 0 ? _initialPosition : LatLng(
                                locationProvider.pickPosition.latitude , locationProvider.pickPosition.longitude,
                              ), zoom: 15)));
                            });


                          },
                        ),
                      ),
                      locationProvider.pickAddress != null?
                      InkWell(
                        onTap: () => _openSearchDialog(context, _controller),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 18.0),
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_LARGE, vertical: 23.0),
                          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL)),
                          child: Builder(
                              builder: (context) {
                                _locationController.text = locationProvider.pickAddress;
                                // if(locationProvider.pickAddress.name != null && ResponsiveHelper.isMobilePhone()) {
                                //   locationProvider.locationController.text = '${locationProvider.pickAddress.name ?? ''} ${locationProvider.pickAddress.subAdministrativeArea ?? ''} ${locationProvider.pickAddress.isoCountryCode ?? ''}';
                                // }

                                return Row(children: [
                                  Expanded(child: Text(
                                      locationProvider.pickAddress ?? ''
                                      // locationProvider.pickAddress.name != null
                                      // ? '${locationProvider.pickAddress.name ?? ''} ${locationProvider.pickAddress.subAdministrativeArea ?? ''} ${locationProvider.pickAddress.isoCountryCode ?? ''}'
                                       , maxLines: 1, overflow: TextOverflow.ellipsis)),
                                  Icon(Icons.search, size: 20),
                                ]);
                              }
                          ),
                        ),
                      ):SizedBox.shrink(),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () => _checkPermission(() {
                                locationProvider.getCurrentLocation(context, true, mapController: _controller);
                              }, context),
                              child: Container(
                                width: 50,
                                height: 50,
                                margin: EdgeInsets.only(right: Dimensions.PADDING_SIZE_LARGE),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(Dimensions.PADDING_SIZE_SMALL),
                                  color: ColorResources.COLOR_WHITE,
                                ),
                                child: Icon(
                                  Icons.my_location,
                                  color: Theme.of(context).primaryColor,
                                  size: 35,
                                ),
                              ),
                            ),
                            SafeArea(
                              child: Center(
                                child: Container(
                                  width: ResponsiveHelper.isDesktop(context) ? 450 : 1170,
                                  child: Padding(
                                    padding: EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),
                                    child: CustomButton(
                                      btnTxt: getTranslated('select_location', context),
                                      onTap: locationProvider.loading ? null : () {
                                        if(widget.googleMapController != null) {
                                          widget.googleMapController.setMapStyle('[]');
                                          widget.googleMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(
                                            locationProvider.pickPosition.latitude, locationProvider.pickPosition.longitude,
                                          ), zoom: 16)));

                                          if(ResponsiveHelper.isWeb()) {
                                            locationProvider.setAddAddressData();
                                          }
                                        }
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          height: MediaQuery.of(context).size.height,
                          child: Image.asset(
                            Images.marker,
                            width: 25,
                            height: 35,
                          )),
                      locationProvider.loading ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor))) : SizedBox(),
                    ],
                    ),
                  ),
                ),
              ),
            ),
            if(ResponsiveHelper.isDesktop(context)) SizedBox(height: Dimensions.PADDING_SIZE_LARGE),
            if(ResponsiveHelper.isDesktop(context)) FooterView(),
          ],
        ),
      ),
    );
  }
  void _checkPermission(Function callback, BuildContext context) async {
    LocationPermission permission = await Geolocator.requestPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }else if(permission == LocationPermission.deniedForever) {
      showDialog(context: context, barrierDismissible: false, builder: (context) => PermissionDialog());
    }else {
      callback();
    }
  }
}
