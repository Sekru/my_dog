class Utility {
  static calculateYear(DateTime? date) {
    Duration parse = DateTime.now().difference(date!).abs();
    return "${parse.inDays~/360} lat ${((parse.inDays%360)~/30)} miesięcy";
  }
}