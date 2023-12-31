class ApiContest {
  static const String paymentApiKey = "PAYMENT_API_KEY";
  static const String baseUrl = 'https://accept.paymob.com/api';
  static const String getAuthToken = '/auth/tokens';
  static const getOrderId = '/ecommerce/orders';
  static const getPaymentRequest = '/acceptance/payment_keys';
  static const getRefCode = '/acceptance/payments/pay';

  static const String integrationIdCard = 'ENTER_YOUR_INTEGRATION_ID';
  static const String integrationIdKiosk = 'ENTER_YOUR_INTEGRATION_ID';
  static const String integrationIdwallet = 'ENTER_YOUR_INTEGRATION_ID';

  static String visaUrl =
      '$baseUrl/acceptance/iframes/802024?payment_token=$finalToken';
  static String walletUrl = '';

  static String paymentFirstToken = '';
  static String paymentOrderId = '';
  static String finalToken = '';
  static String refCode = '';

  static String phone = '';
  static String price = '';
  static String firstName = '';
  static String lastName = '';
  static String email = '';
}

class AppImages {
  static const String refCodeImage =
      "https://cdn-icons-png.flaticon.com/128/4090/4090458.png";
  static const String visaImage =
      "https://cdn-icons-png.flaticon.com/128/349/349221.png";
  static const String walletImage =
      "https://www.dlf.pt/dfpng/middlepng/129-1297575_vodafone-cash-logo-png-transparent-png.png";
}
