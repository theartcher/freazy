import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  Future<void> saveDurations(List<Duration> durations) async {
    final preferences = await SharedPreferences.getInstance();

    final durationList = durations.map((d) => d.inMilliseconds).toList();

    await preferences.setStringList(
        'durations', durationList.map((d) => d.toString()).toList());
  }

  Future<List<Duration>> loadDurations() async {
    final preferences = await SharedPreferences.getInstance();
    final durationList = preferences.getStringList('durations');

    if (durationList == null) {
      return [];
    }

    return durationList
        .map((d) => Duration(milliseconds: int.parse(d)))
        .toList();
  }

  Future<void> saveReceiveNotifications(bool value) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool('receiveNotifications', value);
  }

  Future<bool> loadReceiveNotifications() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getBool('receiveNotifications') ?? false;
  }
}
