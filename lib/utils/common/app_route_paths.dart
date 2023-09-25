import 'package:flutter/material.dart';
import 'package:singx/screens/access_denied/access_denied.dart' deferred as access_denied;
import 'package:singx/screens/access_denied/network_not_available.dart' deferred as network_not_available;
import 'package:singx/screens/change_password/change_password.dart' deferred as change_password;
import 'package:singx/screens/forget_password/forget_password.dart' deferred as forget_password;
import 'package:singx/screens/forget_password/reset_password_successful.dart' deferred as reset_password_successful;
import 'package:singx/screens/fund_transfer/fund_transfer_landing_screen.dart' deferred as fund_transfer_landing_screen;
import 'package:singx/screens/login/login.dart' deferred as login;
import 'package:singx/screens/register/register_aus_hk/register_home_aus_hk.dart' deferred as register_home_aus_hk;
import 'package:singx/screens/register/register_sg/register_home_screen.dart' deferred as register_home_screen;
import 'package:singx/screens/splash/splash_screen.dart' deferred as splash_screen;
import 'package:singx/utils/common/dummy_data.dart';
import 'package:singx/utils/helper_widget/widget_helper.dart';
import '../../screens/dashboard/dashboard_drawer.dart' deferred as dashboard_drawer;

const String splashRoute = "/splash";
const String homeRoute = "/home";
const String loginRoute = "/login";
const String registerRoute = "/register";

const String forgetPasswordRoute = "/forgetPassword";

const String resetPasswordSuccess = "/resetPassword";

const String dashBoardRoute = "/dashboard";
const String registerMethodRoute = "/registerMethod";

const String registerHongKongHomeScreen = "/register/personalDetails";

const String personalDetailsRoute = "/register/personalDetail";

const String nonDigitalVerificationAustralia =
    "/register/nonDigitalVerification";

const String digitalVerificationAustralia = "/register/digitalVerification";

const String personalDetailsAustraliaRoute = "/register/personalDetails";

const String addressVerifyRoute = "/register/addressVerify";

const String verificationMethodRoute = "/register/verificationMethod";

const String uploadMobileBillRoute = "/register/uploadMobileBill";

const String uploadAddressProofRoute = "/register/uploadAddressProof";

const String callBackSingpass = "/callback/singpass";

const String uploadHKIDProofRoute = "/register/uploadHKIDProof";

const String additionalDetailsRoute = "/register/additionalDetails";

const String additionalDetailsRouteOtp = "/register/additionalDetails/otp";

const String uploadDocumentRoute = "/register/uploadDocument";

const String activitiesRoute = "/activities";

const String manageWalletRoute = "/manageWallet";

const String manageReceiverRoute = "/manageReceiver";

const String manageReceiverNewRoute = "/manageReceiver/addNewReceiver";

const String manageSenderRoute = "/manageSender";

const String manageSenderNewRoute = "/manageSender/addNewSender";

const String mobileTopUpRoute = "/mobileTopUp";

const String selectPlanRoute = "/mobileTopUp/selectPlan";

const String indiaBillPaymentRoute = "/indiaBillPayment";

const String newBillPaymentRoute = "/indiaBillPayment/newBillPayment";

const String bankDetailsRoute = "/bankDetails";

const String rateAlertsRoute = "/rateAlerts";

const String processingTimesRoute = "/processingTimes";

const String termsAndUseRoute = "/termsAndUse";

const String supportRoute = "/support";

const String fundTransferSelectAccountRoute = "/fundTransfer/selectAccount";

const String fundTransferSelectReceiverRoute = "/fundTransfer/selectReceiver";

const String fundTransferReviewRoute = "/fundTransfer/Review";

const String editProfileRoute = "/userProfile";

const String editProfileDataRoute = "/userProfile/editProfile";

const String fundTransferTransferRoute = "/fundTransfer/Transfer";

const String changePassword = "/changepassword";

const String accessDeniedRoute = "/accessDenied";

const String networkNotAvailable = "/networkNotAvailable";

const String jumioSuccessRoute = "/callback/jumio/success";

const String jumioErrorRoute = "/callback/jumio/error";

class MyRouter {
  MyRouter() {}

  static Route<dynamic> onGenerateRoute(RouteSettings routeSettings) {
    String state = "";
    String code = "";
    String transactionReference = "";
    String route = routeSettings.name!
        .replaceAll("/$SingaporeName", "")
        .replaceAll("/$AustraliaName", "")
        .replaceAll("/$HongKongName", "")
        .replaceAll("$SingaporeName", "")
        .replaceAll("$AustraliaName", "")
        .replaceAll("$HongKongName", "");

    if (routeSettings.name!.contains(callBackSingpass) &&
        routeSettings.name!.contains("?")||routeSettings.name!.contains(registerMethodRoute) &&
        routeSettings.name!.contains("?")) {
      final parts = route.split('?');
      route = parts[0];
      state = Uri.parse(routeSettings.name!).queryParameters['state'] ?? "";
      code = Uri.parse(routeSettings.name!).queryParameters['code'] ?? "";
    }

    //Jumio Success scenarios
    if (routeSettings.name!.contains(uploadAddressProofRoute) &&
            routeSettings.name!.contains("?") ||
        routeSettings.name!.contains(jumioSuccessRoute) &&
            routeSettings.name!.contains("?")) {
      final parts = route.split('?');
      route = parts[0];
      transactionReference =
          Uri.parse(routeSettings.name!).queryParameters['accountId'] ?? "";
    }

    //Jumio error scenarios
    if (routeSettings.name!.contains(jumioErrorRoute) &&
        routeSettings.name!.contains("?")) {
      final parts = route.split('?');
      route = parts[0];
    }

    switch (route) {
      case splashRoute:
        late Future _myFuture = splash_screen.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return splash_screen.SplashScreen();
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case loginRoute:
        late Future _myFuture = login.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return login.Login(isUserLogin: false);
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case registerRoute:
        late Future _myFuture = login.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return login.Login(isUserLogin: true);
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case forgetPasswordRoute:
        late Future _myFuture = forget_password.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return forget_password.ForgetPassword();
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case resetPasswordSuccess:
        late Future _myFuture = reset_password_successful.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return reset_password_successful.ResetPasswordSuccessful();
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case dashBoardRoute:
        late Future _myFuture = dashboard_drawer.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return dashboard_drawer.DashboardDrawer(className: "Dashboard");
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case activitiesRoute:
        late Future _myFuture = dashboard_drawer.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return dashboard_drawer.DashboardDrawer(
                    className: "Activities");
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case manageWalletRoute:
        late Future _myFuture = dashboard_drawer.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return dashboard_drawer.DashboardDrawer(
                    className: "Manage wallet");
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case manageReceiverRoute:
        late Future _myFuture = dashboard_drawer.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return dashboard_drawer.DashboardDrawer(
                    className: "Manage receivers", navigateData: false);
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );
      case manageReceiverNewRoute:
        late Future _myFuture = dashboard_drawer.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return dashboard_drawer.DashboardDrawer(
                    className: "Manage receivers", navigateData: true);
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case manageSenderRoute:
        late Future _myFuture = dashboard_drawer.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return dashboard_drawer.DashboardDrawer(
                  className: "Manage senders",
                  navigateData: false,
                );
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case manageSenderNewRoute:
        late Future _myFuture = dashboard_drawer.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return dashboard_drawer.DashboardDrawer(
                  className: "Manage senders",
                  navigateData: true,
                );
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case rateAlertsRoute:
        late Future _myFuture = dashboard_drawer.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return dashboard_drawer.DashboardDrawer(
                    className: "Rate alerts");
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case mobileTopUpRoute:
        late Future _myFuture = dashboard_drawer.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return dashboard_drawer.DashboardDrawer(
                    className: "Mobile top-ups", navigateData: false);
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case selectPlanRoute:
        late Future _myFuture = dashboard_drawer.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return dashboard_drawer.DashboardDrawer(
                    className: "Mobile top-ups", navigateData: true);
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case processingTimesRoute:
        late Future _myFuture = dashboard_drawer.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return dashboard_drawer.DashboardDrawer(
                    className: "Processing times");
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case termsAndUseRoute:
        late Future _myFuture = dashboard_drawer.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return dashboard_drawer.DashboardDrawer(
                    className: "Terms of use");
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case supportRoute:
        late Future _myFuture = dashboard_drawer.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return dashboard_drawer.DashboardDrawer(className: "Support");
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case indiaBillPaymentRoute:
        late Future _myFuture = dashboard_drawer.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return dashboard_drawer.DashboardDrawer(
                  className: "India bill payments",
                  navigateData: true,
                );
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case newBillPaymentRoute:
        late Future _myFuture = dashboard_drawer.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return dashboard_drawer.DashboardDrawer(
                  className: "India bill payments",
                  navigateData: false,
                );
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case bankDetailsRoute:
        late Future _myFuture = dashboard_drawer.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return dashboard_drawer.DashboardDrawer(
                    className: "Bank details");
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case editProfileRoute:
        late Future _myFuture = dashboard_drawer.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return dashboard_drawer.DashboardDrawer(
                    className: "View profile", navigateData: false);
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case editProfileDataRoute:
        late Future _myFuture = dashboard_drawer.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return dashboard_drawer.DashboardDrawer(
                    className: "View profile", navigateData: true);
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case changePassword:
        late Future _myFuture = change_password.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return change_password.ChangePassword();
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case fundTransferSelectAccountRoute:
        late Future _myFuture = fund_transfer_landing_screen.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return fund_transfer_landing_screen.FundTransferLandingScreen(
                  selected: 1,
                );
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case fundTransferSelectReceiverRoute:
        late Future _myFuture = fund_transfer_landing_screen.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return fund_transfer_landing_screen.FundTransferLandingScreen(
                  selected: 2,
                );
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case fundTransferReviewRoute:
        late Future _myFuture = fund_transfer_landing_screen.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return fund_transfer_landing_screen.FundTransferLandingScreen(
                  selected: 3,
                );
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case fundTransferTransferRoute:
        late Future _myFuture = fund_transfer_landing_screen.loadLibrary();

        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return fund_transfer_landing_screen.FundTransferLandingScreen(
                  selected: 4,
                );
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case registerHongKongHomeScreen:
        late Future _myFuture = register_home_aus_hk.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return register_home_aus_hk.RegisterHkAusHomeScreen(
                  selected: 1,
                );
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case uploadHKIDProofRoute:
        late Future _myFuture = register_home_aus_hk.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return register_home_aus_hk.RegisterHkAusHomeScreen(
                  selected: 2,
                );
              } else {
                return someThingWentWrong();
              }
            },
          ),
          settings: routeSettings,
        );

      case additionalDetailsRoute:
        late Future _myFuture = register_home_aus_hk.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return register_home_aus_hk.RegisterHkAusHomeScreen(
                  selected: 3,
                );
              } else {
                return someThingWentWrong();              }
            },
          ),
          settings: routeSettings,
        );

      case additionalDetailsRouteOtp:
        late Future _myFuture = register_home_aus_hk.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return register_home_aus_hk.RegisterHkAusHomeScreen(
                  selected: 3,
                  isOTP: true,
                );
              } else {
                return someThingWentWrong();              }
            },
          ),
          settings: routeSettings,
        );

      case personalDetailsAustraliaRoute:
        late Future _myFuture = register_home_aus_hk.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return register_home_aus_hk.RegisterHkAusHomeScreen(
                  selected: 1,
                );
              } else {
                return someThingWentWrong();              }
            },
          ),
          settings: routeSettings,
        );

      case nonDigitalVerificationAustralia:
        late Future _myFuture = register_home_aus_hk.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return register_home_aus_hk.RegisterHkAusHomeScreen(
                  selected: 2,
                  digitalVerification: false,
                );
              } else {
                return someThingWentWrong();              }
            },
          ),
          settings: routeSettings,
        );

      case digitalVerificationAustralia:
        late Future _myFuture = register_home_aus_hk.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return register_home_aus_hk.RegisterHkAusHomeScreen(
                  selected: 2,
                  digitalVerification: true,
                );
              } else {
                return someThingWentWrong();              }
            },
          ),
          settings: routeSettings,
        );

      case registerMethodRoute:
        late Future _myFuture = register_home_screen.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return register_home_screen.RegisterHomeScreen(
                  selected: 1,
                  state: state,code: code,
                  transactionReference: transactionReference,
                );
              } else {
                return someThingWentWrong();              }
            },
          ),
          settings: routeSettings,
        );

      case personalDetailsRoute:
        late Future _myFuture = register_home_screen.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return register_home_screen.RegisterHomeScreen(
                  selected: 2,
                  state: state,code: code,
                  transactionReference: transactionReference,
                );
              } else {
                return someThingWentWrong();              }
            },
          ),
          settings: routeSettings,
        );

      case addressVerifyRoute:
        late Future _myFuture = register_home_screen.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return register_home_screen.RegisterHomeScreen(
                  selected: 3,
                  state: state,code: code,
                  transactionReference: transactionReference,
                );
              } else {
                return someThingWentWrong();              }
            },
          ),
          settings: routeSettings,
        );

      case verificationMethodRoute:
        late Future _myFuture = register_home_screen.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return register_home_screen.RegisterHomeScreen(
                  selected: 4,
                  state: state,code: code,
                  transactionReference: transactionReference,
                );
              } else {
                return someThingWentWrong();              }
            },
          ),
          settings: routeSettings,
        );

      case uploadMobileBillRoute:
        late Future _myFuture = register_home_screen.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return register_home_screen.RegisterHomeScreen(
                  selected: 5,
                  state: state,code: code,
                  transactionReference: transactionReference,
                );
              } else {
                return someThingWentWrong();              }
            },
          ),
          settings: routeSettings,
        );

      case jumioSuccessRoute:
        late Future _myFuture = register_home_screen.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return register_home_screen.RegisterHomeScreen(
                  selected: 6,
                  state: state,code: code,
                  transactionReference: transactionReference,
                );
              } else {
                return someThingWentWrong();              }
            },
          ),
          settings: routeSettings,
        );

      case jumioErrorRoute:
        late Future _myFuture = register_home_screen.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return register_home_screen.RegisterHomeScreen(
                  selected: 7,
                  state: state,code: code,
                  transactionReference: transactionReference,
                );
              } else {
                return someThingWentWrong();              }
            },
          ),
          settings: routeSettings,
        );
      case callBackSingpass:
        late Future _myFuture = register_home_screen.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return register_home_screen.RegisterHomeScreen(
                  selected: 1,
                  state: state,code: code,
                  transactionReference: transactionReference,
                  //transactionReference: transactionReference,
                );
              } else {
                return someThingWentWrong();              }
            },
          ),
          settings: routeSettings,
        );

      case uploadAddressProofRoute:
        late Future _myFuture = register_home_screen.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return register_home_screen.RegisterHomeScreen(
                  selected: 6,
                  state: state,code: code,
                  transactionReference: transactionReference,
                );
              } else {
                return someThingWentWrong();              }
            },
          ),
          settings: routeSettings,
        );

      case uploadDocumentRoute:
        late Future _myFuture = register_home_screen.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return register_home_screen.RegisterHomeScreen(
                  selected: 7,
                  state: state,code: code,
                  transactionReference: transactionReference,
                );
              } else {
                return someThingWentWrong();              }
            },
          ),
          settings: routeSettings,
        );

      case accessDeniedRoute:
        late Future _myFuture = access_denied.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return access_denied.AccessDenied();
              } else {
                return someThingWentWrong();              }
            },
          ),
          settings: routeSettings,
        );

      case networkNotAvailable:
        late Future _myFuture = network_not_available.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return network_not_available.NetworkNotAvailable();
              } else {
                return someThingWentWrong();              }
            },
          ),
          settings: routeSettings,
        );
      default:
        late Future _myFuture = login.loadLibrary();
        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _myFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return login.Login(isUserLogin: true);
              } else {
                return someThingWentWrong();              }
            },
          ),
          settings: routeSettings,
        );
    }
  }
}
