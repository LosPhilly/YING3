import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:ying_3_3/core/constants/app_colors.dart';
import 'package:ying_3_3/core/constants/global_methods.dart';
import 'package:ying_3_3/core/utils/size_utils.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/providers/auth_controller.dart';
import 'package:ying_3_3/theme/custom_button_style.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_image_1.dart';
import 'package:ying_3_3/widgets/app_bar/appbar_subtitle_3.dart';
import 'package:ying_3_3/widgets/app_bar/custom_app_bar.dart';
import 'package:ying_3_3/widgets/custom_elevated_button.dart';
import 'package:ying_3_3/widgets/custom_icon_button.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

// CARD DETAILS PAGE FOR THE SETTING TO SEE WHAT CARDS ARE ON FILE

class AddDebitCardScreen extends StatefulWidget {
  const AddDebitCardScreen({Key? key}) : super(key: key);

  @override
  AddDebitCardScreenState createState() => AddDebitCardScreenState();
}

class AddDebitCardScreenState extends State<AddDebitCardScreen>
    with AutomaticKeepAliveClientMixin<AddDebitCardScreen> {
  bool showBankInfo = false;
  bool canAddBankInfo = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  onTapArrowleftone(BuildContext context) {
    Navigator.pop(context);
  }

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
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: mediaQueryData.size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 28.v),
                  Column(
                    children: [
                      showBankInfo == false
                          ? GestureDetector(
                              onTap: () {},
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 16.h),
                                padding: EdgeInsets.all(20.h),
                                decoration: AppDecoration.outlineOnPrimary
                                    .copyWith(
                                        borderRadius:
                                            BorderRadiusStyle.roundedBorder16),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 150,
                                    ),
                                    CreditCardWidget(
                                      cardNumber: cardNumber,
                                      expiryDate: expiryDate,
                                      cardHolderName: cardHolderName,
                                      cvvCode: cvvCode,
                                      bankName: 'YING',
                                      showBackView: isCvvFocused,
                                      obscureCardNumber: true,
                                      obscureCardCvv: true,
                                      isHolderNameVisible: true,
                                      cardBgColor: theme.colorScheme.primary,
                                      isSwipeGestureEnabled: true,
                                      onCreditCardWidgetChange:
                                          (CreditCardBrand creditCardBrand) {},
                                      customCardTypeIcons: <CustomCardTypeIcon>[],
                                    ),
                                    SingleChildScrollView(
                                      child: Column(
                                        children: <Widget>[
                                          CreditCardForm(
                                            formKey: formKey,
                                            obscureCvv: true,
                                            obscureNumber: true,
                                            cardNumber: cardNumber,
                                            cvvCode: cvvCode,
                                            isHolderNameVisible: true,
                                            isCardNumberVisible: true,
                                            isExpiryDateVisible: true,
                                            cardHolderName: cardHolderName,
                                            expiryDate: expiryDate,
                                            themeColor: Colors.blue,
                                            textColor: Colors.black,
                                            cardNumberDecoration:
                                                InputDecoration(
                                              labelText: 'Number',
                                              hintText: 'XXXX XXXX XXXX XXXX',
                                              hintStyle: const TextStyle(
                                                  color: Colors.black),
                                              labelStyle: const TextStyle(
                                                  color: Colors.black),
                                              focusedBorder: border,
                                              enabledBorder: border,
                                            ),
                                            expiryDateDecoration:
                                                InputDecoration(
                                              hintStyle: const TextStyle(
                                                  color: Colors.black),
                                              labelStyle: const TextStyle(
                                                  color: Colors.black),
                                              focusedBorder: border,
                                              enabledBorder: border,
                                              labelText: 'Expired Date',
                                              hintText: 'XX/XX',
                                            ),
                                            cvvCodeDecoration: InputDecoration(
                                              hintStyle: const TextStyle(
                                                  color: Colors.black),
                                              labelStyle: const TextStyle(
                                                  color: Colors.black),
                                              focusedBorder: border,
                                              enabledBorder: border,
                                              labelText: 'CVV',
                                              hintText: 'XXX',
                                            ),
                                            cardHolderDecoration:
                                                InputDecoration(
                                              hintStyle: const TextStyle(
                                                  color: Colors.black),
                                              labelStyle: const TextStyle(
                                                  color: Colors.black),
                                              focusedBorder: border,
                                              enabledBorder: border,
                                              labelText: 'Card Holder',
                                            ),
                                            onCreditCardModelChange:
                                                onCreditCardModelChange,
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                ),
                                                backgroundColor:
                                                    theme.colorScheme.primary
                                                // backgroundColor: const Color(0xff1b447b),
                                                ),
                                            child: Container(
                                              margin: const EdgeInsets.all(12),
                                              child: const Text(
                                                'Save',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'halter',
                                                  fontSize: 14,
                                                  package:
                                                      'flutter_credit_card',
                                                ),
                                              ),
                                            ),
                                            onPressed: () async {
                                              if (formKey.currentState!
                                                  .validate()) {
                                                print('valid!');

                                                await Get.find<AuthController>()
                                                    .storeUserCard(
                                                        cardNumber,
                                                        expiryDate,
                                                        cvvCode,
                                                        cardHolderName);

                                                await Fluttertoast.showToast(
                                                  msg:
                                                      'Card Uploaded Successfully!',
                                                  toastLength:
                                                      Toast.LENGTH_LONG,
                                                  backgroundColor: Colors.green,
                                                  fontSize: 18,
                                                );
                                                Navigator.pop(context);
                                              } else {
                                                print('invalid!');
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(height: 42.v),
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
                          ],
                        ),
                      ),
                      SizedBox(height: 42.v),
                      Opacity(
                        opacity: 0.25,
                        child: CustomImageView(
                            svgPath: ImageConstant.imgSlotmachineamico,
                            height: 226.v,
                            width: 269.h),
                      ),
                      SizedBox(height: 41.v),
                    ],
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.v),
              decoration: AppDecoration.fillPrimary,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomAppBar(
                    height: 26.v,
                    leadingWidth: 52.h,
                    leading: AppbarImage1(
                        svgPath: ImageConstant.imgArrowleftPrimarycontainer,
                        margin: EdgeInsets.only(left: 28.h, bottom: 2.v),
                        onTap: () {
                          onTapArrowleftone(context);
                        }),
                    centerTitle: true,
                    title: AppbarSubtitle3(text: "My Cards"),
                  ),
                  Container(
                    margin:
                        EdgeInsets.symmetric(horizontal: 5.h, vertical: 10.v),
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.h, vertical: 5.v),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadiusStyle.roundedBorder12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 2.v),
                        SizedBox(
                          width: 333.h,
                          child: Text(
                            "We use Stripe to make sure you get paid, and\nto keep your personal and bank details secure.",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: CustomTextStyles.titleSmallPrimaryContainer_1
                                .copyWith(height: 1.70),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Navigates to the myCardsBankAccountAddBankAccountFiveScreen when the action is triggered.
  ///
  /// The [BuildContext] parameter is used to build the navigation stack.
  /// When the action is triggered, this function uses the [Navigator] widget
  /// to push the named route for the myCardsBankAccountAddBankAccountFiveScreen.
  onTapAddbank(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.userState);
  }
}
