boolean soloState() {
  HashMap<String, Integer> soloState = new HashMap<String, Integer>();
  Iterator soloInfo = miAntropoloops.entrySet().iterator();
  while (soloInfo.hasNext ()) {
    for (int i = 0; i < miAntropoloops.size(); i++) {
      Map.Entry me = (Map.Entry)soloInfo.next();
      HashMap<String, Object> soloClip = (HashMap)me.getValue();

      soloState.put(Integer.toString(i), (Integer)soloClip.get("solo"));
      if (soloState.containsValue(1) == true) {
      }
    }
  }

  return soloState.containsValue(1);
}

color getColor (String colorPalette, int track) {
    float colorH = 0.0;
    float colorS = random(50, 100);
    float colorB = random(80, 100);

    // Assign colors randomly within a range
    if (track == 0) {
      colorH = random(105, 120);
    } else if (track == 1) {
      colorH = random(145, 160);
    } else if (track == 2) {
      colorH = random(300, 315);
    } else if (track == 3) {
      colorH = random(330, 345);
    } else if (track == 4) {
      colorH = random(190, 205);
    } else if (track == 5) {
      colorH = random(210, 225);
    } else if (track == 6) {
      colorH = random(25, 40);
    } else if (track == 7) {
      colorH = random(50, 65);
    }

    return color(colorH, colorS, colorB);
}