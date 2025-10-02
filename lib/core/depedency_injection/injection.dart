import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
Future<void> configureDepedencies() => getIt.init();

// @InjectableInit()
// Future<void> configureDepedencies({required EnvFlavors environment}) =>
//     getIt.init(
//       environment: environment.name,
//     );
