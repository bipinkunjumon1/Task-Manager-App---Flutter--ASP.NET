import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:taskfrontend/screens/task.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailidcontrol = TextEditingController();
  final TextEditingController passwordControl=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 171, 224),
        foregroundColor: const Color.fromARGB(255, 232, 7, 7),
        centerTitle: true,
        title: Text(
          "Welcome to Login Page",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: SizedBox(
              width: 300, // Reduce width of text fields and button
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: emailidcontrol,
                    decoration: InputDecoration(
                      labelText: 'emailID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: passwordControl,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      loginUser();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 4, 254, 58),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: Text('Login'),
                  ),
                  SizedBox(height: 20),
                  TextButton(onPressed: (){
                    Navigator.pushNamed(context, '/register');
                  }, 
                  child: Text('Dont you have account, register here'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future <void> loginUser() async {
    
    String email= emailidcontrol.text.trim();
    String password = passwordControl.text.trim();


  if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;

    }

    String url= 'http://localhost:5210/api/Auth/login?emailID=$email&password=$password';

    print("url: $url");
      final response= await http.post(Uri.parse(url),
      );
      if (response.body.isNotEmpty) {
        Map<String, dynamic> responseData = json.decode(response.body);
      

      int userID = responseData['userID'] ?? 0;
      String username= responseData['username'] ?? '';
      
      if(userID==0 || username.isEmpty){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid response data: ${response.body}')),
        );
        return;

      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userID', userID);
      await prefs.setString('username', username);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login sucessful')
        ),
       
        
      );
        Navigator.pushReplacementNamed(context, '/dashscreen');


    }
    

  }
}
