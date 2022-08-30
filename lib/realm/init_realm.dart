import 'package:realm/realm.dart';
import 'package:flutter_todo/realm/schemas.dart';
import 'package:flutter_todo/viewmodels/todo_viewmodel.dart';

Realm initRealm(User currentUser) {
  Configuration config = Configuration.flexibleSync(currentUser, [Todo.schema]);
  Realm realm = Realm(
    config,
  );
  final userTaskSub =
    realm.subscriptions.findByName('getUserTodosWithPriority');
  if (userTaskSub == null) {
    realm.subscriptions.update((mutableSubscriptions) {
      // server-side rules ensure user only downloads own tasks
      mutableSubscriptions.add(
          realm.query<Todo>(
            'priority <= \$0 OR priority == nil',
            [PriorityLevel.high],
          ),
          name: 'getUserTodosWithPriority');
    });
  }
  return realm;
}
