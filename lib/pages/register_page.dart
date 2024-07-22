import 'package:appmyjuice/components/my_button.dart';
import 'package:appmyjuice/components/my_textfield.dart';
import 'package:appmyjuice/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void register() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
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

    if (password != confirmPassword) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          title: const Text("As senhas não são iguais!", style: TextStyle(color: Colors.white)),
        ),
      );
      return;
    }

    final authService = AuthService();

    try {
      await authService.signUpWithEmailPassWord(email, password);
    } catch (e) {
      String errorMessage;
      if (e.toString().contains('email-already-in-use')) {
        errorMessage = 'E-mail já cadastrado';
      }
      else if(e.toString().contains('weak-password')){
        errorMessage = 'Senha muito fraca\n- Utilize 8 caracteres\n- Uma letra maíuscula\n- Números';
      }
      else if (e.toString().contains('invalid-email')) {
        errorMessage = 'E-mail inválido';
      }
      else {
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
                //logo
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

                const SizedBox(height: 10),

                const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: Text(
                        "Confirme sua senha",
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
                  controller: confirmPasswordController,
                  hintText: "Confimar Senha",
                  obscureText: true,
                  prefixIconData: Icons.lock,
                ),

                const SizedBox(height: 10),

                MyButton(
                  text: "Cadastrar-se",
                  onTap: register,
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Já Possui Cadastro?",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: Text(
                        "Fazer Login!",
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
