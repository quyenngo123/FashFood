import '../entities/user_entity.dart';
import '../repositories/auth_repositories.dart';

class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  Future<UserEntity?> call() async {
    return await _repository.getCurrentUser();
  }
}
