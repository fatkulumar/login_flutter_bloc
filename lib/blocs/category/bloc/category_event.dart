part of 'category_bloc.dart';

@immutable
sealed class CategoryEvent {}

class LoadCategory extends CategoryEvent {}

class DeleteCategory extends CategoryEvent {
  final String id;

  DeleteCategory({required this.id});
}