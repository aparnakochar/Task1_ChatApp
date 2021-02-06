import 'package:flash_chat/components/roundedButton.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation; //to create curves of animation
  @override
  void initState() {

    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 3),
      vsync: this,
      //  upperBound: 60, when we use animation we dont need to use upperbound
    );
    // animation = CurvedAnimation(parent: controller,curve: Curves.decelerate); to increase value of animation first fast and then slow
     animation = CurvedAnimation( parent: controller,curve: Curves.easeIn); //first increases slowly then fast
    // controller.reverse(from: 1.0); to reverse the animation
    //animation = ColorTween(begin: Colors.red, end: Colors.blue).animate(controller); //TWEENANIMATION
    controller.forward();

    controller.addListener(() {
      setState(() {});
    });
  }
@override
  void dispose() {

    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/icon3.png'),
                    //    height: animation.value * 60, //to increase the size of logo by applyng animation
                    height: 120,
                  ),
                ),
                SizedBox(
                  width:20,
                ),
              TyperAnimatedTextKit(
                  text: ['ChitChat'],
                  textStyle: TextStyle(
                    fontSize: 40.0,
                    // color: Colors.blueAccent,
                    color: Color(0xff93B7FF),
                    // fontWeight: FontWeight.bold,
                    fontFamily: 'Pacifico',
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(color: Color(0xff93B7FF), onPressed: () {
            //Go to login screen.
            Navigator.pushNamed(context, 'login_screen');
          },title: 'LogIn',),
           RoundedButton(color: Color(0xff93B7FF), onPressed: () {
            //Go to login screen.
            Navigator.pushNamed(context, 'registration_screen');
          },title: 'Sign-Up',), 
          ],
        ),
      ),
    );
  }
}

/*
tumne clonned mein hi kaam kiya hai kya?hn sabash good thnkuu  waah g  waah errror fix kardi aapne to apnekri h mene  to kuch nhi kiya keval
vs code restart bsss  bhyi mehnat toh mehnat h  ptani isme kya mehnat hui chlo chl gya mian vo h ok madam ye bhi theek haihnji
tum standards kyu follow nhi kar rhi knse standard routing ke or bhi alag jgh par  ek vo id krke btaya tha?  ha mjhe vo acha ni lga mjhe ye vala chiz easy ar suttle lgti h
ye kya baat hui smjh liya h implement toh mrzi hti h ruko fir ek min call pick karo
*/

