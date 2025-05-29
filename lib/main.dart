import 'package:flutter/material.dart';

void main() => runApp(BMIApp());

class BMIApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xFFD6ECF3), // pastel blue background
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFB8DCE8), // slightly darker pastel blue
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFF2F4F4F), // dark  blue-grey
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFE4D0F4), // soft lavender
            foregroundColor: Color(0xFF4B0082), // dark lavender (text and icon color)
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: Color(0xFF4A4A6A)), // muted grey-blue
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFDCCEF9)), // light lavender
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFDCCEF9)), // light lavender
          ),
          border: OutlineInputBorder(),
        ),
      ),

      initialRoute: '/',
      routes: { // the screens of this app
        '/': (context) => NameScreen(),
        '/input': (context) => InputScreen(),
        '/result': (context) => ResultScreen(),
      },
    );        
  }
}

class NameScreen extends StatefulWidget { // the first screen where we input the name of the user
  @override
  _NameScreenState createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  final _controller = TextEditingController(); //when the user presses continue the text edigting controller handles it and reads it

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('BMI calculator app')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column( //organize in the middle
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller, //the name
              style: TextStyle(fontSize: 20), // make the input text bigger
              decoration: InputDecoration(labelText: 'Enter your name',  labelStyle: TextStyle(fontSize: 20), // Change label text size
              ),
            ),
            SizedBox(height: 30),//to put space between field and button
            ElevatedButton(
                onPressed: () {
                  final name = _controller.text.trim(); //the name variable
                  if (name.isNotEmpty) {
                    Navigator.pushNamed(context, '/input', arguments: name);//after we write the name i take this name and then go to the next screen
                  } // /input is the 2nd screen
                },
                child: Text('Continue')//the text on the continue button,
            ),
          ],
        ),
      ),
    );
  }
}

class InputScreen extends StatefulWidget {
  @override
  _InputScreenState createState() => _InputScreenState(); //vreating an object instance input screen state
}

class _InputScreenState extends State<InputScreen> { // i need to main variables in thsi step which are the weight and height
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final name = ModalRoute.of(context)!.settings.arguments as String; //catching the name after we pass it in the last screen using the build context in the build fun

    return Scaffold(
      appBar: AppBar(title: Text('Hello, $name')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField( //text field i wait for input from the user
              controller: _weightController,
              keyboardType: TextInputType.number,
              style: TextStyle(fontSize: 20), // make the input text bigger
              decoration: InputDecoration(labelText: 'Weight (kg)',labelStyle: TextStyle(fontSize: 20), // Change label text size
              ),
            ),
            TextField(
              controller: _heightController,
              keyboardType: TextInputType.number, //itll show a keyboard with numbers ONLY
              decoration: InputDecoration(labelText: 'Height (cm)',labelStyle: TextStyle(fontSize: 20), // Change label text size
              ),//input deco label inside text field
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final weight = double.tryParse(_weightController.text);
                final heightCm = double.tryParse(_heightController.text);
                if (weight != null && heightCm != null) {
                  final heightM = heightCm / 100; //transforming cm to m so i can calculate bmi
                  final bmi = weight / (heightM * heightM);
                  Navigator.pushNamed(
                    context, '/result',
                    arguments: {'name': name, 'bmi': bmi}, //when going to the result screen ill take the name with me and the bmi
                  );
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget { //as soon as i do a stateless screen i use the build function
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final name = args['name'] as String;
    final bmi = args['bmi'] as double;

    String category;
    String imageAsset;

    if (bmi < 16) {
      category = 'Severe thinness';
      imageAsset = 'assets/severe.png';
    } else if (bmi < 17) {
      category = 'Moderate thinness';
      imageAsset = 'assets/moderate.png';
    } else if (bmi < 18.5) {
      category = 'Mild thinness';
      imageAsset = 'assets/mild.png';
    } else if (bmi < 25) {
      category = 'Normal';
      imageAsset = 'assets/normal.png';
    } else if (bmi < 30) {
      category = 'Overweight';
      imageAsset = 'assets/overweight.png';
    } else if (bmi < 35) {
      category = 'Obese Class I';
      imageAsset = 'assets/obese1.png';
    } else if (bmi < 40) {
      category = 'Obese Class II';
      imageAsset = 'assets/obese2.png';
    } else {
      category = 'Obese Class III';
      imageAsset = 'assets/obese3.png';
    }

    return Scaffold(
      appBar: AppBar(title: Text('Your BMI Result')),
      body: Center(
        child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text( //this is just a text label cuz its a stateless widget unlike the textfield of stateful
              '$name, your BMI is ${bmi.toStringAsFixed(1)}', //format to one decimal place
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 10),
            Text(
              category,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Image.asset(imageAsset, height: 150),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, ModalRoute.withName('/'));
              }, // popuntil keeps popping the screen stack until i reach the screen i specify in the bracket
              child: Text('Restart'),
            ),
          ],
        ),
      ),
    )
    );
  }
}
