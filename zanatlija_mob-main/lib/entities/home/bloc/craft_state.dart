part of 'craft_cubit.dart';

sealed class CraftState extends Equatable {
  const CraftState();

  @override
  List<Object> get props => [];
}

final class CraftInitial extends CraftState {}

final class CraftStateError extends CraftState {
  final String error;
  const CraftStateError(this.error);
}

final class CraftLoadingState extends CraftState {}

final class CrafAddNewJobSuccess extends CraftState {}

final class CrafDeleteStateSuccess extends CraftState {}

final class CrafStateSuccess extends CraftState {}

final class CrafAddNewJobError extends CraftStateError {
  const CrafAddNewJobError(super.error);
}

final class CraftUploadedSuccess extends CraftState {}

final class CraftUploadErrorState extends CraftStateError {
  const CraftUploadErrorState(super.error);
}

final class CraftDownloadSuccess extends CraftState {
  final List<Craft> crafts;
  const CraftDownloadSuccess(this.crafts);

  @override
  List<Object> get props => [crafts];
}

final class CraftDownloadError extends CraftStateError {
  const CraftDownloadError(super.error);
}
