import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'mvvm_sign/core/common/multi_provider/app_multi_provider.dart';
import 'mvvm_sign/features/auth/screen/login_Screen.dart';

void main() {
  runApp(MultiProvider(providers: getAppProviders(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MVVM Login Demo',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const SignInView(),
    );
  }
}
