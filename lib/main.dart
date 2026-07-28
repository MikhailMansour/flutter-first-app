import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

void
main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    const MyApp(),
  );
}

class UserData {
  String name;
  String email;
  UserData({
    required this.name,
    required this.email,
  });
}

class MyApp
    extends
        StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(
          0xFFF8F9FA,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/':
            (
              context,
            ) => const RegistrationScreen(),
        '/dashboard':
            (
              context,
            ) => const DashboardScreen(),
      },
    );
  }
}

class AppColors {
  static const Color darkBlue = Color(
    0xFF0D47A1,
  );
  static const Color accentPink = Colors.pinkAccent;
  static const Color lightBlue = Color(
    0xFF1976D2,
  );
}

// --- 1. شاشة التسجيل (مع إظهار/إخفاء الباسورد) ---
class RegistrationScreen
    extends
        StatefulWidget {
  const RegistrationScreen({
    super.key,
  });

  @override
  State<
    RegistrationScreen
  >
  createState() => _RegistrationScreenState();
}

class _RegistrationScreenState
    extends
        State<
          RegistrationScreen
        > {
  final _formKey =
      GlobalKey<
        FormState
      >();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _obscurePass = true; // للتحكم في الإخفاء والإظهار

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.darkBlue,
        elevation: 0,
        toolbarHeight: 35,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(
          25,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // الدايف الصغير والمطور
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 15,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.darkBlue,
                      AppColors.lightBlue,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                child: const Column(
                  children: [
                    Icon(
                      Icons.app_registration,
                      size: 40,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Register Now",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Enter your details below",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 35,
              ),
              _buildField(
                _nameController,
                "Full Name",
                Icons.person,
                (
                  v,
                ) => v!.isEmpty
                    ? "Required"
                    : null,
              ),
              _buildField(
                _emailController,
                "Email",
                Icons.email,
                (
                  v,
                ) =>
                    !v!.contains(
                      '@',
                    )
                    ? "Invalid Email"
                    : null,
              ),

              // حقل كلمة المرور مع العين
              _buildPasswordField(
                _passController,
                "Password",
              ),

              // حقل تأكيد كلمة المرور
              _buildPasswordField(
                _confirmPassController,
                "Confirm Password",
                isConfirm: true,
              ),

              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkBlue,
                  minimumSize: const Size(
                    double.infinity,
                    50,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    Navigator.pushNamed(
                      context,
                      '/dashboard',
                      arguments: UserData(
                        name: _nameController.text,
                        email: _emailController.text,
                      ),
                    );
                  }
                },
                child: const Text(
                  "Get Started",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 35.0,
        color: AppColors.darkBlue,
      ),
    );
  }

  Widget _buildField(
    TextEditingController ctrl,
    String hint,
    IconData icon,
    String? Function(
      String?,
    )?
    val,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 15,
      ),
      child: TextFormField(
        controller: ctrl,
        validator: val,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: Icon(
            icon,
            color: AppColors.accentPink,
            size: 20,
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
    TextEditingController ctrl,
    String hint, {
    bool isConfirm = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 15,
      ),
      child: TextFormField(
        controller: ctrl,
        obscureText: _obscurePass,
        validator:
            (
              v,
            ) {
              if (isConfirm &&
                  v !=
                      _passController.text) {
                return "Not matching";
              }
              return v!.length <
                      6
                  ? "Min 6 chars"
                  : null;
            },
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(
            Icons.lock,
            color: AppColors.accentPink,
            size: 20,
          ),
          // زر العين للإظهار والإخفاء
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePass
                  ? Icons.visibility_off
                  : Icons.visibility,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () => setState(
              () => _obscurePass = !_obscurePass,
            ),
          ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              12,
            ),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}

// --- 2. شاشة الداشبورد (هوم وبروفايل فقط) ---
class DashboardScreen
    extends
        StatefulWidget {
  const DashboardScreen({
    super.key,
  });

  @override
  State<
    DashboardScreen
  >
  createState() => _DashboardScreenState();
}

class _DashboardScreenState
    extends
        State<
          DashboardScreen
        > {
  XFile? _imageFile;
  late UserData user;
  bool isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitialized) {
      final args = ModalRoute.of(
        context,
      )!.settings.arguments;
      user =
          (args
              is UserData)
          ? args
          : UserData(
              name: " No Name",
              email: "No Email",
            );
      isInitialized = true;
    }
  }

  Future<
    void
  >
  _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile !=
        null) {
      setState(
        () => _imageFile = pickedFile,
      );
    }
  }

  // تفعيل تعديل الملف الشخصي ديناميكياً
  void _editProfileDialog() {
    final nameEdit = TextEditingController(
      text: user.name,
    );
    final emailEdit = TextEditingController(
      text: user.email,
    );
    showDialog(
      context: context,
      builder:
          (
            context,
          ) => AlertDialog(
            title: const Text(
              "Edit Profile",
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameEdit,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: emailEdit,
                  decoration: const InputDecoration(
                    labelText: "Email",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(
                  context,
                ),
                child: const Text(
                  "Cancel",
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(
                    () {
                      user.name = nameEdit.text;
                      user.email = emailEdit.text;
                    },
                  );
                  Navigator.pop(
                    context,
                  );
                },
                child: const Text(
                  "Update",
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return DefaultTabController(
      length: 2, // رجعت 2 تابات فقط
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.darkBlue,
          toolbarHeight: 45,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 18,
            ),
            onPressed: () => Navigator.pop(
              context,
            ),
          ),
          title: const Text(
            "DASHBOARD",
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            const TabBar(
              indicatorColor: AppColors.accentPink,
              labelColor: AppColors.darkBlue,
              tabs: [
                Tab(
                  text: "Home",
                ),
                Tab(
                  text: "Profile",
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildHomeTab(
                    user.name,
                  ),
                  _buildProfileTab(
                    user,
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          height: 35.0,
          color: AppColors.darkBlue,
        ),
      ),
    );
  }

  Widget _buildHomeTab(
    String name,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(
        20,
      ),
      child: Column(
        children: [
          // دايف احترافي بنفس ألوان الرجستر
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(
              25,
            ),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppColors.darkBlue,
                  AppColors.lightBlue,
                ],
              ),
              borderRadius: BorderRadius.circular(
                20,
              ),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(
                    0.1,
                  ),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white24,
                  child: Icon(
                    Icons.waving_hand,
                    size: 30,
                    color: Colors.orangeAccent,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Text(
                  "Hello,",
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(
                      0xFFFFD700,
                    ), // Gold
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const Divider(
                  color: Colors.white24,
                  height: 30,
                ),
                const Text(
                  "Welcome back to your dashboard!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileTab(
    UserData user,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(
        20,
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: Colors.grey.shade200,
                backgroundImage:
                    _imageFile !=
                        null
                    ? NetworkImage(
                        _imageFile!.path,
                      )
                    : null,
                child:
                    _imageFile ==
                        null
                    ? const Icon(
                        Icons.person,
                        size: 60,
                        color: AppColors.darkBlue,
                      )
                    : null,
              ),

              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    padding: const EdgeInsets.all(
                      6,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.accentPink,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          _infoCard(
            Icons.person,
            "Name",
            user.name,
            Colors.blue,
          ),
          _infoCard(
            Icons.email,
            "Email",
            user.email,
            Colors.orange,
          ),
          const SizedBox(
            height: 15,
          ),
          OutlinedButton.icon(
            onPressed: _editProfileDialog, // الزر شغال ديناميكياً الآن
            icon: const Icon(
              Icons.edit,
              size: 16,
            ),
            label: const Text(
              "Edit Profile",
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.darkBlue,
              side: const BorderSide(
                color: AppColors.darkBlue,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          12,
        ),
        side: BorderSide(
          color: Colors.grey.shade100,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: color,
          size: 20,
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,

            fontSize: 14,
            color: AppColors.darkBlue,
          ),
        ),
      ),
    );
  }
}
