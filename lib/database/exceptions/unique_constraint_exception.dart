import 'package:sqflite/sqflite.dart';

class UniqueConstraintException extends DatabaseException {
  UniqueConstraintException(String field) : super('Field `$field` must be unique.');
  
  @override
  int? getResultCode() {
    return null;
  }
  
  @override
  Object? get result => null;
}