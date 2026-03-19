import 'package:pocketbase/pocketbase.dart';
import 'package:arcdse/utils/constants.dart';

Future<void> initializePocketbase(PocketBase pb) async {
  try {
    // Check if collections exist, create if they don't
    final collections = await pb.collections.getList();
    
    final dataCollectionExists = collections.items.any((c) => c.name == dataCollectionName);
    if (!dataCollectionExists) {
      await pb.collections.create(body: dataCollectionImport.toJson());
    }
    
    final publicCollectionExists = collections.items.any((c) => c.name == publicCollectionName);
    if (!publicCollectionExists) {
      await pb.collections.create(body: publicCollectionImport.toJson());
    }
    
  } catch (e) {
    // Ignore errors in demo mode
  }
}

Future<void> initializeProfiles(PocketBase pb) async {
  try {
    // Check if profiles collection exists, create if it doesn't
    final collections = await pb.collections.getList();
    
    final profilesCollectionExists = collections.items.any((c) => c.name == profilesCollectionName);
    if (!profilesCollectionExists) {
      await pb.collections.create(body: profilesCollectionImport.toJson());
    }
    
    final profilesViewExists = collections.items.any((c) => c.name == profilesViewCollectionName);
    if (!profilesViewExists) {
      await pb.collections.create(body: profilesViewCollectionImport.toJson());
    }
    
  } catch (e) {
    // Ignore errors in demo mode
  }
}