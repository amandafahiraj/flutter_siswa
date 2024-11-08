import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/student.dart';

class Student {
  final String id;
  String name;
  String age;
  String major;

  Student({
    required this.id,
    required this.name,
    required this.age,
    required this.major,
  });
}

class Students with ChangeNotifier {
  List<Student> _allStudent = [];

  List<Student> get allStudent => _allStudent;

  int get jumlahStudent => _allStudent.length;

  Student selectById(String id) {
    return _allStudent.firstWhere((element) => element.id == id);
  }

  Future<void> initialData() async {
    Uri url = Uri.parse("http://localhost/flutter/student.php/student");
    
    var hasilGetData = await http.get(url);
    List<Map<String, dynamic>> dataResponse = 
        List.from(json.decode(hasilGetData.body) as List);
    
    for (int attribute = 0; attribute < dataResponse.length; attribute++) {
      _allStudent.add(
        Student(
          id: dataResponse[attribute]["id"],
          name: dataResponse[attribute]["name"],
          age: dataResponse[attribute]["age"],
          major: dataResponse[attribute]["major"],
        ),
      );
    }
    
    print("BERHASIL MASUKAN DATA LIST");
    notifyListeners();
  }

  void editStudent(
    String id,
    String name,
    String age,
    String major,
    BuildContext context,
  ) {
    Student selectPlayer = 
        _allStudent.firstWhere((element) => element.id == id);
    selectPlayer.name = name;
    selectPlayer.age = age;
    selectPlayer.major = major;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Berhasil diubah"),
        duration: Duration(seconds: 2),
      ),
    );
    notifyListeners();
  }

  void deletePlayer(String id, BuildContext context) {
    _allStudent.removeWhere((element) => element.id == id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Berhasil dihapus"),
        duration: Duration(milliseconds: 500),
      ),
    );
    notifyListeners();
  }

  Future<void> addStudent(
    String name,
    String age,
    String major,
    BuildContext context,
  ) async {
    Uri url = Uri.parse("http://localhost/flutter/student.php/student");
    
    var response = await http.post(
      url,
      body: {
        "name": name,
        "age": age,
        "major": major,
      },
    );

    print("THEN FUNCTION");
    print(json.decode(response.body));
    Student student = selectById(json.decode(response.body)["id"]);
    
    _allStudent.add(
      Student(
        id: json.decode(response.body)["id"],
        name: name,
        age: age,
        major: major,
      ),
    );
    
    notifyListeners();
  }
}