import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ying_3_3/Presentation/SearchScreens/IndividualSearchScreens/widgets/blogpost_item_widget.dart';
import 'package:ying_3_3/Presentation/SearchScreens/IndividualSearchScreens/widgets/storiescolumn_item_widget.dart';
import 'package:ying_3_3/core/constants/global_variables.dart';
import 'package:ying_3_3/core/utils/image_constant.dart';
import 'package:ying_3_3/core/utils/size_utils.dart';
import 'package:ying_3_3/theme/app_decoration.dart';
import 'package:ying_3_3/theme/custom_text_style.dart';
import 'package:ying_3_3/theme/theme_helper.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';
import 'package:ying_3_3/widgets/custom_outlined_button.dart';
import 'package:ying_3_3/widgets/custom_search_view.dart';

import 'package:flutter/material.dart';
import 'package:ying_3_3/widgets/job_widget.dart';

import '../../../core/constants/color_map.dart';
import 'package:flutter/src/widgets/gesture_detector.dart'
    as flutter_gesture_detector;
import 'package:ying_3_3/Presentation/SearchScreens/IndividualSearchScreens/widgets/storiescolumn_item_widget.dart'
    as storiescolumn_item_widget;

// ignore_for_file: must_be_immutable
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late MediaQueryData mediaQueryData;
  late FocusNode _focusNode;
  TextEditingController searchController = TextEditingController();
  String? jobCategoryFilter;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: flutter_gesture_detector.GestureDetector(
        onTap: () {
          // Remove focus when tapping outside of text fields
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SizedBox(
          width: mediaQueryData.size.width,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(top: 3.v),
            child: Padding(
              padding: EdgeInsets.only(left: 28.h, bottom: 28.v),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomSearchView(
                    margin: EdgeInsets.only(right: 28.h),
                    controller: searchController,
                    autofocus: false,
                    hintText: "Search by name, skill or category",
                    hintStyle: const TextStyle(color: Colors.black),
                    focusNode: _focusNode,
                    prefix: Container(
                      margin: EdgeInsets.fromLTRB(16.h, 10.v, 8.h, 10.v),
                      child: CustomImageView(svgPath: ImageConstant.imgSearch),
                    ),
                    prefixConstraints: BoxConstraints(maxHeight: 40.v),
                    suffix: Padding(
                      padding: EdgeInsets.only(right: 15.h),
                      child: IconButton(
                        onPressed: () {
                          searchController.clear();
                        },
                        icon: Icon(Icons.clear, color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                  SizedBox(height: 29.v),
                  Text("New members", style: theme.textTheme.titleLarge),
                  SizedBox(height: 22.v),
                  SizedBox(
                    height: 250.v,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return SizedBox(width: 15.h);
                      },
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return storiescolumn_item_widget
                            .StoriescolumnItemWidget();
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 44.v, right: 28.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(top: 6.v),
                            child: Text("For you",
                                style: theme.textTheme.titleLarge)),
                        CustomOutlinedButton(
                            height: 34.v,
                            width: 118.h,
                            text: "All Categories",
                            margin: EdgeInsets.only(bottom: 2.v),
                            buttonTextStyle: CustomTextStyles.labelLargePrimary)
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 550.v,
                    child: Stack(
                      children: [
                        StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream: jobCategoryFilter == null
                              ? FirebaseFirestore.instance
                                  .collection('tasks')
                                  .where('recruitment', isEqualTo: true)
                                  .orderBy('createAt', descending: true)
                                  .snapshots()
                              : FirebaseFirestore.instance
                                  .collection('tasks')
                                  .where('taskCategory',
                                      isEqualTo: jobCategoryFilter)
                                  .where('recruitment', isEqualTo: true)
                                  .orderBy('createAt', descending: true)
                                  .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.active) {
                              if (snapshot.hasData &&
                                  snapshot.data!.docs.isNotEmpty) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 1.v),
                                    const Divider(thickness: 2),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          Color backgroundColor =
                                              categoryColors[snapshot
                                                          .data!.docs[index]
                                                          .data()[
                                                      'taskCategory']] ??
                                                  Colors.grey;
                                          return JobWidget(
                                            jobTitle: snapshot.data!.docs[index]
                                                ['taskTitle'],
                                            jobDescription: snapshot
                                                .data!.docs[index]
                                                .data()['taskDescription'],
                                            jobId: snapshot.data!.docs[index]
                                                .data()['taskId'],
                                            uploadedBy: snapshot
                                                .data!.docs[index]
                                                .data()['uploadedBy'],
                                            userImage: snapshot
                                                .data!.docs[index]
                                                .data()['userImage'],
                                            name: snapshot.data!.docs[index]
                                                .data()['userName'],
                                            recruitment: snapshot
                                                .data!.docs[index]
                                                .data()['recruitment'],
                                            jobCategory: snapshot
                                                .data!.docs[index]
                                                .data()['taskCategory'],
                                            email: snapshot.data!.docs[index]
                                                .data()['email'],
                                            location: snapshot.data!.docs[index]
                                                .data()['location'],
                                            backgroundColor: backgroundColor,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              } else {
                                return const Center(
                                  child: Text('There are no gigs available'),
                                );
                              }
                            }
                            return const Center(
                              child: Text(
                                'Something went wrong',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
