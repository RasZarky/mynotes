import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/utilities/dialogs/error_dialog.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            await showErrorDialog(
              context,
              context.loc.login_error_cannot_find_user,
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
              context,
              context.loc.login_error_wrong_credentials,
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              context.loc.login_error_auth_error,
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.45,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/image/background.png"),
                      fit: BoxFit.fill,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      left: 30,
                      width: 80,
                      height: 200,
                      child: FadeInUp(
                          duration: const Duration(seconds: 1),
                          child: Container(
                            decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/image/light-1.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      left: 140,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                          duration: const Duration(milliseconds: 1200),
                          child: Container(
                            decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/image/light-2.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      right: 40,
                      top: 40,
                      width: 80,
                      height: 150,
                      child: FadeInUp(
                          duration: const Duration(milliseconds: 1300),
                          child: Container(
                            decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/image/clock.png')
                            )
                        ),
                      )),
                    ),
                    Positioned(
                      child: FadeInUp(
                          duration: const Duration(milliseconds: 1600),
                          child: Container(
                              margin: const EdgeInsets.only(top: 50),
                              child: Center(
                                child: Text(
                                  context.loc.login,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight:
                                      FontWeight.bold
                                  ),
                                ),
                        ),
                      )),
                    )
                  ],
                ),
              ),

              FadeInUp(
                duration: const Duration(milliseconds: 500),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    context.loc.login_view_prompt,
                    style: const TextStyle(
                        color: Color.fromRGBO(143, 148, 251, 1)),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    FadeInUp(
                      duration: const Duration(milliseconds: 1000),
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color.fromRGBO(143, 148, 251, 1),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromRGBO(143, 148, 251, .2),
                                blurRadius: 20.0,
                                offset: Offset(0, 10),
                              )
                            ]
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8.0),
                                decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(
                                        color:  Color.fromRGBO(
                                            143, 148, 251, 1)))
                                ),
                                child: TextField(
                                  controller: _email,
                                  enableSuggestions: true,
                                  autocorrect: false,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color: Colors.grey[700]
                                    ),
                                    hintText: context.loc.email_text_field_placeholder,
                                  ),
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.all(8.0),
                                child:TextField(
                                  controller: _password,
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                        color: Colors.grey[700]
                                    ),
                                    hintText: context.loc.password_text_field_placeholder,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10,),

              FadeInUp(
                  duration: const Duration(milliseconds: 1900),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(143, 148, 251, 1),
                            Color.fromRGBO(143, 148, 251, .6),
                          ]
                      )
                      ),
                      child: Center(
                        child: TextButton(
                          onPressed: () async {
                            final email = _email.text;
                            final password = _password.text;
                            context.read<AuthBloc>().add(
                              AuthEventLogIn(
                                email,
                                password,
                              ),
                            );
                          },
                          child: Text(
                            context.loc.login,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                                    ),
                                  ),
                  )),

              const SizedBox(height: 5,),

              FadeInUp(
                  duration: const Duration(milliseconds: 2000),
                  child: TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(
                        const AuthEventForgotPassword(),
                      );
                    },
                    child: Text(
                      context.loc.login_view_forgot_password,
                      style: const TextStyle(
                          color: Color.fromRGBO(143, 148, 251, 1)),)
                    ),
                  ),

              FadeInUp(
                duration: const Duration(milliseconds: 2000),
                child: TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      const AuthEventShouldRegister(),
                    );
                  },
                  child: Text(
                    context.loc.login_view_not_registered_yet,
                    style: const TextStyle(
                        color: Color.fromRGBO(143, 148, 251, 1)),
                  ),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}