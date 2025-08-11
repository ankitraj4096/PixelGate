import 'package:basic/models/image_model.dart';
import 'package:equatable/equatable.dart';

abstract class ImagesState extends Equatable {
  const ImagesState();

  @override
  List<Object> get props => [];
}

class ImagesInitial extends ImagesState {}

class ImagesLoading extends ImagesState {}

class ImagesLoaded extends ImagesState {
  final List<ImageModel> images;

  const ImagesLoaded({required this.images});

  @override
  List<Object> get props => [images];
}

class ImagesError extends ImagesState {
  final String error;

  const ImagesError({required this.error});

  @override
  List<Object> get props => [error];
}
