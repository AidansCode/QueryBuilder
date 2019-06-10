A library to simplify MySQL database interaction. Allows for simple query building and asynchronous execution.

# Using

It all starts with a simple Database object

```
import 'package:query_builder/query_builder.dart';

void main() {

  var db = Database('host', 'username', 'password', 'database');
  Future<Results> resF = db.table('users').select(['id', 'name', 'email']).whereOne(['id', 1]).get();

  resF.then((Results results) {
    results.forEach((Row row) {
      print(row['name']);
    });
  });

}
```

# Functionality
QueryBuilder currently supports SELECT, INSERT, UPDATE, and DELETE queries with the following additional options:

* ORDER BY

* GROUP BY

* WHERE

* DISTINCT

# Examples

### SELECT

```
import 'package:query_builder/query_builder.dart';

void main() {

  var db = Database('host', 'username', 'password', 'database');
  Future<Results> resF = db.table('users').select(['id', 'name', 'email']).whereOne(['id', 1]).get();

  resF.then((Results results) {
    results.forEach((Row row) {
      print(row['name']);
    });
  });

}
```

### INSERT

```
import 'package:query_builder/query_builder.dart';

void main() {

  var db = Database('host', 'username', 'password', 'database');
  Future<Results> resF = db.table('users').insert([
    {'name': 'John Doe', 'email': 'johnd@website.com', 'password': 'abc123'},
    {'name': 'Jane Doe', 'email': 'janed@website.com', 'password': '123abc'}
  ]);

}
```

### UPDATE

```
import 'package:query_builder/query_builder.dart';

void main() {
  var db = Database('host', 'username', 'password', 'database');
  Future<Results> resF = db.table('users').where([
    ['id', '>', 5],
    ['name', 'John']
  ]).update({'name': 'Jack'});
}
```

### DELETE

```
import 'package:query_builder/query_builder.dart';

void main() {
  var db = Database('host', 'username', 'password', 'database');
  Future<Results> resF = db.table('users').whereOne(['id', 34]).delete();
}
```
