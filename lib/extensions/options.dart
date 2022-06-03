import 'package:pdoc/ui/widgets/modal_select_widget.dart';
import "package:collection/collection.dart";

extension OptionsExtension on List<ModalSelectOption> {
  void sortByLabel() {
    this.sort((prev, curr) => compareAsciiUpperCase(prev.label, curr.label));
  }
}