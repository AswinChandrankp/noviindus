

import 'package:flutter/material.dart';
import 'package:noviindus/patient/provider/patient_provider.dart';
import 'package:noviindus/widgets/patientcard.dart';
import 'package:provider/provider.dart';
class PatientListView extends StatelessWidget {
  const PatientListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PatientProvider>(
      builder: (context, controller, child) {
        return RefreshIndicator(
          onRefresh: () => controller.getPatients(),
          child: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.patients.isEmpty
                  ? const Center(child: Text('No patients found'))
                  : ListView.builder(
                      itemCount: controller.patients.length,
                      itemBuilder: (context, index) {
                        final patient = controller.patients[index];
                        final cardNumber = index + 1;

                        // Safely access patientdetailsSet and treatmentName
                        final package = (patient.patientdetailsSet != null && patient.patientdetailsSet!.isNotEmpty)
                            ? patient.patientdetailsSet!.first.treatmentName
                            : 'No package info';

                        return PatientCard(
                          cardnumber: cardNumber,
                          patientname: patient.name,
                          package: package,
                        );
                      },
                    ),
        );
      },
    );
  }
}