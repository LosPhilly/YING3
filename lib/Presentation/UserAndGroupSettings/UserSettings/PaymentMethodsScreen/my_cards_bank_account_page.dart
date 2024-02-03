import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/PaymentMethodsScreen/AddDebitCardScreen/add_debit_card_page.dart';
import 'package:ying_3_3/core/constants/app_colors.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/core/utils/size_utils.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/providers/auth_controller.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_icon_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

// CARD DETAILS PAGE FOR THE SETTING TO SEE WHAT CARDS ARE ON FILE

class MyCardsBankAccountPage extends StatefulWidget {
  const MyCardsBankAccountPage({Key? key}) : super(key: key);

  @override
  MyCardsBankAccountPageState createState() => MyCardsBankAccountPageState();
}

class MyCardsBankAccountPageState extends State<MyCardsBankAccountPage>
    with AutomaticKeepAliveClientMixin<MyCardsBankAccountPage> {
  bool showBankInfo = false;
  bool canAddBankInfo = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final authController = Get.find<AuthController>(); // Lazy initialization

  String cardNumber = '5555 55555 5555 4444';
  String expiryDate = '12/25';
  String cardHolderName = 'YING Community';
  String cvvCode = '123';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //AuthController authController = Get.find<AuthController>();

//DELETE USER POST START//
  void _deleteDialog() {
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
      context: context,
      builder: (ctx) {
        return Builder(
          builder: (BuildContext context) {
            return AlertDialog(
              actions: [
                TextButton(
                  onPressed: () async {
                    /* try {
                      if (widget.uploadedBy == _uid) {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.jobId)
                            .delete();
                        await Fluttertoast.showToast(
                          msg: 'Card has been deleted',
                          toastLength: Toast.LENGTH_LONG,
                          backgroundColor: Colors.grey,
                          fontSize: 18,
                        );
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      } else {
                        GlobalMethod.showErrorDialog(
                          error: 'You cannot perform this action',
                          ctx: ctx,
                        );
                      }
                    } catch (error) {
                      if (mounted) {
                        GlobalMethod.showErrorDialog(
                          error: "Task cannot be deleted an error occured.",
                          ctx: ctx,
                        );
                      }
                    } */
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      Text(
                        'Delete',
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  //DELETE USER POST END//

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  @override
  void initState() {
    authController.getUserCards();
    border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: SizedBox(
          width: mediaQueryData.size.width,
          child: Column(
            children: [
              SizedBox(height: 15.v),
              Column(
                children: [
                  showBankInfo == false
                      ? Container(
                          width: size.width * .8,
                          height: size.height * .59,
                          child: Stack(
                            children: <Widget>[
                              Positioned(
                                top: 20,
                                left: 0,
                                right: 0,
                                bottom: 10,
                                child: Obx(() => ListView.builder(
                                      shrinkWrap: true,
                                      itemBuilder: (ctx, i) {
                                        String cardNumber = '';
                                        String expiryDate = '';
                                        String cardHolderName = '';
                                        String cvvCode = '';

                                        try {
                                          cardNumber = authController
                                              .userCards.value[i]
                                              .get('number');
                                        } catch (e) {
                                          cardNumber = '';
                                        }

                                        try {
                                          expiryDate = authController
                                              .userCards.value[i]
                                              .get('expiry');
                                        } catch (e) {
                                          expiryDate = '';
                                        }

                                        try {
                                          cardHolderName = authController
                                              .userCards.value[i]
                                              .get('name');
                                        } catch (e) {
                                          cardHolderName = '';
                                        }

                                        try {
                                          cvvCode = authController
                                              .userCards.value[i]
                                              .get('cvv');
                                        } catch (e) {
                                          cvvCode = '';
                                        }

                                        return CreditCardWidget(
                                          cardBgColor: const Color(0x6236FF),
                                          cardNumber: cardNumber,
                                          expiryDate: expiryDate,
                                          cardHolderName: cardHolderName,
                                          cvvCode: cvvCode,
                                          bankName: '',
                                          showBackView: isCvvFocused,
                                          obscureCardNumber: true,
                                          obscureCardCvv: true,
                                          isHolderNameVisible: true,
                                          isSwipeGestureEnabled: true,
                                          onCreditCardWidgetChange:
                                              (CreditCardBrand
                                                  creditCardBrand) {},
                                        );
                                      },
                                      itemCount:
                                          authController.userCards.length,
                                    )),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(height: 22.v),
                  SizedBox(
                    height: 122.v,
                    width: double.maxFinite,
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 98.v,
                            width: double.maxFinite,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primaryContainer
                                  .withOpacity(1),
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24.h),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 1.v),
                          child: CustomElevatedButton(
                              width: 319.h,
                              text: "Add Debit Card",
                              buttonStyle:
                                  CustomButtonStyles.outlineOnPrimaryTL121,
                              leftIcon: Container(
                                  margin: EdgeInsets.only(right: 8.h),
                                  child: CustomImageView(
                                      svgPath: ImageConstant
                                          .imgOutlineaddPrimarycontainer)),
                              onTap: () {
                                onTapAddbank(context);
                              },
                              alignment: Alignment.topCenter),
                        )
                      ],
                    ),
                  ),
                  /* SizedBox(height: 10.v),
                  Opacity(
                    opacity: 0.25,
                    child: CustomImageView(
                        svgPath: ImageConstant.imgSlotmachineamico,
                        height: 226.v,
                        width: 269.h),
                  ),
                  SizedBox(height: 41.v), */
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Navigates to the myCardsBankAccountAddBankAccountFiveScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the myCardsBankAccountAddBankAccountFiveScreen.
  onTapAddbank(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddDebitCardScreen(),
      ),
    );
  }
}
