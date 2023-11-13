import 'package:flutter/material.dart';
import 'package:flutter_supabase/ui/screen/home_screen.dart';
import 'package:flutter_supabase/ui/screen/start_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final SupabaseClient supabase = Supabase.instance.client;
  User? user;

  @override
  void initState() {
    _getAuth();
    super.initState();
  }

  // To get current user : supabase.auth.currentUser
  Future<void> _getAuth() async {
    setState(() {
      user = supabase.auth.currentUser;
    });
    supabase.auth.onAuthStateChange.listen((event) {
      setState(() {
        user = event.session?.user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return user == null ? const StartScreen() : HomeScreen();
  }
}
