import 'package:get_it/get_it.dart';
import 'local_storage_service.dart';

GetIt sl = GetIt.instance;
LocalStorageService localStorageService = sl<LocalStorageService>();

Future<void> setupLocator() async {
  final instance = await LocalStorageService.getInstance();
  sl.registerSingleton<LocalStorageService>(instance);
}
