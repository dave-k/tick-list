// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  
  // First, define the Finders and use them to locate widgets from the
  // test suite. Note: the Strings provided to the `byValueKey` method must
  // be the same as the Strings we used for the Keys in the app.
  final titleTextFinder = find.byValueKey('main-app-title');

  FlutterDriver driver;

  // Connect to the Flutter driver before running any tests.
  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });

  // Close the connection to the driver after the tests have completed.
  tearDownAll(() async {
    if (driver != null) {
      driver.close();
    }
  });

  group('TickList App', () {
    test('App starts and has a title', () async {
      // Use the `driver.getText` method to verify the counter starts at 0.
      expect(await driver.getText(titleTextFinder), "Tick List");
    });
  });

  group('Testing Item:', () {
    test('Go to Add Item View', () async {
      final itemTitle = find.byValueKey('item-view-title');

      await driver.tap(find.byType('FloatingActionButton'));
      await driver.waitFor(itemTitle);

      expect(await driver.getText(itemTitle), "Add Item");
    });
  });

  test('Add item', () async {
    final String itemTitle = 'new item created by test';

    await driver.tap(find.byType("TextField"));
    await driver.enterText(itemTitle);
    await driver.tap(find.byType("RaisedButton"));

    expect(await driver.getText(find.byValueKey('item-0')), itemTitle);
  });

  test('Set item as completed', () async {
    final item = find.byValueKey('item-0');
    
    RenderTree renderTree;
    renderTree = await driver.getRenderTree();

    // This seems like a horrible way to test this, but I haven't found a better way.
    expect(renderTree.tree.contains('TextDecoration.lineThrough'), false);

    await driver.tap(item);

    renderTree = await driver.getRenderTree();
    expect(renderTree.tree.contains('TextDecoration.lineThrough'), true);
  });

  test('Edit item', () async {
    final item = find.byValueKey('item-0');
    final String itemTitle = 'item edited by test';

    await driver.scroll(item, 0.0, 0.0, Duration(milliseconds: 1000));
    await driver.tap(find.byType("TextField"));
    await driver.enterText(itemTitle);
    await driver.tap(find.byType("RaisedButton"));

    expect(await driver.getText(find.byValueKey('item-0')), itemTitle);
  });

  test('Delete item', () async {
    final item = find.byValueKey('item-0');
    await driver.waitFor(item);
    await driver.scroll(item, 200.0, 0.0, Duration(milliseconds: 100));
    await driver.waitForAbsent(item);
  });
}