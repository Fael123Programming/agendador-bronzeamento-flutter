import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ConfigController extends GetxController {
  static const since = 'since';
  static const name = 'name';
  static const bronzes = 'bronzes';

  late GetStorage config;

  Future<void> init() async {
    await GetStorage.init('Config');
    config = GetStorage('Config');
    await config.writeIfNull('turnArounds', '1');
    await config.writeIfNull('defaultHours', '0');
    await config.writeIfNull('defaultMins', '0');
    await config.writeIfNull('defaultSecs', '1');
    await config.writeIfNull('defaultPrice', '10.00');
    await config.writeIfNull('sortBy', 'name');
    await config.writeIfNull('increasing', true);
  }

  dynamic _get(String key) {
    return config.read(key);
  }

  Future<void> _set(String key, dynamic value) async {
    await config.write(key, value);
  }

  String getTurnArounds() {
    return _get('turnArounds');
  }

  Future<void> setTurnArounds(String turnArounds) async {
    await _set('turnArounds', turnArounds);
  }

  String getDefaultHours() {
    return _get('defaultHours');
  }

  Future<void> setDefaultHours(String defaultHours) async {
    await _set('defaultHours', defaultHours);
  }

  String getDefaultMins() {
    return _get('defaultMins');
  }

  Future<void> setDefaultMins(String defaultMins) async {
    await _set('defaultMins', defaultMins);
  }

  String getDefaultSecs() {
    return _get('defaultSecs');
  }

  Future<void> setDefaultSecs(String defaultSecs) async {
    await _set('defaultSecs', defaultSecs);
  }

  String getDefaultPrice() {
    return _get('defaultPrice');
  }

    Future<void> setDefaultPrice(String defaultPrice) async {
    await _set('defaultPrice', defaultPrice);
  }

  String getSortBy() {
    return _get('sortBy');
  }

  Future<void> setSortBy(String sortBy) async {
    await _set('sortBy', sortBy);
  }

  bool getIncreasing() {
    return _get('increasing');
  }

  Future<void> setIncreasing(bool value) async {
    await _set('increasing', value);
  }
}