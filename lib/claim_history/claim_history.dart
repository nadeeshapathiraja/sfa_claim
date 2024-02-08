import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:sfa_claim/components/custom_button.dart';
import 'package:sfa_claim/components/custom_text.dart';

import '../claim_request/claim_request_screen.dart';

class ClaimHistory extends StatefulWidget {
  const ClaimHistory({super.key});

  @override
  State<ClaimHistory> createState() => _ClaimHistoryState();
}

class _ClaimHistoryState extends State<ClaimHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomText(
              text: 'Claim History',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            CustomButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ClaimRequest(),
                    ),
                  );
                },
                text: "text"),
            Container(
              width: context.width(),
              height: context.height() / 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: const Color(0xffffccff),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.deepPurple,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
