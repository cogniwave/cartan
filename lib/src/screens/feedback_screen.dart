import 'package:cartan/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cartan/src/blocs/feedback/feedback_bloc.dart';
import 'package:cartan/src/blocs/feedback/feedback_event.dart';
import 'package:cartan/src/blocs/feedback/feedback_state.dart';

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

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    setState(() {
      _nameError = _emailError = _messageError = null;
    });

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

  void _handleError(String error) {
    final localizations = AppLocalizations.of(context)!;
    setState(() {
      _nameError = error == localizations.name_required ? error : null;
      _emailError = (error == localizations.email_required ||
          error == localizations.invalid_email) ? error : null;
      _messageError = error == localizations.message_required ? error : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(localizations.feedback)),
      body: BlocListener<FeedbackBloc, FeedbackState>(
        listener: (context, state) {
          if (state is FeedbackFailure) {
            _handleError(state.error);
            AppSnackBar.showError(context, state.error);
          } else if (state is FeedbackSuccess) {
            AppSnackBar.showSuccess(context, localizations.feedback_sent);
            Navigator.pop(context);
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: localizations.name,
                  errorText: _nameError,
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailCtrl,
                decoration: InputDecoration(
                  labelText: localizations.email,
                  errorText: _emailError,
                ),
                keyboardType: TextInputType.emailAddress,
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