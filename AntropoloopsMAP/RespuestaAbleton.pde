void oscEvent(OscMessage theOscMessage) {
  String path = theOscMessage.addrPattern();

  // Info about all the clips there are in Ableton (track, clip, name, color)
  if (path.equals("/live/name/clip")) {
    println("+++++++++++++Oyendo " + path + "++++++++++++++++");
    timerPuntoRojo.start(1);
    statePuntoRojo = 1;

    HashMap<String, Object> infoLoop = new HashMap<String, Object>();
    int track = (Integer)theOscMessage.arguments()[0];
    int clip = (Integer)theOscMessage.arguments()[1];
    infoLoop.put("trackLoop", track);
    infoLoop.put("clipLoop", clip);
    infoLoop.put("nombreLoop", theOscMessage.arguments()[2]);

    color trackColor = getColor("mundo", track);
    println("trackColor", trackColor);

    // Default info to prevent errors
    infoLoop.put("loopend", 8.0);
    infoLoop.put("volume", 0.5);
    infoLoop.put("solo", 0);
    infoLoop.put("mute", 0);
    infoLoop.put("delay", 0.0);
    infoLoop.put("send", 0.0);

    infoLoop.put("color", trackColor);

    miAntropoloops.put(infoLoop.get("trackLoop") + "-" + infoLoop.get("clipLoop"), infoLoop);
    println(infoLoop.get("trackLoop") + "-" + infoLoop.get("clipLoop"), "/", infoLoop);

    loopsIndexed.add(infoLoop.get("trackLoop") + "-" + infoLoop.get("clipLoop"));
    PImage thisImage = loadImage("../0_covers/" + (String)infoLoop.get("nombreLoop") + ".jpg");
    if (thisImage != null) {
      misImagenes.put(infoLoop.get("trackLoop") + "-" + infoLoop.get("clipLoop"), thisImage);
    }
  }

  // Message when all live/name/clip messages are sent
  if (path.equals("/live/name/clip/done")) {
    println("***********DONE************");
    //println(theOscMessage.arguments()[0]);
  }

  // Listener for clip state (clip (0), has clip (1), playing (2), triggered (3))
  if (path.equals("/live/clip/info")) {
    int claveTrack = theOscMessage.get(0).intValue();
    int claveClip = theOscMessage.get(1).intValue();
    int state = (Integer)theOscMessage.get(2).intValue();
    // println(claveTrack + "-" + claveClip + ": " + state);

    miAntropoloops.get(claveTrack + "-" + claveClip).put("state", state);
    // println("clip: ", miAntropoloops.get(claveTrack + "-" + claveClip));

    if (state == 2) {
      HashMap<String, Object> musicalParameters = miAntropoloops.get(claveTrack + "-" + claveClip);
      String songName = (String)musicalParameters.get("nombreLoop");
      if ((HashMap)loopsDB.get(songName) != null) {
        ultimoLoop = miAntropoloops.get(claveTrack + "-" + claveClip);
        // println(ultimoLoop);
        timerOnda.start(5);
        dibujaOnda = true;
        ultLoopParado = false;

        float dvolu = (Float)ultimoLoop.get("volume") * 100;
        // Averigua el tamaño del círculo para que la onda inicial sea del mismo tamaño
        if (dvolu <= 40) {
          diamOnda = dvolu * 3 / 4;
        } else if (40 < dvolu && dvolu <= 70) {
          diamOnda = (4 * dvolu - 70) / 3;
        } else if (dvolu > 70 && dvolu <= 80) {
          diamOnda= 5 * dvolu - 280;
        } else if (dvolu > 80) {
          diamOnda = 120;
        }
      }
    }
    if (state == 1) {
      if ((Integer)ultimoLoop.get("trackLoop") == claveTrack && (Integer)ultimoLoop.get("clipLoop") == claveClip) {
        ultLoopParado = true;
      }
    }

    // Send color messages to Ableton
    color myColor = (color)miAntropoloops.get(claveTrack + "-" + claveClip).get("color");
    colorMode(RGB, 255);
    int red = int(red(myColor));
    int green = int(green(myColor));
    int blue = int(blue(myColor));

    OscMessage colorMessage = new OscMessage("/live/clip/color");
    int[] params = {claveTrack, claveClip, red, green, blue};
    colorMessage.add(params);
    oscP5.send(colorMessage);
    colorMode(HSB, 360, 100, 100, 100);
  }

  if (path.equals("/live/play")) {
    // println("typetag /live/play: ", theOscMessage.typetag());
    playStop = theOscMessage.get(0).intValue();
    println("playStop ", playStop);
  }

  if (path.equals("/live/clip/loopend")) {
    timerPuntoVerde.start(1);
    statePuntoVerde = 1;
    ct1 = ct1 + 1;
    String idTrackClip = loopsIndexed.get(ct1);
    miAntropoloops.get(idTrackClip).put("loopend", theOscMessage.get(0).floatValue());
    // println("idTrackClip ", idTrackClip, "loopend ", theOscMessage.get(0).floatValue());
  }

  if (path.equals("/live/volume")) {
    for (int i = 0; i < loopsIndexed.size(); i++) {
      String claveClip = loopsIndexed.get(i);
      int[] a = int(split(claveClip, '-'));
      if (a[0] == theOscMessage.get(0).intValue()) {
        miAntropoloops.get(claveClip).put("volume", theOscMessage.get(1).floatValue());
      }
    }
  }

  if (path.equals("/live/solo")) {
    int trackId = theOscMessage.get(0).intValue();
    int soloActiveId = theOscMessage.get(1).intValue(); 
    soloActive.set(trackId, soloActiveId);

    for (int i = 0; i < loopsIndexed.size(); i++) {
      String claveClip = loopsIndexed.get(i);
      int[] a = int(split(claveClip, '-'));
      if (a[0] == trackId) {
        miAntropoloops.get(claveClip).put("solo", soloActiveId);
      }
    }
  }

  if (path.equals("/live/mute")) {
    int trackId = theOscMessage.get(0).intValue();
    int muteActiveId = theOscMessage.get(1).intValue();

    for (int i = 0; i < loopsIndexed.size(); i++) {
      String claveClip = loopsIndexed.get(i);
      int[] a = int(split(claveClip, '-'));
      if (a[0] == trackId) {
        miAntropoloops.get(claveClip).put("mute", muteActiveId);
      }
    }
  }

  if (path.equals("/live/tempo")) {
    timerPuntoVerde.start(1);
    statePuntoVerde = 1;

    tempo = theOscMessage.get(0).floatValue();
  }

  if (path.equals("/live/name/scene")) {
    sceneName = theOscMessage.get(0).toString();

    String[] parameters = sceneName.split(" ");
    if (parameters[7] != null && !parameters[7].equals("x")) {
      String[] geoZoneDataBg = parameters[7].split("_");
      geoZone = parameters[7];

      if (geoZoneDataBg.length == 1) {
        geoZoneData = parameters[7];
      } else if (geoZoneDataBg.length > 1) {
        geoZoneData = geoZoneDataBg[0];
      }

      // Set base map according to the scene
      if (loadImage("../1_BDatos/mapa_" + geoZone + ".jpg") != null) {
        backgroundMapBase = backgroundMapNew;
        backgroundMapNew = loadImage("../1_BDatos/mapa_" + geoZone + ".jpg");
        alpha = 0;
      } else {
        backgroundMapBase = loadImage("../1_BDatos/mapa_mundo.jpg");
        println("************************************************");
        println("No se ha encontrado ninguna imagen de fondo con el nombre: mapa_" + geoZone);
        println("************************************************");
      }

      // Load BDLugares acording to the scene
      if (loadJSONArray("../1_BDatos/BDlugares_" + geoZoneData + ".txt") != null) {
        misLugaresJSON = loadJSONArray("../1_BDatos/BDlugares_" + geoZoneData + ".txt");
        // Empty placesDB
        placesDB = new HashMap<String, HashMap<String, Object>>();

        for (int i = 0; i < misLugaresJSON.size(); i++) {
          HashMap<String, Object> coordenadas = new HashMap<String, Object>();

          coordenadas.put("coordX", misLugaresJSON.getJSONObject(i).getInt("coordX"));
          coordenadas.put("coordY", misLugaresJSON.getJSONObject(i).getInt("coordY"));
          placesDB.put(misLugaresJSON.getJSONObject(i).getString("lugar"), coordenadas);
        }
      } else {
        misLugaresJSON = loadJSONArray("../1_BDatos/BDlugares_mundo.txt");
        println("************************************************");
        println("No se ha encontrado ningún archivo con el nombre: BDlugares_" + geoZoneData);
        println("************************************************");
      }

      String geoZoneColors = geoZoneDataBg[0] + "_" + geoZoneDataBg[1];
      // Set colors according to scene
      for (int i = 0; i < loopsIndexed.size(); i++) {
        String claveClip = loopsIndexed.get(i);
        int[] a = int(split(claveClip, '-'));
        int track = a[0];
        miAntropoloops.get(claveClip).put("color", getColor(geoZoneColors, track));
      }
    }
  }

  if (path.equals("/live/delay")) {
    int trackId = theOscMessage.get(0).intValue();
    float delay = theOscMessage.get(1).floatValue();

    for (int i = 0; i < loopsIndexed.size(); i++) {
      String claveClip = loopsIndexed.get(i);
      int[] a = int(split(claveClip, '-'));
      if (a[0] == trackId) {
        miAntropoloops.get(claveClip).put("delay", delay);
      }
    }
  }

  if (path.equals("/live/send")) {
    int trackId = theOscMessage.get(0).intValue();
    float send = theOscMessage.get(1).floatValue();

    for (int i = 0; i < loopsIndexed.size(); i++) {
      String claveClip = loopsIndexed.get(i);
      int[] a = int(split(claveClip, '-'));
      if (a[0] == trackId) {
        miAntropoloops.get(claveClip).put("send", send);
      }
    }
  }

    if (path.equals("/live/filter")) {
    int trackId = theOscMessage.get(0).intValue();
    float filter = theOscMessage.get(1).floatValue();
    // filter is a float between 20 and 135
    // When there isn't any filter applied, the value is 135.

    for (int i = 0; i < loopsIndexed.size(); i++) {
      String claveClip = loopsIndexed.get(i);
      int[] a = int(split(claveClip, '-'));
      if (a[0] == trackId) {
        miAntropoloops.get(claveClip).put("filter", filter);
      }
    }
  }
}
