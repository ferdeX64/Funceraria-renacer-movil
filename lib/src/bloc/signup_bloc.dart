import 'package:funeraria14/src/bloc/validator_bloc.dart';
import 'package:rxdart/rxdart.dart';




class SignUpBloc with Validator {
  SignUpBloc();
  //Controllers
  
  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _usernameController = BehaviorSubject<String>();
  final _videonameController = BehaviorSubject<String>();
  final _anticipoController = BehaviorSubject<String>();
  final _celularController = BehaviorSubject<String>();
  final _actividadDescriptionController = BehaviorSubject<String>();
  //Streams, vinculados con la validación
  Stream<String> get emailStream =>
      _emailController.stream.transform(emailValidator);
        Stream<String> get celularStream =>
      _celularController.stream.transform(celularValidator);
  Stream<String> get passwordStream =>
      _passwordController.stream.transform(passwordValidator);
  Stream<String> get usernameStream =>
      _usernameController.stream.transform(usernameValidator);
  Stream<bool> get formSignUpStream => Rx.combineLatest3(
      usernameStream, emailStream, passwordStream, (a, b, c) => true);
  Stream<String> get videonameStream =>
      _videonameController.stream.transform(videonameValidator);
    Stream<String> get anticipoStream =>
      _anticipoController.stream.transform(anticipoValidator);
  Stream<String> get actividadDescriptionStream =>
      _actividadDescriptionController.stream.transform(actividadDescriptionValidator);
  Stream<bool> get formVideoStream => Rx.combineLatest2(
      videonameStream, actividadDescriptionStream, (a, b) => true);

    
  //Funciones para el onChange cada control
  Function(String) get changeEmail => _emailController.sink.add;
   Function(String) get changeCelular => _celularController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeUsername => _usernameController.sink.add;
   Function(String) get changeVideoname => _videonameController.sink.add;
   Function(String) get changeAnticipo => _anticipoController.sink.add;
  Function(String) get changeActividadDescription => _actividadDescriptionController.sink.add;
  //Propiedades con el valor del texto ingreso
  String get email => _emailController.value;
    String get celular => _celularController.value;
  String get password => _passwordController.value;
  String get username => _usernameController.value;
  String get videoname=>_videonameController.value;
   String get anticipo=>_anticipoController.value;
  String get videodescription=>_actividadDescriptionController.value;
  dispose() {
    _usernameController.close();
    _emailController.close();
    _passwordController.close();
    _actividadDescriptionController.close();
    _videonameController.close();
  }
}
