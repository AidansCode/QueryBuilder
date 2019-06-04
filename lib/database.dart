import 'package:query_builder/query.dart';
import 'package:query_builder/database_interactor.dart';

class Database {

  Database(String host, String username, String password, String database, {int port}) {
    DatabaseInteractor.host = host;
    DatabaseInteractor.username = username;
    DatabaseInteractor.pass = password;
    DatabaseInteractor.database = database;
    if (port != null)
      DatabaseInteractor.port = port;
  }

  Query table(String tableName) {
    Query query = new Query();
    query.setTable(tableName);

    return query;
  }

}