import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final UserType userType;

  UserProfile({
    required this.userType,
  });

  @override
  List<Object> get props => [userType];

  static UserProfile getDefault() {
    return UserProfile(userType: UserType.moving);
  }

  UserProfile withUserType(UserType userType) {
    return UserProfile(
        userType: userType,
    );
  }
}

enum UserType {
  moving, parking
}
