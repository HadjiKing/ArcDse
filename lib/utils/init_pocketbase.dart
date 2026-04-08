import 'package:arcdse/utils/constants.dart';
import 'package:arcdse/utils/logger.dart';
import 'package:pocketbase/pocketbase.dart';

/// Creates the main data and public collections in PocketBase if they do not
/// already exist.  Called on first login by an admin user.
Future<void> initializePocketbase(PocketBase pb) async {
  try {
    await pb.collections.import([
      dataCollectionImport,
      publicCollectionImport,
    ]);
  } catch (e, s) {
    logger('Error initializing PocketBase collections: $e', s);
    rethrow;
  }
}

/// Creates the profiles and profiles_view collections in PocketBase.
Future<void> initializeProfiles(PocketBase pb) async {
  try {
    await pb.collections.import([
      profilesCollectionImport,
      profilesViewCollectionImport,
    ]);
  } catch (e, s) {
    logger('Error initializing PocketBase profile collections: $e', s);
    rethrow;
  }
}
