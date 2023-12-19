import 'package:flutter/material.dart';

class AccountSwitcherOverlay extends StatefulWidget {
  @override
  _AccountSwitcherOverlayState createState() => _AccountSwitcherOverlayState();
}

class _AccountSwitcherOverlayState extends State<AccountSwitcherOverlay> {
  int selectedAccountIndex = 0; // Variable to track the selected account index

  List<String> accounts = [
    'Account 1',
    'Account 2',
    'Account 3',
  ]; // List of accounts

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          // Show overlay to switch accounts
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Switch Account'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(accounts.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAccountIndex =
                              index; // Update the selected account index
                        });
                        Navigator.pop(context); // Close the overlay
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: selectedAccountIndex == index
                              ? Colors.grey[200]
                              : null,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(accounts[index]),
                      ),
                    );
                  }),
                ),
              );
            },
          );
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            Icons.account_circle,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
