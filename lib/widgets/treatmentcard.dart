import 'package:flutter/material.dart';

class TreatmentCard extends StatelessWidget {
  final index;
  final treatmentname;
  final delete;
  final malecount;
  final femalecount;
  TreatmentCard({
    super.key,
    required this.index,
    this.treatmentname,
    this.delete,
    this.malecount,
    this.femalecount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 99,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(217, 217, 217, 0.25),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    " ${index + 1}" + ". " + "$treatmentname",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Male",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 0, 104, 55)
                          ),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )
                          ,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15,top: 0,bottom: 0),
                            child: Center(
                              child: Text(
                                "$malecount",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 0, 104, 55)
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "Female",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 0, 104, 55)
                          ),
                        ), SizedBox(width: 10,),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )
                          ,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15,top: 0,bottom: 0),
                            child: Center(
                              child: Text(
                                "$femalecount",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 0, 104, 55)
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          Column(
            children: [
              Container(
                
                child: IconButton(onPressed: delete, icon: Icon(Icons.close),color: Colors.white ,style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red[100]!),
                  padding:  MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(0)),

                ),)),
              IconButton(onPressed: () {}, icon: Icon(Icons.edit,size: 20,)),
            ],
          ),
        ],
      ),
    );
  }
}
