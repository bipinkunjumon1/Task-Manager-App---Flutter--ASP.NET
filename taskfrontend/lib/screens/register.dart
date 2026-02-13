import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
final TextEditingController usernamecontrol = TextEditingController();
final TextEditingController emailidcontrol = TextEditingController();
final TextEditingController passwordControl = TextEditingController();
   
  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 11, 171, 224),
        foregroundColor: const Color.fromARGB(255, 232, 7, 7),
        centerTitle: true,
        title: Text(
          "Welcome to Registration Page",
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
                    'Registration',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: usernamecontrol,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: emailidcontrol,
                    decoration: InputDecoration(
                    labelText: 'email ID',
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
                      registerUser();
                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 4, 254, 58),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                    ),
                    child: Text('Register'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }

  Future <void> registerUser() async {
    print("===========>1");
    // Implement your registration logic here
    String username = usernamecontrol.text.trim();
    String email = emailidcontrol.text.trim();
    String password = passwordControl.text.trim();

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill all fields')),
      );
      return;

    }

        print("===========>2");

    String url = 'http://localhost:5210/api/Auth/register?username=$username&emailID=$email&password=$password'; 
    // Replace with your API endpoint
   print("url: $url");
      final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'text/plain',
        }
        );
       if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration successful')),
        );
        Navigator.pushReplacementNamed(context, '/login'); // Navigate to login screen after successful registration

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed')),
        );
      }
    }
    // Proceed with registration logic
  }
