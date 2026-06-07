import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider para controlar el índice de navegación seleccionado en el layout principal.
final appLayoutIndexProvider = StateProvider<int>((ref) => 0);
