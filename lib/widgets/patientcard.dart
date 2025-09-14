import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class PatientCard extends StatelessWidget {
  final int cardnumber;
  final String patientname;
  final String package;
  final VoidCallback? ontap; 
  final String? date; 
  final String? name; 

  const PatientCard({
    super.key,
    required this.cardnumber,
    required this.patientname,
    required this.package,
    this.ontap,
    this.date,
    this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 166,
        decoration: BoxDecoration(
          color: const Color.fromRGBO(241, 241, 241, 1.0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 20),
              child: Row(
                children: [
                  Text(
                    "$cardnumber.",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    patientname,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 33),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 5),
                  Text(
                    "Package: $package",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Color.fromRGBO(0, 104, 55, 1),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Color.fromRGBO(242, 78, 30, 1),
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        date ?? "N/A", // Fallback for null date
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.group,
                        color: Color.fromRGBO(242, 78, 30, 1),
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        name ?? "N/A", // Fallback for null name
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: InkWell(
                onTap: ontap, // Safe, as onTap accepts null
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      "View Booking Details",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(
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