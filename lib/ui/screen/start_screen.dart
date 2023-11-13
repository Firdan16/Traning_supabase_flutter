import 'dart:io';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  bool _signInLoading = false;
  bool _signUpLoading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? deviceId = "";

  @override
  void dispose() {
    supabase.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: const InputDecoration(labelText: "Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
                // SIGN IN
                _signInLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          final isValid = _formKey.currentState!.validate();
                          if (isValid != true) {
                            return;
                          }
                          setState(() {
                            _signInLoading = true;
                          });
                          try {
                            await supabase.auth.signInWithPassword(
                              password: _passwordController.text,
                              email: _emailController.text,
                            );
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Sign In Failed, please try again"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            setState(() {
                              _signInLoading = false;
                            });
                          }
                        },
                        child: const Center(
                          child: Text("Sign In"),
                        ),
                      ),
                const SizedBox(height: 20),
                // SIGN UP
                _signUpLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : OutlinedButton(
                        onPressed: () async {
                          final isValid = _formKey.currentState!.validate();
                          var device = DeviceInfoPlugin();

                          if (Platform.isAndroid) {
                            var androidInfo = await device.androidInfo;
                            setState(() {
                              deviceId = androidInfo.id;
                            });
                          } else if (Platform.isIOS) {
                            var iosInfo = await device.iosInfo;
                            setState(() {
                              deviceId = iosInfo.identifierForVendor;
                            });
                          }
                          if (isValid != true) {
                            return;
                          }
                          setState(() {
                            _signUpLoading = true;
                          });
                          try {
                            await supabase.auth.signUp(
                              email: _emailController.text,
                              password: _passwordController.text,
                              data: {
                                'device_id': deviceId,
                              },
                            );
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Success!! Confirmation Email has been sent"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            setState(() {
                              _signUpLoading = false;
                            });
                          } catch (e) {
                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Sign Up Failed, please try again"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            setState(() {
                              _signUpLoading = false;
                            });
                          }
                        },
                        child: const Center(
                          child: Text("Sign Up"),
                        ),
                      ),
                const SizedBox(height: 20),
                GoogleAuthButton(
                  themeMode: ThemeMode.light,
                  style: const AuthButtonStyle(
                    buttonType: AuthButtonType.icon,
                    iconType: AuthIconType.outlined,
                  ),
                  onPressed: () async {
                    try {
                      // Syntax for Google SignIn
                      await supabase.auth.signInWithOAuth(
                        Provider.google,
                        redirectTo: kIsWeb
                            ? null
                            : 'io.supabase.flutterquickstart://login-callback',
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Sign Up Failed, please try again"),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
