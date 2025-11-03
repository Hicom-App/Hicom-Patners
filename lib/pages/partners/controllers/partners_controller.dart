import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hicom_patners/controllers/api_controller.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../companents/instrument/instrument_components.dart';
import '../../../companents/instrument/show_toast.dart';
import '../../../controllers/get_controller.dart';
import '../../../models/sample/coordinates_models.dart';
import '../../../models/sample/partner_model.dart';
import '../../../models/sample/partner_models.dart';

class CachedTileProvider extends TileProvider {
  @override
  ImageProvider<Object> getImage(TileCoordinates coordinates, TileLayer options) {
    final url = options.urlTemplate!.replaceAll('{x}', coordinates.x.toString()).replaceAll('{y}', coordinates.y.toString()).replaceAll('{z}', coordinates.z.toString()).replaceAll('{s}', options.subdomains.first);
    return NetworkImage(url);
  }
}

class AppDimensions {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double buttonHeight = 56.0;
  static const double cardRadius = 12.0;
  static const double iconSizeLarge = 140.0;
  static const double iconSizeMedium = 28.0;
}


class PartnersController extends GetxController with GetTickerProviderStateMixin {

  late final AnimatedMapController animatedMapController;
  final GetController _getController = Get.find<GetController>();

  final _categories = <String>[].obs;
  final _countries = <String>[].obs;
  final _regions = <String>[].obs;
  final _districts = <String>[].obs;

  final _selectedCategory = 'Barchasi'.obs;
  final _selectedCountry = ''.obs;
  final _selectedRegion = ''.obs;
  final _selectedDistrict = ''.obs;
  final _searchQuery = ''.obs;
  final _viewMode = ViewMode.list.obs;
  final _sortBy = 'distance'.obs;
  final _isLoading = false.obs;
  final _showOnlyOpen = false.obs;
  final _sortByRating = false.obs;
  final _isFiltersApplied = false.obs;
  final locationFieldKey = GlobalKey<FormFieldState>();

  var selectedLocation = const LatLng(41.2995, 69.2401).obs;
  var currentZoom = 10.0.obs;
  var currentLocation = const LatLng(41.2995, 69.2401).obs;
  var isMapReady = false.obs;

  final locationTitleController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();

  List<String> get categories => _categories;
  List<String> get countries => _countries;
  List<String> get regions => _regions;
  List<String> get districts => _districts;
  String get selectedCategory => _selectedCategory.value;
  String get selectedCountry => _selectedCountry.value;
  String get selectedRegion => _selectedRegion.value;
  String get selectedDistrict => _selectedDistrict.value;
  String get searchQuery => _searchQuery.value;
  ViewMode get viewMode => _viewMode.value;
  String get sortBy => _sortBy.value;
  bool get isLoading => _isLoading.value;
  bool get showOnlyOpen => _showOnlyOpen.value;
  bool get sortByRating => _sortByRating.value;
  bool get isFiltersApplied => _isFiltersApplied.value;

  late ScrollController scrollController;
  final RxBool showScrollToTop = false.obs;
  final RxBool mapStyle = false.obs;

  int get currentWeekday => DateTime.now().weekday;
  final mapController = MapController();


  Future<void> initializeApp() async {
    await getCurrentLocation();
  }

  @override
  void onInit() {
    super.onInit();
    animatedMapController = AnimatedMapController(vsync: this, mapController: MapController());
    scrollController = ScrollController();
    scrollController.addListener(() {showScrollToTop.value = scrollController.offset > 200;});
    ever(_getController.partnerModels, (_) => findNearestPartner());

    _loadFilterData();
  }

  @override
  void dispose() {
    animatedMapController.dispose();
    super.dispose();
  }

  WorkingDays? getTodayWorkingDay(List<WorkingDays>? days) {
    if (days == null || days.isEmpty) return null;
    try {
      return days.firstWhere((day) => day.weekday == currentWeekday);
    } catch (e) {
      return null;  // Kun topilmasa
    }
  }

  void _loadFilterData() async {
    try {
      // Davlatlarni yuklash
      await ApiController().getCountries();
      _countries.value = _getController.countriesModel.value.countries?.map((e) => e.name ?? '').toList() ?? [];

      // Default viloyat va tumanlarni yuklash (davlat 1 deb hisoblab)
      await ApiController().getRegions(1);  // Birinchi davlat ID si (yoki _getController.countriesModel.value.countries!.first.id)
      _regions.value = _getController.regionsModel.value.regions?.map((e) => e.name ?? '').toList() ?? [];

      await ApiController().getCities(1);  // Birinchi viloyat ID si
      _districts.value = _getController.citiesModel.value.cities?.map((e) => e.name ?? '').toList() ?? [];
    } catch (e) {
      print('Filter data yuklash xatosi: $e');
      // Default qiymatlar qo'shing (test uchun)
      _countries.value = ['O\'zbekistonss'];  // Misol
      _regions.value = ['Toshkent viloyati'];
      _districts.value = ['Yunusobod'];
    }
  }


  void changeMapStyle(bool isHybrid) {
    mapStyle.value = isHybrid;  // true = giprit, false = shema
    print('Map uslubi o\'zgartirildi: ${isHybrid ? "Giprit" : "Shema"}');  // Debug uchun
    update();  // UI ni yangilash
  }

  bool get isHybridStyle => mapStyle.value;


  Future<void> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        //ShowToast.show('Ruxsat rad etildi', 'Joylashuv ruxsatini sozlamalardan yoqing.', 4, 1);
        InstrumentComponents().locationPermissionDeniedDialog(Get.context!);
      }

      // GPS yoqilganligini tekshirish (Android uchun muhim)
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('GPS o\'chirilgan');
      }

      // Oxirgi ma'lum joylashuvni olish (fallback – tezroq)
      Position? lastPosition = await Geolocator.getLastKnownPosition();
      if (lastPosition != null) {
        currentLocation.value = LatLng(lastPosition.latitude, lastPosition.longitude);
        selectedLocation.value = currentLocation.value;
        print('Oxirgi ma\'lum location ishlatildi: ${lastPosition.latitude}, ${lastPosition.longitude}');
      }

      // Yangi pozitsiyani olish (timeout 60 soniyaga ko'paytirildi)
      Position position = await Geolocator.getCurrentPosition(locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 60), distanceFilter: 10));
      currentLocation.value = LatLng(position.latitude, position.longitude);
      selectedLocation.value = currentLocation.value;

      // Kichik delay qo'shing (map tayyorligini ta'minlash uchun)
      await Future.delayed(const Duration(milliseconds: 500));

      // Siz turgan joyga silliq harakatlantirish va yaqinlashtirish
      if (isMapReady.value) {
        await animatedMapController.animateTo(dest: selectedLocation.value, zoom: 12.0, duration: const Duration(milliseconds: 1200));
      }
      update();
      await Future.delayed(const Duration(milliseconds: 500));
      ApiController().getPartnerMagazine(rating: _sortByRating.value ? true : null);

    } catch (e) {
      print('Xato: $e');
      currentLocation.value = const LatLng(41.2995, 69.2401);
      selectedLocation.value = currentLocation.value;
      update();
      await Future.delayed(const Duration(milliseconds: 500));
      ApiController().getPartnerMagazine(rating: _sortByRating.value ? true : null);
    }
  }


  Rx<Result?> nearestPartner = Rx<Result?>(null);  // Result tipiga o'zgartirildi
  Result? get nearest => nearestPartner.value;

  // Yangi funksiya: Eng yaqin do'konni topish (Result tipida)
  void findNearestPartner() {
    final result = _getController.partnerModels.value.result;
    print('Result uzunligi: ${result?.length ?? 0}');  // Console da ko'ring
    print('Joriy location: ${currentLocation.value.latitude}, ${currentLocation.value.longitude}');
    //if (result == null || result.isEmpty || currentLocation.value.latitude == 0.0) {
    if (result == null || result.isEmpty) {
      print('Topish mumkin emas: result bo\'sh yoki location 0');
      nearestPartner.value = null;
      return;
    }

    Result? closest;  // Allaqachon Result? – yaxshi
    double minDistance = double.infinity;

    for (var partner in result) {
      if (partner.lat == null || partner.lng == null) continue; // Null check
      final distanceStr = partner.distance;
      final distance = _parseDistance(distanceStr);
      if (distance < minDistance) {
        minDistance = distance;
        closest = partner;
      }
    }

    nearestPartner.value = closest;  // Endi xato yo'q
    print('Eng yaqin do\'kon: ${closest?.name}, masofa: ${minDistance.toStringAsFixed(2)} km'); // Debug
    update(); // UI ni yangilash uchun
  }

  double _parseDistance(String distStr) {
    if (distStr == '-' || distStr.isEmpty) return double.infinity;

    // Raqam qismini ajratish (masalan, "1.2 km" yoki "500 m")
    final numStr = distStr.replaceAll(RegExp(r'[^\d.]'), '');
    final num = double.tryParse(numStr) ?? double.infinity;

    if (distStr.contains('m')) {
      return num / 1000.0;  // m ni km ga o'tkazish
    } else {
      return num;  // Allaqachon km
    }
  }
  // moveMap ni saqlang
  void moveMap(MapController mapController, LatLng point, double zoom) {
    mapController.move(point, zoom);
  }


  Future<void> zoomIn() async {
    if (!isMapReady.value) {
      print('Map hali tayyor emas, zoom in to\'xtatildi');  // Debug uchun
      return;
    }
    try {
      currentZoom.value = (currentZoom.value + 1).clamp(1.0, 18.0);
      final currentCenter = animatedMapController.mapController.camera.center;  // To'g'ri controller (animated dan)
      await animatedMapController.animateTo(
        dest: currentCenter,
        zoom: currentZoom.value,
        duration: Duration(milliseconds: 500),
      );
    } catch (e) {
      print('Zoom in xatosi: $e');
    }
  }

  Future<void> zoomOut() async {
    if (!isMapReady.value) {
      print('Map hali tayyor emas, zoom out to\'xtatildi');  // Debug uchun
      return;
    }
    try {
      currentZoom.value = (currentZoom.value - 1).clamp(1.0, 18.0);
      final currentCenter = animatedMapController.mapController.camera.center;  // To'g'ri controller (animated dan)
      await animatedMapController.animateTo(
        dest: currentCenter,
        zoom: currentZoom.value,
        duration: Duration(milliseconds: 500),
      );
    } catch (e) {
      print('Zoom out xatosi: $e');
    }
  }

  void updateLocation(LatLng point) {  // Faqat point
    selectedLocation.value = point;

    animatedMapController.animateTo(
      dest: point,  // Tuzatilgan
      zoom: currentZoom.value,
      duration: const Duration(milliseconds: 800),
    );

    currentLocation.value = point;  // Joriy location ni yangilash
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }


  void _applyFilters() {
    _checkFiltersApplied();
    update();
  }

  String? _previousSortBy;

  // _checkFiltersApplied metodini o'zgartiring (so'rt tugmalari filter menu ni faol qilmasligi uchun)
  void _checkFiltersApplied() {
    _isFiltersApplied.value = _selectedCountry.value.isNotEmpty || _selectedRegion.value.isNotEmpty || _selectedDistrict.value.isNotEmpty;  // SortBy ni olib tashlash (faqat location filterlar)
  }

  void toggleShowOnlyOpen() {
    _showOnlyOpen.value = !_showOnlyOpen.value;
    _selectedCategory.value = 'Barchasi';
    final model = _getController.partnerModels.value;
    model.applyFilterAndSort(_sortBy.value, currentWeekday, _showOnlyOpen.value);
    _getController.partnerModels.refresh();  // UI yangilash
    _applyFilters();
  }

  void toggleSortByRating() {
    _sortByRating.value = !_sortByRating.value;
    if (_sortByRating.value) {
      _sortBy.value = 'rating';  // Sort type o'rnatish
      _selectedCategory.value = 'Barchasi';
    } else {
      _sortBy.value = 'distance';  // Default ga qaytarish
    }
    final model = _getController.partnerModels.value;
    model.applyFilterAndSort(_sortBy.value, currentWeekday, _showOnlyOpen.value);  // Filter holati saqlanadi
    _getController.partnerModels.refresh();  // UI yangilash
    _applyFilters();
  }

  void setSortBy(String sortBy) {
    _sortBy.value = sortBy;
    _sortByRating.value = false;
    _applyFilters();
    sortResults();
  }


  void sortResults() {
    final list = _getController.partnerModels.value.result;
    if (list == null || list.isEmpty) return;

    switch (_sortBy.value) {
      case 'distance':
        list.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
        break;
      case 'rating':
        list.sort((a, b) => (b.rating ?? 0.0).compareTo(a.rating ?? 0.0));
        break;
      case 'open':
        list.sort((a, b) {
          final aOpen = getTodayWorkingDay(a.workingDays)?.isOpen ?? 0;
          final bOpen = getTodayWorkingDay(b.workingDays)?.isOpen ?? 0;
          if (aOpen != bOpen) return bOpen.compareTo(aOpen); // Ochiq (1) birinchi
          return 0;
        });
        break;
      default:
      // Default: old state yoki distance
        _sortBy.value = _previousSortBy ?? 'distance';
        sortResults();  // Recursive, but safe (default ga qaytadi)
        return;
    }

    update();
    findNearestPartner();
  }


  void clearAllFilters() {
    _selectedCategory.value = 'Barchasi';
    _selectedCountry.value = '';
    _selectedRegion.value = '';
    _selectedDistrict.value = '';
    _showOnlyOpen.value = false;
    _sortByRating.value = false;
    _sortBy.value = 'distance';
    _previousSortBy = 'distance';  // Reset old state
    _districts.value = [];
    _applyFilters();
    sortResults();  // Default sort
    Get.back();
  }


  void setCategory(String category) {
    ApiController().getPartnerMagazine(rating: false);
    _selectedCategory.value = category;
    clearAllFilters();
  }


  void setCountry1(String country) {
    _selectedCountry.value = country == 'Barcha davlatlar' ? '' : country;
    _selectedRegion.value = ''; // Davlat o'zgarganda viloyatni tozalash
    _selectedDistrict.value = ''; // Tuman ham tozalanadi
    _selectedCategory.value = 'Barchasi'; // "Barchasi" ga qaytarish
    _applyFilters();
  }


  void setRegion1(String region) {
    _selectedRegion.value = region;
    _selectedDistrict.value = ''; // Viloyat o'zgarganda tumanni tozalash
    _selectedCategory.value = 'Barchasi'; // "Barchasi" ga qaytarish
    if (region.isNotEmpty) {
    } else {
      _districts.value = [];
    }
    _applyFilters();
  }

  void setCountry(String country) {
    _selectedCountry.value = country == 'Barcha davlatlar' ? '' : country;
    _selectedRegion.value = '';  // Viloyatni tozalash
    _selectedDistrict.value = '';  // Tumanlarni tozalash
    _selectedCategory.value = 'Barchasi';
    if (_selectedCountry.value.isNotEmpty) {
      ApiController().getRegions(_getController.countriesModel.value.countries!.firstWhere((e) => e.name == _selectedCountry.value).id!.toInt()).then((value) => _regions.value = _getController.regionsModel.value.regions?.map((e) => e.name ?? '').toList() ?? []);
      _getController.regionsModel.refresh();
    }
    _applyFilters();
  }

  void setRegion(String region) {
    _selectedRegion.value = region;
    _selectedDistrict.value = '';  // Tumanlarni tozalash
    _selectedCategory.value = 'Barchasi';
    if (_selectedRegion.value.isNotEmpty) {
      ApiController().getCities(_getController.regionsModel.value.regions!.firstWhere((e) => e.name == _selectedRegion.value).id!.toInt()).then((value) => _districts.value = _getController.citiesModel.value.cities?.map((e) => e.name ?? '').toList() ?? []);
      _getController.citiesModel.refresh();
    }
    _applyFilters();
  }

  void setDistrict1(String district) {
    _selectedDistrict.value = district;
    _selectedCategory.value = 'Barchasi'; // "Barchasi" ga qaytarish
    _applyFilters();
  }

  void setDistrict(String district) {
    if (_selectedDistrict.value == district) {
      _selectedDistrict.value = '';  // O'sha district ni tanlaganda filter o'chirish (toggle style, ochiq kabi)
    } else {
      _selectedDistrict.value = district;  // Filter o'rnatish
    }
    _selectedCategory.value = 'Barchasi'; // "Barchasi" ga qaytarish
    if (_selectedDistrict.value.isNotEmpty) {
      // Tanlangan district uchun city_id ni topib filter qo'llash
      final selectedCity = _getController.citiesModel.value.cities!.firstWhere((e) => e.name == _selectedDistrict.value);
      final model = _getController.partnerModels.value;
      model.applyFilterAndSort(_sortBy.value, currentWeekday, _showOnlyOpen.value, cityIdFilter: selectedCity.id.toString());  // city_id bo'yicha filter (ochiq kabi)
      _getController.partnerModels.refresh();
    } else {
      // Filter o'chirish: original ga qaytarish
      final model = _getController.partnerModels.value;
      model.resetToFullAndSort(_sortBy.value, currentWeekday);  // Original ga qaytarish
      _getController.partnerModels.refresh();
    }
    _applyFilters();
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
    ApiController().getPartnerMagazine(search: query);
    _applyFilters();
  }

  void toggleViewMode() {
    _viewMode.value = _viewMode.value == ViewMode.list
        ? ViewMode.map
        : ViewMode.list;
  }


}