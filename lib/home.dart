import 'package:flutter/material.dart';
import 'package:flutter_application_2/blocs/category/bloc/category_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Home'), actions: [
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: IconButton(onPressed: () {
            context.read<CategoryBloc>().add(LoadCategory());
          }, icon: Icon(Icons.refresh)),
        )
      ],),
      body: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is CategoryFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategoryLoaded) {
              final categories = state.data;
              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(categories[index].id),
                    subtitle: Text(categories[index].name),
                    leading: Icon(Icons.category),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (dialogContext) => AlertDialog(
                            title: Text('Konfirmasi'),
                            content: Text('Hapus data kategori ini?'),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(dialogContext, false),
                                child: Text('Batal'),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(dialogContext, true),
                                child: Text('Hapus'),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true && context.mounted) {
                          context.read<CategoryBloc>().add(
                            DeleteCategory(id: categories[index].id),
                          );
                        }
                      },
                    ),
                    onTap: () {
                      // Uncomment and update for navigating to another page
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => MyAdd(user: categories[index]),
                      //   ),
                      // );
                    },
                  );
                },
              );
            } else if (state is CategoryFailure) {
              return Center(child: Text(state.message));
            } else if (state is CategoryDeleted) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Uncomment and update for adding a new category
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const MyAdd()),
          // );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
