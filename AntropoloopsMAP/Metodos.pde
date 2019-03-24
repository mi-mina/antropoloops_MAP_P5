boolean soloState() {
  HashMap<String, Integer> soloState = new HashMap<String, Integer>();

  // Create a deep copy of miAntropoloops HashMap
  HashMap<String, HashMap<String, Object>> miAntropoloopsCopy = new HashMap<String, HashMap<String, Object>>();

  for(HashMap.Entry<String, HashMap<String, Object>> entry : miAntropoloops.entrySet()){
      miAntropoloopsCopy.put(entry.getKey(), new HashMap<String, Object>(entry.getValue()));
  }

//   for (Map.Entry<Integer, int[]> entry : originalMatrix.entrySet()) {
//     newMatrix.put(entry.getKey(), entry.getValue().clone());
// }

  // Copy miAntropoloops content into miAntropoloopsCopy
  // println("miAntropoloopsCopy: "+miAntropoloopsCopy);

  Iterator soloInfo = miAntropoloopsCopy.entrySet().iterator();

  while (soloInfo.hasNext ()) {
    for (int i = 0; i < miAntropoloopsCopy.size(); i++) {
      Map.Entry me = (Map.Entry)soloInfo.next();
      HashMap<String, Object> soloClip = (HashMap)me.getValue();

      soloState.put(Integer.toString(i), (Integer)soloClip.get("solo"));
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
      colorB = 60;
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
  } else if (colorPalette.equals("med_desierto")) {
    if (track == 0) {
      colorH = 197;
      colorS = 29;
      colorB = 70;
    } else if (track == 1) {
      colorH = 6;
      colorS = 56;
      colorB = 74;
    } else if (track == 2) {
      colorH = 257;
      colorS = 26;
      colorB = 80;
    } else if (track == 3) {
      colorH = 358;
      colorS = 78;
      colorB = 60;
    } else if (track == 4) {
      colorH = 286;
      colorS = 33;
      colorB = 60;
    } else if (track == 5) {
      colorH = 10;
      colorS = 76;
      colorB = 70;
    } else if (track == 6) {
      colorH = 329;
      colorS = 47;
      colorB = 75;
    } else if (track == 7) {
      colorH = 17;
      colorS = 66;
      colorB = 61;
    }
  } else if (colorPalette.equals("med_rondena")) {
    if (track == 0) {
      colorH = 58;
      colorS = 59;
      colorB = 85;
    } else if (track == 1) {
      colorH = 109;
      colorS = 52;
      colorB = 70;
    } else if (track == 2) {
      colorH = 195;
      colorS = 69;
      colorB = 77;
    } else if (track == 3) {
      colorH = 56;
      colorS = 63;
      colorB = 60;
    } else if (track == 4) {
      colorH = 179;
      colorS = 60;
      colorB = 68;
    } else if (track == 5) {
      colorH = 144;
      colorS = 70;
      colorB = 60;
    } else if (track == 6) {
      colorH = 180;
      colorS = 12;
      colorB = 70;
    } else if (track == 7) {
      colorH = 165;
      colorS = 65;
      colorB = 61;
    }
  } else if (colorPalette.equals("med_delfines") || colorPalette.equals("med_fin")) {
    if (track == 0) {
      colorH = 0;
      colorS = 87;
      colorB = 64;
    } else if (track == 1) {
      colorH = 35;
      colorS = 80;
      colorB = 89;
    } else if (track == 2) {
      colorH = 49;
      colorS = 91;
      colorB = 70;
    } else if (track == 3) {
      colorH = 21;
      colorS = 83;
      colorB = 88;
    } else if (track == 4) {
      colorH = 49;
      colorS = 76;
      colorB = 85;
    } else if (track == 5) {
      colorH = 28;
      colorS = 86;
      colorB = 91;
    } else if (track == 6) {
      colorH = 42;
      colorS = 76;
      colorB = 87;
    } 
    // else if (track == 7) {
    //   colorH = 10;
    //   colorS = 58;
    //   colorB = 88;
    // }
    else if (track == 7) {
      colorH = 189;
      colorS = 91;
      colorB = 79;
    }
  } else if (colorPalette.equals("med_alba")) {
    if (track == 0) {
      colorH = 0;
      colorS = 0;
      colorB = 100;
    } else if (track == 1) {
      colorH = 0;
      colorS = 0;
      colorB = 85;
    } else if (track == 2) {
      colorH = 0;
      colorS = 0;
      colorB = 76;
    } else if (track == 3) {
      colorH = 0;
      colorS = 0;
      colorB = 95;
    } else if (track == 4) {
      colorH = 0;
      colorS = 0;
      colorB = 67;
    } else if (track == 5) {
      colorH = 0;
      colorS = 0;
      colorB = 81;
    } else if (track == 6) {
      colorH = 0;
      colorS = 0;
      colorB = 71;
    } else if (track == 7) {
      colorH = 0;
      colorS = 0;
      colorB = 90;
    }
  } else {
    colorS = random(50, 100);
    colorB = random(80, 100);
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
