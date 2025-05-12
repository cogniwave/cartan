import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/blocs/feedback/feedback_bloc.dart';
import 'package:cartan/src/blocs/feedback/feedback_event.dart';
import 'package:cartan/src/blocs/feedback/feedback_state.dart';
import 'package:cartan/utils/app_snackbar.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  // Text controllers for input fields
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();

  // Focus nodes for keyboard navigation
  final _nameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _messageFocusNode = FocusNode();

  // Error messages for each field
  String? _nameError;
  String? _emailError;
  String? _messageError;

  @override
  void dispose() {
    // Dispose of all controllers and focus nodes
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _messageFocusNode.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    // Reset error states
    setState(() {
      _nameError = null;
      _emailError = null;
      _messageError = null;
    });

    // Trigger feedback submission event
    context.read<FeedbackBloc>().add(
      SubmitFeedback(
        name: _nameCtrl.text,
        email: _emailCtrl.text,
        message: _messageCtrl.text,
        nameRequiredError: AppLocalizations.of(context)!.name_required,
        emailRequiredError: AppLocalizations.of(context)!.email_required,
        invalidEmailError: AppLocalizations.of(context)!.invalid_email,
        messageRequiredError: AppLocalizations.of(context)!.message_required,
        submissionError: AppLocalizations.of(context)!.feedback_submission_error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.feedback)),
      body: BlocListener<FeedbackBloc, FeedbackState>(
        listener: (context, state) {
          if (state is FeedbackFailure) {
            // Set specific error based on error message
            setState(() {
              if (state.error == localizations.name_required) {
                _nameError = state.error;
                _nameFocusNode.requestFocus();
              } else if (state.error == localizations.email_required ||
                  state.error == localizations.invalid_email) {
                _emailError = state.error;
                _emailFocusNode.requestFocus();
              } else if (state.error == localizations.message_required) {
                _messageError = state.error;
                _messageFocusNode.requestFocus();
              } else {
                // Generic error handling if needed
                AppSnackBar.showError(context, state.error);
              }
            });
          } else if (state is FeedbackSuccess) {
            // Show success message and pop the screen
            AppSnackBar.showSuccess(context, localizations.feedback_sent);
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _nameCtrl,
                focusNode: _nameFocusNode,
                decoration: InputDecoration(
                  labelText: localizations.name,
                  errorText: _nameError,
                ),
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _emailCtrl,
                focusNode: _emailFocusNode,
                decoration: InputDecoration(
                  labelText: localizations.email,
                  errorText: _emailError,
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                onSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_messageFocusNode);
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _messageCtrl,
                focusNode: _messageFocusNode,
                decoration: InputDecoration(
                  labelText: localizations.message,
                  errorText: _messageError,
                ),
                maxLines: 5,
                minLines: 3,
                textInputAction: TextInputAction.newline,
              ),
              const SizedBox(height: 24),
              BlocBuilder<FeedbackBloc, FeedbackState>(
                builder: (context, state) {
                  final submitting = state is FeedbackSubmitting;
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: submitting ? null : () => _onSubmit(context),
                      child: submitting
                          ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                          : Text(localizations.submit),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}