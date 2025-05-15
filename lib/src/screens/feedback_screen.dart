import 'package:cartan/src/services/navigation_service.dart';
import 'package:cartan/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});
  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  String? _nameError;
  String? _emailError;
  String? _messageError;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  // Validates email using a regex pattern
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  Future<void> _onSubmit() async {
    final localizations = AppLocalizations.of(context)!;

    // Reset previous errors
    setState(() {
      _nameError = _emailError = _messageError = null;
    });

    // Validate fields
    bool hasError = false;

    // Name validation
    if (_nameCtrl.text.trim().isEmpty) {
      setState(() {
        _nameError = localizations.name_required;
      });
      hasError = true;
    }

    // Email validation
    if (_emailCtrl.text.trim().isEmpty) {
      setState(() {
        _emailError = localizations.email_required;
      });
      hasError = true;
    } else if (!_isValidEmail(_emailCtrl.text.trim())) {
      setState(() {
        _emailError = localizations.invalid_email;
      });
      hasError = true;
    }

    // Message validation
    if (_messageCtrl.text.trim().isEmpty) {
      setState(() {
        _messageError = localizations.message_required;
      });
      hasError = true;
    }

    if (hasError) {
      return;
    }

    // Show loading indicator
    setState(() {
      _isSubmitting = true;
    });

    try {
      // Simulate API call with a delay
      await Future.delayed(const Duration(seconds: 1));

      // Send feedback to backend
      //   await FirebaseFirestore.instance.collection('feedback').add({
      //     'name': _nameCtrl.text,
      //     'email': _emailCtrl.text,
      //     'message': _messageCtrl.text,
      //     'timestamp': FieldValue.serverTimestamp(),
      //   });

      if (!mounted) return;

      AppSnackBar.showSuccess(localizations.feedback_sent);

      NavigationService().pop();
    } catch (e) {
      if (!mounted) return;

      AppSnackBar.showError(localizations.feedback_submission_error);

      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.feedback)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: localizations.name,
                errorText: _nameError,
              ),
              textInputAction: TextInputAction.next,
              onChanged: (_) {
                // Clear error when user types
                if (_nameError != null) {
                  setState(() {
                    _nameError = null;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailCtrl,
              decoration: InputDecoration(
                labelText: localizations.email,
                errorText: _emailError,
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              onChanged: (_) {
                // Clear error when user types
                if (_emailError != null) {
                  setState(() {
                    _emailError = null;
                  });
                }
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _messageCtrl,
              decoration: InputDecoration(
                labelText: localizations.message,
                errorText: _messageError,
              ),
              maxLines: 5,
              minLines: 3,
              onChanged: (_) {
                // Clear error when user types
                if (_messageError != null) {
                  setState(() {
                    _messageError = null;
                  });
                }
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _onSubmit,
                child: _isSubmitting
                    ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : Text(localizations.submit),
              ),
            ),
          ],
        ),
      ),
    );
  }
}