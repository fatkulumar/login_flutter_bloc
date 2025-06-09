import 'package:flutter/material.dart';
import 'package:flutter_application_2/blocs/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:flutter_application_2/blocs/auth/logout/bloc/logout_bloc.dart';
import 'package:flutter_application_2/blocs/category/bloc/category_bloc.dart';
import 'package:flutter_application_2/blocs/user/bloc/user_bloc.dart';
import 'package:flutter_application_2/pages/category/add_category_pages.dart';
import 'package:flutter_application_2/pages/welcome_pages.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(LoadCategory());
    context.read<UserBloc>().add(LoadUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Home'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: IconButton(
              onPressed: () {
                context.read<CategoryBloc>().add(LoadCategory());
                context.read<UserBloc>().add(LoadUser());
              },
              icon: Icon(Icons.refresh),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 24),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text('Konfirmasi Logout'),
                        content: Text('Apakah kamu yakin ingin keluar?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // tutup dialog
                              context.read<LogoutBloc>().add(LogoutSubmited());
                            },
                            child: Text('Logout'),
                          ),
                        ],
                      ),
                );
              },
              icon: Icon(Icons.logout),
            ),
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<CategoryBloc, CategoryState>(
            listener: (context, state) {
              if (state is CategoryDeleted) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
          BlocListener<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => WelcomePages()),
                );
              }
            },
          ),
          BlocListener<LogoutBloc, LogoutState>(
            listener: (context, state) {
              if (state is LogoutLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => Center(child: CircularProgressIndicator()),
                );
              } else {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pop(); // tutup loading
              }

              if (state is LogoutFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is LogoutSuccess) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => WelcomePages()),
                  (route) => false,
                );
              }
            },
          ),
          BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
            listener: (context, state) {
              if (state is ForgotPasswordLoading) {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => Center(child: CircularProgressIndicator()),
                );
              } else {
                Navigator.of(
                  context,
                  rootNavigator: true,
                ).pop(); // tutup loading
              }

              if (state is ForgotPasswordFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              } else if (state is ForgotPasswordSuccess) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => WelcomePages()),
                  (route) => false,
                );
              }
            },
          ),
        ],
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserLoaded) {
                    final user = state.data;
                    return ListTile(
                      leading: Icon(Icons.person),
                      title: Text(user.email),
                      subtitle: Text(user.name),
                    );
                  } else if (state is UserFailure) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoryLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is CategoryLoaded) {
                    final categories = state.data;
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
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
                                builder:
                                    (dialogContext) => AlertDialog(
                                      title: Text('Konfirmasi'),
                                      content: Text('Hapus data kategori ini?'),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(
                                                dialogContext,
                                                false,
                                              ),
                                          child: Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(
                                                dialogContext,
                                                true,
                                              ),
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => AddCategoryPages(
                                      category: categories[index],
                                    ),
                              ),
                            );
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
              BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
                builder: (context, state) {
                  if (state is ForgotPasswordLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ForgotPasswordSuccess) {
                    final forgotPassword = state;
                    return ListTile(
                      leading: Icon(Icons.person),
                      title: Text(forgotPassword.message),
                      subtitle: Text(forgotPassword.data),
                    );
                  } else if (state is ForgotPasswordFailure) {
                    return Center(child: Text(state.message));
                  }
                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCategoryPages()),
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
