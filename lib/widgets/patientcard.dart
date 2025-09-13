import 'package:flutter/material.dart';

class PatientCard extends StatelessWidget {
  final cardnumber;
  final patientname;
  final package;
  final ontap;
  const PatientCard(
      {super.key, this.cardnumber, this.patientname, this.package, this.ontap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
      child: Container(
        height: 166,
        decoration: BoxDecoration(
          color: Color.fromRGBO(241, 241, 241, 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 20),
              child: Row(
                children: [
                  Text(
                    "${cardnumber}.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(width: 10),
                  Text("${patientname}",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 33),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    "Package: ${package}",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(0, 104, 55, 1)),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month,
                        color: Color.fromRGBO(242, 78, 30, 1),
                        size: 15,
                      ),
                      Text("Date: "),
                      Icon(
                        Icons.group,
                        color: Color.fromRGBO(242, 78, 30, 1),
                        size: 15,
                      ),
                      Text("name"),
                    ],
                  )
                ],
              ),
            ),

            Divider(),
            Expanded(
              child: InkWell(
                onTap: ontap,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "View Details",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Colors.black),
                    ),
                    SizedBox(width: 10),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Color.fromRGBO(0, 104, 55, 1),
                      size: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
