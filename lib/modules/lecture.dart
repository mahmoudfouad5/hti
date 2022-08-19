import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:buildcondition/buildcondition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hti/models/course_model.dart';
import 'package:hti/shared/componant/components.dart';
import 'package:hti/shared/componant/constant.dart';
import 'package:hti/shared/cubit/cubit.dart';
import 'package:hti/shared/cubit/states.dart';
import 'package:intl/intl.dart';

class LecturesScreen extends StatelessWidget {
  LecturesScreen({Key? key}) : super(key: key);
  var titlecontroller = TextEditingController();

  var scaffoldkey = GlobalKey<ScaffoldState>();
  var formkey = GlobalKey<FormState>();
  var timeNow = new DateFormat.jm().format(DateTime.now());
  var dateNow = new DateFormat.yMd().format(DateTime.now());



  @override
  Widget build(BuildContext context) {
    var cubit = Appcubit.get(context);
    return BlocConsumer<Appcubit, AppStates>(
      listener: (context, state) {
        if (state is CreateUserCourseSuccessState) {
          showToast(message: state.Success, state: ToastStates.SUCCESS);
        }
        if (state is CreateUserCourseErrorState) {
          showToast(message: state.error, state: ToastStates.ERROR);
        }
      },
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text("a"),
        ),
        key: scaffoldkey,
        body: BuildCondition(
          condition: state is! CreateUserCourseLoadingState,
          builder: (context) => BuildCondition(
              condition:  false,//cubit.courses.length > 0,
              builder: (context) => ListView.builder(
                itemBuilder: (context, index) =>
                    buildCourseItem(cubit.courses[index], context),
                itemCount: cubit.courses.length,
              ),
              fallback: (context) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.upload_file,
                        size: 200, color: Colors.black.withOpacity(.8)),
                    Text(
                      "please add your Lecture",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.black.withOpacity(.8)),
                    )
                  ],
                ),
              )),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        ),
        floatingActionButton: Visibility(
            visible: (cubit.currentIndex == 0),
            child: FloatingActionButton(
              onPressed: () {
                late AwesomeDialog dialog;
                dialog = AwesomeDialog(
                  context: context,
                  animType: AnimType.SCALE,
                  dialogType: DialogType.INFO,
                  keyboardAware: true,
                  body: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: formkey,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Select Yu',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                           Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AnimatedButton (
                                  isFixedHeight: false,
                                  width: 75,
                                  text: 'Select',
                                  pressEvent: (){}
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                AnimatedButton(
                                  isFixedHeight: false,
                                  color: Colors.red,
                                  width: 75,
                                  text: 'Close',
                                  pressEvent: () {
                                     dialog.dismiss();
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )..show();
              },
              child: Icon(Icons.add),
            )),
      ),
    );
  }

  Widget buildCourseItem(CoursesData data, context) => Padding(
    padding: const EdgeInsetsDirectional.only(start: 10, top: 20,end: 20),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
      width: double.infinity,
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.book,
                size: 50,
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${data.title}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                        Text(
                          'Date:${data.date}',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(
                          'Time:${data.time}',
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 20,),
                        SizedBox(height: 40,)
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
