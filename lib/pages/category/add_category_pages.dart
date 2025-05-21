import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/category/category_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_2/blocs/category/bloc/category_bloc.dart';

class AddCategoryPages extends StatefulWidget {
   final CategoryModel? category; 
  const AddCategoryPages({super.key, this.category});

  @override
  State<AddCategoryPages> createState() => _AddCategoryPagesState();
}

class _AddCategoryPagesState extends State<AddCategoryPages> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Category')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              BlocListener<CategoryBloc, CategoryState>(
                listener: (context, state) {
                  if (state is CategoryLoaded) {
                    final message = state.message;
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(message)));
                    Navigator.pop(context); // Kembali ke halaman utama
                  } else if (state is CategoryFailure) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final name = _nameController.text;

                      if (widget.category == null) {
                        context.read<CategoryBloc>().add(
                          AddCategory(name: name),
                        );
                      } else {
                        // mode edit
                        context.read<CategoryBloc>().add(
                          UpdateCategory(
                            id: widget.category!.id,
                            name: name,
                          ),
                        );
                      }
                    }
                  },
                  child: Text(widget.category == null ? 'Tambah Category' : 'Update Category'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}