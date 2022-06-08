@Timeout(Duration(milliseconds: 500))
import 'package:ecommerce_app/src/features/authentication/presentation/account/account_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../../mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late AccountScreenController controller;
  setUp(() {
    authRepository = MockAuthRepository();
    controller = AccountScreenController(authRepository: authRepository);
  });
  group('AccountScreenController', () {
    test('initial state is AsyncValue.data', () {
      expect(controller.debugState, const AsyncData<void>(null));
    });

    test('signOut success', () async {
      //setUp
      when(authRepository.signOut).thenAnswer(
        (_) => Future.value(),
      );
      //expect later
      expectLater(
        controller.stream,
        emitsInOrder(const [
          AsyncLoading<void>(),
          AsyncData<void>(null),
        ]),
      );
      //run
      await controller.signOut();
      //verify
      verify(authRepository.signOut).called(1);
      expect(controller.debugState, const AsyncData<void>(null));
    });

    test('signOut failure', () async {
      //setUp
      final exception = Exception('Connection failed');
      when(authRepository.signOut).thenThrow(exception);
      //expect later
      expectLater(
        controller.stream,
        emitsInOrder([
          const AsyncLoading<void>(),
          predicate<AsyncValue<void>>((value) {
            expect(value.hasError, true);
            return true;
          }),
        ]),
      );
      //run
      await controller.signOut();
      //verify
      verify(authRepository.signOut).called(1);
      expect(controller.debugState.hasError, true);
      // expect(controller.debugState, isA<AsyncError>());
    });
  });
}


///Testing with mocks
///
///1. Create a mock class for each dependency in our object under test.
///2. Configure the mock by stubbing all the methods that will be called (return, answer or throw).
///3. Call the method we want to test.
///4. verify the results (with verify and/or expect).