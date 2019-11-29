// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tick_list/main.dart';
import 'package:tick_list/item_view.dart';
import 'package:tick_list/item.dart';

void main() {

  testWidgets('Tick List smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that item list is empty.
    expect(find.text('No Items'), findsOneWidget);
    expect(find.text('Test item'), findsNothing);
  });

  testWidgets('Test Home Widget by checking if the title is present', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialAppTester(MyApp())
    );
    expect(find.text('Tick List'), findsOneWidget);
  });
  
  testWidgets('Test new empty ItemView Widget by checking if the title is present and the item is null', (WidgetTester tester) async {
    final itemView = new ItemView();
    await tester.pumpWidget(
      MaterialAppTester(itemView)
    );
    expect(find.text('Add Item'), findsOneWidget);
    expect(itemView.item, null);
    expect(find.byType(RaisedButton), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('Test ItemView Widget with an item by checking if the title is present, the item was loaded and set on the textfield', (WidgetTester tester) async {
    final item = new Item(title: 'test item');
    final newTodoView = new ItemView(item: item,);

    await tester.pumpWidget(
      MaterialAppTester(newTodoView)
    );

    expect(find.text('Edit Item'), findsOneWidget);
    expect(newTodoView.item, item);
    expect(find.text('test item'), findsOneWidget);
  });
}

// This Widget is here to enable testing widgets on their own, 
// without the main App, by running inside a base MaterialApp.
class MaterialAppTester extends StatelessWidget {
  final Widget testWidget;

  MaterialAppTester(this.testWidget);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MaterialAppTester',
      home: this.testWidget,
    );
  }
}