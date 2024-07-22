import 'package:flutter/material.dart';
import 'package:appmyjuice/services/auth/auth_service.dart';
import 'package:appmyjuice/components/my_button.dart';
import '../components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          title: const Text(
            "Por favor, preencha todos os campos",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
      return;
    }

    final authService = AuthService();

    try {
      await authService.signInWithEmailPassWord(email, password);
    } catch (e) {
      String errorMessage;
      if (e.toString().contains('invalid-email')) {
        errorMessage = 'E-mail inválido';
      } else if (e.toString().contains('invalid-credential')) {
        errorMessage = 'Senha incorreta';
      } else {
        errorMessage = e.toString();
      }

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          title: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                ClipOval(
                  child: Image.asset(
                    'lib/images/logo/logo.jpg',
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 25),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: Text(
                        "Email",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                MyTextField(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                  prefixIconData: Icons.email,
                ),
                const SizedBox(height: 10),
                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: Text(
                        "Senha",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                MyTextField(
                  controller: passwordController,
                  hintText: "Senha",
                  obscureText: true,
                  prefixIconData: Icons.lock,
                ),
                const SizedBox(height: 25),
                MyButton(
                  text: "Fazer Login",
                  onTap: login,
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Ainda Não Tem Cadastro?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Cadastre-se!",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
