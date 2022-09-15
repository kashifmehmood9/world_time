import 'package:path/path.dart';

class Extractor {
  static String extract(String path) {
    return basename(path);
  }
}
