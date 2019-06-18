class FilterArgs {
  final buf = StringBuffer('?');

  void appendIfNotNull(String name, dynamic value) {
    if (value != null) {
      append(name, value);
    }
  }

  void append(String name, dynamic value) {
    if (buf.length > 1) {
      buf.write('&');
    }
    buf.write(r'$');
    buf.write(name);
    buf.write('=');
    buf.write(value);
  }

  @override
  String toString() {
    return buf.length > 1 ? buf.toString() : '';
  }
}
