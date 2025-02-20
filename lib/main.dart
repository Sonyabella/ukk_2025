import 'package:flutter/material.dart';
import 'package:ukk_2025/pelanggan/indexpelanggan.dart';
import 'package:ukk_2025/home_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future <void> main() async {
  await Supabase.initialize(
    url: 'https://ktdusmbvejbrvfczgrpd.supabase.co',
    anonKey: 
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt0ZHVzbWJ2ZWpicnZmY3pncnBkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzk0MTUzNTEsImV4cCI6MjA1NDk5MTM1MX0.ubcuk3BEsma7nHtbOHNY-zHkJe07anPdwsl7Sq-DwPA'
    );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      // home: pelangganTab(),
    );
  }
}

class LoginPage extends StatefulWidget { 
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final SupabaseClient supabase = Supabase.instance.client;
   bool _isPasswordVisible = false;

  // fungsi login username dan password di supabase
  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final response = await supabase
      .from('user')
      .select('username, password')
      .eq('username', username)
      .maybeSingle();

      if (response == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username tidak ditemukan!')),
          );
        return;
      }

      if (response['password'] == password) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login berhasil!')),
        );
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => HomePage()),
          );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password salah!')),
          );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}'))
        );  
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        automaticallyImplyLeading: false,
        title: Row(
          children: const <Widget>[
            SizedBox(width: 8),
            Text("Administrator"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 30),
              height: 200,
              width: double.infinity,
              child:  Image(
                image: AssetImage('asset/asset.administrasi.png'),
                ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              child: const Text(
                "User Login",
                style: TextStyle(fontSize: 30, color: Colors.amber),
              ),
            ),
            Container(
              width: 350,
              margin: const EdgeInsets.only(top: 20),
              child: TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  icon: Icon(Icons.person, color: Colors.blue),
                  fillColor: Colors.amber[200],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    ),
                     ),
                     ),
            ),
            Container(
              width: 350,
              margin: const EdgeInsets.only(top: 20),
              child: TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  icon: Icon(Icons.vpn_key_sharp, color: Colors.blue),
                  fillColor: Colors.amber[200],
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                 ),
                   obscureText: true,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: ElevatedButton(
                  onPressed: _login,
                  child: const Text("Login"),
                  style:  ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    fixedSize: const Size(110, 40),
                  ),
                ),
              ),
            ],
          ),
        ),
    );
  }
}
