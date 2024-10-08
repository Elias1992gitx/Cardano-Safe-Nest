import 'dart:isolate';
import 'package:safenest/features/profile/data/models/child_model.dart';
import 'package:safenest/features/profile/data/data_sources/parental_info_remote_data_source.dart';

void connectionIsolate(SendPort sendPort) {
  final ReceivePort receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);

  receivePort.listen((message) async {
    if (message is Map<String, dynamic>) {
      final childId = message['childId'] as String;
      final parentId = message['parentId'] as String;
      final dataSource = message['dataSource'] as ParentalInfoRemoteDataSource;

      sendPort.send({'showDialog': true});

      try {
        await dataSource.linkChildToParent(childId, parentId);
        sendPort.send({'success': true});
      } catch (e) {
        sendPort.send({'success': false, 'error': e.toString()});
      }
    }
  });
}