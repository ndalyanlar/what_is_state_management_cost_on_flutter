import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/memory_repository.dart';
import '../../data/search_provider.dart';
import '../../mock_service/mock_service.dart';

final memoryProvider = ChangeNotifierProvider((ref) => MemoryRepository());

final serviceProvider = Provider((ref) => MockService());

final searchProvider = ChangeNotifierProvider((ref) => SearchStateNotifier());
