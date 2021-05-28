import 'package:flutter/material.dart';
import 'package:pdoc/constants.dart';
import 'package:pdoc/l10n/l10n.dart';

class ModalSelectOption<T> {
  final String label;
  final T value;

  ModalSelectOption({required this.label, required this.value});
}

class ModalSelectWidget extends StatefulWidget {
  static const routeName = '/modal-select';

  final String title;
  final List<ModalSelectOption> options;

  ModalSelectWidget({
    required this.title,
    required this.options,
  });

  @override
  _ModalSelectWidgetState createState() => _ModalSelectWidgetState();
}

class _ModalSelectWidgetState extends State<ModalSelectWidget> {
  List<ModalSelectOption>? _options;
  int? _selectedIndex;
  List<ModalSelectOption>? _filteredOptions;

  void _onChanged(String val) {
    final filtered = _options!
        .where(
          (element) => element.label.toLowerCase().contains(val.toLowerCase()),
        )
        .toList();
    setState(() {
      _filteredOptions = filtered;
      _selectedIndex = null;
    });
  }

  void _onSubmit({required BuildContext ctx}) {
    Navigator.of(context).pop(_filteredOptions![_selectedIndex!]);
  }

  @override
  Widget build(BuildContext context) {
    if (_options == null) {
      _options = widget.options;
    }

    if (_filteredOptions == null) {
      setState(() {
        _filteredOptions = widget.options;
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.close),
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.white,
            ),
            onPressed: _selectedIndex == null ? null : () => _onSubmit(ctx: context),
            child: Text(L10n.of(context).modal_select_app_bar_done_button_text),
          ),
        ],
        bottom: _SearchBar(onChanged: _onChanged),
      ),
      body: Scrollbar(
        child: ListView.builder(
          itemCount: _filteredOptions!.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              title: Text(_filteredOptions![index].label),
              trailing: _selectedIndex == index ? Icon(Icons.check) : null,
            );
          },
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget with PreferredSizeWidget {
  Size get preferredSize => Size.fromHeight(50);
  final ValueChanged<String>? onChanged;

  _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ThemeConstants.spacing(1)),
      child: TextFormField(
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: L10n.of(context).modal_select_app_bar_search_text,
        ),
      ),
    );
  }
}
