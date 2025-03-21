import 'package:flutter/foundation.dart';

class Assets {
  const Assets._();

  static const _assets = (kIsWeb) ? 'images' : 'assets/images';

  static const String logo = '$_assets/ant-logo.png';
}
