
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:noviindus/patient/provider/patient_provider.dart';
import 'package:noviindus/registration/models/branch_model.dart';
import 'package:noviindus/registration/provider/registration_provider.dart';
import 'package:noviindus/registration/screens/addtreatment.dart';
import 'package:noviindus/widgets/customButton.dart';
import 'package:noviindus/widgets/customdropdown.dart';
import 'package:noviindus/widgets/customtextfield.dart';
import 'package:noviindus/widgets/paymentoption.dart';
import 'package:noviindus/widgets/treatmentcard.dart';

import 'package:provider/provider.dart';

class Registerscreen extends StatefulWidget {
  Registerscreen({super.key});

  @override
  State<Registerscreen> createState() => _RegisterscreenState();
}

class _RegisterscreenState extends State<Registerscreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer <RegistrationProvider>(
      builder: (context, registrationcontroller, child) {
          //  final items = registrationcontroller.branches;
      //  List<String> NewBranchData = [];
        
      //                 for (int i = 0; i < items.length; i++) {
      //                   final data = items.elementAt(i).name;
      //                   NewBranchData.add(data.toString());
      //                 }
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Register Now",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Divider(
                    height: 1,
                    color: Color.fromRGBO(0, 0, 0, 0.2),
                    thickness: 1,
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: registrationcontroller.nameController,
                    keyboardType: TextInputType.name,
                    hintText: "Enter Your Full Name",
                    title: "Name",
                  ),
                  CustomTextField(
                    controller: registrationcontroller.phoneController,
                    keyboardType: TextInputType.number,
                    hintText: " Enter Your Whatsapp Number",
                    title: "Whatsapp Number",
                  ),
                  CustomTextField(
                    controller: registrationcontroller.detailsController,
                    keyboardType: TextInputType.streetAddress,
                    hintText: "Enter Your full address",
                    title: "Address",
                  ),
                  CustomDropdown(
                    selectedValue: registrationcontroller.selectedadress ,
                    items: registrationcontroller.alladress, 
                    hintText: "Choose Your Location", 
                    title: "Location",
                    onChanged: (value) {
                      print('Selected value: $value');

                      registrationcontroller.setAddress(value!);
                    },

                  ),
               
        
                       BranchesDropdown(
                        selectedValue: registrationcontroller.selectedBranch,
                        items: registrationcontroller.branches , 
                        hintText: "Choose Branch",
                        title: "Branch",
                        onChanged: (Branches ) {
                          print('Selected value: ${Branches!.name}');
                          registrationcontroller.setBranch(Branches!);
                          
                        },
                      ),
                 
                      ListView.separated(
                        itemCount: registrationcontroller.addTreatment.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final treatment = registrationcontroller.addTreatment[index];
                          
                          return TreatmentCard(
                            treatmentname: treatment['treatment'],
                            malecount: treatment['male'],
                            femalecount: treatment['female'],
                            
                            index:  index,
        
                            delete: () {
                              // Provider.of<addtreatmentcontroller>(context, listen:false).removeTreatment(index);
                              registrationcontroller.deleteTreatment(index);
                              
                            }
        
                          );
                        }, separatorBuilder: (BuildContext context, int index) { 
                          return SizedBox(height: 10,);
                         },
                      ),
                    // },
                  // ),
                  Row(
                    children: [
                      Expanded(
                          child: CustomElevatedButton(
                        text: "+Add Treatment",
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                backgroundColor: Colors.white,
                                insetPadding: EdgeInsets.all(0),
                                child: Addtreatment(),
                              );
                            },
                          );
                          
                          // then((value) => 
                          //     Provider.of<RegistrationController>(context, listen: false).fetchTreatments());;
                        },
                        color: Color.fromRGBO(56, 154, 72, 0.4),
                        textColor: Colors.black,
                      )),
                    ],
                  ),
                  CustomTextField(
                    controller: registrationcontroller.totalAmountController,
                    keyboardType: TextInputType.number,
                    hintText: "Enter Amount",
                    title: "Amount",),
                  CustomTextField(
                    controller: registrationcontroller.discountAmountController,
                    keyboardType: TextInputType.number,
                    hintText: " Enter Discount Amount",
                    title: "Amount",),
                  PaymentOptionsWidget(onChanged: (value) {
                    print(value);
                    registrationcontroller.paymentController.text = value.toString();
                  },),
                  CustomTextField(
                    controller: registrationcontroller.advanceAmountController,
                    keyboardType: TextInputType.number,
                    hintText:"Advance Amount",
                    title: "Advance",),
                  CustomTextField(
                    controller: registrationcontroller.balanceAmountController,
                    keyboardType: TextInputType.number,
                    hintText: "Balance Amount",
                    title: "Balance",),
                  CustomTextField(

                    suffixIcon: Icons.calendar_month,
                    isDatePicker: true,
                    controller: registrationcontroller.dateController, keyboardType: TextInputType.datetime, hintText: "", title: "Treatment Date",),
                    
           DropdownTimePicker (
                selectedValue: registrationcontroller.timeController.text,
                 title: "Treatment Time",
                 hintText: "Start Time",
                 onChanged: (value) {
                      registrationcontroller.timeController.text = value.toString();
                 },
                 
                ),
                  Row(
                    children: [
                      Expanded(child: CustomElevatedButton(text: "Saved", onPressed: () {
                        print("saved");
                        registrationcontroller.register(
                          context
                        );
                      }, textColor: Colors.white,)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}