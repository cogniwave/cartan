import 'package:bloc/bloc.dart';
import 'feedback_event.dart';
import 'feedback_state.dart';

// A BLoC that handles feedback submission
class FeedbackBloc extends Bloc<FeedbackEvent, FeedbackState> {
  FeedbackBloc() : super(FeedbackInitial()) {
    on<SubmitFeedback>((event, emit) async {
      // Input validation
      // Name
      if (event.name == null || event.name!.isEmpty) {
        emit(FeedbackFailure(event.nameRequiredError));
        return;
      }
      // Email
      if (event.email == null || event.email!.isEmpty) {
        emit(FeedbackFailure(event.emailRequiredError));
        return;
      }

      final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
      if (!emailRegex.hasMatch(event.email!)) {
        emit(FeedbackFailure(event.invalidEmailError));
        return;
      }

      // Message
      if (event.message.trim().isEmpty) {
        emit(FeedbackFailure(event.messageRequiredError));
        return;
      }

      emit(FeedbackSubmitting());
      try {
        // TODO: real backend call
        await Future.delayed(const Duration(seconds: 2));
        emit(FeedbackSuccess());
      } catch (e) {
        emit(FeedbackFailure('Failed to send feedback.'));
      }
    });
  }
}