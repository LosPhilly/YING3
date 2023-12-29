import 'package:flutter/material.dart';
import 'package:ying_3_3/Presentation/LoginPage/login_one_screen.dart';
import 'package:ying_3_3/Presentation/GigFeedScreens/IndividualGigFeedScreen/gig_feed_1_feed_screen.dart';
import 'package:ying_3_3/Presentation/MainMenuScreens/IndividualMainMenuScreen/individual_main_menu_one_screen.dart';

import 'package:ying_3_3/Presentation/ForgotPasswordPage/forgot_password_screen.dart';

import 'package:ying_3_3/Presentation/PostTaskScreens/IndividualPostTaskScreen/individual_post_a_taks_1_screen.dart';
import 'package:ying_3_3/Presentation/PostTaskScreens/IndividualPostTaskScreen/individual_post_a_taks_1_screen_2.dart';
import 'package:ying_3_3/Presentation/PostTaskScreens/IndividualPostTaskScreen/post_a_task_one_screen.dart';
import 'package:ying_3_3/Presentation/PostTaskScreens/IndividualPostTaskScreen/post_a_task_two_screen.dart';

//import 'package:ying_3_3/Presentation/GigFeedScreens/TaskDetails/task_details_screen.dart';

import 'package:ying_3_3/Presentation/OpenScreen/welcome_main_screen.dart';
import 'package:ying_3_3/Presentation/SignUpPage/register_individual_one_screen.dart';
import 'package:ying_3_3/Presentation/SignUpPage/setup_g_account_one_screen.dart';
import 'package:ying_3_3/Presentation/SignUpPage/VerifyScreen/setup_g_account_verify_email_screen.dart';
import 'package:ying_3_3/Presentation/SignUpPage/VerifyScreen/register_individual_verify_email_screen.dart';
import 'package:ying_3_3/Presentation/SignUpPage/SetUpGroupScreens/GroupSetUpSkillsOffering/setup_g_account_offering_screen.dart';
import 'package:ying_3_3/Presentation/SignUpPage/SetUpGroupScreens/GroupSetUpSkillsAvaiable/setup_g_account_skills_screen.dart';
import 'package:ying_3_3/Presentation/SignUpPage/SetUpGroupScreens/GroupSetUpProfilePicture/setup_g_account_g_upload_profile_pic_screen.dart';
import 'package:ying_3_3/Presentation/SignUpPage/SetUpGroupScreens/GroupCodeScreen/setup_g_account_group_code_screen.dart';
import 'package:ying_3_3/Presentation/SignUpPage/SetUpIndividualScreens/InterestScreen/register_setup_individual_account_interest_screen.dart';
import 'package:ying_3_3/Presentation/SignUpPage/SetUpIndividualScreens/SkillsScreen/register_setup_individual_account_skills_screen.dart';
import 'package:ying_3_3/Presentation/SignUpPage/SetUpIndividualScreens/AvailabilityScreen/register_setup_individual_account_availability_screen.dart';
import 'package:ying_3_3/Presentation/SignUpPage/SetUpIndividualScreens/UploadProfilePictureScreen/register_setup_individual_account_upload_profile_picture_screen.dart';
import 'package:ying_3_3/user_state.dart';

// Search Pages

import 'package:ying_3_3/Presentation/SearchScreens/IndividualSearchScreens/search_container_screen.dart';
import 'package:ying_3_3/Presentation/SearchScreens/IndividualSearchScreens/search_page.dart';

// Search Pages End

// User Account Settings Start

//import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/MainUserSettingsScreen/user_profile_settings_main_screen.dart';
//import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/PersonalDataScreen/user_profile_settings_data_screen.dart';

// Account Settings
//import 'package:ying_3_3/Presentation/UserAndGroupSettings/UserSettings/AccountSettingsScreen/account_settings_screen.dart';

// User Account Settings End

class AppRoutes {
  static const String forgotPasswordScreen = '/forgot_password_screen';
  static const String loginOneScreen = '/login_one_screen';
  static const String gigFeedOneScreen = '/gig_feed_1_feed_screen';
  static const String userState = '/user_state';

  /// USER ACCOUNT SETTINGS ///
  /*
  static const String userProfileSettingsDataScreen =
      '/user_profile_settings_data_screen';
  static const String userProfileSettingsMainScreen =
      '/user_profile_settings_main_screen';

static const String accountSettingsScreen = '/account_settings_screen';
*/
  /// USER ACCOUNT SETTINGS END ///

  /// REGISTER INDIVIDUAL ///
  static const String registerIndividualOneScreen =
      '/register_individual_one_screen';
  static const String registerIndividualVerifyEmailScreen =
      '/register_individual_verify_email_screen';
  static const String registerIndividualInterestScreen =
      '/register_setup_individual_account_interest_screen';
  static const String registerIndividualSkillsScreen =
      '/register_setup_individual_account_skills_screen';
  static const String registerIndividualAvailabilityScreen =
      '/register_setup_individual_account_availability_screen';
  static const String registerIndividualUploadPictureScreen =
      '/register_setup_individual_account_upload_profile_picture_screen';

  /// REGISTER INDIVIDUAL END ///

  /// REGISTER GROUP START ////

  static const String setupGAccountVerifyEmailScreen =
      '/setup_g_account_verify_email_screen';

  static const String setupGAccountOfferingScreen =
      '/setup_g_account_offering_screen';

  static const String setupGAccountSkillsScreen =
      '/setup_g_account_skills_screen';

  static const String setupGAccountUploadProfilePictureScreen =
      '/setup_g_account_g_upload_profile_pic_screen';

  static const String setupGAccountGroupCodeScreen =
      '/setup_g_account_group_code_screen';

  /// REGISTER GROUP END ///

  static const String setupGAccountOneScreen = '/setup_g_account_one_screen';
  static const String welcomeMainScreen = '/welcome_main_screen';

  //USER AND GROUP MENU//
  static const String individualMainMenuScreen =
      '/individual_main_menu_one_screen';

  //USER AND GROUP MENU END//

// INDIVIDUAL POST TASK SCREEN START//

  static const String individualPostTask1Screen =
      '/individual_post_a_taks_1_screen';
  static const String individualPostTask1Screen2 =
      '/individual_post_a_taks_1_screen_2';
  static const String postATaskOneScreen = '/post_a_task_one_screen';
  static const String postATaskTwoScreen = '/post_a_task_two_screen';

// INDIVUDUAL POST TASK SCREEN END //

// TASK DETAILS START //
  //static const String taskDetailsScreen = '/task_details_screen';

// TASK DETAILS END //

// USER PROFILE USER VIEW START //
  static const String userProfileUserView = '/user_profile_user_view_screen';
  static const String clientUserProfileView =
      '/user_profile_client_view_screen';

// USER PROFILE USER VIEW END//

// Search Pages
  static const String searchPage = '/search_container_screen';
  static const String searchPageContainer = '/search_page';

// Search Pages End

  /////////////  ROUTES MAP  START //////////////////
  static Map<String, WidgetBuilder> routes = {
    userState: (context) => const UserState(),
    forgotPasswordScreen: (context) => const ForgetPassword(),
    loginOneScreen: (context) => const LoginOneScreen(),
    gigFeedOneScreen: (context) => const GigFeed1FeedScreen(),
    setupGAccountOneScreen: (context) => const SetupGAccountOneScreen(),
    welcomeMainScreen: (context) => const WelcomeMainScreen(),
    individualMainMenuScreen: (context) => const IndividualMainMenuOneScreen(),

    /// User Account Settings
    /*
    userProfileSettingsDataScreen: (context) =>
        const UserProfileSettingsDataScreen(userId:,),
    userProfileSettingsMainScreen: (context) =>
        const UserProfileSettingsMainScreen(),

accountSettingsScreen:(context) => const AccountSettingsScreen(),
*/
    /// User Account Settings End

// Register Individual Start Map
    registerIndividualVerifyEmailScreen: (context) =>
        const RegisterIndividualVerifyEmailScreen(),
    registerIndividualOneScreen: (context) =>
        const RegisterIndividualOneScreen(),
    registerIndividualInterestScreen: (context) =>
        const RegisterSetupIndividualAccountInterestScreen(),
    registerIndividualSkillsScreen: (context) =>
        const RegisterSetupIndividualAccountSkillsScreen(),
    registerIndividualAvailabilityScreen: (context) =>
        const RegisterSetupIndividualAccountAvailabilityScreen(),
    registerIndividualUploadPictureScreen: (context) =>
        const RegisterSetupIndividualAccountUploadProfilePictureScreen(),

    // Register Individual End Map

    //User and Group Menu Start Map//
    setupGAccountVerifyEmailScreen: (context) =>
        const SetupGAccountVerifyEmailScreen(),

    setupGAccountOfferingScreen: (context) =>
        const SetupGAccountOfferingScreen(),

    setupGAccountSkillsScreen: (context) =>
        const SetupGAccountSkillsListScreen(),

    setupGAccountUploadProfilePictureScreen: (context) =>
        const SetupGAccountGUploadProfilePicScreen(),

    setupGAccountGroupCodeScreen: (context) =>
        const SetupGAccountGroupCodeScreen(),

    //User and Group Menu End Map//

// Individual Post Task Screen Start//
    individualPostTask1Screen: (context) => const IndividualPostATask1Screen(),
    individualPostTask1Screen2: (context) =>
        const IndividualPostATask1Screen_2(),
    postATaskOneScreen: (context) => const PostATaskOneScreen(),
    postATaskTwoScreen: (context) => const PostATaskTwoScreen(),
    // Individual Post Task Screen End //

// Search Page Start
    searchPage: (context) => const SearchPage(),
    searchPageContainer: (context) => SearchContainerScreen(),
// Search Page End

    /////////////  ROUTES MAP  END //////////////////
  };
}
