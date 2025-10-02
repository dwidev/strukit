import 'package:injectable/injectable.dart';

import '../../../../core/local_storage_manager/local_storage_adapter.dart';
import '../model/token_model.dart';

enum AuthStorageKey {
  complete,
  draftCompleteProfile,
  accessToken,
  refreshtoken,
}

abstract class AuthLocalStorageDataSource {
  Future<void> setCompleteRegisStatus(bool value);
  Future<bool> completeRegis();
  Future<void> setToken(TokenModel authToken);
  Future<TokenModel> getToken();
  Future<void> clear();
}

@LazySingleton(as: AuthLocalStorageDataSource)
class AuthLocalStorageDataSourceImpl implements AuthLocalStorageDataSource {
  final LocalStorageAdapter adapter;

  AuthLocalStorageDataSourceImpl({@sharedPref required this.adapter});

  @override
  Future<void> setCompleteRegisStatus(bool value) async {
    await adapter.storeData(AuthStorageKey.complete.name, value);
  }

  @override
  Future<bool> completeRegis() async {
    final result = await adapter.getData(AuthStorageKey.complete.name);
    return (result as bool?) ?? false;
  }

  @override
  Future<void> clear() async {
    final req = AuthStorageKey.values.map((e) => adapter.remove(e.name));
    await Future.wait(req);
  }

  @override
  Future<void> setToken(TokenModel authToken) async {
    final accessToken = authToken.accessToken;
    final refreshToken = authToken.refreshToken;
    await Future.wait([
      adapter.storeData(AuthStorageKey.accessToken.name, accessToken),
      adapter.storeData(AuthStorageKey.refreshtoken.name, refreshToken),
    ]);
  }

  @override
  Future<TokenModel> getToken() async {
    final req = await Future.wait([
      adapter.getData(AuthStorageKey.accessToken.name),
      adapter.getData(AuthStorageKey.refreshtoken.name),
    ]);

    final accessToken = (req[0] as String?) ?? "";
    final refreshToken = (req[1] as String?) ?? "";

    return TokenModel(accessToken: accessToken, refreshToken: refreshToken);
  }
}
