import 'package:flutter/material.dart';
import 'package:ying_3_3/core/app_export.dart';
import 'package:ying_3_3/widgets/custom_image_view.dart';

class CustomBottomAppBar extends StatefulWidget {
  CustomBottomAppBar({this.onChanged});

  Function(BottomBarEnum)? onChanged;

  @override
  CustomBottomAppBarState createState() => CustomBottomAppBarState();
}

class CustomBottomAppBarState extends State<CustomBottomAppBar> {
  List<BottomMenuModel> bottomMenuList = [
    BottomMenuModel(
        icon: ImageConstant.imgOutlinehome,
        activeIcon: ImageConstant.imgOutlinehome,
        type: BottomBarEnum.Outlinehome,
        isSelected: true),
    BottomMenuModel(
      icon: ImageConstant.imgDuetonesearch,
      activeIcon: ImageConstant.imgDuetonesearch,
      type: BottomBarEnum.Duetonesearch,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgOutlineaddPrimarycontainer,
      activeIcon: ImageConstant.imgOutlineaddPrimarycontainer,
      type: BottomBarEnum.Outlineaddprimarycontainer,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgOutlinebellBlueGray200,
      activeIcon: ImageConstant.imgOutlinebellBlueGray200,
      type: BottomBarEnum.Outlinebellbluegray200,
    ),
    BottomMenuModel(
      icon: ImageConstant.imgOutlineuserBlueGray200,
      activeIcon: ImageConstant.imgOutlineuserBlueGray200,
      type: BottomBarEnum.Outlineuserbluegray200,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: SizedBox(
        height: 98.v,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            bottomMenuList.length,
            (index) {
              return InkWell(
                onTap: () {
                  for (var element in bottomMenuList) {
                    element.isSelected = false;
                  }
                  bottomMenuList[index].isSelected = true;
                  widget.onChanged?.call(bottomMenuList[index].type);
                  setState(() {});
                },
                child: bottomMenuList[index].isSelected
                    ? Container(
                        padding: EdgeInsets.all(12.h),
                        decoration: AppDecoration.outlineOnPrimary1.copyWith(
                          borderRadius: BorderRadiusStyle.circleBorder26,
                        ),
                        child: CustomImageView(
                          svgPath: bottomMenuList[index].activeIcon,
                          height: 24.adaptSize,
                          width: 24.adaptSize,
                          color:
                              theme.colorScheme.primaryContainer.withOpacity(1),
                          margin: EdgeInsets.symmetric(vertical: 12.v),
                        ),
                      )
                    : CustomImageView(
                        svgPath: bottomMenuList[index].icon,
                        height: 24.adaptSize,
                        width: 24.adaptSize,
                        color: appTheme.blueGray200,
                      ),
              );
            },
          ),
        ),
      ),
    );
  }
}

enum BottomBarEnum {
  Outlinehome,
  Duetonesearch,
  Outlineaddprimarycontainer,
  Outlinebellbluegray200,
  Outlineuserbluegray200,
}

class BottomMenuModel {
  BottomMenuModel({
    required this.icon,
    required this.activeIcon,
    required this.type,
    this.isSelected = false,
  });

  String icon;

  String activeIcon;

  BottomBarEnum type;

  bool isSelected;
}

class DefaultWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please replace the respective Widget here',
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
