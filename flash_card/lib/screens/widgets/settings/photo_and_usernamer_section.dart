import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoAndUsernamerSection extends StatefulWidget {
  const PhotoAndUsernamerSection({super.key});

  @override
  State<PhotoAndUsernamerSection> createState() =>
      _PhotoAndUsernamerSectionState();
}

class _PhotoAndUsernamerSectionState extends State<PhotoAndUsernamerSection> {
  TextEditingController usernameController = TextEditingController();
  String? username;
  String? previousUsername;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //Get the username from shared preferences

      String? fetchedUsername = await getUsername();
      if (fetchedUsername != null) {
        debugPrint("Fetched username: $fetchedUsername");
        setState(() {
          username = fetchedUsername;
        });
        usernameController.text = username!;
      }
      debugPrint("Username: $username");
    });
  }

  //Method to get the username from shared preferences
  Future<String?> getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString('username');
  }

  ///Method to get the text style based on the current theme
  TextStyle? getTextStyle(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark
        ? TextTheme.of(context).headlineSmall?.copyWith(color: Colors.white)
        : TextTheme.of(context).headlineSmall?.copyWith(color: Colors.black);
  }

  //Method to set the username if it exists
  void setPreviosUsername() async {
    final previosUserName = await getUsername();
    if (previosUserName != null) {
      setState(() {
        username = previosUserName;
        debugPrint("Previous username: $previosUserName");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      "Photo and user section: SIZE: ${MediaQuery.of(context).size.height * 0.25}",
    );

    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.25,
      color: Colors.blue.withValues(
        alpha: 0.5,
      ), //Theme.of(context).colorScheme.primary,
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //User photo
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 60.0,
                backgroundImage: AssetImage('assets/images/dawn2.jpg'),
              ),
              //icon to edit the photo
              Positioned(
                bottom: 10,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    //show dialog to edit the photo
                    debugPrint("Edit photo");
                  },
                  child: Icon(
                    Icons.photo_camera,
                    color: IconTheme.of(context).color,
                    size: 25.0,
                  ),
                ),
              ),
            ],
          ),

          //Spacing
          const SizedBox(height: 10.0),

          //Username
          Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Username text
              Text(
                username ?? 'Username',
                style: TextTheme.of(context).bodySmall?.copyWith(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              //Spacing
              const SizedBox(width: 5.0),
              //Icon pen to edit the username
              GestureDetector(
                onTap: () async {
                  //show dialog to edit the username

                  previousUsername = username;

                  final bool? result = await showDialog<bool>(
                    context: context,
                    barrierDismissible: true,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Edit Username',
                          style: getTextStyle(
                            context,
                          )?.copyWith(fontSize: 20.0),
                        ),
                        content: TextField(
                          controller: usernameController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          textCapitalization: TextCapitalization.words,
                          style:
                              Theme.of(context).brightness == Brightness.dark
                                  ? const TextStyle(
                                    color: Colors.white,
                                  ) // Text color for dark mode
                                  : const TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            //hintText: 'Enter new username',
                            hintStyle: getTextStyle(
                              context,
                            )?.copyWith(fontSize: 16.0),
                            //helperText: 'Username must be unique',
                            //helper: Icon(Icons.info, color: Colors.blue),
                            //floatingLabelStyle: getTextStyle(context),
                            label: Text(
                              'Enter new username',
                              style: getTextStyle(
                                context,
                              )?.copyWith(fontSize: 16.0),
                            ),
                          ),
                          onChanged: (value) {
                            // Handle text change
                            debugPrint("Username: $value");
                            if (value.isNotEmpty) {
                              setState(() {
                                username = value;
                              });
                            }
                          },
                          onTapOutside: (_) async {
                            debugPrint("Username onTapOutside:");
                            setPreviosUsername();
                          },
                          /* */
                          onSubmitted: (value) async {
                            // Handle text submission

                            debugPrint("Username onSubmitted: $value");

                            /* if (username == value) {
                              debugPrint("Both values are same: $value");
                              //Save the username
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('username', value);
                              debugPrint("Username saved: $value");
                            } */
                          },
                        ),
                        actions: [
                          //Cancel button
                          TextButton(
                            onPressed: () {
                              // Handle cancel action
                              Navigator.of(context).pop(false);
                            },
                            child: Text('Cancel'),
                          ),

                          //Save button
                          TextButton(
                            onPressed: () async {
                              // Handle save action
                              if (username != null) {
                                //Save the username
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.setString('username', username!);
                                debugPrint("Username saved: $username");
                              }
                              Navigator.of(context).pop(true);
                            },
                            child: Text('Save'),
                          ),
                        ],
                      );
                    },
                  );

                  //Run this if the user tap outside the Dialog or canceled the dialog
                  debugPrint("Dialog result: $result");
                  if (result != true) {
                    // Or null
                    debugPrint(
                      "User has canceled the dialog orxs tapped outside the dialog",
                    );
                    debugPrint(
                      "Dialog dismissed without saving. Resetting username.",
                    );
                    setPreviosUsername(); // Reset to the previous username
                  }
                },
                child: Icon(
                  Icons.edit,
                  color: IconTheme.of(context).color,
                  size: 25.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
