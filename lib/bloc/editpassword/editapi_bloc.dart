import 'package:async/async.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import '../mixins.dart';
import '../../data/repos/editpassword_repository.dart';
import '../../models/errors.dart';
//import 'package:rxdart/rxdart.dart';

abstract class EditApiEvent {}

class EditPassword extends EditApiEvent {
  final String existingPassword;
  EditPassword(this.existingPassword);
}

abstract class EditApiState {}

//class InitialState extends EditApiState{}
class EditPasswordStill extends EditApiState {}

class Clear extends EditApiState {}

class EditApiLoadingState extends EditApiState {}

class EditSuccessState extends EditApiState {
  final String insertMessage;

  EditSuccessState({
    required this.insertMessage,
  });
}

class EditApiStateAuthError extends EditApiState {
  final String errorMessage;
  EditApiStateAuthError({
    required this.errorMessage,
  });
}

class EditApiStateUnknownError extends EditApiState {
  final String errorMessage;
  EditApiStateUnknownError({
    required this.errorMessage,
  });
}

class EditApiStateError4xx extends EditApiState {
  final String errorMessage;
  EditApiStateError4xx({
    required this.errorMessage,
  });
}

class EditApiStateGeneralError extends EditApiState {
  final String errorMessage;
  EditApiStateGeneralError({
    required this.errorMessage,
  });
}

class EditApiBloc extends Bloc<EditApiEvent, EditApiState>
    with TransitionMixin {
  EditApiBloc(this.repository) : super(EditPasswordStill()) {
    on<EditPassword>((event, emit) async {
      try {
        emit(EditApiLoadingState());
        var result = await apiCall(event.existingPassword);

        if (result == null) {
          if (errorType is AuthError) {
            emit(EditApiStateAuthError(
              errorMessage: errorMessage,
            ));
          } else if (errorType is UnknownError) {
            emit(EditApiStateUnknownError(
              errorMessage: errorMessage,
            ));
          } else if (errorType is Error4xx) {
            emit(EditApiStateError4xx(
              errorMessage: errorMessage,
            ));
          } else {
            errorType = "GeneralError";
            emit(EditApiStateUnknownError(
              errorMessage: errorMessage,
            ));
          }
        } else {
          emit(EditSuccessState(insertMessage: "Success"));
        }
      } catch (exception) {
        emit(EditApiStateUnknownError(
          errorMessage: exception.toString(),
        ));
      }
    });
  }

  String errorType = "";
  String errorMessage = "";

  String lastUrl = 'allvehicle';
  int lastVehicleID = 0;

  late CancelableOperation cancelableCall;

  final EditPasswordRepository repository;
  //List<VehicleinfoDetails> vehicleInfoList;

  EditApiState get initialState => EditPasswordStill();

  Future apiCall(String existingPassword) async {
    //print("Calling api to get data");
    var future = repository
        .editData(
      existingPassword: existingPassword,
    )
        .catchError((err, stackTrace) {
      //print("api_bloc:Error is " + err.toString());
      if (err is AuthError) {
        //print("Auth error"+err.message);
        errorType = "AuthError";
        errorMessage = err.message;
        //return Future.error(AuthError(err.message));
      } else if (err is UnknownError) {
        print("UnknownError error" + err.message);
        errorType = "UnknownError";
        errorMessage = err.message;
        //return Future.error(UnknownError(err.message));
      } else if (err is Error4xx) {
        errorType = "Error4xx";
        errorMessage = err.message;
        //return Future.error(Error4xx(err.message));
        //return Future.error(Error4xx(err.message));
      } else {
        errorType = "GeneralError";
        errorMessage = "Something went wrong reason:unknown";
        //return Future.error(UnknownError(err.message));
      }
    });

    cancelableCall = CancelableOperation.fromFuture(future);
    return cancelableCall.valueOrCancellation(null);
  }

  /*@override
  Stream<Transition<EditApiEvent, EditApiState>> transformEvents(
      Stream<EditApiEvent> events, transitionFn) {
    return events
        .debounceTime(const Duration(milliseconds: 50))
        .switchMap((transitionFn));
  }*/

  void editPassword(String existingPassword) {
    add(EditPassword(existingPassword));
  }
}
