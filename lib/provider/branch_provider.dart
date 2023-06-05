import 'package:flutter/material.dart';
import 'package:flutter_restaurant/data/model/response/config_model.dart';
import 'package:flutter_restaurant/data/repository/splash_repo.dart';
import 'package:flutter_restaurant/main.dart';
import 'package:flutter_restaurant/provider/splash_provider.dart';
import 'package:flutter_restaurant/view/screens/home/home_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class BranchProvider extends ChangeNotifier {
  final SplashRepo splashRepo;
  BranchProvider({@required this.splashRepo});

  int _selectedBranchId;
  int get selectedBranchId => _selectedBranchId;
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  int _branchTabIndex = 0;
  int get branchTabIndex => _branchTabIndex;

  void updateTabIndex(int index, {bool isUpdate = true}){
    _branchTabIndex = index;
    if(isUpdate) {
      notifyListeners();
    }
  }


  void updateBranchId(int value, {bool isUpdate = true}) {
    _selectedBranchId = value;
    if(isUpdate) {
      notifyListeners();
    }
  }

  int getBranchId() => splashRepo.getBranchId();

  Future<void> setBranch(int id) async {
    await splashRepo.setBranchId(id);
    await HomeScreen.loadData(true);
    notifyListeners();
  }

  Branches getBranch({int id}) {
    int branchId = id != null ? id : getBranchId();
    Branches branch;
   ConfigModel _config = Provider.of<SplashProvider>(Get.context, listen: false).configModel;
   if(_config.branches != null && _config.branches.length > 0) {
     try{
       branch = _config.branches.firstWhere((branch) => branch.id == branchId, orElse: null);
     }catch(e){
       splashRepo.setBranchId(-1);
     }
   }
    return branch;
  }


  List<BranchValue> branchSort(LatLng currentLatLng){
    _isLoading = true;
    List<BranchValue> _branchValueList = [];

    Provider.of<SplashProvider>(Get.context, listen: false).configModel.branches.forEach((_branch) {
      double _distance = -1;
      if(currentLatLng != null) {
        _distance = Geolocator.distanceBetween(
          double.parse(_branch.latitude), double.parse(_branch.longitude),
          currentLatLng.latitude, currentLatLng.longitude,
        )/ 1000;
      }

      _branchValueList.add(BranchValue(_branch, _distance));


    });
    _branchValueList.sort((a, b) => a.distance.compareTo(b.distance));

    _isLoading = false;
    notifyListeners();

    return _branchValueList;
  }
}