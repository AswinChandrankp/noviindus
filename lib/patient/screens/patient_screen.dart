
import 'package:flutter/material.dart';
import 'package:noviindus/patient/provider/patient_provider.dart';
import 'package:noviindus/patient/screens/patient_listview.dart';
import 'package:noviindus/patient/screens/registration_screen.dart';
import 'package:noviindus/widgets/customButton.dart';
import 'package:provider/provider.dart';

class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  @override


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
        ],
      ),
      body: PatientListView(), 

        floatingActionButton: CustomElevatedButton(
        text: "Register Now",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Registerscreen()),
          );
          //.then((value) => Provider.of<RegistrationController>(context, listen: false).onRegister());
          
          
        },
        padding: EdgeInsets.only(
            left: MediaQuery.of(context).size.width * 0.25,
            right: MediaQuery.of(context).size.width * 0.25,
            bottom: MediaQuery.of(context).size.height * 0.02,
            top: MediaQuery.of(context).size.height * 0.02),
            fontWeight: FontWeight.w600,
            fontsize: 17,
            borderRadius: 8.52,

            

            
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
