import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/extensions/buildcontext/loc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  _VerifyEmailViewState createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              height: MediaQuery.of(context).size.height * 0.60,
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
                              context.loc.verify_email,
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
                  context.loc.verify_email_view_prompt,
                  style: const TextStyle(
                      color: Color.fromRGBO(143, 148, 251, 1)),
                ),
              ),
            ),

            const SizedBox(height: 30,),

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
                          context.read<AuthBloc>().add(
                            const AuthEventSendEmailVerification(),
                          );
                        },
                        child: Text(
                          context.loc.verify_email_send_email_verification,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                )),

            FadeInUp(
                duration: const Duration(milliseconds: 2000),
                child: TextButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
                  },
                  child: Text(
                    context.loc.restart,
                    style: const TextStyle(
                        color: Color.fromRGBO(143, 148, 251, 1)),
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}