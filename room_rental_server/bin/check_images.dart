import 'package:room_rental_server/src/generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

void main(List<String> args) async {
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  await pod.start();
  final session = await pod.createSession();

  try {
    final rooms = await Room.db.find(session, limit: 1);
    if (rooms.isNotEmpty) {
      print('First room image URL: ${rooms.first.imageUrl}');
      print('First room secondary images: ${rooms.first.images}');
    } else {
      print('No rooms found.');
    }
  } finally {
    await session.close();
    await pod.shutdown();
  }
}

class Endpoints extends EndpointDispatch {
  @override
  void initializeEndpoints(Server server) {}
}
