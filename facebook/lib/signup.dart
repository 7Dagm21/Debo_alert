import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'design_system.dart';

class signupPage extends StatefulWidget {
  @override
  State<signupPage> createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? selectedValue1;
  String? selectedValue2;
  String? selectedValue3;
  String? gender;
  bool _isLoading = false;

  Future<void> _signUp() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Signup failed: ${e.toString()}')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FBColors.white,
      appBar: AppBar(
        backgroundColor: FBColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: FBColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create account',
          style: TextStyle(color: FBColors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'What\'s your name?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: FBColors.black,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _FBTextField(
                    hint: 'First name',
                    controller: _firstNameController,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _FBTextField(
                    hint: 'Last name',
                    controller: _lastNameController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Birthday',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: FBColors.black,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _FBDropDown(
                    hint: 'Month',
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
                    value: selectedValue1,
                    onChanged: (v) => setState(() => selectedValue1 = v),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _FBDropDown(
                    hint: 'Day',
                    items: List.generate(31, (i) => (i + 1).toString()),
                    value: selectedValue2,
                    onChanged: (v) => setState(() => selectedValue2 = v),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _FBDropDown(
                    hint: 'Year',
                    items: List.generate(
                      100,
                      (i) => (DateTime.now().year - i).toString(),
                    ),
                    value: selectedValue3,
                    onChanged: (v) => setState(() => selectedValue3 = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Gender',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: FBColors.black,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Male'),
                    value: 'Male',
                    groupValue: gender,
                    onChanged: (v) => setState(() => gender = v),
                    activeColor: FBColors.blue,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: RadioListTile<String>(
                    title: const Text('Female'),
                    value: 'Female',
                    groupValue: gender,
                    onChanged: (v) => setState(() => gender = v),
                    activeColor: FBColors.blue,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _FBTextField(
              hint: 'Mobile number or email',
              controller: _emailController,
            ),
            const SizedBox(height: 16),
            _FBTextField(
              hint: 'New password',
              obscureText: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: FBColors.blue,
                  foregroundColor: FBColors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
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

class _FBTextField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final TextEditingController? controller;
  const _FBTextField({
    required this.hint,
    this.obscureText = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: FBColors.grey),
        filled: true,
        fillColor: FBColors.offWhite.withOpacity(0.3),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class _FBDropDown extends StatelessWidget {
  final String hint;
  final List<String> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  const _FBDropDown({
    required this.hint,
    required this.items,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: FBColors.offWhite.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(hint, style: const TextStyle(color: FBColors.grey)),
          value: value,
          onChanged: onChanged,
          isExpanded: true,
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
        ),
      ),
    );
  }
}
