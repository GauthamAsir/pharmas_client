import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/models/user_model.dart';
import 'package:e_commerce/utils/auth_helper.dart';
import 'package:e_commerce/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';

  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String error = '';
  String verificationId = '';

  bool isLoading = false;

  AuthHelper authenticationHelper = AuthHelper();

  void setIsLoading() {
    if (mounted) {
      setState(() {
        isLoading = !isLoading;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SafeArea(
                      child: Form(
                          key: formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Visibility(
                                  visible: error.isNotEmpty,
                                  child: MaterialBanner(
                                    backgroundColor:
                                        Theme.of(context).errorColor,
                                    content: Text(error),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            error = '';
                                          });
                                        },
                                        child: const Text(
                                          'dismiss',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      )
                                    ],
                                    contentTextStyle:
                                        const TextStyle(color: Colors.white),
                                    padding: const EdgeInsets.all(10),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: phoneController,
                                  decoration: const InputDecoration(
                                    labelText: 'Phone number',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLength: 10,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],
                                  validator: (value) =>
                                      value != null && value.isNotEmpty
                                          ? null
                                          : 'Required',
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: isLoading ? null : _phoneAuth,
                                    child: isLoading
                                        ? const CircularProgressIndicator
                                            .adaptive()
                                        : const Text('Login'),
                                  ),
                                ),
                              ],
                            ),
                          ))),
                ),
              ),
            ),
          ),
        ));
  }

  Future<String?> getSmsCodeFromUser() async {
    String? smsCode;

    // Update the UI - wait for the user to enter the SMS code
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('SMS code:'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Sign in'),
            ),
            OutlinedButton(
              onPressed: () {
                smsCode = null;
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
          content: Container(
            padding: const EdgeInsets.all(20),
            child: TextField(
              onChanged: (value) {
                smsCode = value;
              },
              textAlign: TextAlign.center,
              autofocus: true,
              maxLength: 6,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(6),
              ],
            ),
          ),
        );
      },
    );

    return smsCode;
  }

  Future<void> _phoneAuth() async {
    if (formKey.currentState?.validate() ?? false) {
      setIsLoading();

      try {
        log('try-Outer');
        if (kIsWeb) {
          final confirmationResult = await authenticationHelper.auth
              .signInWithPhoneNumber('+91 ${phoneController.text}');
          final smsCode = await getSmsCodeFromUser();

          if (smsCode != null) {
            await confirmationResult.confirm(smsCode);

            User? user = FirebaseAuth.instance.currentUser;

            if (user != null) {
              QuerySnapshot<Map<String, dynamic>> snap = await db
                  .collection('users')
                  .where('phone', isEqualTo: user.phoneNumber)
                  .get();

              if (snap.docs.isEmpty) {
                await db.collection('users').doc(user.uid).set(UserModel(
                      phone: user.phoneNumber!,
                    ).toMap());
              } else {
                await db
                    .collection('users')
                    .doc(user.uid)
                    .update({'last_logged_in': Timestamp.now()});
              }
            }
            log('Logged In');
            // Get.toNamed(MainScreen.routeName);
          }
        } else {
          await authenticationHelper.auth.verifyPhoneNumber(
            phoneNumber: phoneController.text,
            verificationCompleted: (_) {},
            verificationFailed: (e) {
              setState(() {
                error = '${e.message}';
              });
            },
            codeSent: (String verificationId, int? resendToken) async {
              final smsCode = await getSmsCodeFromUser();

              if (smsCode != null) {
                // Create a PhoneAuthCredential with the code
                final credential = PhoneAuthProvider.credential(
                  verificationId: verificationId,
                  smsCode: smsCode,
                );

                try {
                  log('try-Inner');
                  // Sign the user in (or link) with the credential
                  await authenticationHelper.auth
                      .signInWithCredential(credential);
                  log('Logged In');
                  // Get.toNamed(MainScreen.routeName);
                } on FirebaseAuthException catch (e) {
                  log('Catch-Inner');
                  setState(() {
                    error = e.message ?? '';
                  });
                }
              }
            },
            codeAutoRetrievalTimeout: (e) {
              setState(() {
                error = e;
              });
            },
          );
        }
      } catch (e) {
        log('Catch-Outer');
        setState(() {
          error = '$e';
        });
      } finally {
        log('Finally');
        setIsLoading();
      }
    }
  }
}
