import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:payment/models/authentication_request_model.dart';
import 'package:payment/models/order_registration_model.dart';
import 'package:payment/models/payment_reqeust_model.dart';
import 'package:payment/modules/payment/cubit/state.dart';
import 'package:payment/core/network/dio.dart';

import '../../../core/network/constant.dart';

class PaymentCubit extends Cubit<PaymentStates> {
  PaymentCubit() : super(PaymentInitialStates());
  static PaymentCubit get(context) => BlocProvider.of(context);
  AuthenticationRequestModel? authTokenModel;
  Future<void> getAuthToken() async {
    emit(PaymentAuthLoadingStates());
    DioHelperPayment.postData(url: ApiContest.getAuthToken, data: {
      'api_key': ApiContest.paymentApiKey,
    }).then((value) {
      authTokenModel = AuthenticationRequestModel.fromJson(value.data);
      ApiContest.paymentFirstToken = authTokenModel!.token;
      print('The token 🍅 ${ApiContest.paymentFirstToken}');
      emit(PaymentAuthSuccessStates());
    }).catchError((error) {
      print('Error in auth token 🤦‍♂️ $error');
      emit(
        PaymentAuthErrorStates(error.toString()),
      );
    });
  }

  Future getOrderRegistrationID({
    required String price,
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
  }) async {
    emit(PaymentOrderIdLoadingStates());
    DioHelperPayment.postData(url: ApiContest.getOrderId, data: {
      'auth_token': ApiContest.paymentFirstToken,
      "delivery_needed": "false",
      "amount_cents": price,
      "currency": "EGP",
      "items": [],
    }).then((value) {
      OrderRegistrationModel orderRegistrationModel =
          OrderRegistrationModel.fromJson(value.data);
      ApiContest.paymentOrderId = orderRegistrationModel.id.toString();
      // getPaymentRequest(price, firstName, lastName, email, phone,ApiContest.integrationIdCard);
      ApiContest.phone = phone;
      ApiContest.price = price;
      ApiContest.firstName = firstName;
      ApiContest.lastName = lastName;
      ApiContest.email = email;
      print('The order id 🍅 =${ApiContest.paymentOrderId}');
      emit(PaymentOrderIdSuccessStates());
    }).catchError((error) {
      print('Error in order id 🤦‍♂️');
      emit(
        PaymentOrderIdErrorStates(error.toString()),
      );
    });
  }

  // for final request token

  Future<void> getPaymentRequest(
    String priceOrder,
    String firstName,
    String lastName,
    String email,
    String phone,
    String integrationId,
  ) async {
    emit(PaymentRequestTokenLoadingStates());
    DioHelperPayment.postData(
      url: ApiContest.getPaymentRequest,
      data: {
        "auth_token": ApiContest.paymentFirstToken,
        "amount_cents": priceOrder,
        "expiration": 3600,
        "order_id": ApiContest.paymentOrderId,
        "billing_data": {
          "apartment": "NA",
          "email": email,
          "floor": "NA",
          "first_name": firstName,
          "street": "NA",
          "building": "NA",
          "phone_number": phone,
          "shipping_method": "NA",
          "postal_code": "NA",
          "city": "NA",
          "country": "NA",
          "last_name": lastName,
          "state": "NA"
        },
        "currency": "EGP",
        "integration_id": integrationId,
        "lock_order_when_paid": "false"
      },
    ).then((value) {
      PaymentRequestModel paymentRequestModel =
          PaymentRequestModel.fromJson(value.data);
      ApiContest.finalToken = paymentRequestModel.token;
      print('Final token 🚀 ${ApiContest.finalToken}');
      emit(PaymentRequestTokenSuccessStates());
    }).catchError((error) {
      print('Error in final token 🤦‍♂️');
      emit(
        PaymentRequestTokenErrorStates(error.toString()),
      );
    });
  }

  Future getRefCode() async {
    DioHelperPayment.postData(
      url: ApiContest.getRefCode,
      data: {
        "source": {
          "identifier": "AGGREGATOR",
          "subtype": "AGGREGATOR",
        },
        "payment_token": ApiContest.finalToken,
      },
    ).then((value) {
      ApiContest.refCode = value.data['id'].toString();
      print('The ref code 🍅${ApiContest.refCode}');
      emit(PaymentRefCodeSuccessStates());
    }).catchError((error) {
      print("Error in ref code 🤦‍♂️");
      emit(PaymentRefCodeErrorStates(error.toString()));
    });
  }

  Future getCard() async {
    await getPaymentRequest(
        ApiContest.price,
        ApiContest.firstName,
        ApiContest.lastName,
        ApiContest.email,
        ApiContest.phone,
        ApiContest.integrationIdCard);
    emit(PaymentCardSuccessStates());
  }

  Future getWallet() async {
    await getPaymentRequest(
        ApiContest.price,
        ApiContest.firstName,
        ApiContest.lastName,
        ApiContest.email,
        ApiContest.phone,
        ApiContest.integrationIdwallet);

    DioHelperPayment.postData(
      url: "https://accept.paymob.com/api/acceptance/payments/pay",
      data: {
        "source": {
          "identifier": ApiContest.phone,
          "subtype": "WALLET",
        },
        "payment_token": ApiContest.finalToken,
      },
    ).then((value) {
      ApiContest.walletUrl = value.data['redirect_url'].toString();
      emit(PaymentWalletSuccessStates());
    }).catchError((error) {
      print("Error in Wallet Url 🤦‍♂️$error");
      emit(PaymentWalletErrorStates(error.toString()));
    });
  }
}
