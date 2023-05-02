import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:nodejs_test/bloc/activities/activities_bloc.dart';
import 'package:nodejs_test/bloc/user/user_bloc.dart';
import 'package:nodejs_test/repository/database_repository.dart';
import 'package:nodejs_test/route/app_page_route.dart';
import 'package:nodejs_test/route/route_name.dart';
import 'package:nodejs_test/view/home_page.dart';
import 'package:nodejs_test/view/login_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProvidersInit());
}

class ProvidersInit extends StatelessWidget {
  const ProvidersInit({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => DatabaseRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserBloc(
              databaseRepository: context.read<DatabaseRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ActivitiesBloc(
              databaseRepository: context.read<DatabaseRepository>(),
            ),
          )
        ],
        child: App(),
      ),
    );
  }
}

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: AppPageRoute.pages,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xfffafbff),
        fontFamily: 'Roboto',
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state.status == UserStatus.authenticated) {
            Get.snackbar(
              'notification',
              '${state.user.email} berhasil login',
              snackPosition: SnackPosition.BOTTOM,
            );
            context.read<ActivitiesBloc>().add(ActivitiesLoad());
          } else {
            Get.snackbar(
              'notofication',
              'logout berhasil',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        },
        builder: (context, state) {
          if (state.status == UserStatus.unauthenticated) {
            return const LoginPage();
          } else {
            return const HomePage();
          }
        },
      ),
    );
  }
}
