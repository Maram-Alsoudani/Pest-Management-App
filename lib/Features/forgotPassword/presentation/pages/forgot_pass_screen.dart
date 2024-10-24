import 'package:flutter/material.dart';
import 'package:pesticides/Core/utils/colors.dart';
import 'package:pesticides/Core/utils/strings.dart';

class ForgotPassScreen extends StatelessWidget {
  const ForgotPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              StringManager.forgotPass,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: ColorManager.whiteColor, fontSize: 30),
            ),
            SizedBox(
              height: 15,
            ),
            Text(StringManager.enterEmailForResetPass,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: ColorManager.greyShade2, fontSize: 15)),
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                cursorColor: ColorManager.greyShade6,
                decoration: InputDecoration(
                    hintText: StringManager.email,
                    filled: true,
                    fillColor: ColorManager.whiteColor,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            BorderSide(color: ColorManager.primaryColor))),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStatePropertyAll(ColorManager.primaryColor),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)))),
              onPressed: () {},
              child: Text(StringManager.send,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(color: ColorManager.whiteColor, fontSize: 17)),
            ),
            Spacer(),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("${StringManager.already_have_an_account} Login",
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: ColorManager.whiteColor,
                        )))
          ],
        ),
      ),
    );
  }
}
