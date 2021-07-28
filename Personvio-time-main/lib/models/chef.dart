class Chef {
  String chefName;
  String age;
  String experience;
  String speciality;
  String rating;
  String id;

  Chef(this.id, this.chefName, this.age, this.rating, this.experience,
      this.speciality);

  // Food.fromMap(Map<String, dynamic> data) {
  //   displayName = data['displayName'];
  //   email = data['email'];
  //   password = data['password'];
  //   uuid = data['uuid'];
  //   role = data['role'];
  //   balance = data['balance'];
  // }

  //Map<String, dynamic> toMapForCart() {
  //Map<String, dynamic> map = {};
  //map['item_id'] = id;
  // map['count'] = 1;
  // return map;
  //}
}
