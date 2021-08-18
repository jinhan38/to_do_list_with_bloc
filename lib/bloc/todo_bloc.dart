import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_with_bloc/bloc/todo_event.dart';
import 'package:to_do_list_with_bloc/bloc/todo_state.dart';
import 'package:to_do_list_with_bloc/model/todo.dart';
import 'package:to_do_list_with_bloc/repository/todo_repository.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository todoRepository;

  TodoBloc({required this.todoRepository}) : super(Empty());

  @override
  Stream<TodoState> mapEventToState(TodoEvent event) async* {
    if (event is ListTodosEvent) {
      yield* _mapListTodoEvent(event);
    } else if (event is CreateTodoEvent) {
      yield* _mapCreateTodoEvent(event);
    } else if (event is DeleteTodoEvent) {
      yield* _mapDeleteTodoEvent(event);
    }
  }

  Stream<TodoState> _mapListTodoEvent(ListTodosEvent event) async* {
    try {
      yield Loading();
      final resp = await this.todoRepository.listTodo();
      final todos = resp.map<Todo>((e) => Todo.fromJson(e)).toList();
      yield Loaded(todos: todos);
    } catch (e) {
      yield Error(message: e.toString());
    }
  }

  Stream<TodoState> _mapCreateTodoEvent(CreateTodoEvent data) async* {
    //yield된 것들은 bloc의 state에 저장된다.
    try {
      //중요
      //await this.todoRepository.createTodo(newTodo)를 이용해서 repository를 호출하면 1초의 딜레이를 설정해놨다.
      //하지만 여기서 repository.createTodo를 호출하기 전에 미리 ui를 그렸기 때문에 실제 앱에서 delay가 발생하지 않는다.

      if (state is Loaded) {
        final parsedState = (state as Loaded);

        final newTodo = Todo(
          id: parsedState.todos[parsedState.todos.length - 1].id + 1,
          title: data.title,
          createdAt: DateTime.now().toString(),
        );

        //spread operator (...)
        // parsedState.todos는 list다. prevTodos라는 List에 List add하려고 할 때 사용할 수 있다.
        final prevTodos = [
          ...parsedState.todos,
        ];

        final newTodos = [...parsedState.todos, newTodo];

        yield Loaded(todos: newTodos);

        final resp = await this.todoRepository.createTodo(newTodo);

        yield Loaded(todos: [
          ...prevTodos,
          Todo.fromJson(resp),
        ]);
      }
    } catch (e) {
      yield Error(message: e.toString());
    }
  }

  Stream<TodoState> _mapDeleteTodoEvent(DeleteTodoEvent data) async* {
    //yield된 것들은 bloc의 state에 저장된다.
    try {
      if (state is Loaded) {
        final newTodo = (state as Loaded)
            .todos
            .where((todo) => todo.id != data.todo.id)
            .toList();

        yield Loaded(todos: newTodo);

        await todoRepository.deleteTodo(data.todo);
      }
    } catch (e) {
      yield Error(message: e.toString());
    }
  }
}
