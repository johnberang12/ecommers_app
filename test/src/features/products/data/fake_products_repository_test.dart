import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  FakeProductsRepository makeProductsRepository() => FakeProductsRepository(
        addDelay: false,
      );

  group('FakeProductsRepository', () {
    test('getProductsList return global list', () {
      final productsRepository = makeProductsRepository();
      expect(
        productsRepository.getProductsList(),
        kTestProducts,
      );
    });

    test('getProduct(1) returns first item', (() {
      final productsRepository = makeProductsRepository();
      expect(
        productsRepository.getProduct('6'),
        kTestProducts[5],
      );
    }));

    ///testing for null like this needs the function block to
    ///be enclosed with try/catch
    test('getProduct(100) returns null', () {
      final productsRepository = makeProductsRepository();
      expect(
        productsRepository.getProduct('100'),
        null,
      );
    });
  });

  ///testing future needs to use async/await
  test('fetchProductsList returns global list', () async {
    final productsRepository = makeProductsRepository();
    expect(
      await productsRepository.fetchProductsList(),
      kTestProducts,
    );
  });

  ///streams cam emit multiple values overtime
  ///so testing streams needs to use emits() method
  test('watchProductsList', () {
    final productsRepository = makeProductsRepository();
    expect(
      productsRepository.watchProductsList(),

      ///use stream matcher
      emits(kTestProducts),
    );
  });

  test('watchProduct(1) emits first item', () {
    final productsRepository = makeProductsRepository();
    expect(
      productsRepository.watchProduct('2'),
      emits(kTestProducts[1]),
    );
  });

  test('watchProduct(100) returns null', () {
    final productsRepository = makeProductsRepository();
    expect(
      productsRepository.watchProduct('100'),
      emits(null),
    );
  });
}
