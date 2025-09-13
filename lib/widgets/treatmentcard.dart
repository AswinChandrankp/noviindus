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
        color: Color.fromRGBO(241, 241, 241, 1.0),
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
                          "male",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "$malecount",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "female",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "$femalecount",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
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
              IconButton(onPressed: delete, icon: Icon(Icons.close)),
              IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
            ],
          ),
        ],
      ),
    );
  }
}
