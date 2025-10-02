enum SignType {
  email,
  phoneNumber;

  String get title => switch (this) {
        SignType.email => "Email",
        SignType.phoneNumber => "Phone number",
      };
}
