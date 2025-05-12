abstract class FeedbackEvent {}

// Triggered when the user submits the form
class SubmitFeedback extends FeedbackEvent {
  final String? name;
  final String? email;
  final String message;
  final String nameRequiredError;
  final String emailRequiredError;
  final String invalidEmailError;
  final String messageRequiredError;
  final String submissionError;

  SubmitFeedback({
    this.name,
    this.email,
    required this.message,
    required this.nameRequiredError,
    required this.emailRequiredError,
    required this.invalidEmailError,
    required this.messageRequiredError,
    required this.submissionError,
  });
}