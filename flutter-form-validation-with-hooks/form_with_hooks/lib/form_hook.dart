import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Form useForm({
  required List<Widget> children,
  MainAxisAlignment? mainAxisAlignment,
  CrossAxisAlignment? crossAxisAlignment,
  FocusNode? buttonFocusNode,
  required Widget buttonChild,
  required VoidCallback onSubmit,
}) =>
    use(_FormHook(
      children: children,
      buttonChild: buttonChild,
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      mainAxisAlignment: mainAxisAlignment ?? MainAxisAlignment.start,
      onSubmit: onSubmit,
      buttonFocusNode: buttonFocusNode,
    ));

class _FormHook extends Hook<Form> {
  final List<Widget> children;
  final Widget buttonChild;
  final VoidCallback onSubmit;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final FocusNode? buttonFocusNode;

  const _FormHook({
    required this.children,
    required this.buttonChild,
    required this.crossAxisAlignment,
    required this.mainAxisAlignment,
    required this.onSubmit,
    this.buttonFocusNode,
  });
  @override
  __FormHookState createState() => __FormHookState();
}

class __FormHookState extends HookState<Form, _FormHook> {
  final _formKey = GlobalKey<FormState>();
  @override
  Form build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: this.hook.mainAxisAlignment,
        crossAxisAlignment: this.hook.crossAxisAlignment,
        children: [
          for (var child in this.hook.children) child,
          TextButton(
            focusNode: this.hook.buttonFocusNode,
            child: this.hook.buttonChild,
            onPressed: () {
              if (_formKey.currentState!.validate())
                return this.hook.onSubmit();
              return null;
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.resolveWith<EdgeInsetsGeometry>(
                  (states) => EdgeInsets.symmetric(vertical: 20)),
              backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (states) => Colors.indigo),
            ),
          ),
        ],
      ),
    );
  }
}
