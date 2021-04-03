import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_with_hooks/form_hook.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final email = useState('');
    final password = useState('');
    final passwordFocusNode = useFocusNode();
    final buttonFocusNode = useFocusNode();
    final form = useForm(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          decoration: InputDecoration(labelText: "Email"),
          onChanged: (data) => email.value = data,
          onEditingComplete: () => FocusScope.of(context).requestFocus(
            passwordFocusNode,
          ),
          validator: (data) {
            if (data == null || data.isEmpty) return "Email is required";
            if (!EmailValidator.validate(data)) return "Invalid email address";
            return null;
          },
        ),
        TextFormField(
          obscureText: true,
          focusNode: passwordFocusNode,
          decoration: InputDecoration(labelText: "Password"),
          onChanged: (data) => password.value = data,
          onEditingComplete: () => FocusScope.of(context).requestFocus(
            buttonFocusNode,
          ),
          validator: (data) {
            if (data == null || data.isEmpty) return "Password is required";
            if (!RegExp(
                    r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
                .hasMatch(data))
              return "Your password should contain at least one upper case, one lower case, one digit, one special character.";
            return null;
          },
        ),
      ],
      buttonChild: Text("Sign In", style: TextStyle(color: Colors.white)),
      buttonFocusNode: buttonFocusNode,
      onSubmit: () => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Success"),
          content: Text("email: ${email.value}\nPassword: ${password.value}"),
        ),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Awesome form with validation"),
      ),
      body: Container(
          height: 250,
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: form),
    );
  }
}
