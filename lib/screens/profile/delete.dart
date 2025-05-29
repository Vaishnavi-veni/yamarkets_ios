import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yamarkets_ios/screens/home/home_screen.dart';
import 'package:http/http.dart'as http;
import 'package:yamarkets_ios/screens/register.dart';

import '../../utils/localization_utils.dart';
import '../../view/url.dart';

class AccountDeletionPage extends StatefulWidget {
    final String languageCode;

      const AccountDeletionPage({super.key, required this.languageCode});


  @override
  _AccountDeletionPageState createState() => _AccountDeletionPageState();
}

class _AccountDeletionPageState extends State<AccountDeletionPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isOtherSelected = false;
  final ValueNotifier<bool> isButtonEnabled = ValueNotifier(false);
  final storage=const FlutterSecureStorage();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _updateButtonState() {
    if (_formKey.currentState != null) {
      final reason = _formKey.currentState?.fields['reason']?.value;
      final otherReason = _formKey.currentState?.fields['otherReason']?.value;

      if (reason == 'Other') {
        isButtonEnabled.value = otherReason?.isNotEmpty ?? false;
      } else {
        isButtonEnabled.value = reason != null;
      }
    }
  }

  Future<void> _deleteAccount(String reason) async {
    print("Reason: $reason");
    String? accessToken = await storage.read(key: 'access_token');
    String? userId = await storage.read(key: 'uid');
    print("Access token for delete:$accessToken");
    print("User Id for delete:$userId");
    final url = Uri.parse('${MyConstants.baseUrl}/course_api/delete_account');
    final response = await http.post(
      url,
      headers: {
        'Authorization': '$accessToken', // Include the access token here
      },
      body: {'user_id': userId, 'reason_for_delete': reason},
    );
    print('Status code for deletion: ${response.statusCode}');
    if (response.statusCode == 200) {
      // Handle successful deletion
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(Localization.translate('delete') ?? 'Delete Account',),
            content: Text(
              Localization.translate('deletion_success') ?? 'Your account is deleted successfully.',
              style: TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage(languageCode: widget.languageCode,)),
                  );
                },
                child: Text(Localization.translate('ok') ?? 'OK',),
              ),
            ],
          );
        },
      );
    } else {
      // Handle deletion error
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(
              "There was an error deleting your account. Please try again.",
              style: TextStyle(color: Colors.red),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Localization.translate('delete') ?? 'Delete Account',),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          onChanged: _updateButtonState,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                Localization.translate('reason') ?? 'Please let us know why you are deleting your account:',
                style: TextStyle(fontSize: 16),
              ),
              FormBuilderRadioGroup<String>(
                name: 'reason',
                options: [
                  FormBuilderFieldOption(
                    value: 'Privacy concerns',
                    child: Text(
                      Localization.translate('reason1') ?? 'Privacy concerns',
                    ),
                  ),
                  FormBuilderFieldOption(
                    value: 'Switching to another service',
                    child: Text(
                      Localization.translate('reason2') ?? 'Switching to another service',
                    ),
                  ),
                  FormBuilderFieldOption(
                    value: 'Not satisfied with the service',
                    child: Text(
                      Localization.translate('reason3') ?? 'Not satisfied with the service',

                    ),
                  ),
                  FormBuilderFieldOption(
                    value: 'Other',
                    child: Text(
                      Localization.translate('other_reasons') ?? 'Other reasons (Please specify your reason)',
                    ),
                  ),
                ],
                wrapAlignment: WrapAlignment.start,
                onChanged: (value) {
                  setState(() {
                    isOtherSelected = value == 'Other';
                    _updateButtonState();
                  });
                },
              ),
              if (isOtherSelected)
                FormBuilderTextField(
                  name: 'otherReason',
                  decoration: InputDecoration(
                    labelText: 'Please specify',
                  ),
                  onChanged: (value) {
                    _updateButtonState();
                  },
                ),
              SizedBox(height: 20),
              Center(
                child: ValueListenableBuilder<bool>(
                  valueListenable: isButtonEnabled,
                  builder: (context, value, child) {
                    return ElevatedButton(
                      onPressed: value
                          ? () async {
                        if (_formKey.currentState?.saveAndValidate() ??
                            false) {
                          final formData =
                              _formKey.currentState?.value;
                          print(formData);
                          // Add your deletion logic here
                          final reason = formData!['reason'] == 'Other'
                              ? formData['otherReason']
                              : formData['reason'];
                          await _deleteAccount(reason);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Delete Account"),
                                content: Text(
                                  "Your account is deleted successfully.",
                                  style: TextStyle(color: Colors.green),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Register()),
                                      );
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          print('Validation failed');
                        }
                      }
                          : null,
                      child: Text('Submit',
                          style: TextStyle(color: Colors.black)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.withOpacity(0.7),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
