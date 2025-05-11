import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:support/features/auth/signup/data/models/register_request_model.dart';
import 'package:support/features/auth/signup/data/repos/register_repo.dart';

part 'signup_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterRepo registerRepo;

  RegisterCubit(this.registerRepo) : super(RegisterInitial());

  Future<void> register(RegisterRequestModel req) async {
    emit(RegisterLoading());

    try {
      await registerRepo.register(req);
      emit(RegisterSuccess());
    } catch (e) {
      // Pass error message directly without Exception prefix
      emit(RegisterFailure(e.toString()));
    }
  }
}
