import '../../utils/network_utils.dart';
import '../../models/errors.dart';

class EditPasswordRepository {
  //final String existingPassword;

  EditPasswordRepository();

  Future<String> editData({
    required String existingPassword,
  }) async {
    try {
      final data = {
        'ePass': existingPassword,
      };
      //print("Update password " + data.toString());
      final editPasswordStatus =
          await NetworkUtils.post("editPassword", data).catchError((err) {
        //print("cinsert had error ready " + err.toString());
        //print("cinsert had error messages " + err.message);
        if (err is AuthError) {
          //print("Full AuthError message is " + err.message);
          return Future.error(AuthError(err.message));
        } else if (err is UnknownError) {
          return Future.error(UnknownError(err.message));
        } else if (err is Error4xx) {
          //print("Full Error4xx message is " + err.message);
          return Future.error(Error4xx(err.message));
        } else {
          return Future.error(UnknownError(err.message));
        }
      });
      //print("vehicleInfoJson" + vehicleInfoJson.toString());
      return editPasswordStatus;
    } catch (exception) {
      //print("IN CATCH OF REPORISTY");
      //print("IN CATCH OF REPORISTY EXCEPTION is" + exception.toString());
      if (exception is AuthError) {
        //print("catch at repository Auth error");
        return Future.error(AuthError(exception.message));
      }
      if (exception is UnknownError) {
        return Future.error(UnknownError(exception.message));
      }
      if (exception is Error4xx) {
        //print(
        //    "IN CATCH OF REPORISTY EXCEPTION IN THE IF" + exception.toString());
        return Future.error(Error4xx(exception.message));
      }
      //print("Exception" + exception.toString());
    }
    return "";
  }
}
