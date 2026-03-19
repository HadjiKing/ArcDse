import '../../core/observable.dart';

class _ChartsController {
  final filterByOperatorID = ObservableState("");
  
  void resetSelected() {
    filterByOperatorID("");
  }
  
  void filterByOperator(String id) {
    filterByOperatorID(id);
  }
  
  void dispose() {
    filterByOperatorID.dispose();
  }
}

final chartsCtrl = _ChartsController();