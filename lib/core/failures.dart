abstract class Failure {
  final String message;
  Failure(this.message);
}

class CityNotFoundFailure extends Failure {
  CityNotFoundFailure() : super("City not found");
}

class ServerFailure extends Failure {
  ServerFailure() : super("Something went wrong");
}

