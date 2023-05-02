import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:nodejs_test/bloc/activities/activities_bloc.dart';
import 'package:nodejs_test/bloc/user/user_bloc.dart';
import 'package:nodejs_test/view/widgets/responsive_layout.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

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
      body: Column(
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
              'Register to Beam Space',
              style: TextStyle(
                color: Colors.red,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 25,
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
                  context.read<UserBloc>().add(UserRegister(
                      email: controllerEmail.value.text,
                      password: controllerPassword.value.text));
                  Get.back();
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: 45,
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
