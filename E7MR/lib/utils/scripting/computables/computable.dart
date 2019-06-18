abstract class Computable<T> {
  Future<T> compute();
}

Future<Iterable<T>> computeAll<T>(Iterable<Computable<T>> computables) async =>
    await Future.wait(
        computables.map((computable) async => await computable.compute()));
