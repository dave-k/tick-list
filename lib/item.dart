
class Item {
  String title;
  bool done;

  Item({
    this.title,
    this.done = false,
  });

  Item.fromMap(Map map) :
    this.title = map['title'],
    this.done = map['done'];

  Map toMap() {
    return {
      'title': this.title,
      'done': this.done,
    };
  }
}