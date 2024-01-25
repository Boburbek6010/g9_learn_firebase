class Car {
  String name;
  String color;
  int speed;
  double cost;
  int madeYear;
  String type;

  Car(
      {required this.name,
      required this.color,
      required this.cost,
      required this.speed,
      required this.madeYear,
      required this.type}
);


  Map<String, dynamic>toJson(){
    return{
      "name":name,
      "color":color,
      "speed":speed,
      "cost":cost,
      "madeYear":madeYear,
      "type":type,
    };
  }

}
