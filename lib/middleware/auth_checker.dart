import 'package:flutter/material.dart';
import 'package:flutter_application_2/pages/home.dart';
import 'package:flutter_application_2/pages/welcome_pages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_2/blocs/user/bloc/user_bloc.dart';
import 'package:flutter_application_2/utils/token_storage_util.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({super.key});

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  bool _isChecking = true;
  bool _isAuthenticated = false;
  bool _hasChecked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasChecked) {
      _hasChecked = true;
      _checkAuth();
    }
  }

  void _checkAuth() async {
    final token = await TokenStorageUtil.getToken();

    if (!mounted) return; // ❗️Cek mounted setelah await

    if (token == null || token.isEmpty) {
      _navigateToWelcome();
      return;
    }

    try {
      final userBloc = BlocProvider.of<UserBloc>(context);
      userBloc.add(LoadUser());

      final subscription = userBloc.stream.listen((state) {
        if (!mounted) return;

        if (state is UserLoaded) {
          setState(() {
            _isAuthenticated = true;
            _isChecking = false;
          });
        } else if (state is UserFailure) {
          _navigateToWelcome();
        }
      });

      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        await subscription.cancel();
      }
    } catch (e) {
      if (mounted) _navigateToWelcome();
    }
  }

  void _navigateToWelcome() {
    if (!mounted) return;

    setState(() {
      _isAuthenticated = false;
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return _isAuthenticated ? const Home() : const WelcomePages();
  }
}
