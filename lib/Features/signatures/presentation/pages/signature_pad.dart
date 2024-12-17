import 'package:flutter/material.dart';
import 'package:signature/signature.dart';

import '../../../../../Core/utils/colors.dart';

class SignaturePad extends StatefulWidget {
  const SignaturePad({super.key});

  @override
  State<SignaturePad> createState() => _SignaturePadState();
}

class _SignaturePadState extends State<SignaturePad> {
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  @override
  void dispose() {
    signatureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: ColorManager.whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Signature(
                  controller: signatureController,
                  backgroundColor: ColorManager.whiteColor,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  signatureController.clear();
                  setState(() {});
                },
                icon: const Icon(
                  Icons.clear,
                  color: ColorManager.primaryColor,
                  size: 35,
                ),
              ),
              IconButton(
                onPressed: () async {
                  if (signatureController.isNotEmpty) {
                    var data = await signatureController.toPngBytes();
                    if (data != null) {
                      Navigator.pop(context, data); // Return signature data
                    }
                  }
                },
                icon: const Icon(
                  Icons.check,
                  color: ColorManager.primaryColor,
                  size: 35,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
