class Utils {
  static String intCentsToFomattedString(int cents) {
    var centsStr = (cents % 100).toString();
    if (centsStr.length == 1) {
      centsStr = "0$centsStr";
    }
    return "\$${cents ~/ 100}.$centsStr";
  }
}