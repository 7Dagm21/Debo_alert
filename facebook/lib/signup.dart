import 'package:flutter/material.dart';
import 'login_page.dart';

class signupPage extends StatefulWidget {
  @override
  State<signupPage> createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {
  String? selectedValue1;
  String? selectedValue2;
  String? selectedValue3;
  String? gender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 221, 214, 214),
      body: Center(
        child: Column(
          children: [
            Text(
              'facebook',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            Container(
              height: 500,
              width: 400,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text(
                    'Create New Account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'It\'s quick and easy.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),

                  SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'First Name',
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 177, 173, 173),
                              ),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 8),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Last Name',
                              hintStyle: TextStyle(
                                color: const Color.fromARGB(255, 177, 173, 173),
                              ),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // Birthday
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '   Birthday',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: _CustomDropDown(
                          items: [
                            'Jan',
                            'Feb',
                            'Mar',
                            'Apr',
                            'May',
                            'Jun',
                            'Jul',
                            'Aug',
                            'Sep',
                            'Oct',
                            'Nov',
                            'Dec',
                          ],
                          hint: 'Month',
                          value: selectedValue1,
                          onChanged: (val) =>
                              setState(() => selectedValue1 = val),
                        ),
                      ),

                      SizedBox(width: 4),

                      Expanded(
                        child: _CustomDropDown(
                          items: List.generate(
                            31,
                            (index) => (index + 1).toString(),
                          ),
                          hint: 'Day',
                          value: selectedValue2,
                          onChanged: (val) =>
                              setState(() => selectedValue2 = val),
                        ),
                      ),

                      SizedBox(width: 4),

                      Expanded(
                        child: _CustomDropDown(
                          items: List.generate(
                            100,
                            (index) => (DateTime.now().year - index).toString(),
                          ),
                          hint: 'Year',
                          value: selectedValue3,
                          onChanged: (val) =>
                              setState(() => selectedValue3 = val),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // gender
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '   Gender',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Male'),
                          value: 'Male',
                          groupValue: gender,
                          onChanged: (val) => setState(() => gender = val),
                        ),
                      ),

                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Female'),
                          value: 'Female',
                          groupValue: gender,
                          onChanged: (val) => setState(() => gender = val),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  Padding(
                    padding: EdgeInsets.only(left: 4.0, right: 4.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Mobile number or email address',
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 177, 173, 173),
                        ),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  Padding(
                    padding: EdgeInsets.only(left: 4.0, right: 4.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'New password',
                        hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 177, 173, 173),
                        ),
                        border: OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(150, 40),
                    ),
                    onPressed: () {},
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),

                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => loginPage()),
                      );
                    },
                    child: Text(
                      'Already have an account?',
                      style: TextStyle(fontSize: 14, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomDropDown extends StatelessWidget {
  final List<String> items;
  final String hint;
  final String? value;
  final ValueChanged<String?> onChanged;

  const _CustomDropDown({
    required this.items,
    required this.hint,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
      ),
      hint: Text(hint),
      value: value,
      onChanged: onChanged,
      items: items.map((item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      dropdownColor: Colors.white,
      menuMaxHeight: 5 * 48.0, // Limit height to show max 5 items
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }
}
