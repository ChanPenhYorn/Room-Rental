import 'dart:nativewrappers/_internal/vm/lib/mirrors_patch.dart';
import 'package:serverpod_auth_shared_flutter/serverpod_auth_shared_flutter.dart';

void main() {
  var sm = SessionManager(caller: null as dynamic); // Mock caller
  var mirror = reflect(sm);
  print('Members of SessionManager:');
  for (var k in mirror.type.instanceMembers.keys) {
    print(MirrorSystem.getName(k));
  }
}
