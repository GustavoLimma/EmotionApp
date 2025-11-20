import 'package:flutter/foundation.dart';
import 'result.dart';

/// A strongly-typed command following the Command Pattern.
///
/// T = result type
/// A = argument type (can be void, a single type, or a record)
typedef CommandAction<T, A> = Future<Result<T>> Function(A args);


/*
O Command diz PARA a tela: "Ei, a ação que eu represento está em
andamento/terminou/falhou, atualize os widgets que dependem de mim
(botões, indicadores de progresso, etc.)!"
 */
class Command<T, A> extends ChangeNotifier {
  Command(this._action);

  final CommandAction<T, A> _action;

  bool _running = false;
  Result<T>? _result;

  bool get running => _running;
  Result<T>? get result => _result;

  bool get completed => _result is Ok<T>;
  bool get error => _result is Error<T>;

  void clearResult() {
    _result = null;
    notifyListeners();
  }

  Future<void> execute(A args) async {
    if (_running) return;

    _running = true;
    _result = null;
    notifyListeners();

    try {
      _result = await _action(args);
    } finally {
      _running = false;
      notifyListeners();
    }
  }
}

/// Extensão para comandos cujo T é void.
/// Permite executar sem precisar passar null.
extension VoidCommandExtensions<A> on Command<void, A> {
  Future<void> executeVoid(A args) async {
    await execute(args);
  }
}

/// Extensão para comandos sem argumentos (A = void)
extension NoArgsCommandExtensions<T> on Command<T, void> {
  Future<void> executeNoArgs() async {
    await execute(null);
  }
}