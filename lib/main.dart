import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SignUpScreen(),
  ));
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isTraveler = true;
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  // Text Controllers for Traveler
  TextEditingController travelerNameController = TextEditingController();
  TextEditingController travelerEmailController = TextEditingController();
  TextEditingController travelerPasswordController = TextEditingController();

  // Text Controllers for Tour Guide
  TextEditingController guideNameController = TextEditingController();
  TextEditingController guideEmailController = TextEditingController();
  TextEditingController guidePasswordController = TextEditingController();
  TextEditingController guideConfirmPasswordController = TextEditingController();
  TextEditingController guidePhoneController = TextEditingController();
  String? validateEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (email.isEmpty) return "Email cannot be empty";
    if (!emailRegex.hasMatch(email)) return "Enter a valid email";
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) return "Password cannot be empty";
    if (password.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  bool validateForm() {
    if (isTraveler) {
      if (travelerNameController.text.isEmpty) {
        showValidationError("Full name is required");
        return false;
      }
      if (validateEmail(travelerEmailController.text) != null) {
        showValidationError(validateEmail(travelerEmailController.text)!);
        return false;
      }
      if (validatePassword(travelerPasswordController.text) != null) {
        showValidationError(validatePassword(travelerPasswordController.text)!);
        return false;
      }
    } else {
      if (guideNameController.text.isEmpty) {
        showValidationError("Full name is required");
        return false;
      }
      if (validateEmail(guideEmailController.text) != null) {
        showValidationError(validateEmail(guideEmailController.text)!);
        return false;
      }
      if (validatePassword(guidePasswordController.text) != null) {
        showValidationError(validatePassword(guidePasswordController.text)!);
        return false;
      }
      if (guidePasswordController.text != guideConfirmPasswordController.text) {
        showValidationError("Passwords do not match");
        return false;
      }
      if (guidePhoneController.text.isEmpty) {
        showValidationError("Phone number is required");
        return false;
      }
    }

    if (!agreeTerms) {
      showValidationError("You must agree to the terms and conditions");
      return false;
    }
    if (!confirmInfo) {
      showValidationError("You must confirm the information is accurate");
      return false;
    }

    return true;
  }

  void showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }

  // Checkbox states
  bool agreeTerms = false;
  bool confirmInfo = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                "Join WanderPlan and Start Your Adventure!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3E50), // Replace with your desired hex color
                ),
              ),




              const SizedBox(height: 10),
              const Text(
                "Create your account to explore Aswan’s treasures and plan the perfect trip",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 20),

              // Traveler & Tour Guide Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isTraveler = true),
                      child: _buildSelectionButton("Traveler", Icons.person, isTraveler),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isTraveler = false),
                      child: _buildSelectionButton("Tour guide", Icons.map, !isTraveler),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              if (isTraveler) ...[
                // Traveler Fields
                Row(
                  children: [
                    Expanded(child: _buildTextField("Full Name", travelerNameController)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildTextField("E-Mail", travelerEmailController)),
                  ],
                ),
                const SizedBox(height: 15),
                _buildPasswordField("Password", travelerPasswordController, true),
                const SizedBox(height: 10),

                // Traveler Checkboxes
                _buildCheckbox("I agree to the terms and conditions", agreeTerms, (value) {
                  setState(() => agreeTerms = value!);
                }),
                _buildCheckbox(
                  "I confirm that the information provided is accurate and valid",
                  confirmInfo,
                      (value) {
                    setState(() => confirmInfo = value!);
                  },
                  wrapText: true,
                ),
              ] else ...[
                // Tour Guide Fields
                Row(
                  children: [
                    Expanded(child: _buildTextField("Full Name", guideNameController)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildTextField("E-Mail", guideEmailController)),
                  ],
                ),
                const SizedBox(height: 15),
                _buildPasswordField("Password", guidePasswordController, true),
                const SizedBox(height: 10),
                _buildPasswordField("Confirm Password", guideConfirmPasswordController, false),
                const SizedBox(height: 15),

                // Contact Number (Now numbers only)
                Row(
                  children: [
                    _buildCountrySelector(),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: guidePhoneController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Restrict to numbers only
                        decoration: InputDecoration(
                          labelText: "Phone Number",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 15),

              // Continue Button
              ElevatedButton.icon(
                onPressed: () {
                  if (validateForm()) {
                    // Proceed with form submission
                  }
                },
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                label: const Text("Continue", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2D3E50),
                  minimumSize: Size(screenWidth, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),


              const SizedBox(height: 10),

              // Google Sign-Up Button for Traveler
              if (isTraveler)
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Image.network(
                    "https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png",
                    width: 24,
                    height: 24,
                  ),
                  label: const Text("Sign Up With Google", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    minimumSize: Size(screenWidth, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),

              const SizedBox(height: 10),

              // Login Link
              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Already have an account? Log In",
                    style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3E50), // Updated color
                    ),
                    ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Button for selecting Traveler or Tour Guide
  Widget _buildSelectionButton(String label, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFF2D3E50) : Colors.grey[200], // Updated color
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: isSelected ? Colors.white : Colors.black),
          const SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }




  // General Text Field Builder
  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Password Field with Visibility Toggle
  Widget _buildPasswordField(String label, TextEditingController controller, bool isMainPassword) {
    return TextField(
      controller: controller,
      obscureText: isMainPassword ? !isPasswordVisible : !isConfirmPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        suffixIcon: IconButton(
          icon: Icon(isMainPassword
              ? (isPasswordVisible ? Icons.visibility : Icons.visibility_off)
              : (isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off)),
          onPressed: () {
            setState(() {
              if (isMainPassword) {
                isPasswordVisible = !isPasswordVisible;
              } else {
                isConfirmPasswordVisible = !isConfirmPasswordVisible;
              }
            });
          },
        ),
      ),
    );
  }

  // Checkbox Builder (with wrapping option)
  Widget _buildCheckbox(String text, bool value, Function(bool?) onChanged, {bool wrapText = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(value: value, onChanged: onChanged),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Color(0xFF2D3E50),fontSize: 14),
            softWrap: wrapText,
          ),
        ),
      ],
    );
  }

  // Country Selector
  Widget _buildCountrySelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(Icons.flag, color: Color(0xFF2D3E50)), // Updated color
          const SizedBox(width: 5),
          const Text("+20", style: TextStyle(fontSize: 16)),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
