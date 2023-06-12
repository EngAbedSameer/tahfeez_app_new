class MapStyle {
  printMap(Map map) {
    print("{ \n");
    map.entries.forEach((entrity) {
      print(" " + entrity.key.toString() + " : " + entrity.value.toString());
    });
    print("} \n");
  }
}
