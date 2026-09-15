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
}

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
