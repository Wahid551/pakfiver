import 'package:flutter/material.dart';

class payment_summary extends StatefulWidget {
  const payment_summary({Key? key}) : super(key: key);

  @override
  _payment_summaryState createState() => _payment_summaryState();
}

class _payment_summaryState extends State<payment_summary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color.fromARGB(2000, 34, 116, 135),
        elevation: 8.0,
        title: Text(
          "Payment Summary",
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Card(
              color: Colors.grey.shade200,
              child: ListTile(
                leading: Text('Payment Send To:',style: TextStyle(fontWeight: FontWeight.bold),),
                title: Text('Shahzaib Khan'),
                subtitle: Text('8000Rs'),

              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Card(
              color: Colors.grey.shade200,
              child: ListTile(
                leading: Text('Payment Received from:',style: TextStyle(fontWeight: FontWeight.bold),),
                title: Text('Wahid Ali'),
                subtitle: Text('600Rs'),

              ),
            ),
          ),
        ],
      ),
    );
  }
}
