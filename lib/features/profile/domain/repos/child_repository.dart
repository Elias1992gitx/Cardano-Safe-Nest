import 'package:safenest/core/utils/typedef.dart';
import 'package:safenest/features/profile/domain/entity/child.dart';

abstract class ChildRepository {
  ResultFuture<Child> getChildById(String id);
  ResultFuture<List<Child>> getAllChildrenByParentId(String parentId);
  ResultVoid addChild(Child child);
  ResultVoid updateChild(Child child);
  ResultVoid deleteChild(String id);
  ResultFuture<List<String>> getChildActivityLogs(String childId);
}