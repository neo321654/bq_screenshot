import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class SettingsstorageData {
  late String saveDirectoryPath;
  late String s3_endPoint;
  late String s3_accessKey;
  late String s3_secretKey;
  late String s3_bucket;

  toJson() async {
    return jsonEncode({
      "saveDirectoryPath": saveDirectoryPath.isNotEmpty? saveDirectoryPath : await getDefaultSaveDirectoryPath(),
      "s3_endPoint": s3_endPoint,
      "s3_accessKey": s3_accessKey,
      "s3_secretKey": s3_secretKey,
      "s3_bucket": s3_bucket,
    });
  }

  fromJson(String json) async {
    if (json.isEmpty == false) {
      Map parse = jsonDecode(json);
      saveDirectoryPath = parse['saveDirectoryPath'];
      if(saveDirectoryPath.isEmpty){
        saveDirectoryPath = await getDefaultSaveDirectoryPath() as String;
      }
      s3_endPoint = parse['s3_endPoint'];
      s3_accessKey = parse['s3_accessKey'];
      s3_secretKey = parse['s3_secretKey'];
      s3_bucket = parse['s3_bucket'];
    }
  }

  Future<String> getDefaultSaveDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return "${directory.path}/Screenshots/";
  }
}

class Settingstorage {
  late SettingsstorageData Settings;

  static const String configFileName = "config.json";

  Settingstorage() {
    Settings = SettingsstorageData();
  }

  Future<Settingstorage> loadSettings() async {
    final configExist = await isConfigExist();
    if (configExist) {
      File settingsFile = await getConfigFile();
      final contents = await settingsFile.readAsString();
      await Settings.fromJson(contents);
    }
    return this;
  }

  Future<void> saveSettings() async {
    File settingsFile = await getConfigFile();
    settingsFile.writeAsStringSync(await Settings.toJson());
  }

  Future<bool> isConfigExist() async {
    File config = await getConfigFile();
    return config.existsSync();
  }

  Future<File> getConfigFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/${configFileName}');
  }
}
