import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment/modules/payment/cubit/cubit.dart';
import 'package:payment/modules/payment/cubit/state.dart';
import 'package:payment/modules/payment/ref_code_screen.dart';
import 'package:payment/modules/payment/visa_screen.dart';
import 'package:payment/modules/widgets/show_snack.dart';
import 'package:payment/core/components/component_screen.dart';
import 'package:payment/core/network/constant.dart';

import 'wallet_screen.dart';

class ToggleScreen extends StatefulWidget {
  const ToggleScreen({Key? key}) : super(key: key);

  @override
  State<ToggleScreen> createState() => _ToggleScreenState();
}

class _ToggleScreenState extends State<ToggleScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentCubit(),
      child: SafeArea(
        child: BlocConsumer<PaymentCubit, PaymentStates>(
          listener: (context, state) {
            if (state is PaymentRefCodeSuccessStates) {
              showSnackBar(
                context: context,
                text: "Success get ref code ",
                color: Colors.amber.shade400,
              );
              navigateAndFinish(context, const ReferenceScreen());
            }
            if (state is PaymentRefCodeErrorStates) {
              showSnackBar(
                context: context,
                text: "Error get ref code ",
                color: Colors.red,
              );
            }
            if (state is PaymentCardSuccessStates) {
              showSnackBar(
                context: context,
                text: "Success get Card",
                color: Colors.amber.shade400,
              );
              navigateAndFinish(context, const VisaScreen());
            }

            if (state is PaymentWalletSuccessStates) {
              showSnackBar(
                context: context,
                text: "Success get Wallet",
                color: Colors.amber.shade400,
              );
              navigateAndFinish(context, const WalletScreen());
            }
            if (state is PaymentWalletErrorStates) {
              showSnackBar(
                context: context,
                text: "Error get Wallet",
                color: Colors.red,
              );
            }
          },
          builder: (context, state) {
            var cubit = PaymentCubit.get(context);
            return Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          cubit.getRefCode();
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(15.0),
                            border:
                                Border.all(color: Colors.black87, width: 2.0),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                image: NetworkImage(AppImages.refCodeImage),
                              ),
                              SizedBox(height: 15.0),
                              Text(
                                'Payment with Ref code',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          cubit.getCard();
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(color: Colors.black, width: 2.0),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                image: NetworkImage(AppImages.visaImage),
                              ),
                              Text(
                                'Payment with visa',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          cubit.getWallet();
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(15.0),
                            border: Border.all(color: Colors.black, width: 2.0),
                          ),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image(
                                image: NetworkImage(AppImages.walletImage),
                                width: 215,
                                height: 171,
                              ),
                              Text(
                                'Payment with Wallets',
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
