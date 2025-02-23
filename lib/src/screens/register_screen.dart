import 'package:auth/src/auth/providers/auth_provider.dart';
import 'package:auth/src/common/widgets/circles_background.dart';
import 'package:auth/src/common/widgets/go_back.dart';
import 'package:auth/src/common/widgets/main_text_field.dart';
import 'package:auth/src/common/widgets/next_button.dart';
import 'package:auth/src/common/widgets/scrollable_form.dart';
import 'package:auth/src/common/widgets/underlined_button.dart';
import 'package:auth/src/screens/home_screen.dart';
import 'package:auth/src/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = '/register';

  RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _passwordController = TextEditingController();

  String _username = '';
  String _email = '';
  bool _loading = false;

  @override
  void dispose() {
    super.dispose();

    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final node = FocusScope.of(context);

    return Scaffold(
      body: CirclesBackground(
        backgroundColor: theme.highlightColor,
        topSmallCircleColor: theme.primaryColor,
        topMediumCircleColor: theme.primaryColor,
        topRightCircleColor: theme.highlightColor,
        bottomRightCircleColor: Colors.white,
        child: Stack(
          children: [
            GoBack(),
            Column(
              children: [
                ScrollableForm(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  children: [
                    SizedBox(
                      height: 90,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 250),
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              fontSize: 46,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 70,
                        ),
                        _form(node, context),
                        _thirdPartySignInButtons(context),
                      ],
                    ),
                  ],
                ),
                _FooterButtons(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _form(FocusScopeNode node, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MainTextField(
          label: 'Username',
          usernameField: true,
          onChanged: (value) => setState(() {
            _username = value;
          }),
          onEditingComplete: () => node.nextFocus(),
        ),
        SizedBox(
          height: 20,
        ),
        MainTextField(
          label: 'Email',
          emailField: true,
          onChanged: (value) => setState(() {
            _email = value;
          }),
          onEditingComplete: () => node.nextFocus(),
        ),
        SizedBox(
          height: 20,
        ),
        MainTextField(
          label: 'Password',
          controller: _passwordController,
          passwordField: true,
          onSubmitted: (_) {
            node.unfocus();

            _registerWithAccount(context);
          },
        ),
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Text(
              'Sign Up',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            Spacer(),
            NextButton(
              onPressed: () => _registerWithAccount(context),
              loading: _loading,
            )
          ],
        ),
      ],
    );
  }

  Widget _thirdPartySignInButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30,
        ),
        SignInButton(
          Buttons.AppleDark,
          text: "Sign up with Apple",
          onPressed: () => _registerWithApple(context),
        ),
        SizedBox(
          height: 10,
        ),
        SignInButton(
          Buttons.Facebook,
          text: "Sign up with Facebook",
          onPressed: () => _registerWithFacebook(context),
        ),
        SizedBox(
          height: 10,
        ),
        SignInButton(
          Buttons.GoogleDark,
          text: "Sign up with Google",
          onPressed: () => _registerWithGoogle(context),
        )
      ],
    );
  }

  _registerWithAccount(BuildContext context) async {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    return _registerWith(context, () {
      return provider.register(
        _username,
        _email,
        _passwordController.text,
      );
    });
  }

  _registerWithFacebook(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    return _registerWith(context, () => provider.loginWithFacebook(context));
  }

  _registerWithGoogle(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    return _registerWith(context, () => provider.loginWithGoogle(context));
  }

  _registerWithApple(BuildContext context) {
    final provider = Provider.of<AuthProvider>(context, listen: false);

    return _registerWith(context, () => provider.loginWithApple(context));
  }

  _registerWith(BuildContext context, Future<void> Function() method) async {
    if (_loading) {
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await method();

      Navigator.of(context).pushNamedAndRemoveUntil(
        HomeScreen.routeName,
        (_) => false,
      );
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }
}

class _FooterButtons extends StatelessWidget {
  const _FooterButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        children: [
          Spacer(),
          UnderlinedButton(
            onPressed: () => Navigator.pushNamed(
              context,
              LoginScreen.routeName,
            ),
            child: Text('Sign In'),
            color: theme.highlightColor,
          ),
        ],
      ),
    );
  }
}
