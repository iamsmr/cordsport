import 'dart:async';
import 'package:codespot/blocs/user/user_bloc.dart';
import 'package:codespot/models/models.dart';
import 'package:codespot/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

import 'package:bloc/bloc.dart';
import 'package:geolocator/geolocator.dart';

part 'location_event.dart';
part 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  StreamSubscription<List<User>>? _userSubscribtion;
  final UserRepository _userRepository;
  late StreamSubscription<Position> _locationSubscription;

  final UserBloc _userBloc;

  LocationBloc({
    required UserBloc userBloc,
    required UserRepository userRepository,
  })  : _userBloc = userBloc,
        _userRepository = userRepository,
        super(LocationInitial());

  @override
  Stream<LocationState> mapEventToState(
    LocationEvent event,
  ) async* {
    if (event is LocationStarted) {
      yield* _mapLocationStartedEventToState();
    } else if (event is LocationChanged) {
      yield LocationLoadSuccess(position: event.position);
    }
    // TODO: implement later

    // else if (event is LocationUserGetUserWithInOneKiloMterDistance) {
    //   yield* _mapGetUserWithRadiusEventToState();
    // }
  }

  Stream<LocationState> _mapLocationStartedEventToState() async* {
    yield(LocationLoadInProgress());
    // _locationSubscription.cancel();
    _userSubscribtion?.cancel();
    _locationSubscription = Geolocator.getPositionStream().listen((position) {
      _userBloc.add(UserUpdatePosition(position: position));
      _userRepository
          .getUserWithInRadius(radius: 10, center: position)
          .listen((users) {
        _userBloc.add(UserUpdateUser(users: users));
      });
      add(LocationChanged(position: position));

      // (LocationLoadSuccess(position: position));
    });
  }

  @override
  Future<void> close() {
    _locationSubscription.cancel();
    return super.close();
  }


  // TODO: implement later

//   Stream<LocationState> _mapGetUserWithRadiusEventToState() async* {
//     if (state is LocationLoadSuccess) {
//       final state = this.state as LocationLoadSuccess;
//       _userSubscribtion?.cancel();
//     }
//   }
}
