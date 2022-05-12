## Widget Testing

Before starting any tests, it is good to lay out the steps and expectation of a flow. Let's add a test to verify popup alert works as expected.
```dart
/// 1. Start by going to edit screen with an item created
/// 2. Tap on trash bin icon
/// 3. Verify that popup dialog did appear
/// 4. * Tap no button to cancel
/// 5. Verify popup did disappear as nothing happen
/// 4.1 * User can also dismiss the popup when tap the background
/// 5.1  Verify popup did disappear as nothing happen
```
 
```dart
testWidgets('Can dismiss/cancel removal', (WidgetTester tester) async {
 // Test code here...
});
```

Next, create a scaffold for test, wrapping `MyApp` with a ProviderScope from riverpod
```dart
// Test code here...
const myapp = ProviderScope(child: MyApp(initialRoute: '/home'));
    await tester.pumpWidget(myapp);
```

Expand each step into tests
```dart
await _addRecipe(tester, 'Pineapple'); // helper method to add test item quickly
await tester.tap(find.text('Pineapple')); // click the ListTile that contain newly created item

/// 1. Edit screen
await tester.pumpAndSettle(); // wait for screen transition to complete
expect(find.byKey(EditFoodViewState.scaffoldKey), findsOneWidget); 

/// 2. Tap on bin button
await tester.tap(find.byKey(EditFoodViewState.delFoodKey));
await tester.pump();

/// 3. Show pop up to confirm
expect(find.byType(AlertDialog), findsOneWidget);

/// 4. * Tap no
await tester.tap(find.byKey(const Key('No')));
expect(find.byKey(EditFoodViewState.scaffoldKey), findsOneWidget);
await tester.pump();

/// 5. Tap confirm to delete again
await tester.tap(find.byKey(EditFoodViewState.delFoodKey));
await tester.pump();
expect(find.byType(AlertDialog), findsOneWidget);

/// Extra test to verify tapping outside of alert could dismiss the dialog
/// https://github.com/flutter/flutter/blob/master/packages/flutter/test/material/dialog_test.dart
await tester.tapAt(const Offset(10.0, 10.0));
await tester.pump();
expect(find.byType(AlertDialog), findsNothing);
```

