/*
 * Coded by MI-MI NA
 * www.mi-mina.com
 * for Antropoloops
 * www.antropoloops.com
 */

import oscP5.*;
import netP5.*;
import java.util.Map;
import java.util.Iterator;

OscP5 oscP5;
NetAddress myRemoteLocation;

int inPort = 9001;
int outPort = 9000;
// int outPort = 9000;

int alpha = 0;
PImage backgroundMapBase;
PImage backgroundMapNew;
boolean drawing=false;

HashMap<String, HashMap<String, Object>> miAntropoloops;
HashMap<String, HashMap<String, Object>> loopsDB;
HashMap<String, HashMap<String, Object>> placesDB;
HashMap<String, PImage> misImagenes;

ArrayList<String> loopsIndexed;

processing.data.JSONArray misLoopsJSON;
processing.data.JSONArray misLugaresJSON;

int playStop = 1;
HashMap<String, Object> ultimoLoop;

// Image resolution
float backgroundImageWidth = 1920;
float backgroundImageHeight = 1080;
// float backgroundImageHeight = 1200;
float imageRatio = backgroundImageWidth / backgroundImageHeight;

int ct1;
int m; //millis
int sceneNumber;
String sceneName;
String geoZoneData = "mundo";
String geoZone = "mundo";
float tempo;
float coordX, coordY, coordXOnda, coordYOnda;
float origenX, origenY;
float coverSide;
float ladoCuadrado;
float finalX;
float finalY;
int statePuntoRojo, statePuntoVerde;
boolean dibujaOnda, ultLoopParado;
IntList soloActive = new IntList();
Timer timerPuntoRojo, timerPuntoVerde, timerOnda;

Abanico[] misAbanicos;
Red[] miRed;

float v = 0;
float diamOnda;

//============================================================================
void setup() {
  size(displayWidth, displayHeight);
  if (frame != null) {
    surface.setResizable(true);
  }
  frameRate(10);

  backgroundMapBase = loadImage("../1_BDatos/default.jpg");
  backgroundMapNew = loadImage("../1_BDatos/default.jpg");

  colorMode(HSB, 360, 100, 100, 100);

  /* create a new osc properties object */
  OscProperties properties = new OscProperties();

  /* set a default NetAddress. sending osc messages with no NetAddress parameter
   * in oscP5.send() will be sent to the default NetAddress.
   */
  properties.setRemoteAddress("localhost", outPort);
  // properties.setRemoteAddress("192.168.1.35", outPort);

  /* the port number you are listening for incoming osc packets. */
  properties.setListeningPort(inPort);

  /* set the datagram byte buffer size. this can be useful when you send/receive
   * huge amounts of data, but keep in mind, that UDP is limited to 64k
   */
  properties.setDatagramSize(5000);

  /* initialize oscP5 with our osc properties */
  oscP5 = new OscP5(this, properties);
  //println("Estas son las propiedades "+properties.toString());

  statePuntoRojo = 0;
  statePuntoVerde = 0;
  dibujaOnda = false;
  timerPuntoRojo = new Timer(0);
  timerPuntoVerde = new Timer(0);
  timerOnda = new Timer(0);

  // Load data -------------------------------------------------
  misLoopsJSON = loadJSONArray ("../1_BDatos/BDloops.txt");
  misLugaresJSON = loadJSONArray ("../1_BDatos/BDlugares_mundo.txt");

  loopsDB = new HashMap<String, HashMap<String, Object>>();
  for (int i = 0; i < misLoopsJSON.size(); i++) {
    HashMap<String, Object> canciones = new HashMap<String, Object>();
    canciones.put("lugar", misLoopsJSON.getJSONObject(i).getString("lugar"));
    canciones.put("imagen", misLoopsJSON.getJSONObject(i).getString("nombreArchivo"));
    canciones.put("fecha", misLoopsJSON.getJSONObject(i).get("fecha"));
    canciones.put("artista", misLoopsJSON.getJSONObject(i).getString("artista"));
    canciones.put("album", misLoopsJSON.getJSONObject(i).getString("album"));
    canciones.put("titulo", misLoopsJSON.getJSONObject(i).getString("titulo"));
    loopsDB.put(misLoopsJSON.getJSONObject(i).getString("nombreArchivo"), canciones);
  }

  placesDB = new HashMap<String, HashMap<String, Object>>();
  for (int i = 0; i < misLugaresJSON.size(); i++) {
    HashMap<String, Object> coordenadas = new HashMap<String, Object>();
    coordenadas.put("coordX", misLugaresJSON.getJSONObject(i).getInt("coordX"));
    coordenadas.put("coordY", misLugaresJSON.getJSONObject(i).getInt("coordY"));
    placesDB.put(misLugaresJSON.getJSONObject(i).getString("lugar"), coordenadas);
  }

  misImagenes = new HashMap<String, PImage>();
  ultimoLoop = new HashMap<String, Object>();
} // End setup()

//=======================================================================
void draw() {
  background(#000000);
  float bWidth, bHeight, bX, bY, textX, textY, puntoX, puntoY;
  int dPuntos = 10;
  int paddingTexto = 10;
  int paddingPunto = 15;

  // La posición del background y del texto www.antropoloops.com cambia dependiendo
  // de la proporción de la pantalla.
  if (float(width) / float(height) >= imageRatio) {
    bWidth = height * imageRatio;
    bHeight = height;
    bX = (width - bWidth) / 2;
    bY = 0;
    textX = (width - bWidth) / 2 + paddingTexto + paddingPunto;
    textY = height - paddingTexto;
  } else {
    bWidth = width;
    bHeight = width / imageRatio;
    bX = 0;
    bY = 0;
    textX = paddingTexto + paddingPunto;
    textY = bHeight - paddingTexto;
  }

  if (alpha < 100) {
    alpha += 5;
  }

  if (alpha == 100) {
    backgroundMapBase = backgroundMapNew;
  }

  noStroke();
  image(backgroundMapBase, bX, bY, bWidth, bHeight);
  tint(360, alpha);
  image(backgroundMapNew, bX, bY, bWidth, bHeight);
  noTint();

  // Translucent rectangle on the bottom, to obscure the area of the map where the mp3 info is drawn.
  // if (!geoZoneData.equals("mundo")) {
  //   fill(0, 0, 0, 30);
  //   rect(0, finalY - ladoCuadrado, width, ladoCuadrado);
  // }
  // Translucent rectangle on the top, to obscure the area of the map where the covers are drawn.
  fill(0, 0, 17, 75);
  rect(0, 0, width, coverSide);

  if (timerPuntoRojo.isFinished()) {
    statePuntoRojo = 0;
  }
  if (timerPuntoVerde.isFinished()) {
    statePuntoVerde = 0;
  }
  if (timerOnda.isFinished()) {
    dibujaOnda = false;
  }

  if (float(width) / float(height) >= imageRatio) {
    puntoX = (width - bWidth) / 2 + paddingPunto;
    puntoY = height - paddingPunto;
  } else {
    puntoX = paddingPunto;
    puntoY = bHeight - paddingPunto;
  }

  if (statePuntoRojo == 1) {
    fill(0, 100, 100);
    ellipse(puntoX, puntoY, dPuntos, dPuntos);
  }
  if (statePuntoVerde == 1) {
    fill(360);
    ellipse(puntoX, puntoY, dPuntos, dPuntos);
  }

  switch(playStop) {
  case 0:
    break;

  case 1:
    if (miAntropoloops != null && drawing == true) {
      misAbanicos = new Abanico[miAntropoloops.size()];
      miRed = new Red[miAntropoloops.size()];
      m = millis();

      color trackColorU;
      float volu;

      // Dibuja una ONDA en el ÚLTIMO LOOP lanzado.
      if (!ultimoLoop.isEmpty()) { // primero compruebo que hay último loop para que no de error si no hay
        trackColorU = (color)ultimoLoop.get("color");
        volu = (Float)ultimoLoop.get("volume");

        if (dibujaOnda == true && volu > 0.05) {
          diamOnda = diamOnda + 8;
          String loopName = (String)ultimoLoop.get("nombreLoop");
          HashMap<String, Object> placeObject = (HashMap)loopsDB.get(loopName);
          String placeName = (String)placeObject.get("lugar");
          HashMap<String, Object> placeCoordinates = new HashMap<String, Object>();
          if ((HashMap)placesDB.get(placeName) != null) {
            int trackId = (Integer)ultimoLoop.get("trackLoop");
            if (!soloActive.hasValue(1) && soloActive.get(trackId) == 1) {
              println("Don't draw wave");
            } else {
              placeCoordinates = (HashMap)placesDB.get(placeName);
              stroke(trackColorU, 100 - diamOnda / 90);
              float a = 5 - diamOnda / 50;
              if (a < 0) { 
                a = 0;
              }
              strokeWeight(a);
              noFill();
              if (float(width) / float(height) >= imageRatio) {
                origenX = (width - (height * imageRatio)) / 2;
                coordXOnda = origenX + map((Integer)placeCoordinates.get("coordX"), 0, backgroundImageWidth, 0, height * imageRatio);
                coordYOnda = map((Integer)placeCoordinates.get("coordY"), 0, backgroundImageHeight, 0, height);
              } else if (float(width) / float(height) < imageRatio) {
                coordXOnda = map((Integer)placeCoordinates.get("coordX"), 0, backgroundImageWidth, 0, width);
                coordYOnda = map((Integer)placeCoordinates.get("coordY"), 0, backgroundImageHeight, 0, width / imageRatio);
              }
              ellipse(coordXOnda, coordYOnda, diamOnda, diamOnda);
              noStroke();
            }
          }
        }
      }
      // End of ONDA ÚLTIMO LOOP

      Iterator recorreMiAntropoloops = miAntropoloops.entrySet().iterator();
      while (recorreMiAntropoloops.hasNext()) {
        for (int index = 0; index < miAntropoloops.size(); index++) {
          Map.Entry me = (Map.Entry)recorreMiAntropoloops.next();
          HashMap<String, Object> loopParameters = (HashMap)me.getValue();
          
          // boolean stateIsSet = loopParameters.get("state") != null;
          // if (stateIsSet) {
            int state = (Integer)loopParameters.get("state");
            boolean soloState = soloState();
            // boolean muteIsSet = (Integer)loopParameters.get("mute") != null;
            int mute = (Integer)loopParameters.get("mute");
            int solo = (Integer)loopParameters.get("solo");
            if (state == 2) {
              if (!soloState && mute == 0) {
                drawLoops(loopParameters, index);
              } else if (soloState && solo == 1 && mute == 0) {
                drawLoops(loopParameters, index);
              } 
            } 
          // } 
        } 
      } 
    }
    break;
  } // End of switch

  // Draw antropoloops web
  textAlign(LEFT, BOTTOM);
  textSize(bWidth / 100);
  fill(255);
  text("www.antropoloops.com", textX, textY);
}

void drawLoops(HashMap loopParameters, int i) {
  String loopName = (String)loopParameters.get("nombreLoop"); //loopName = nombreLoop, que es el nombre del clip segun Ableton, o sea, el nombre del archivo

  if ((HashMap)loopsDB.get(loopName) != null) {
    HashMap<String, Object> miCancion = (HashMap)loopsDB.get(loopName);

    String placeName = (String)miCancion.get("lugar");
    String fecha = "";
    if (miCancion.get("fecha") instanceof Integer) {
      fecha = str((int)miCancion.get("fecha"));
    }

    color trackColor = (color)loopParameters.get("color");
    color placeTextColor = (color)loopParameters.get("placeTextColor");
    color dateTextColor = (color)loopParameters.get("dateTextColor");
    float vol = (Float)loopParameters.get("volume");
    float delay = (Float)loopParameters.get("delay");
    float send = (Float)loopParameters.get("send");
    float filter = (Float)loopParameters.get("filter");
    int position = (Integer)loopParameters.get("trackLoop");
    String imageIndex = loopParameters.get("trackLoop") + "-" + loopParameters.get("clipLoop");

    PImage miImagen = new PImage();
    // Check if there is an image
    if (misImagenes.get(imageIndex) != null) {
      miImagen = misImagenes.get(imageIndex);
    } else {
      println("************************************************");
      println("No se ha encontrado ninguna imagen con el nombre: " + loopName);
      println("************************************************");
    }

    HashMap<String, Object> coordinates = new HashMap<String, Object>();

    // Check if there is a place
    boolean isThereAPlace = false;
    if ((HashMap)placesDB.get(placeName) != null) {
      isThereAPlace = true;
      coordinates = (HashMap)placesDB.get(placeName);
    } else {
      isThereAPlace = false;
      coordinates.put("coordX", 0);
      coordinates.put("coordY", 0);
      println("************************************************");
      println("No se ha encontrado ningún lugar con el nombre: " + placeName);
      println("************************************************");
    }

    if (float(width) / float(height) >= imageRatio) {
      origenX = (width - (height * imageRatio)) / 2;
      coordX = origenX + map((Integer)coordinates.get("coordX"), 0, backgroundImageWidth, 0, height * imageRatio);
      coordY = map((Integer)coordinates.get("coordY"), 0, backgroundImageHeight, 0, height);
      coverSide = height * imageRatio / 8;
      finalX = width - (width - (height * imageRatio)) / 2;
      finalY = height;
      ladoCuadrado = height / 13;
    } else if (float(width) / float(height) < imageRatio) {
      coordX = map((Integer)coordinates.get("coordX"), 0, backgroundImageWidth, 0, width);
      coordY = map((Integer)coordinates.get("coordY"), 0, backgroundImageHeight, 0, width / imageRatio);
      coverSide = width / 8;
      finalX = width;
      finalY = width / imageRatio;
      ladoCuadrado = (width / imageRatio) / 13;
    }

    float alturaRect = coverSide / 10;
    int linSep = 0;
    float alturaText = alturaRect - 2;
    textSize(alturaText);

    float effect;

    if (delay > send) {
      effect = delay;
    } else {
      effect = send;
    }

    float normFilter = map(filter, 135, 20, 1, 0);

    float a = 0;
    if (vol * normFilter <= 0.45) {
      a = vol * normFilter * 223; // 100 / 0.45 = 223
    } else  if (vol * normFilter > 0.45) {
      a = 100;
    }

    if (isThereAPlace) {
      miRed[i] = new Red(
        coordX, 
        coordY, 
        (origenX + coverSide * position + coverSide * 0.02), 
        origenY + coverSide + linSep + alturaRect * 2.1, 
        trackColor, 
        a * 0.6);
      miRed[i].dibujaRed();
      fill(trackColor, a); 
      ellipse(origenX + coverSide * position + coverSide * 0.02, origenY + coverSide + linSep + alturaRect * 2.1, 3, 3);

      misAbanicos[i] = new Abanico(vol, effect, filter, trackColor);
      pushMatrix();
      translate(coordX, coordY);
      v = m / (60 / tempo * parseInt((Float)loopParameters.get("loopend")) * 1000 / 360);
      float sp = radians(v);
      rotate(sp);
      misAbanicos[i].dibuja();
      popMatrix();
    }

    textAlign(LEFT, CENTER);

    // Color rect under album cover
    fill(trackColor, a); 
    rect(origenX + (coverSide * position), origenY + coverSide + linSep, coverSide, alturaRect);
    // Place name
    fill(placeTextColor, a);
    text(placeName, coverSide * 0.04 + (origenX + (coverSide * position)), origenY + coverSide + alturaRect / 2 - 1);
    // Date
    fill(dateTextColor, a);
    text(fecha, coverSide * 0.04 + (origenX + (coverSide * position)), origenY + coverSide + linSep + alturaRect + linSep + alturaText / 2);
    // Album cover
    tint(360, a);
    image(miImagen, origenX + (coverSide * position), origenY, coverSide, coverSide);
    noTint();

    //Info cuadrado abajo derecha ultimo loop
    // textSize((ladoCuadrado - 13) / 3);
    // if (!ultimoLoop.isEmpty()) { // Compruebo que hay ultimo loop para que no de error
    //   if ((Integer)ultimoLoop.get("mute") != null) {
    //     if ((Integer)ultimoLoop.get("mute") == 0 && ultLoopParado == false) {
    //       // Si el último loop está muteado no se dibuja
    //       trackColorU = (color)ultimoLoop.get("color");
    //       volu = (Float)ultimoLoop.get("volume");

    //       fill(trackColorU, volu * 225);
    //       rect(finalX - ladoCuadrado, finalY - ladoCuadrado, ladoCuadrado, ladoCuadrado);

    //       String esteLoop = (String)ultimoLoop.get("nombreLoop");
    //       HashMap<String, Object> ultLoop = (HashMap)loopsDB.get(esteLoop);
    //       String artista = (String)ultLoop.get("artista");
    //       String titulo = (String)ultLoop.get("titulo");
    //       String album = (String)ultLoop.get("album");
    //       textAlign(RIGHT, CENTER);
    //       fill(230, volu * 223);
    //       text(titulo, finalX - (ladoCuadrado + 7), finalY - ((ladoCuadrado - 12) / 3 * 2.5 + 11));
    //       text(artista, finalX - (ladoCuadrado + 7), finalY - ((ladoCuadrado - 12) / 3 * 1.5 + 9));
    //       text(album, finalX - (ladoCuadrado + 7), finalY - ((ladoCuadrado - 12) / 3 * 0.5 + 6));
    //       textAlign(LEFT, CENTER);

    //       fill(0, 0, 17, volu * 223);
    //       text("title", finalX - (ladoCuadrado - 4), finalY - ((ladoCuadrado - 12) / 3 * 2.5 + 11));
    //       text("artist", finalX - (ladoCuadrado - 4), finalY - ((ladoCuadrado - 12) / 3 * 1.5 + 9));
    //       text("album", finalX - (ladoCuadrado - 4), finalY - ((ladoCuadrado - 12) / 3 * 0.5 + 6));
    //     }
    //   } // Fin info cuadrado abajo derecha ultimo loop
    // }
  } else {
    println("************************************************");
    println("No se ha encontrado ningún antropoloops con el nombre: " + loopName);
    println("************************************************");
  }
}

void keyPressed() {
  if (key == '1') {
    loopsIndexed = new ArrayList<String>();
    miAntropoloops = new HashMap();
    remapea();
  } else if (key == '2') {
    ct1 = -1;
    println("Lanzo pregunta");
    pregunta();
  } else if (key == '3') {
    drawing = true;
    println("draw running");
  } else if (key == '4') {
    println(loopsIndexed);
  } else if (key == '5') {
    println("miAntropoloops: " + miAntropoloops);
    println("loopsDB: " + loopsDB);
  }
}
