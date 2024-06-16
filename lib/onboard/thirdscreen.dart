import 'package:flutter/material.dart';

class Thirdscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white, // Set a common background color
        child: Column(
          children: [
            Container(
              //decoration: BoxDecoration(
              // color: Color.fromRGBO(0, 168, 135, 1),
              // borderRadius: const BorderRadius.only(
              //   bottomLeft: Radius.circular(200),
              //   bottomRight: Radius.circular(200),
              width: 320,
              height: 565,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(0, 168, 135, 1),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(200),
                      bottomRight: Radius.circular(200))),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: Image.asset(
                          'assets/images/png/yashmobile.jpeg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Container(
                      width: 295,
                      height: 295,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30.0),
                        child: Image.asset(
                          'assets/images/png/6.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30),
              child: Text(
                "ALL YOU NEED IS HERE",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.black),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, left: 62, right: 50),
              child: Center(
                child: Text(
                  "Dive in! Sign up today and unlock exclusive deals and discounts",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                      color: Colors.black
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
