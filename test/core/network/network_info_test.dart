import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trivia_number_new/core/network/network_info.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfoImpl networkInfoImpl;
  MockDataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl =
        NetworkInfoImpl(connectionChecker: mockDataConnectionChecker);
  });

  test(
    "Nous allons tester la connectivité à Internet",
    () async {
      final tHasConnectionFuture = Future.value(true);
      //Arrange
      //Ici comme tHasConnectionFuture est dejà un Future alors on ne met pas
      //async dans thenAnswer comme auparavant
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((_) => tHasConnectionFuture);
      //Act
      final result = networkInfoImpl.isConnected;
      //Assert
      expect(result, tHasConnectionFuture);
      verify(mockDataConnectionChecker.hasConnection);
    },
  );
}
