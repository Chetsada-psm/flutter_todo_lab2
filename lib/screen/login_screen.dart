import 'package:flutter/material.dart';
import 'package:flutter_todo_lab2/main.dart';
import 'package:flutter_todo_lab2/screen/register_screen.dart';
import 'package:flutter_todo_lab2/service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo"),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Container(
          height: 280,
          width: 300,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "ToDo",
                style: TextStyle(fontSize: 40),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: "Email", border: OutlineInputBorder()),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(
                    labelText: "Password", border: OutlineInputBorder()),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => RegisterScreen()),
                      );
                    },
                    child: const Text("Register"),
                  ),
                  TextButton(
                    onPressed: () async {
                      var res = await AuthService().signin(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                      if (res == "success") {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => TodoApp()),
                        );
                      } else {
                        print("Login failed with message: $res");
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res!)));
                      }
                    },
                    child: const Text("Login"),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
