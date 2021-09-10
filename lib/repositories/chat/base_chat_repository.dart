import 'package:codespot/models/message.dart';

abstract class BaseChatRepository {
  Future<void> sendMessage({required Message message});
  Stream<List<Future<Message?>>> getMessage({required String convId});
  Future<bool> isConverstationExist({required String convId});
}
