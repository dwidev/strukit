extension ValidationExt on String {
  bool get validEmail {
    final regExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9-]+\.[a-zA-Z]+.[a-zA-Z]+",
    );
    return regExp.hasMatch(this);
  }

  bool get validPhone {
    final regExp = RegExp(r'^(^\+62\s?|^0)(\d{3,4}-?){2}\d{3,4}$');
    return regExp.hasMatch(this);
  }
}
