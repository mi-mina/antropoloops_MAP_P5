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
  float colorS = 0.0;
  float colorB = 0.0;

  if (colorPalette.equals("med_tammuriata")) {
    if (track == 0) {
      colorH = 36;
      colorS = 36;
      colorB = 100;
    } else if (track == 1) {
      colorH = 19;
      colorS = 62;
      colorB = 100;
    } else if (track == 2) {
      colorH = 358;
      colorS = 65;
      colorB = 88;
    } else if (track == 3) {
      colorH = 350;
      colorS = 91;
      colorB = 68;
    } else if (track == 4) {
      colorH = 30;
      colorS = 55;
      colorB = 100;
    } else if (track == 5) {
      colorH = 9;
      colorS = 63;
      colorB = 95;
    } else if (track == 6) {
      colorH = 352;
      colorS = 78;
      colorB = 79;
    } else if (track == 7) {
      colorH = 0;
      colorS = 100;
      colorB = 55;
    }
  } else if (colorPalette.equals("med_estrecho")) {
    if (track == 0) {
      colorH = 93;
      colorS = 15;
      colorB = 97;
    } else if (track == 1) {
      colorH = 168;
      colorS = 26;
      colorB = 68;
    } else if (track == 2) {
      colorH = 203;
      colorS = 100;
      colorB = 50;
    } else if (track == 3) {
      colorH = 177;
      colorS = 62;
      colorB = 75;
    } else if (track == 4) {
      colorH = 160;
      colorS = 18;
      colorB = 96;
    } else if (track == 5) {
      colorH = 188;
      colorS = 40;
      colorB = 53;
    } else if (track == 6) {
      colorH = 181;
      colorS = 59;
      colorB = 98;
    } else if (track == 7) {
      colorH = 173;
      colorS = 65;
      colorB = 60;
    }
  } else {
    colorS = random(50, 100);
    colorB = random(80, 100);

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
  }

  return color(colorH, colorS, colorB);
}
