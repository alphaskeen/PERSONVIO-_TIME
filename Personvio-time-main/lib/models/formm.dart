class Formm {
  String no;
  String date;
  String time;
  String preference;
  String meals;
  String course;

  Formm();

  Formm.fromMap(Map<String, dynamic> data) {
    no = data['no'];
    date = data['date'];
    time = data['time'];
    preference = data['preference'];
    meals = data['meals'];
    course = data['course'];
  }

  Map<String, dynamic> toMap() {
    return {
      'no': no,
      'date': date,
      'time': time,
      'preference': preference,
      'meals': meals,
      'course': course,
    };
  }
}
