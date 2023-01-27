import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../common/constant/env.dart';
import '../controller/profile_controller.dart';
import '../generated/locales.g.dart';

class ProfileScreen extends StatelessWidget {
  final ctrl = Get.put(ProfileController());

  ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Theme(
          data: ThemeData(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Navigation Drawer'),
              backgroundColor: const Color(0xff764abc),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () =>
                      ctrl.toggleDarkMode(!ctrl.globalConfig.value.isDarkMode),
                  icon: Icon(
                    ctrl.globalConfig.value.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                  ),
                )
              ],
            ),
            body: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 200,
                    child: TextFormField(
                      initialValue: ctrl.host.value,
                      decoration: const InputDecoration(
                        labelText: 'host',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        fillColor: Colors.red,
                      ),
                      onChanged: (value) {
                        ctrl.updateHost(value);
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                  DropdownButton(
                    items: [
                      DropdownMenuItem(
                        value: Environment.dev,
                        child: Text(LocaleKeys.environment_development.tr),
                      ),
                      DropdownMenuItem(
                        value: Environment.prod,
                        child: Text(LocaleKeys.environment_production.tr),
                      ),
                    ],
                    value: ctrl.env.value,
                    onChanged: (value) => ctrl.switchEnv(value!),
                  ),
                  const SizedBox(height: 50),
                  DropdownButton(
                    items: [
                      DropdownMenuItem(
                        value: 'en_US',
                        child: Text(LocaleKeys.language_english.tr),
                      ),
                      DropdownMenuItem(
                        value: 'zh_CN',
                        child: Text(LocaleKeys.language_chinese.tr),
                      ),
                    ],
                    value: ctrl.globalConfig.value.language,
                    onChanged: (value) {
                      ctrl.updateLocale(value ?? '');
                    },
                  ),
                ],
              ),
            ),
            drawer: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Drawer(
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: [
                    const UserAccountsDrawerHeader(
                      decoration: BoxDecoration(color: Color(0xff764abc)),
                      accountName: Text(
                        'Lysander',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      accountEmail: Text(
                        'mgician3@gmail.com',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      currentAccountPicture: FlutterLogo(),
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.home,
                      ),
                      title: const Text('Page 1'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.train,
                      ),
                      title: const Text('Page 2'),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    const AboutListTile(
                      icon: Icon(
                        Icons.info,
                      ),
                      applicationIcon: Icon(
                        Icons.local_play,
                      ),
                      applicationName: 'Music App',
                      applicationVersion: '1.0.27',
                      applicationLegalese: '© 2023 Company',
                      aboutBoxChildren: [
                        ///Content goes here...
                      ],
                      child: Text('About app'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
