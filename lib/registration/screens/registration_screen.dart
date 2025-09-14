
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
   
        return Scaffold(
          backgroundColor:    Colors.white,
          appBar: AppBar(
              backgroundColor: Colors.white,
            scrolledUnderElevation: 0,
            elevation: 0,
             actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_outlined, 
                          color: Colors.black, 
                          size: 28),
                onPressed: () {},
              ),
              Positioned(
                right: 13,
                top: 13,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
            bottom: PreferredSize(
              preferredSize: Size(MediaQuery.of(context).size.width, 30),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25, bottom: 10),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Register",
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
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: registrationcontroller.phoneController,
                    keyboardType: TextInputType.number,
                    hintText: " Enter Your Whatsapp Number",
                    title: "Whatsapp Number",
                     hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    )
                  ),
                    SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: registrationcontroller.detailsController,
                    keyboardType: TextInputType.streetAddress,
                    hintText: "Enter Your full address",
                    title: "Address",
                     hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    )
                  ),
                    SizedBox(
                    height: 10,
                  ),
                  CustomDropdown(
                    selectedValue: registrationcontroller.selectedadress,
                    items: registrationcontroller.alladress, 
                    hintText: "Choose Your Location", 
                    title: "Location",
                     hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    onChanged: (value) {
                      print('Selected value: $value');

                      registrationcontroller.setAddress(value!);
                    },

                  ),
               
         SizedBox(
                    height: 10,
                  ),
                       BranchesDropdown(
                        selectedValue: registrationcontroller.selectedBranch,
                        items: registrationcontroller.branches , 
                        hintText: "Choose Branch",
                         hintStyle: TextStyle(
                      fontSize: 14,
                      
                      fontWeight: FontWeight.normal,
                    ),
                        title: "Branch",
                        onChanged: (Branches ) {
                          print('Selected value: ${Branches!.name}');
                          registrationcontroller.setBranch(Branches!);
                          
                        },
                      ),
                  SizedBox(
                    height: 10,
                  ),
                      ListView.separated(
                        itemCount: registrationcontroller.addTreatment.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final treatment = registrationcontroller.addTreatment[index];
                          
                          return TreatmentCard(
                            treatmentname: treatment['name'],
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
                        text: "+ Add Treatment",
                        fontWeight: FontWeight.w500,
                        fontsize: 16,
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
                    hintText: " Enter Total Amount",
                       hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    title: "Total Amount",),
                     SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: registrationcontroller.discountAmountController,
                    keyboardType: TextInputType.number,
                    hintText: " Enter Discount Amount",

                       hintStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),

                    title: "Discount Amount",),
                     SizedBox(
                    height: 10,
                  ),
                  PaymentOptionsWidget(onChanged: (value) {
                    print(value);
                    registrationcontroller.paymentController.text = value.toString();
                    
                  },),
                   SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: registrationcontroller.advanceAmountController,
                    keyboardType: TextInputType.number,
                    hintText:" Enter Advance Amount",
                    title: "Advance Amount",),
                      SizedBox(
                    height: 10,
                  ),
                  CustomTextField(
                    controller: registrationcontroller.balanceAmountController,
                    keyboardType: TextInputType.number,
                    hintText: " Enter Balance Amount",
                    title: "Balance Amount",),
                      SizedBox(
                    height: 10,
                  ),
                  CustomTextField(

                    suffixIcon: Icons.calendar_month,
                    isDatePicker: true,
                    controller: registrationcontroller.dateController, keyboardType: TextInputType.datetime, hintText: "", title: "Treatment Date",),
                      SizedBox(
                    height: 10,
                  ),
           DropdownTimePicker (
                selectedValue: registrationcontroller.timeController.text,
                 title: "Treatment Time",
                 hintText: "Start Time",
                 onChanged: (value) {
                      registrationcontroller.timeController.text = value.toString();
                 },
                 
                ),
                SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(child: CustomElevatedButton(
                        padding: const EdgeInsets.all(15),
                        borderRadius:9,
                        // fontsize: ,
                        fontWeight: FontWeight.bold,
                        fontsize: 18,
                        text: "Save", onPressed: () {
                        print("save");
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