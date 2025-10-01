import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/utils/api_service.dart';
import '../../core/colors_manger/colors.dart';
import '../../core/bottoms/buttons.dart';
import '../../core/models/user_model/user_model.dart';
import '../auth/login_screen.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _oldPasswordController;
  late TextEditingController _newPasswordController;

  bool _isLoading = false;
  bool _isActionLoading = false;
  ProfileModel? _currentProfile;
  int _selectedAvatarId = 1;

  final List<String> _avatars = List.generate(
    9,
        (index) => "assets/images/av_${index + 1}.png",
  );

  final double _mainAvatarRadius = 50.0;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _oldPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _loadCurrentProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {Color color = AppColors.yellow}) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: color,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _loadCurrentProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await ApiService.getProfile();
      if (profile != null) {
        _currentProfile = profile;
        _nameController.text = profile.name;
        _emailController.text = profile.email;
        _phoneController.text = profile.phone;
        _selectedAvatarId = profile.avaterId;
      } else {
        _showSnackBar("Could not load profile data. Please log in again.", color: AppColors.red);
        if (mounted) Navigator.pop(context, false);
      }
    } catch (e) {
      _showSnackBar("Error fetching profile: ${e.toString()}", color: AppColors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleUpdate() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final String? newName = _nameController.text != _currentProfile?.name ? _nameController.text : null;
    final String? newPhone = _phoneController.text != _currentProfile?.phone ? _phoneController.text : null;
    final int? newAvatarId = _selectedAvatarId != _currentProfile?.avaterId ? _selectedAvatarId : null;

    if (newName == null && newPhone == null && newAvatarId == null) {
      _showSnackBar("No changes detected.");
      setState(() => _isLoading = false);
      return;
    }

    try {
      final result = await ApiService.updateProfile(
        name: newName,
        phone: newPhone,
        avaterId: newAvatarId,
      );

      _showSnackBar(result ?? "Profile updated successfully!");

      if (mounted) {
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showSnackBar("Update failed: ${e.toString().split(':').last.trim()}", color: AppColors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handlePasswordReset() async {
    if (_oldPasswordController.text.isEmpty || _newPasswordController.text.isEmpty) {
      _showSnackBar("Please enter both old and new passwords to reset.");
      return;
    }
    if (_oldPasswordController.text == _newPasswordController.text) {
      _showSnackBar("New password must be different from the old password.");
      return;
    }

    setState(() => _isActionLoading = true);
    try {
      final result = await ApiService.resetPassword(
        oldPassword: _oldPasswordController.text,
        newPassword: _newPasswordController.text,
      );

      if (result != null && !result.toLowerCase().contains("exception")) {
        _showSnackBar(result, color: AppColors.yellow);
        _oldPasswordController.clear();
        _newPasswordController.clear();
      } else {
        _showSnackBar(result?.split(':').last.trim() ?? "Password reset failed.", color: AppColors.red);
      }
    } catch (e) {
      _showSnackBar("An unexpected error occurred: ${e.toString()}", color: AppColors.red);
    } finally {
      setState(() => _isActionLoading = false);
    }
  }

  void _handleDeleteAccount() async {
    setState(() => _isActionLoading = true);
    try {
      final result = await ApiService.deleteProfile();
      _showSnackBar(result ?? "Account deleted successfully.", color: AppColors.yellow);

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      _showSnackBar("Deletion failed: ${e.toString().split(':').last.trim()}", color: AppColors.red);
      setState(() => _isActionLoading = false);
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    String? Function(String?)? validator,
    bool isPassword = false,
  }) {
    final ValueNotifier<bool> isObscure = ValueNotifier(isPassword);

    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: ValueListenableBuilder<bool>(
        valueListenable: isObscure,
        builder: (context, obscureValue, child) {
          return TextFormField(
            controller: controller,
            readOnly: readOnly,
            obscureText: obscureValue,
            keyboardType: label.toLowerCase().contains("phone")
                ? TextInputType.phone
                : TextInputType.text,
            style: TextStyle(color: AppColors.white, fontSize: 16.sp),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: TextStyle(color: AppColors.grey, fontSize: 16.sp),
              prefixIcon: Icon(icon, color: AppColors.yellow),
              suffixIcon: isPassword
                  ? IconButton(
                icon: Icon(
                  obscureValue ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.grey,
                ),
                onPressed: () {
                  isObscure.value = !obscureValue;
                },
              )
                  : null,
              filled: true,
              fillColor: AppColors.grey.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
                borderSide: const BorderSide(color: AppColors.yellow, width: 2),
              ),
            ),
            validator: validator,
          );
        },
      ),
    );
  }

  void _showAvatarSelection() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        const int columnCount = 3;
        final double avatarItemRadius = 45.0.r;

        return Container(
          // استخدام SingleChildScrollView لجعل الـ Container بأكمله قابلاً للتمرير إذا أصبح أكبر من الشاشة
          // ولكن بما أننا نستخدم Column with mainAxisSize.min، سنجعل الـ GridView هو القابل للتمرير
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.r),
              topRight: Radius.circular(25.r),
            ),
          ),
          padding: EdgeInsets.all(20.w),
          child: Column(
            // استخدام min لكي لا تستهلك النافذة المنبثقة كامل الارتفاع إلا عند الحاجة
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select Avatar",
                style: TextStyle(
                  color: AppColors.yellow,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),

              // **التعديل هنا: استخدام Flexible و GridView.builder لجعل القائمة قابلة للتمرير**
              Flexible( // تسمح لـ GridView بأخذ المساحة اللازمة وتجعله قابلاً للتمرير
                child: GridView.builder(
                  shrinkWrap: true, // يمنع GridView من النمو إلى ارتفاع لانهائي داخل Flexible إذا كان المحتوى صغيراً
                  physics: const ClampingScrollPhysics(), // جعلها قابلة للتمرير
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columnCount, // 3 عناصر في الصف
                    crossAxisSpacing: 15.w, // مسافة أفقية
                    mainAxisSpacing: 20.h, // مسافة رأسية
                    childAspectRatio: 1.0, // للحفاظ على شكل دائري
                  ),
                  itemCount: _avatars.length,
                  itemBuilder: (context, index) {
                    final avatarId = index + 1;
                    final isSelected = _selectedAvatarId == avatarId;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatarId = avatarId;
                        });
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? AppColors.yellow : AppColors.grey.withOpacity(0.3),
                            width: isSelected ? 3.w : 1.w,
                          ),
                          color: AppColors.grey.withOpacity(0.1),
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            _avatars[index],
                            fit: BoxFit.cover,
                            width: avatarItemRadius * 2,
                            height: avatarItemRadius * 2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10.h),
              CustomButton(
                label: "Close",
                backgroundColor: AppColors.grey.withOpacity(0.7),
                textColor: AppColors.white,
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAvatar() {
    int displayId = _selectedAvatarId;
    String avatarPath = "assets/images/av_1.png";
    if (displayId > 0 && displayId <= _avatars.length) {
      avatarPath = _avatars[displayId - 1];
    }

    return GestureDetector(
      onTap: _showAvatarSelection,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: CircleAvatar(
            radius: _mainAvatarRadius.r,
            backgroundColor: AppColors.grey.withOpacity(0.5),
            child: ClipOval(
              child: Image.asset(
                avatarPath,
                width: _mainAvatarRadius.r * 2,
                height: _mainAvatarRadius.r * 2,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.person, size: _mainAvatarRadius.r, color: AppColors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isBusy = _isLoading || _isActionLoading;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: Text(
          "Update Profile",
          style: TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: AppColors.black,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: _isLoading && _currentProfile == null
          ? const Center(
        child: CircularProgressIndicator(color: AppColors.yellow),
      )
          : SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20.w,
          right: 20.w,
          top: 0,
          bottom: 33.h + 10.h * 2 + 50.h,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAvatar(),
              _buildTextField(
                controller: _nameController,
                label: "Name",
                icon: Icons.person_rounded,
                readOnly: isBusy,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name.';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _emailController,
                label: "Email",
                icon: Icons.email_rounded,
                readOnly: true,
              ),
              _buildTextField(
                controller: _phoneController,
                label: "Phone Number",
                icon: Icons.phone_rounded,
                readOnly: isBusy,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number.';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _oldPasswordController,
                label: "Old Password",
                icon: Icons.lock_rounded,
                isPassword: true,
                readOnly: isBusy,
                validator: (value) {
                  if (value != null && value.isNotEmpty && _newPasswordController.text.isEmpty) {
                    return 'If entering an old password, you must enter a new one.';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _newPasswordController,
                label: "New Password",
                icon: Icons.lock_open_rounded,
                isPassword: true,
                readOnly: isBusy,
                validator: (value) {
                  if (value != null && value.isNotEmpty && _oldPasswordController.text.isEmpty) {
                    return 'If entering a new password, you must enter the old one.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.h),
              CustomButton(
                label: isBusy ? "Processing..." : "Reset Password",
                backgroundColor: isBusy ? AppColors.grey.withOpacity(0.5) : AppColors.grey.withOpacity(0.7),
                textColor: AppColors.white,
                onPressed: isBusy ? null : _handlePasswordReset,
              ),
              SizedBox(height: 20.h),
              CustomButton(
                label: isBusy ? "Processing..." : "Delete Account",
                backgroundColor: isBusy ? AppColors.red.withOpacity(0.5) : AppColors.red,
                textColor: AppColors.white,
                onPressed: isBusy ? null : _handleDeleteAccount,
              ),
              SizedBox(height: 10.h),
              CustomButton(
                label: isBusy ? "Processing..." : "Update Data",
                backgroundColor: isBusy ? AppColors.yellow.withOpacity(0.5) : AppColors.yellow,
                textColor: AppColors.black,
                onPressed: isBusy ? null : _handleUpdate,
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}
