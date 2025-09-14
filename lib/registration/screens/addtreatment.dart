import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:noviindus/registration/provider/registration_provider.dart';
import 'package:noviindus/widgets/customButton.dart';
import 'package:noviindus/widgets/customdropdown.dart';
import 'package:provider/provider.dart' show Consumer, ReadContext;

class Addtreatment extends StatelessWidget {
  const Addtreatment({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RegistrationProvider>(
      builder: (context, registrationprovider, child) {
        return Container(
          height: 428,
          width: 348,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
            
         
                  TreatmentsDropdown(
                      items: registrationprovider.treatments,
                      hintText: "Choose Treatment",
                      title: "Treatment",
                      onChanged: (Treatment) {
                        print("${Treatment!.name}");
                        registrationprovider.setTreatment(Treatment);
                     
                      },
                    ),
            
                SizedBox(height: 20),
                Text("Add Patient"),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(217, 217, 217, 0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          width: 1,
                        ),
                      ),
                      height: 50,
                      width: 124,
                      child: Center(child: Text("Male")),
                    ),
                    SizedBox(width: 20),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            registrationprovider.decrementMaleCount();
                          },
                          child: Card(
                            color: Color.fromARGB(255, 0, 104, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            clipBehavior: Clip.antiAlias,
                            elevation: 5.0,
                            child: Icon(
                              Icons.remove,
                              size: 40.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(217, 217, 217, 0.25),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                width: 1,
                              ),
                            ),
                            height: 40,
                            width: 44,
                            child: Center(
                              child: Text('${registrationprovider.maleCount}'),
                              // },
                              // ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            registrationprovider.incrementMaleCount();
                          },
                          child: Card(
                            color: Color.fromARGB(255, 0, 104, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            clipBehavior: Clip.antiAlias,
                            elevation: 5.0,
                            child: Icon(
                              Icons.add,
                              size: 40.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(217, 217, 217, 0.2),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color.fromRGBO(0, 0, 0, 0.25),
                          width: 1,
                        ),
                      ),
                      height: 50,
                      width: 124,
                      child: Center(child: Text("Female")),
                    ),
                    SizedBox(width: 20),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            registrationprovider.decrementFemaleCount();
                          },
                          child: Card(
                            color: Color.fromARGB(255, 0, 104, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            clipBehavior: Clip.antiAlias,
                            elevation: 5.0,
                            child: Icon(
                              Icons.remove,
                              size: 40.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(217, 217, 217, 0.25),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Color.fromRGBO(0, 0, 0, 0.25),
                                width: 1,
                              ),
                            ),
                            height: 40,
                            width: 44,
                            child: Center(
                              child: Text(
                                '${registrationprovider.femaleCount}',
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            registrationprovider.incrementFemaleCount();
                          },
                          child: Card(
                            color: Color.fromARGB(255, 0, 104, 55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            clipBehavior: Clip.antiAlias,
                            elevation: 5.0,
                            child: Icon(
                              Icons.add,
                              size: 40.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        text: "Saved",
                        onPressed: () {
                          registrationprovider.addTreatmentToList();
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
