import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String AUTH_STORAGE_KEY = "delphis_auth_jwt_v5";

class DelphisAuthRepository extends ChangeNotifier {
  String _authString;
  FlutterSecureStorage _storage;

  DelphisAuthRepository(FlutterSecureStorage storage) {
    this._storage = storage;
    this._authString = null;
  }

  // Asynchronously loads auth JWT from secure storage if possible.
  Future<bool> loadFromStorage() async {
    if (this._storage != null) {
      var authString = await this._storage.read(key: AUTH_STORAGE_KEY);

      if (authString != null && authString != '') {
        // Do not notify.
        this._authString = authString;
      }
    }
    return this.isAuthed;
  }

  Future<void> storeJWT() async {
    if (this._storage != null) {
      await this._storage.write(key: AUTH_STORAGE_KEY, value: this._authString);
    }
  }

  Future<void> deleteStoredJWT() async {
    if (this._storage != null) {
      await this._storage.delete(key: AUTH_STORAGE_KEY);
    }
  }

  set authString(String newAuthString) {
    this._authString = newAuthString;

    if (newAuthString != null && newAuthString != '') {
      this.storeJWT();
    } else {
      this.deleteStoredJWT();
    }

    this.notifyListeners();
  }

  // Call invalidateInternal when the authString is
  // rejected for any reason.
  invalidateInternal() {
    this.authString = null;
  }

  String get authString => this._authString;

  bool get isAuthed => this._authString != null;
}
