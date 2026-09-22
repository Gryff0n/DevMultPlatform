import 'dart:math';

class Person implements Comparable {
  final String first;
  final String last;
  final int age;
  Person(this.first, this.last, this.age);

  @override
  int compareTo(other) {
    var resultat = (this.age - other.age) as int;
    if (resultat == 0) {
      resultat = (this.last + this.first).compareTo(other.last + other.first);
    }
    return resultat;
  }

  @override
  String toString() {
    return first + " " + last + " " + age.toString();
  }
}

//exo 8
class Matrix {
  List<List<int>> values;
  Matrix(this.values);

  Matrix operator +(Matrix m) {
    int lignes = this.values.length;
    int colonnes = this.values[0].length;
    Matrix ans = Matrix(
      List.generate(lignes, ((index) => List.filled(colonnes, 0))),
    );
    for (int i = 0; i < lignes - 1; i++) {
      for (int j = 0; j < colonnes - 1; j++) {
        ans.values[i][j] = this.values[i][j] + m.values[i][j];
      }
    }
    return ans;
  }

  Matrix operator *(Matrix m) {
    int colonnesA = this.values[0].length;
    int lignesB = m.values.length;
    if (colonnesA != lignesB) {
      throw Exception(
        "Matrices incompatibles : $colonnesA colonnes != $lignesB lignes",
      );
    }

    int lignes = this.values.length;
    int colonnes = m.values[0].length;
    int n = colonnesA;

    Matrix ans = Matrix(List.generate(lignes, (_) => List.filled(colonnes, 0)));

    for (int i = 0; i < lignes; i++) {
      for (int j = 0; j < colonnes; j++) {
        int somme = 0;
        for (int k = 0; k < n; k++) {
          somme += this.values[i][k] * m.values[k][j];
        }
        ans.values[i][j] = somme;
      }
    }

    return ans;
  }

  @override
  String toString() {
    int colWidth = values
        .expand((row) => row)
        .map((e) => e.toString().length)
        .reduce((a, b) => a > b ? a : b);

    String result = "";
    for (int i = 0; i < values.length; i++) {
      String row = values[i]
          .map((e) => e.toString().padLeft(colWidth))
          .join("  ");

      if (i == 0) {
        result += "⎡ $row ⎤\n";
      } else if (i == values.length - 1) {
        result += "⎣ $row ⎦\n";
      } else {
        result += "⎢ $row ⎥\n";
      }
    }
    return result;
  }
}

//exo 9

abstract class Shape {
  double area();
}

class Circle extends Shape {
  final int radius;
  Circle(int this.radius);

  @override
  double area() {
    return pi * pow(radius, 2);
  }
}

class Rectangle extends Shape {
  final double long;
  final double larg;
  Rectangle(double this.long, double this.larg);

  @override
  double area() {
    return long * larg;
  }
}

void main() {
  //exo 1.1
  List<int> listInt = [8, 6, 4, 84, 3, 2];
  listInt.sort((n1, n2) => n1.compareTo(n2));
  print(listInt);

  //exo1.2

  List<Map> data = [
    {"first": "Nadia", "last": "Mueller", "age": 10},
    {"first": "Lucas", "last": "Bernard", "age": 24},
    {"first": "Emma", "last": "Dupont", "age": 17},
    {"first": "Allan", "last": "Chiant", "age": 17},
    {"first": "Karim", "last": "Benali", "age": 32},
    {"first": "Sophie", "last": "Martin", "age": 45},
    {"first": "Théo", "last": "Rousseau", "age": 8},
    {"first": "Amina", "last": "Diallo", "age": 29},
    {"first": "Hugo", "last": "Petit", "age": 63},
  ];
  final persons = data
      .map<Person>((raw) => Person(raw["first"], raw["last"], raw["age"]))
      .toList();
  persons.sort((n1, n2) => n1.compareTo(n2));
  print(persons);

  //exo 2

  var L1 = [1, 2, 3, 4, 5, 6];
  var L2 = [4, 5, 6, 7, 8];

  print({...L1, ...L2});

  //exo 3
  Function curry(Function(dynamic, dynamic) f) {
    return (dynamic arg1) {
      return (dynamic arg2) {
        return f(arg1, arg2);
      };
    };
  }

  var add = curry((a, b) => a + b);

  var add5 = add(5);

  print(add5(3));

  //exo 4
  var L = [1, 2, 3, 4, 5, 6];
  print((L.reduce((sum, num) => sum + num)) / L.length);

  //exo 5

  int increment(int a) => a + 1;
  int decrement(int a) => a - 1;
  int zeroing(int a) => 0;
  int doubling(int a) => a * 2;
  int halving(int a) => a ~/ 2;

  List<Function(int)> funk = [
    increment,
    decrement,
    zeroing,
    increment,
    doubling,
    halving,
  ];

  int Function(int) compose(List<Function(int)> functions) {
    return (int a) {
      int result = a;
      for (var f in functions) {
        result =
            f(result) as int; // on passe le résultat à la fonction suivante
      }
      return result;
    };
  }

  var composed = compose(funk);
  print(composed(15));

  //exo 6

  int divideZeroHandled(int a, int b) {
    try {
      if (b == 0) throw "Division By Zero ERROR";
      return a ~/ b;
    } catch (e) {
      print("$e");
      return 0;
    }
  }

  print(divideZeroHandled(6, 3));
  print(divideZeroHandled(6, 0));

  //exo 7

  List<dynamic> numbers = [3, -2, 4, "hello", 5, -1, 2.5, 7];

  int sumOfSquares(List<dynamic> list) {
    int sum = 0;
    for (var n in list) {
      try {
        if (n is! int) throw "Valeur non entière : $n";
        if (n > 0) sum += n * n;
      } catch (e) {
        print("Exception ignored -> $e");
      }
    }
    return sum;
  }

  print(sumOfSquares(numbers));

  // Cas 1 : 2x3 * 3x2
  Matrix A = Matrix([
    [1, 2, 3],
    [4, 5, 6],
  ]);
  Matrix B = Matrix([
    [7, 8],
    [9, 10],
    [11, 12],
  ]);
  print((A + B).values);

  // Cas 2 : 2x2 * 2x2
  Matrix C = Matrix([
    [1, 2],
    [3, 4],
  ]);
  Matrix D = Matrix([
    [5, 6],
    [7, 8],
  ]);
  print((C * D).values);

  // Cas 4 : incompatible
  Matrix E = Matrix([
    [1, 2],
  ]);
  Matrix F = Matrix([
    [1, 2],
  ]);
  try {
    print((E * F).values);
  } catch (e) {
    print(e);
  }

  //main2();
  main3();
}

void main2() async {
  print("Starting Download...");
  fetchDownload();
  print("closing client.");
}

void main3() async {
  print("Starting Download...");
  var task = AsyncTask();

  await task.process();
  print("closing client.");
}

Future<void> fetchDownload() {
  return Future.delayed(
    const Duration(seconds: 2),
    () => print("Download finished successfully !"),
  );
}

class AsyncTask {
  Future<void> process() async {
    print("starting process...");
    await Future.delayed(
      const Duration(seconds: 2),
      () => print("process finished succesfully."),
    );
    return;
  }
}
