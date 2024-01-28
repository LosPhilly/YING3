import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ying_3_3/Presentation/UserProfileScreens/ClientViewUserProfileScreen/user_profile_client_view_screen.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/core/utils/image_constant.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';
import 'package:ying_3_3/widgets/custom_search_view.dart';

class CategorySelector extends StatefulWidget {
  @override
  _CategorySelectorState createState() => _CategorySelectorState();
}

class _CategorySelectorState extends State<CategorySelector> {
  int selectedIndex = 0;
  final List<String> categories = ['Messages', 'Online', 'Groups', 'Requests'];
  TextEditingController searchController = TextEditingController();
  String? jobCategoryFilter;
  bool isShowUsers = false;
  Future<QuerySnapshot>? searchResultFuture;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void executeSearch() {
    setState(() {
      isShowUsers = true;
      searchResultFuture = FirebaseFirestore.instance
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: searchController.text)
          .get();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Remove focus when tapping outside of text fields
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        height: 90.0,
        color: Theme.of(context).primaryColor,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (BuildContext context, int index) {
            return Row(
              children: [
                SizedBox(
                  height: 25,
                ),
                CustomSearchView(
                  margin: EdgeInsets.only(right: 28.h),
                  controller: searchController,
                  autofocus: false,
                  hintText: "Search by name, skill or category",
                  hintStyle: const TextStyle(color: Colors.black),
                  prefix: Container(
                    margin: EdgeInsets.fromLTRB(16.h, 10.v, 8.h, 10.v),
                    child: CustomImageView(svgPath: ImageConstant.imgSearch),
                  ),
                  prefixConstraints: BoxConstraints(maxHeight: 40.v),
                  onFieldSubmitted: (String value) {
                    executeSearch();
                  },
                  suffix: Padding(
                    padding: EdgeInsets.only(right: 15.h),
                    child: IconButton(
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          isShowUsers = false; // Reset the flag to hide users
                          searchResultFuture =
                              null; // Reset the future to clear results
                        });
                      },
                      icon: Icon(Icons.clear, color: Colors.grey.shade600),
                    ),
                  ),
                ),
                isShowUsers && searchResultFuture != null
                    ? FutureBuilder<QuerySnapshot>(
                        future: searchResultFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }
                          if (snapshot.hasData &&
                              snapshot.data!.docs.isNotEmpty) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (context, index) {
                                var userData = snapshot.data!.docs[index];
                                var userPhotoUrl = userData['userImage'] ??
                                    'https://st.depositphotos.com/2218212/3092/i/600/depositphotos_30920521-stock-photo-facebook-profiles.jpg';
                                var userName = userData['name'] ?? 'No Name';
                                var userId = userData['id'];

                                return InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        showDragHandle: true,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(20),
                                                topRight: Radius.circular(20))),
                                        context: context,
                                        builder: (BuildContext context) {
                                          return UserProfileClientViewScreen(
                                              userId: userId);
                                        },
                                      );
                                    },
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(userPhotoUrl),
                                      ),
                                      title: Text(userName),
                                      onTap: () {
                                        showModalBottomSheet(
                                          isScrollControlled: true,
                                          showDragHandle: true,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight:
                                                      Radius.circular(20))),
                                          context: context,
                                          builder: (BuildContext context) {
                                            return UserProfileClientViewScreen(
                                                userId: userId);
                                          },
                                        );
                                      },
                                    ));
                              },
                            );
                          } else {
                            return const Text('No users found');
                          }
                        },
                      )
                    : SizedBox(height: 29.v),
              ],
            );

            /* GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 30.0,
                ),
                child: Text(
                  categories[index],
                  style: TextStyle(
                    color: index == selectedIndex ? Colors.white : Colors.white60,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ); */
          },
        ),
      ),
    );
  }
}
