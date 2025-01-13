import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:bug_away/Features/register/data/models/user_model_dto.dart';
import 'package:bug_away/Features/reports/data/data_sources/get_users_data_source.dart';

import '../../../../Core/errors/failures.dart';

@Injectable(as: GetUsersDataSource)
class GetUsersDataSourceImpl implements GetUsersDataSource {
  @override
  Future<Either<Failure, List<UserAndAdminModelDto>>>
      getUsersFromFireStore() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.wifi) ||
        connectivityResult.contains(ConnectivityResult.mobile)) {
      try {
        var usersCollection = FirebaseFirestore.instance.collection('user');
        var querySnapshot = await usersCollection.get();
        var users = querySnapshot.docs.map((doc) {
          final data = doc.data();
          return UserAndAdminModelDto.fromFireStore(data);
        }).toList();
        return Right(users);
      } catch (e) {
        return Left(Failure(errorMessage: e.toString()));
      }
    } else {
      return Left(Failure(errorMessage: "Internet Connection is lost."));
    }
  }
}
