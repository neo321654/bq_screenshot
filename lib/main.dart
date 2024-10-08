import 'dart:async';
import 'dart:io';
// import 'dart:io';

//import 'package:bq_screenshot/menu.dart';
//import 'package:bq_screenshot/tray.dart';

// import 'package:tray_manager/tray_manager.dart';

import 'package:talker_flutter/talker_flutter.dart';

import '/utils/functions.dart';

import '/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:hotkey_manager/hotkey_manager.dart';
import 'package:window_manager/window_manager.dart';

//import 'app_window.dart';
//import 'constants.dart';
//import 'menu_item.dart';

// import 'package:system_tray/system_tray.dart';

// import 'package:bitsdojo_window/bitsdojo_window.dart';
// import 'package:english_words/english_words.dart';
// import 'package:system_tray/system_tray.dart';

// import 'package:system_tray/system_tray.dart' ;

final talker = TalkerFlutter.init();

void main() async {
  checkDateReturn();

  runZonedGuarded(() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      talker.error('Caught a Flutter error: ${details.exception}');
    };

    WidgetsFlutterBinding.ensureInitialized();

    await hotKeyManager.unregisterAll();

    await windowManager.ensureInitialized();

    WindowOptions windowOptions = const WindowOptions(
      size: Size(800, 600),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });

    runApp(TalkerWrapper(
        talker: talker,
        options: const TalkerWrapperOptions(
          enableErrorAlerts: true,
        ),
        child: MyApp()));
  }, (error, stackTrace) {
    talker.error('Caught an error in zone: $error');
  });
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final AppWindow _appWindow = AppWindow();
  // final SystemTray _systemTray = SystemTray();
  // final Menu _menuMain = Menu();
  // final Menu _menuSimple = Menu();

  // Timer? _timer;
  bool _toogleTrayIcon = true;

  bool _toogleMenu = true;

  @override
  void initState() {
    super.initState();
    // initSystemTray();
  }

  @override
  void dispose() {
    super.dispose();
    // _timer?.cancel();
  }

  // Future<void> initSystemTray() async {
  //   List<String> iconList = ['darts_icon', 'gift_icon'];
  //
  //   // We first init the systray menu and then add the menu entries
  //   await _systemTray.initSystemTray(iconPath: getTrayImagePath('app_icon'), title: '');
  //   _systemTray.setTitle("system tray");
  //   _systemTray.setToolTip("How to use system tray with Flutter");
  //
  //   // handle system tray event
  //   _systemTray.registerSystemTrayEventHandler((eventName) {
  //     debugPrint("eventName: $eventName");
  //     if (eventName == kSystemTrayEventClick) {
  //       Platform.isWindows ? _appWindow.show() : _systemTray.popUpContextMenu();
  //     } else if (eventName == kSystemTrayEventRightClick) {
  //       Platform.isWindows ? _systemTray.popUpContextMenu() : _appWindow.show();
  //     }
  //   });
  //
  //   await _menuMain.buildFrom(
  //     [
  //       MenuItemLabel(
  //         label: 'Change Context Menu',
  //         image: getImagePath('darts_icon'),
  //         onClicked: (menuItem) {
  //           debugPrint("Change Context Menu");
  //
  //           _toogleMenu = !_toogleMenu;
  //           _systemTray.setContextMenu(_toogleMenu ? _menuMain : _menuSimple);
  //         },
  //       ),
  //       MenuSeparator(),
  //       MenuItemLabel(
  //           label: 'Show',
  //           image: getImagePath('darts_icon'),
  //           onClicked: (menuItem) => _appWindow.show()),
  //       MenuItemLabel(
  //           label: 'Hide',
  //           image: getImagePath('darts_icon'),
  //           onClicked: (menuItem) => _appWindow.hide()),
  //       MenuSeparator(),
  //       SubMenu(
  //         label: "Test API",
  //         image: getImagePath('gift_icon'),
  //         children: [
  //           SubMenu(
  //             label: "setSystemTrayInfo",
  //             image: getImagePath('darts_icon'),
  //             children: [
  //               MenuItemLabel(
  //                 label: 'setTitle',
  //                 image: getImagePath('darts_icon'),
  //                 onClicked: (menuItem) {
  //                   final String text = 'WordPair.random().asPascalCase';
  //                   debugPrint("click 'setTitle' : $text");
  //                   _systemTray.setTitle(text);
  //                 },
  //               ),
  //               MenuItemLabel(
  //                 label: 'setImage',
  //                 image: getImagePath('gift_icon'),
  //                 onClicked: (menuItem) {
  //                   String iconName =
  //                   iconList[1];
  //                   String path = getTrayImagePath(iconName);
  //                   debugPrint("click 'setImage' : $path");
  //                   _systemTray.setImage(path);
  //                 },
  //               ),
  //               MenuItemLabel(
  //                 label: 'setToolTip',
  //                 image: getImagePath('darts_icon'),
  //                 onClicked: (menuItem) {
  //                   final String text = 'WordPair.random().asPascalCase';
  //                   debugPrint("click 'setToolTip' : $text");
  //                   _systemTray.setToolTip(text);
  //                 },
  //               ),
  //               MenuItemLabel(
  //                 label: 'getTitle',
  //                 image: getImagePath('gift_icon'),
  //                 onClicked: (menuItem) async {
  //                   String title = await _systemTray.getTitle();
  //                   debugPrint("click 'getTitle' : $title");
  //                 },
  //               ),
  //             ],
  //           ),
  //           MenuItemLabel(
  //               label: 'disabled Item',
  //               name: 'disableItem',
  //               image: getImagePath('gift_icon'),
  //               enabled: false),
  //         ],
  //       ),
  //       MenuSeparator(),
  //       MenuItemLabel(
  //         label: 'Set Item Image',
  //         onClicked: (menuItem) async {
  //           debugPrint("click 'SetItemImage'");
  //
  //           String iconName = iconList[1];
  //           String path = getImagePath(iconName);
  //
  //           await menuItem.setImage(path);
  //           debugPrint(
  //               "click name: ${menuItem.name} menuItemId: ${menuItem.menuItemId} label: ${menuItem.label} image: ${menuItem.image}");
  //         },
  //       ),
  //       MenuItemCheckbox(
  //         label: 'Checkbox 1',
  //         name: 'checkbox1',
  //         checked: true,
  //         onClicked: (menuItem) async {
  //           debugPrint("click 'Checkbox 1'");
  //
  //           MenuItemCheckbox? checkbox1 =
  //           _menuMain.findItemByName<MenuItemCheckbox>("checkbox1");
  //           await checkbox1?.setCheck(!checkbox1.checked);
  //
  //           MenuItemCheckbox? checkbox2 =
  //           _menuMain.findItemByName<MenuItemCheckbox>("checkbox2");
  //           await checkbox2?.setEnable(checkbox1?.checked ?? true);
  //
  //           debugPrint(
  //               "click name: ${checkbox1?.name} menuItemId: ${checkbox1?.menuItemId} label: ${checkbox1?.label} checked: ${checkbox1?.checked}");
  //         },
  //       ),
  //       MenuItemCheckbox(
  //         label: 'Checkbox 2',
  //         name: 'checkbox2',
  //         onClicked: (menuItem) async {
  //           debugPrint("click 'Checkbox 2'");
  //
  //           await menuItem.setCheck(!menuItem.checked);
  //           await menuItem.setLabel('WordPair.random().asPascalCase');
  //           debugPrint(
  //               "click name: ${menuItem.name} menuItemId: ${menuItem.menuItemId} label: ${menuItem.label} checked: ${menuItem.checked}");
  //         },
  //       ),
  //       MenuItemCheckbox(
  //         label: 'Checkbox 3',
  //         name: 'checkbox3',
  //         checked: true,
  //         onClicked: (menuItem) async {
  //           debugPrint("click 'Checkbox 3'");
  //
  //           await menuItem.setCheck(!menuItem.checked);
  //           debugPrint(
  //               "click name: ${menuItem.name} menuItemId: ${menuItem.menuItemId} label: ${menuItem.label} checked: ${menuItem.checked}");
  //         },
  //       ),
  //       MenuSeparator(),
  //       MenuItemLabel(
  //           label: 'Exit', onClicked: (menuItem) => _appWindow.close()),
  //     ],
  //   );
  //
  //   await _menuSimple.buildFrom([
  //     MenuItemLabel(
  //       label: 'Change Context Menu',
  //       image: getImagePath('app_icon'),
  //       onClicked: (menuItem) {
  //         debugPrint("Change Context Menu");
  //
  //         _toogleMenu = !_toogleMenu;
  //         _systemTray.setContextMenu(_toogleMenu ? _menuMain : _menuSimple);
  //       },
  //     ),
  //     MenuSeparator(),
  //     MenuItemLabel(
  //         label: 'Show',
  //         image: getImagePath('app_icon'),
  //         onClicked: (menuItem) => _appWindow.show()),
  //     MenuItemLabel(
  //         label: 'Hide',
  //         image: getImagePath('app_icon'),
  //         onClicked: (menuItem) => _appWindow.hide()),
  //     MenuItemLabel(
  //       label: 'Exit',
  //       image: getImagePath('app_icon'),
  //       onClicked: (menuItem) => _appWindow.close(),
  //     ),
  //   ]);
  //
  //   _systemTray.setContextMenu(_menuMain);
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BqScreenshot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePageWidget(),
    );
  }
}

String getTrayImagePath(String imageName) {
  return Platform.isWindows ? 'assets/$imageName.ico' : 'assets/$imageName.png';
}

String getImagePath(String imageName) {
  return Platform.isWindows ? 'assets/$imageName.bmp' : 'assets/$imageName.png';
}
