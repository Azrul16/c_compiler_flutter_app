import 'dart:ffi';
import 'dart:io';
import 'package:ffi/ffi.dart';

typedef CompileCodeFunc = Pointer<Utf8> Function(Pointer<Utf8>);
typedef CompileCode = Pointer<Utf8> Function(Pointer<Utf8>);

class Compiler {
  late DynamicLibrary _lib;
  late CompileCode _compileCode;

  Compiler() {
    if (Platform.isAndroid) {
      _lib = DynamicLibrary.open('libcompiler.so');
    } else if (Platform.isIOS) {
      _lib = DynamicLibrary.process(); // Adjust accordingly for iOS
    } else {
      throw UnsupportedError("This platform is not supported");
    }

    print('Library loaded: $_lib');

    _compileCode = _lib
        .lookup<NativeFunction<CompileCodeFunc>>('compile_code')
        .asFunction();

    print('Function loaded: $_compileCode');
  }

  String compile(String code) {
    final ptrCode = code.toNativeUtf8();
    print('Code converted to native string: $ptrCode');
    final ptrResult = _compileCode(ptrCode);
    final result = ptrResult.toDartString();
    calloc.free(ptrCode); // Free the allocated pointer
    print('Compilation result: $result');
    return result;
  }
}

Future<String> compileCCode(String code) async {
  final compiler = Compiler();
  return compiler.compile(code);
}
