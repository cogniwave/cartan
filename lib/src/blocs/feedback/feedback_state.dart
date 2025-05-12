abstract class FeedbackState {}

// Initial state
class FeedbackInitial extends FeedbackState {}

// Form is being submitted
class FeedbackSubmitting extends FeedbackState {}

// Submission succeeded
class FeedbackSuccess extends FeedbackState {}

// Submission failed
class FeedbackFailure extends FeedbackState {
  final String error;
  FeedbackFailure(this.error);
}