import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:nodejs_test/bloc/activities/activities_bloc.dart';
import 'package:nodejs_test/bloc/user/user_bloc.dart';
import 'package:nodejs_test/route/route_name.dart';
import 'package:nodejs_test/view/register_page.dart';
import 'package:nodejs_test/view/widgets/responsive_layout.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      smallScreen: _LoginSmallScreen(),
      largeScreen: const _LoginLargeScreen(),
    );
  }
}

class _LoginLargeScreen extends StatelessWidget {
  const _LoginLargeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                SvgPicture.asset(
                  'image/background.svg',
                  fit: BoxFit.cover,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 80),
                  child: const Text(
                    'Enjoy the Convenience of Beam Space Storage',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 35,
                        fontWeight: FontWeight.w500),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 500,
                child: _LoginForm(),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _LoginSmallScreen extends StatelessWidget {
  _LoginSmallScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 200,
                child: SvgPicture.asset(
                  'image/background_mobile.svg',
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Container(
                width: double.infinity,
                height: 200,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.center,
                child: const Text(
                  'Enjoy the Convenience of Beam Space Storage',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          _LoginForm(),
        ],
      ),
    );
  }
}

class _LoginForm extends StatelessWidget {
  _LoginForm({
    super.key,
  });

  final _formKey = GlobalKey<FormState>();

  final controllerEmail = TextEditingController();
  final controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        key: _formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            const Text(
              'Log in to Beam Space',
              style: TextStyle(
                color: Colors.red,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Container(
                height: 45,
                alignment: Alignment.center,
                child: const Text(
                  'Get started with Google',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () {},
              child: Container(
                alignment: Alignment.center,
                height: 45,
                child: const Text(
                  'Get started with Facebook',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Divider(),
                Text(
                  'or log in with your email',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Divider()
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Email Address*',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              validator: (value) {
                // if (value == '') {
                //   return 'email tidak boleh kosong';
                // }
                if (!GetUtils.isEmail(value!)) {
                  return 'isi email dengan benar';
                }
                return null;
              },
              controller: controllerEmail,
              decoration: const InputDecoration(
                hintText: 'E.g, name@email.com',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const Text(
              'Password*',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: controllerPassword,
              validator: (value) {
                if (value == '') {
                  return 'password tidak boleh kosong';
                }
                return null;
              },
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'Enter your password',
                hintStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<UserBloc>().add(UserLogin(
                      email: controllerEmail.value.text,
                      password: controllerPassword.value.text));
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 45,
                child: const Text('Login'),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () {
                context.read<ActivitiesBloc>().add(ActivitiesLoad());
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Get.toNamed(RouteName.goRegisterPage);
                  },
                  child: const Text(
                    'Create an account',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
