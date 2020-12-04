import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jcrm/authorization/service/auth_service.dart';
import 'package:jcrm/general/GeneralUtil.dart';
import 'package:jcrm/mainPage/ui/screen/MainPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Center(
        child: Container(
          // height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.05),
                height: MediaQuery.of(context).size.height * 0.2,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                    Padding(
                      child: Text(
                        "Jysan CRM",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height * 0.04,
                          decorationStyle: TextDecorationStyle.double
                        ),
                      ),
                      padding: EdgeInsets.only(left: 10),
                    )
                  ],
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextField(
                  controller: _username,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(12),
                    FilteringTextInputFormatter.singleLineFormatter,
                  ],
                  // onChanged: (String iinChanged) {},
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    labelText: GeneralUtil.username,
                    prefixText: ' ',
                    suffixStyle: const TextStyle(color: Colors.green),
                  ),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.04,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextField(
                  controller: _password,
                  obscureText: true,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(12),
                    FilteringTextInputFormatter.singleLineFormatter,
                  ],
                  decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.teal)),
                    labelText: GeneralUtil.password,
                    prefixText: ' ',
                    suffixStyle: const TextStyle(color: Colors.green),
                  ),
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.height * 0.04,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                height: MediaQuery.of(context).size.height * 0.1,
                width: MediaQuery.of(context).size.width * 0.6,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                    side: BorderSide(color: Colors.blue),
                  ),
                  color: Colors.deepOrange[500],
                  child: Text(
                    "Войти",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => onClickEnter(context),
                ),
              ),
              // Container(
              //   height: MediaQuery.of(context).size.height * 0.4,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  void onClickEnter(BuildContext context) {
    {
      if (isNotEmpty(_username) && isNotEmpty(_password)) {
        getAccessToken(_username.text, _password.text, context);
      }
    }
  }

  // Navigator
  void navigateToMainPage(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MainPage(title: 'Main Page'),
      ),
      (Route<dynamic> route) => false,
    );
  }

  // EmptyChecker
  bool isNotEmpty(TextEditingController text) {
    if (text != null && text.text != null && text.text.length > 1) {
      return true;
    }
    return false;
  }

  // AccessToken
  void getAccessToken(
      String username, String password, BuildContext context) async {
    AuthService().getToken(username, password).then((res) => {
          if (res != null)
            {
              savePreferences(username, password, res.accessToken),
              navigateToMainPage(context),
            }
          else
            {print('ERROR'), _showMyDialog(context)}
        });
  }

  //SavePreferences
  void savePreferences(
      String username, String password, String accessToken) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      GeneralUtil.username,
      username,
    );
    await preferences.setString(
      GeneralUtil.password,
      password,
    );
    await preferences.setString(
      GeneralUtil.accessToken,
      accessToken,
    );
  }

  //Error Dialog
  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Center(
                  child: Text('Вход невозможен!'),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.pinkAccent,
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
