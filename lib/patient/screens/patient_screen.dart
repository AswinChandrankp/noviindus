
import 'package:flutter/material.dart';
import 'package:noviindus/patient/provider/patient_provider.dart';
import 'package:noviindus/patient/screens/patient_listview.dart';
import 'package:noviindus/registration/screens/registration_screen.dart';
import 'package:noviindus/widgets/customButton.dart';
import 'package:provider/provider.dart';

// class PatientScreen extends StatefulWidget {
//   const PatientScreen({super.key});

//   @override
//   State<PatientScreen> createState() => _PatientScreenState();
// }

// class _PatientScreenState extends State<PatientScreen> {
//   @override


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: PatientListView(), 

//         floatingActionButton: CustomElevatedButton(
//         text: "Register Now",
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => Registerscreen()),
//           );
//           //.then((value) => Provider.of<RegistrationController>(context, listen: false).onRegister());
          
          
//         },
//         padding: EdgeInsets.only(
//             left: MediaQuery.of(context).size.width * 0.25,
//             right: MediaQuery.of(context).size.width * 0.25,
//             bottom: MediaQuery.of(context).size.height * 0.02,
//             top: MediaQuery.of(context).size.height * 0.02),
//             fontWeight: FontWeight.w600,
//             fontsize: 17,
//             borderRadius: 8.52,

            

            
//       ),
//       // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,,
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//     );
//   }
// }
class PatientScreen extends StatefulWidget {
  const PatientScreen({super.key});

  @override
  State<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends State<PatientScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _sortValue = 'Date';
  final List<String> _sortOptions = ['Date', 'Name', 'Status'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
        
          },
        ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          children: [
  
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Search for treatments",
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey[500],
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 104, 55),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Search",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onPressed: () {
                 
                      print("Search pressed: ${_searchController.text}");
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

          
            Align(
              alignment: Alignment.centerLeft,
              child: Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Sort by :",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Spacer(),
                  Container(
                    height: 40,
                    width: 160,
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(33),
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _sortValue,
                        isDense: true,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                        dropdownColor: Colors.white,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey[600],
                          size: 18,
                        ),
                        items: _sortOptions.map((option) {
                          return DropdownMenuItem(
                            value: option,
                            child: Text(
                              option,
                              style: TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _sortValue = value!;
                          });
                          
                          print("Sort by: $value");
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Expanded(child: PatientListView()), 
          ],
        ),
      ),
      floatingActionButton: CustomElevatedButton(
        text: "Register Now",
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Registerscreen()),
          );
        },
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.25,
          right: MediaQuery.of(context).size.width * 0.25,
          bottom: MediaQuery.of(context).size.height * 0.02,
          top: MediaQuery.of(context).size.height * 0.02,
        ),
        fontWeight: FontWeight.w600,
        fontsize: 17,
        borderRadius: 8.52,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}