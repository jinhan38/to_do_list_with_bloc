import 'package:to_do_list_with_bloc/model/todo.dart';

///Get - ListTodo
///Post - CreateTodo
///Delete - DeleteTodo

class TodoRepository {

  Future<List<Map<String, dynamic>>> listTodo() async {
    await Future.delayed(Duration(seconds: 1));
    return [
      {
        'id': 1,
        'title': "flutter bloc 111",
        'createdAt': DateTime.now().toString(),
      },
      {
        'id': 2,
        'title': "flutter bloc 222",
        'createdAt': DateTime.now().toString(),
      },
    ];
  }

  Future<Map<String, dynamic>> createTodo(Todo data) async{
    await Future.delayed(Duration(seconds: 1));
    return data.toJson();
  }

  Future<Map<String, dynamic>> deleteTodo(Todo data) async{
    await Future.delayed(Duration(seconds: 1));
    return data.toJson();
  }
  
}
