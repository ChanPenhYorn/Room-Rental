import 'package:serverpod/serverpod.dart';
import 'package:dwellly_server/src/generated/protocol.dart' as p;
import 'package:dwellly_server/src/generated/endpoints.dart' as e;
import 'package:serverpod_auth_server/serverpod_auth_server.dart';

Future<void> main(List<String> args) async {
  // Initialize Serverpod
  final pod = Serverpod(
    args,
    p.Protocol(),
    e.Endpoints(),
    authenticationHandler: null,
  );

  await pod.start();
  final session = await pod.createSession(enableLogging: true);

  try {
    print('--- Inspecting UserInfo ---');
    final userInfos = await UserInfo.db.find(session);
    for (final u in userInfos) {
      print(
        'ID: ${u.id}, UserIdentifier: "${u.userIdentifier}", Email: "${u.email}", UserName: "${u.userName}"',
      );
    }

    // Check specific identifier failing in logs
    final failingId = "019c6af2-bec4-7295-85f2-9406dabf77d6";
    final match = await UserInfo.db.findFirstRow(
      session,
      where: (t) => t.userIdentifier.equals(failingId),
    );

    if (match == null) {
      print('❌ FAILED to find UserInfo with identifier: "$failingId"');
      // Maybe try to find by partial match?
      final partial = await UserInfo.db.findFirstRow(
        session,
        where: (t) => t.userIdentifier.like('%$failingId%'),
      );
      if (partial != null) {
        print('⚠️ But found partial match: "${partial.userIdentifier}"');
      }
    } else {
      print('✅ Found UserInfo with identifier: "$failingId"');
    }

    print('--- End Inspection ---');
  } catch (e, stack) {
    print('Error: $e');
    print(stack);
  } finally {
    await session.close();
    await pod.shutdown();
  }
}
