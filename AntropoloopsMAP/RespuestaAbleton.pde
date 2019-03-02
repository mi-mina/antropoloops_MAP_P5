//Todos los Eventos que escuchamos de Ableton

void oscEvent(OscMessage theOscMessage) {
  String path = theOscMessage.addrPattern();

  //Nos da la info de todos los clips que hay (track, clip, name, color)
  if (path.equals("/live/name/clip")) {
    println("+++++++++++++Oyendo " + path + "++++++++++++++++");
    // println("typetag: ", theOscMessage.typetag());
    timerPuntoRojo.start(1);
    statePuntoRojo = 1;

    HashMap<String, Object> infoLoop = new HashMap<String, Object>();
    infoLoop.put("trackLoop", theOscMessage.arguments()[0]);
    infoLoop.put("clipLoop", theOscMessage.arguments()[1]);
    infoLoop.put("nombreLoop", theOscMessage.arguments()[2]);

    // Información por defecto para que no pete si se hace un remapeo automático
    // y no se ha lanzado el método pregunta todavía.
    infoLoop.put("loopend", 8.0);
    infoLoop.put("volume", 0.5);
    infoLoop.put("solo", 0);
    infoLoop.put("mute", 0);

    infoLoop.put("colorS", random(50, 100));
    infoLoop.put("colorB", random(80, 100));

    if ((Integer)theOscMessage.arguments()[0] == 0) {
      infoLoop.put("colorH", random(105, 120));
    } else if ((Integer)theOscMessage.arguments()[0] == 1) {
      infoLoop.put("colorH", random(145, 160));
    } else if ((Integer)theOscMessage.arguments()[0] == 2) {
      infoLoop.put("colorH", random(300, 315));
    } else if ((Integer)theOscMessage.arguments()[0] == 3) {
      infoLoop.put("colorH", random(330, 345));
    } else if ((Integer)theOscMessage.arguments()[0] == 4) {
      infoLoop.put("colorH", random(190, 205));
    } else if ((Integer)theOscMessage.arguments()[0] == 5) {
      infoLoop.put("colorH", random(210, 225));
    } else if ((Integer)theOscMessage.arguments()[0] == 6) {
      infoLoop.put("colorH", random(25, 40));
    } else if ((Integer)theOscMessage.arguments()[0] == 7) {
      infoLoop.put("colorH", random(50, 65));
    }

    miAntropoloops.put(infoLoop.get("trackLoop") + "-" + infoLoop.get("clipLoop"), infoLoop);
    println(infoLoop.get("trackLoop") + "-" + infoLoop.get("clipLoop"), "/", infoLoop);
    //infoLoop.get("nombreLoop")
    loopsIndexed.add(infoLoop.get("trackLoop") + "-" + infoLoop.get("clipLoop"));
    //println(loopsIndexed);
    PImage thisImage = loadImage("../0_covers/" + (String)infoLoop.get("nombreLoop") + ".jpg");
    if (thisImage != null) {
      // println("saving image ", (String)infoLoop.get("nombreLoop"));
      misImagenes.put(infoLoop.get("trackLoop") + "-" + infoLoop.get("clipLoop"), thisImage);
    }
    // println("loopsIndexed ", loopsIndexed);
  }

  // Me avisa cuando live/name/clip ha terminado de lanzar mensajes
  // Es un path que he añadido yo a LiveOSC
  if (path.equals("/live/name/clip/done")) {
    println("***********DONE************");
    //println(theOscMessage.arguments()[0]);
  }

  //Aquí escuchamos si un clip cambia de estado (clip (0), has clip (1), playing (2), triggered (3))
  if (path.equals("/live/clip/info")) {
    // println("typetag /live/clip/info: ", theOscMessage.typetag());
    int claveTrack = theOscMessage.get(0).intValue();
    int claveClip = theOscMessage.get(1).intValue();
    int state = (Integer)theOscMessage.get(2).intValue();
    println(claveTrack + "-" + claveClip + ": " + state);
    

    miAntropoloops.get(claveTrack + "-" + claveClip).put("state", state);
    println("miAntropoloops", miAntropoloops.get(claveTrack + "-" + claveClip));

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
  }

  if (path.equals("/live/play")) {
    // println("typetag /live/play: ", theOscMessage.typetag());
    playStop = theOscMessage.get(0).intValue();
    println("playStop ", playStop);
  }

  if (path.equals("/live/clip/loopend")) {
    // println("typetag /live/clip/loopend: ", theOscMessage.typetag());
    timerPuntoVerde.start(1);
    statePuntoVerde = 1;
    ct1 = ct1 + 1;
    String idTrackClip = loopsIndexed.get(ct1);
    miAntropoloops.get(idTrackClip).put("loopend", theOscMessage.get(0).floatValue());
    // println("idTrackClip ", idTrackClip, "loopend ", theOscMessage.get(0).floatValue());
    // println("miAntropoloops ", miAntropoloops);
  }

  if (path.equals("/live/volume")) {
    // println("typetag /live/volume: ", theOscMessage.typetag());
    for (int i = 0; i < loopsIndexed.size(); i++) {
      String claveClip = loopsIndexed.get(i);
      int[] a = int(split(claveClip, '-'));
      if (a[0] == theOscMessage.get(0).intValue()) {
        miAntropoloops.get(claveClip).put("volume", theOscMessage.get(1).floatValue());
        // println("trackId ", theOscMessage.get(0).intValue(), " / volume", theOscMessage.get(1).floatValue());
      }
    }
  }

  if (path.equals("/live/solo")) {
    // println("typetag /live/solo: ", theOscMessage.typetag());
    int trackId = theOscMessage.get(0).intValue();
    int soloActiveId = theOscMessage.get(1).intValue(); 
    soloActive.set(trackId, soloActiveId);

    for (int i = 0; i < loopsIndexed.size(); i++) {
      String claveClip = loopsIndexed.get(i);
      int[] a = int(split(claveClip, '-'));
      if (a[0] == trackId) {
        miAntropoloops.get(claveClip).put("solo", soloActiveId);
        // println("trackId ", trackId, " / solo ", soloActiveId);
      }
    }
  }

  if (path.equals("/live/mute")) {
    // println("typetag /live/mute: ", theOscMessage.typetag());
    int trackId = theOscMessage.get(0).intValue();
    int muteActiveId = theOscMessage.get(1).intValue();

    for (int i = 0; i < loopsIndexed.size(); i++) {
      String claveClip = loopsIndexed.get(i);
      int[] a = int(split(claveClip, '-'));
      if (a[0] == trackId) {
        miAntropoloops.get(claveClip).put("mute", muteActiveId);
        // println("trackId ", trackId, " / mute ", muteActiveId);
      }
    }
  }

  if (path.equals("/live/tempo")) {
    // println("typetag /live/tempo: ", theOscMessage.typetag());
    timerPuntoVerde.start(1);
    statePuntoVerde = 1;

    tempo = theOscMessage.get(0).floatValue();
    // println("tempo: ", tempo);
  }

  // if (path.equals("/live/scene")) {
  //   // Listens if a scene has been selected.
  //   // The received number is the scene position, starting the enumeration at 1.
  //   sceneNumber = theOscMessage.get(0).intValue();
  //   // println("sceneNumber " + sceneNumber);
  //   // println("Scene number " + sceneNumber + " has been selected");

  //   // To get the scene name, I send a new message
  //   OscMessage sceneMessage = new OscMessage("/live/name/scene");
  //   // In order to ask by the scene name, I don't know why, the enumaration of the scenes
  //   // starts at 0, as usual, that's why I have to substract 1 to sceneNumber.
  //   sceneMessage.add(sceneNumber - 1);
  //   oscP5.send(sceneMessage);
  //   // println("Asking by scene " + (sceneNumber - 1));
  // }

  if (path.equals("/live/name/scene")) {
    // println("typetag /live/name/scene: ", theOscMessage.typetag());
    sceneName = theOscMessage.get(0).toString();
    println("sceneName " + sceneName);
    String[] parameters = sceneName.split(" ");
    if (parameters[7] != null) {
      geoZone = parameters[7];

      if (loadImage("../1_BDatos/mapa_" + geoZone + ".jpg") != null) {
        backgroundMap = loadImage("../1_BDatos/mapa_" + geoZone + ".jpg");
      } else {
        backgroundMap = loadImage("../1_BDatos/mapa_mundo.jpg");
        println("************************************************");
        println("No se ha encontrado ninguna imagen de fondo con el nombre: mapa_" + geoZone);
        println("************************************************");
      }

      if (loadJSONArray("../1_BDatos/BDlugares_" + geoZone + ".txt") != null) {
        misLugaresJSON = loadJSONArray("../1_BDatos/BDlugares_" + geoZone + ".txt");

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
        println("No se ha encontrado ningún archivo con el nombre: BDlugares_" + geoZone);
        println("************************************************");
      }
    }
  }
}
