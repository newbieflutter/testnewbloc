import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../data/repos/editpassword_repository.dart';
import '../../bloc/editpassword/editapi_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const EditPasswordPage());
}

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({Key? key}) : super(key: key);

  @override
  _EditPasswordPageState createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage>
    with SingleTickerProviderStateMixin {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late EditPasswordRepository _editPasswordRepo;
  late EditApiBloc editApiBLoC;
  String selectedPlateNumber = "";
  String selectedVehicleID = "";
  String selectedDateTime = "";
  DateTime current = DateTime.now();
  // ignore: unnecessary_new
  TextEditingController existingPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmedPasswordController = TextEditingController();
  @override
  void initState() {
    _editPasswordRepo = EditPasswordRepository();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider<EditApiBloc>(
            create: (BuildContext context) {
              editApiBLoC = EditApiBloc(_editPasswordRepo);
              return editApiBLoC;
            },
          ),
        ],
        child: Theme(
            data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
            child: MaterialApp(
                home: Scaffold(
                    key: _scaffoldKey,
                    resizeToAvoidBottomInset: true,
                    backgroundColor: Colors.white,
                    appBar: appBar(),
                    body: SafeArea(
                        child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const SizedBox(
                            height: 30,
                          ),
                          Form(
                            key: _formKey,
                            child: formUI(),
                          ),
                          BlocBuilder<EditApiBloc, EditApiState>(builder:
                              (BuildContext context, EditApiState state) {
                            //print("EditApiState Current state is " + state.toString());
                            if (state is EditPasswordStill) {
                              return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            0, 30, 0, 10),
                                        child: Material(
                                            color: Colors.blue,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(5.0)),
                                            elevation: 0,
                                            child: MaterialButton(
                                                onPressed: () {
                                                  final form =
                                                      _formKey.currentState;
                                                  if (form!.validate()) {
                                                    editApiBLoC.editPassword(
                                                        existingPasswordController
                                                            .text);
                                                  } else {
                                                    //print("NOT VALIDATE");
                                                  }
                                                },
                                                minWidth: 150.0,
                                                elevation: 0.0,
                                                height: 32.0,
                                                child: const Text(
                                                  'Edit',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ))))
                                  ]);
                            }
                            if (state is EditApiLoadingState) {
                              return const Text("Loading");
                            }
                            if (state is EditApiStateAuthError) {
                              Future.delayed(const Duration(seconds: 1), () {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    "/loginpage", ModalRoute.withName("/"));
                              });
                              return const Text(
                                "Your session expired. Relogin",
                              );
                            }
                            if (state is EditApiStateError4xx) {
                              return const Text("TE");
                            }
                            if (state is EditApiStateGeneralError) {
                              return SizedBox(
                                  height: 150,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 30, 0, 10),
                                            child: Material(
                                                color: Colors.blue,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5.0)),
                                                elevation: 0,
                                                child: MaterialButton(
                                                    onPressed: () {
                                                      final form =
                                                          _formKey.currentState;
                                                      if (form!.validate()) {
                                                        editApiBLoC
                                                            .editPassword(
                                                          existingPasswordController
                                                              .text,
                                                        );
                                                      } else {
                                                        //print("NOT VALIDATE");
                                                      }
                                                    },
                                                    minWidth: 150.0,
                                                    elevation: 0.0,
                                                    height: 32.0,
                                                    child: const Text(
                                                      'Edit',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )))),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          state.errorMessage,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]));
                            }
                            if (state is EditApiStateUnknownError) {
                              return SizedBox(
                                  height: 100,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 30, 0, 10),
                                            child: Material(
                                                color: Colors.blue,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5.0)),
                                                elevation: 0,
                                                child: MaterialButton(
                                                    onPressed: () {
                                                      final form =
                                                          _formKey.currentState;
                                                      if (form!.validate()) {
                                                        editApiBLoC
                                                            .editPassword(
                                                          existingPasswordController
                                                              .text,
                                                        );
                                                      } else {
                                                        //print("NOT VALIDATE");
                                                      }
                                                    },
                                                    minWidth: 150.0,
                                                    elevation: 0.0,
                                                    height: 32.0,
                                                    child: const Text(
                                                      'Edit',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )))),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          state.errorMessage,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]));
                            }
                            if (state is EditSuccessState) {
                              return SizedBox(
                                  height: 120,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 30, 0, 10),
                                            child: Material(
                                                color: Colors.blue,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(5.0)),
                                                elevation: 0,
                                                child: MaterialButton(
                                                    onPressed: () {
                                                      final form =
                                                          _formKey.currentState;
                                                      if (form!.validate()) {
                                                        editApiBLoC
                                                            .editPassword(
                                                          existingPasswordController
                                                              .text,
                                                        );
                                                      } else {
                                                        //print("NOT VALIDATE");
                                                      }
                                                    },
                                                    minWidth: 150.0,
                                                    elevation: 0.0,
                                                    height: 32.0,
                                                    child: const Text(
                                                      'Edit',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )))),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Text(
                                          state.insertMessage,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ]));
                            }
                            return const SizedBox(
                              height: 0,
                              width: 0,
                            );
                          }),
                        ],
                      ),
                    ))))));
  }

  PreferredSizeWidget? appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: const IconThemeData(color: Colors.black),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              padding: const EdgeInsets.all(0.0),
              child: const Text(
                'Edit Password',
              ))
        ],
      ),
      actions: const <Widget>[
        SizedBox(
          width: 20,
        ),
      ],
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      toolbarTextStyle: const TextTheme(
        headline6: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ).bodyText2,
      titleTextStyle: const TextTheme(
        headline6: TextStyle(
          color: Colors.black,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ).headline6,
    );
  }

  Widget formUI() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 0, 20),
                  child: Text(
                    "Existing Password",
                  )),
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 0, 0, 20),
                child: SizedBox(
                    width: 180,
                    child: TextFormField(
                      controller: existingPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        isDense: true,
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        border: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                        ),
                        contentPadding: EdgeInsets.only(
                            left: 0, right: 0, top: 0, bottom: 0),
                        errorStyle: TextStyle(fontSize: 10, height: 0.3),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please Insert Existing Password';
                        } else if (value.length < 8) {
                          return 'Minimal 8 characters';
                        }
                        return null;
                      },
                    )),
              ),
            ],
          ),
        ]);
  }

  Widget buildTabBar() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1),
      ),
      elevation: 18,
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Container(
        height: 55,
        color: Colors.white,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: const <Widget>[],
        ),
      ),
    );
  }
}
