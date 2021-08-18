import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list_with_bloc/bloc/todo_bloc.dart';
import 'package:to_do_list_with_bloc/bloc/todo_cubit.dart';
import 'package:to_do_list_with_bloc/bloc/todo_event.dart';
import 'package:to_do_list_with_bloc/bloc/todo_state.dart';
import 'package:to_do_list_with_bloc/repository/todo_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

///bloc
// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => TodoBloc(todoRepository: TodoRepository()),
//       child: HomeWidget(),
//     );
//   }
// }

///cubit
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TodoCubit(repository: TodoRepository()),
      child: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  var title = "";

  @override
  void initState() {
    super.initState();

    //Bloc
    // BlocProvider.of<TodoBloc>(context).add(ListTodosEvent());

    //Cubit
    BlocProvider.of<TodoCubit>(context).listTodo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("to_do_list_with_bloc"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Bloc
          //// BlocProvider.of<TodoBloc>(context).add(ListTodosEvent()); 와 같은 문법
          // context.read<TodoBloc>().add(CreateTodoEvent(title: this.title));

          //Cubit
          context.read<TodoCubit>().createTodo(this.title);
        },
        child: Icon(Icons.edit),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (val) {
                this.title = val;
              },
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            //Bloc
            // child: BlocBuilder<TodoBloc, TodoState>(builder: (_, state) {

            //Cubit
            child: BlocBuilder<TodoCubit, TodoState>(builder: (_, state) {
              if (state is Empty) {
                return Container();
              } else if (state is Error) {
                return Container(child: Text(state.message));
              } else if (state is Loading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is Loaded) {
                final items = state.todos;
                return ListView.separated(
                    itemBuilder: (_, index) {
                      final item = items[index];
                      return Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: Row(
                          children: [
                            Expanded(child: Text(item.title)),
                            GestureDetector(
                              child: Icon(Icons.delete),
                              onTap: () {

                                //Bloc
                                // BlocProvider.of<TodoBloc>(context)
                                //     .add(DeleteTodoEvent(todo: item));

                                //Cubit
                                BlocProvider.of<TodoCubit>(context)
                                    .deleteTodo(item);
                              },
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (_, index) => Divider(),
                    itemCount: items.length);
              } else {
                return Container();
              }
            }),
          ),
        ],
      ),
    );
  }
}
