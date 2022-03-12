import 'package:bloc/bloc.dart';

typedef TransitionHandler<Event, State> = Function(Transition<Event, State>);

mixin TransitionMixin<E, Z> on Bloc<E, Z> {
  //late TransitionHandler<E, Z> transitionListener;

  @override
  void onTransition(Transition<E, Z> transition) {
    //if (transitionListener != null) transitionListener(transition);
    super.onTransition(transition);
    //transitionListener(transition);
    //super.onTransition(transition);
  }
}
