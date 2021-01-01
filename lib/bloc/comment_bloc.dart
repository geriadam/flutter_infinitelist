import 'package:flutter_infinitelist/events/comment_events.dart';
import 'package:flutter_infinitelist/services/services.dart';
import 'package:flutter_infinitelist/states/comment_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class CommentBloc extends Bloc<CommentEvent, CommentState> {
  final NUMBER_OF_COMMENTS_PER_PAGE = 20;
  CommentBloc():super(CommentStateInitial());
  @override
  Stream<CommentState> mapEventToState(CommentEvent event) async* {
    if(event is CommentFetchedEvent &&
        !(state is CommentStateSuccess && (state as CommentStateSuccess).hasReachedEnd)) {
      try {
        if (state is CommentStateInitial) {
          final comments = await getCommentFromApi(0, NUMBER_OF_COMMENTS_PER_PAGE);
          yield CommentStateSuccess(
              comments: comments,
              hasReachedEnd: false
          );
        } else if (state is CommentStateSuccess) {
          final currentState = state as CommentStateSuccess;
          int finalIndexOfCurrentPage  = currentState.comments.length;
          final comments = await getCommentFromApi(finalIndexOfCurrentPage, NUMBER_OF_COMMENTS_PER_PAGE);
          if (comments.isEmpty) {
            yield currentState.cloneWith(hasReachedEnd: false);
          } else {
            yield CommentStateSuccess(
                comments: currentState.comments + comments,
                hasReachedEnd: false
            );
          }
        }
      } catch(exception) {
        yield CommentStateFailure();
      }
    }
  }
}