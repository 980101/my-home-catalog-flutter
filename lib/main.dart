import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_home_catalog_flutter/app/app.dart';
import 'package:my_home_catalog_flutter/features/home/data/firebase_recommendation_repository.dart';
import 'package:my_home_catalog_flutter/features/home/data/startup_error_recommendation_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    runApp(
      MyHomeCatalogApp(
        recommendationRepository: FirebaseRecommendationRepository(),
      ),
    );
  } catch (error) {
    runApp(
      MyHomeCatalogApp(
        recommendationRepository: StartupErrorRecommendationRepository(error),
      ),
    );
  }
}
