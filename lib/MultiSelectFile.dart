import 'package:flutter/material.dart';

class MultiSelectPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiSelectDropdown(),
    );
  }
}

/////////////////////////////////////////////////////////////////
// ============== Copied from Stack Overflow ================ //

class MultiSelectDialogItem<V> {
  final V value;
  final String label;
  const MultiSelectDialogItem(this.value, this.label);
}

class MultiSelectDialog<V> extends StatefulWidget {
  final List<MultiSelectDialogItem<V>> items;
  final Set<V> initialSelectedValues;
  MultiSelectDialog({Key key, this.items, this.initialSelectedValues})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _MultiSelectDialogState<V>();
}

class _MultiSelectDialogState<V> extends State<MultiSelectDialog<V>> {
  final _selectedValues = Set<V>();

  void initState() {
    super.initState();
    if (widget.initialSelectedValues != null) {
      _selectedValues.addAll(widget.initialSelectedValues);
    }
  }

  void _onItemCheckedChange(V itemValue, bool checked) {
    setState(() {
      if (checked) {
        _selectedValues.add(itemValue);
      } else {
        _selectedValues.remove(itemValue);
      }
    });
  }

  void _onCancelTap() {
    Navigator.pop(context);
  }

  void _onSubmitTap() {
    Navigator.pop(context, _selectedValues);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      title: Text('Select Country'),
      contentPadding: EdgeInsets.only(top: 12.0),
      content: SingleChildScrollView(
        child: ListTileTheme(
          contentPadding: EdgeInsets.fromLTRB(14.0, 0.0, 24.0, 0.0),
          child: ListBody(
            children: widget.items.map(_buildItem).toList(),
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text('CANCEL'),
          onPressed: _onCancelTap,
        ),
        FlatButton(
          child: Text('OK'),
          onPressed: _onSubmitTap,
        ),
      ],
    );
  }

  Widget _buildItem(MultiSelectDialogItem<V> item) {
    final checked = _selectedValues.contains(item.value);
    return CheckboxListTile(
      value: checked,
      title: Text(item.label),
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item.value, checked),
    );
  }
}

// ============================================================= //
///////////////////////////////////////////////////////////////////

class MultiSelectDropdown extends StatefulWidget {
  @override
  _MultiSelectDropdownState createState() => _MultiSelectDropdownState();
}

class _MultiSelectDropdownState extends State<MultiSelectDropdown> {
  List<MultiSelectDialogItem<int>> multiItem = List();
  //TODO Populated Value's Map
  final valuesToPopulate = {
    1: "Pakistan",
    2: "Britain",
    3: "Russia",
    4: "Canada",
    5: "China"
  };

  // Add values to list
  void populateMultiSelect() {
    for (int v in valuesToPopulate.keys) {
      multiItem.add(MultiSelectDialogItem(v, valuesToPopulate[v]));
      // multiItem.add(MultiSelectDialogItem(value, label));
    }
  }

  void _showMultiSelect(BuildContext context) async {
    // create empty list
    multiItem = [];
    populateMultiSelect();
    final items = multiItem;
    // final items = <MultiSelectDialogItem<int>>[
    //   MultiSelectDialogItem(1, 'Pakistan'),
    //   MultiSelectDialogItem(2, 'USA'),
    //   MultiSelectDialogItem(3, 'Canada'),
    // ];

    final selectedValues = await showDialog<Set<int>>(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          items: items,
          //initialSelectedValues: [1, 2].toSet(),
        );
      },
    );
    // print(selectedValues);
    getValueFromKey(selectedValues);
  }

  String displayValues = '';
  List<String> _value = List();
  // Get values from map
  void getValueFromKey(Set selection) {
    if (selection != null) {
      _value = [];
      for (int x in selection.toList()) {
        // print(valuesToPopulate[x]);
        _value.add(valuesToPopulate[x]);
      }
      setState(() {
        displayValues = _value.toString();
      });
    } else {
      setState(() {
        displayValues = "Please Select any Value";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        centerTitle: true,
        title: Text(
          'Other Way - MultiSelect',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Center(
            child: RaisedButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                elevation: 5.0,
                child: Text('Select Values', style: TextStyle(fontSize: 18.0)),
                textColor: Colors.black,
                color: Colors.yellow,
                onPressed: () => _showMultiSelect(context)),
          ),
          Text(
            '$displayValues',
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
