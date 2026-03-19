import 'package:arcdse/core/observable.dart';

class _Launch {
  final dialogShown = ObservableState(false);
  final isFirstLaunch = ObservableState(false);
  final isDemo = Uri.base.host == "demo.arcdse.app" || Uri.base.queryParameters.containsKey('demo');
  final open = ObservableState(false);
  double layoutWidth = 0;
}

final launch = _Launch();
