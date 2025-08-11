import 'package:equatable/equatable.dart';

abstract class ImagesEvent extends Equatable {
  const ImagesEvent();

  @override
  List<Object> get props => [];
}

class FetchImages extends ImagesEvent {}
