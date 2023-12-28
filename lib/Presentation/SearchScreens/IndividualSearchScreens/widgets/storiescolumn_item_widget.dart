import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ying_3_3/Presentation/UserProfileScreens/ClientViewUserProfileScreen/user_profile_client_view_screen.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/core/utils/image_constant.dart';
import 'package:ying_3_3/theme/app_decoration.dart';
import 'dart:math' as math;

class StoriescolumnItemWidget extends StatefulWidget {
  const StoriescolumnItemWidget({Key? key}) : super(key: key);

  @override
  State<StoriescolumnItemWidget> createState() =>
      _StoriescolumnItemWidgetState();
}

class UserModel {
  final String name;

  final String userPhotoUrl;

  UserModel({required this.name, required this.userPhotoUrl});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      userPhotoUrl: map['userImage'] ?? '',
    );
  }
}

class _StoriescolumnItemWidgetState extends State<StoriescolumnItemWidget> {
  late Future<UserModel> randomUserFuture;

  Future<UserModel?> getFirstUser() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    if (querySnapshot.docs.isNotEmpty) {
      return UserModel.fromMap(
          querySnapshot.docs.first.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<UserModel> getRandomUser() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    List<UserModel> users = querySnapshot.docs.map((doc) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }).toList();

    if (users.isEmpty) {
      throw Exception('No users found');
    }

    // Select a random user
    final randomIndex = math.Random().nextInt(users.length);
    return users[randomIndex];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    randomUserFuture = getRandomUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: randomUserFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.hasData && snapshot.data != null) {
          UserModel user = snapshot.data!;

          return Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.h,
              vertical: 15.v,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadiusStyle.roundedBorder16,
              image: DecorationImage(
                image: NetworkImage(user.userPhotoUrl),
                fit: BoxFit.cover,
              ),
            ),
            foregroundDecoration: AppDecoration.gradientBlackToBlack.copyWith(
              borderRadius: BorderRadiusStyle.roundedBorder16,
            ),
            width: 152.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(height: 157.v),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.name ?? 'No Name',
                      style: CustomTextStyles.titleSmallPrimaryContainer,
                    ),
                    Text(
                      'No Date',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          CustomTextStyles.bodySmallPrimaryContainer.copyWith(
                        height: 1.70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }

        return Text('No users found');
      },
    );

/* coverage: ignore-start
//GestureDetector(
      child: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc('uid')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          if (snapshot.hasData && snapshot.data!.data() != null) {
            final data = snapshot.data!.data() as Map<String, dynamic>;
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.h,
                vertical: 15.v,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadiusStyle.roundedBorder16,
                image: DecorationImage(
                  image: AssetImage(
                    ImageConstant.imgStories250x152,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              foregroundDecoration: AppDecoration.gradientBlackToBlack.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder16,
              ),
              width: 152.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 157.v),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'] ?? 'No Name',
                        style: CustomTextStyles.titleLarge23,
                      ),
                      Text(
                        data['createdAt'] ?? 'No Date',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            CustomTextStyles.bodySmallPrimaryContainer.copyWith(
                          height: 1.70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          } else {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.h,
                vertical: 15.v,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadiusStyle.roundedBorder16,
                image: DecorationImage(
                  image: AssetImage(
                    ImageConstant.imgStories250x152,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              foregroundDecoration: AppDecoration.gradientBlackToBlack.copyWith(
                borderRadius: BorderRadiusStyle.roundedBorder16,
              ),
              width: 152.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(height: 157.v),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No Name',
                        style: CustomTextStyles.titleLarge23,
                      ),
                      Text(
                        'No Date',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            CustomTextStyles.bodySmallPrimaryContainer.copyWith(
                          height: 1.70,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        },
      ),
    );

*/
  }
}
