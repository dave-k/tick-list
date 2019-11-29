// Import the test package and Counter class
import 'package:test/test.dart';
import 'package:tick_list/main.dart';
import 'package:tick_list/item.dart';
import 'package:flutter/services.dart'; // <-- needed for `MethodChannel`

void main() {
  
  setUp(() {
    
  });

  setUpAll(() {

    // mock getAll from shared_preferences
    const MethodChannel('plugins.flutter.io/shared_preferences')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getAll') {
        return <String, dynamic>{}; // set initial values here if desired
      }
      return null;
    });
  });

  test('item list should be empty', () {
    final MyHomePageState homePageState = MyHomePageState();
    expect(homePageState.list.length, 0);
  });

  test('item list should have 1 item and it should be an instance of Item class', () async {
    final MyHomePageState homePageState = MyHomePageState();
    Item item = new Item(title: 'Test item');

    homePageState.addItem(item);
    expect(homePageState.list.length, 1);

    item = homePageState.list.first;
    expect(item.runtimeType, Item);
  });

  test('item in list should be modified', () async {
    final MyHomePageState homePageState = MyHomePageState();
    Item item = new Item(title: 'Test item');
    String title = 'Edited Test item';

    homePageState.addItem(item);
    homePageState.editItem(item, title);

    expect(item.title, title);
  });

  test('item in list should be completed', () async {
    final MyHomePageState homePageState = MyHomePageState();
    Item item = new Item(title: 'Test item');

    homePageState.addItem(item);
    homePageState.setDone(item);
    item = homePageState.list.first;
    expect(item.done, true);
  });

  test('item in list should be deleted and list should be empty again', () async {
    final MyHomePageState homePageState = MyHomePageState();
    Item item = new Item(title: 'Test item');

    homePageState.addItem(item);
    homePageState.removeItem(item);
    expect(homePageState.list.length, 0);
  });
}
