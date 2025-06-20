import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../../features/auth/viewmodel/login_viewmodel.dart';
import '../../../features/auth/viewmodel/profile_viewmodel.dart';

List<SingleChildWidget> getAppProviders() {
  return [
    ChangeNotifierProvider(create: (_) => SignInViewModel()),
    ChangeNotifierProvider(create: (_) => ProfileViewModel()),
  ];
}
