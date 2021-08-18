import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_with_bloc/bloc/todo_state.dart';
import 'package:to_do_list_with_bloc/model/todo.dart';
import 'package:to_do_list_with_bloc/repository/todo_repository.dart';

class TodoCubit extends Cubit<TodoState> {
  final TodoRepository repository;

  TodoCubit({required this.repository}) : super(Empty());

  listTodo() async {
    try {
      //emit은 yield와 같다
      emit(Loading());
      Loading();
      final resp = await this.repository.listTodo();
      final todos = resp.map<Todo>((e) => Todo.fromJson(e)).toList();
      emit(Loaded(todos: todos));
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

  createTodo(String title) async {
    try {

      if (state is Loaded) {
        final parsedState = (state as Loaded);

        final newTodo = Todo(
          id: parsedState.todos[parsedState.todos.length - 1].id + 1,
          title: title,
          createdAt: DateTime.now().toString(),
        );

        //spread operator (...)
        // parsedState.todos는 list다. prevTodos라는 List에 List add하려고 할 때 사용할 수 있다.
        final prevTodos = [
          ...parsedState.todos,
        ];

        final newTodos = [...parsedState.todos, newTodo];

        emit(Loaded(todos: newTodos));

        final resp = await this.repository.createTodo(newTodo);

        emit(Loaded(todos: [
          ...prevTodos,
          Todo.fromJson(resp),
        ]));
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }


  deleteTodo(Todo data) async{
    try {
      if (state is Loaded) {
        final newTodo = (state as Loaded)
            .todos
            .where((todo) => todo.id != data.id)
            .toList();

        emit(Loaded(todos: newTodo)) ;

        await repository.deleteTodo(data);
      }
    } catch (e) {
      emit(Error(message: e.toString()));
    }
  }

}
