/*
 * Needs OSCLive from http://livecontrol.q3f.org/ableton-liveapi/liveosc/
 * to be installed within Ableton
 * complete List of OSC calls at http://monome.q3f.org/browser/trunk/LiveOSC/OSCAPI.txt
 *
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
PImage mundi;
boolean drawing=false;

HashMap<String, HashMap<String, Object>> miAntropoloops ;
HashMap<String, HashMap<String, Object>> todosMisLoops;
HashMap<String, HashMap<String, Object>> todosMisLugares;
HashMap<String, PImage> misImagenes;

ArrayList<String> loopsIndexed;

processing.data.JSONArray misLoopsJSON;
processing.data.JSONArray misLugaresJSON;

int playStop = 1;
HashMap<String, Object> ultimoLoop;

int ct1;
int m; //millis
float tempo;
float coordX, coordY, coordXOnda, coordYOnda;
float origenX, origenY;
float ladoCaratula;
float ladoCuadrado;
float finalX;
float finalY;
String web;
int statePuntoRojo, statePuntoVerde;
boolean dibujaOnda, ultLoopParado;
Timer timerPuntoRojo, timerPuntoVerde, timerOnda;

Abanico[] misAbanicos;
Red[] miRed;

float v = 0;
float d;

//============================================================================
void setup() {
  size(displayWidth, displayHeight);
  if (frame != null) {
    frame.setResizable(true);
  }
  frameRate(7);

  mundi = loadImage("mapa_1728x1080.jpg");
  colorMode(HSB, 360, 100, 100, 100);
  // PFont font;
  // font= loadFont("ArialMT-20.vlw");

  /* create a new osc properties object */
  OscProperties properties = new OscProperties();
  /* set a default NetAddress. sending osc messages with no NetAddress parameter
   * in oscP5.send() will be sent to the default NetAddress.
   */
  properties.setRemoteAddress("localhost", outPort);
   /* the port number you are listening for incoming osc packets. */
  properties.setListeningPort(inPort);
  /* set the datagram byte buffer size. this can be useful when you send/receive
   * huge amounts of data, but keep in mind, that UDP is limited to 64k
  */
  properties.setDatagramSize(5000);
   /* initialize oscP5 with our osc properties */
  oscP5 = new OscP5(this,properties);
  //println("Estas son las propiedades "+properties.toString());

  statePuntoRojo = 0;
  statePuntoVerde = 0;
  dibujaOnda = false;
  timerPuntoRojo = new Timer(0);
  timerPuntoVerde = new Timer(0);
  timerOnda = new Timer(0);

  //**********Cargo los datos de las Bases de Datos***************
  misLoopsJSON = loadJSONArray ("BDloops.txt");
  misLugaresJSON = loadJSONArray ("BDlugares.txt");

  todosMisLoops = new HashMap<String, HashMap<String, Object>>();
  for (int i = 0; i < misLoopsJSON.size(); i++) {
    HashMap<String, Object> canciones = new HashMap<String, Object>();
    canciones.put("lugar", misLoopsJSON.getJSONObject(i).getString("lugar"));
    canciones.put("imagen", misLoopsJSON.getJSONObject(i).getString("nombreArchivo"));
    canciones.put("fecha", misLoopsJSON.getJSONObject(i).getString("fecha"));
    canciones.put("artista", misLoopsJSON.getJSONObject(i).getString("artista"));
    canciones.put("album", misLoopsJSON.getJSONObject(i).getString("album"));
    canciones.put("titulo", misLoopsJSON.getJSONObject(i).getString("titulo"));
    todosMisLoops.put(misLoopsJSON.getJSONObject(i).getString("nombreArchivo"), canciones);
  }

  todosMisLugares = new HashMap<String, HashMap<String, Object>>();
  for (int i = 0; i < misLugaresJSON.size(); i++) {
    HashMap<String, Object> coordenadas = new HashMap<String, Object>();
    coordenadas.put("coordX", misLugaresJSON.getJSONObject(i).getInt("coordX"));
    coordenadas.put("coordY", misLugaresJSON.getJSONObject(i).getInt("coordY"));
    todosMisLugares.put(misLugaresJSON.getJSONObject(i).getString("lugar"), coordenadas);
  }
  misImagenes = new HashMap<String, PImage>();
  ultimoLoop = new HashMap<String, Object>();
  web = "www.antropoloops.com";
} // End setup()

//=======================================================================
void draw() {
  background(#000000);
  float bWidth, bHeight, bX, bY, textX, textY;
  float puntoX, puntoY;
  int dPuntos = 10;
  int paddingTexto = 10;
  int paddingPunto = 15;

  // La posición del background y del texto www.antropoloops.com cambia dependiendo
  // de la proporción de la pantalla.
  if (float(width) / float(height) >= 1.6) { //El tamaño de la imagen de fondo es 1280x800. 1280/800=1.6
    bWidth = height * 1.6;
    bHeight = height;
    bX = (width - bWidth) / 2;
    bY = 0;
    textX = (width - bWidth) / 2 + paddingTexto + paddingPunto;
    textY = height - paddingTexto;
  } else {
    bWidth = width;
    bHeight = width / 1.6;
    bX = 0;
    bY = (height - bHeight) / 2;
    textX = paddingTexto;
    textY = (height + bHeight) / 2 - paddingTexto + paddingPunto;
  }

  image(mundi, bX, bY, bWidth, bHeight);
  textAlign(LEFT, BOTTOM);
  textSize(bWidth / 100);
  fill(255);
  text("www.antropoloops.com", textX, textY);

  if (timerPuntoRojo.isFinished()) {
    statePuntoRojo = 0;
  }
  if (timerPuntoVerde.isFinished()) {
    statePuntoVerde = 0;
  }
  if (timerOnda.isFinished()) {
    dibujaOnda = false;
  }

  noStroke();
  if (float(width) / float(height) >= 1.6) {
    puntoX = (width - bWidth) / 2 + paddingPunto;
    puntoY = height - paddingPunto;
    if (statePuntoRojo == 1) {
      fill(150);
      ellipse(puntoX, puntoY, dPuntos, dPuntos);
    }
    if (statePuntoVerde == 1) {
      fill(360);
      ellipse(puntoX, puntoY, dPuntos, dPuntos);
    }
  } else {
    puntoX = paddingPunto;
    puntoY = (height + bHeight) / 2 - paddingPunto;
    if (statePuntoRojo == 1) {
      fill(150);
      ellipse(puntoX, puntoY, dPuntos, dPuntos);
    }
    if (statePuntoVerde == 1) {
      fill(360);
      ellipse(puntoX, puntoY, dPuntos, dPuntos);
    }
  }

  switch(playStop) {
    case 1:
      break;

    case 2:
      if (miAntropoloops != null && drawing == true) {
        misAbanicos = new Abanico[miAntropoloops.size()];
        miRed = new Red[miAntropoloops.size()];
        m = millis();

        float hu = (Float)ultimoLoop.get("colorH");
        float su = (Float)ultimoLoop.get("colorS");
        float bu = (Float)ultimoLoop.get("colorB");
        float volu = (Float)ultimoLoop.get("volume");

        if (dibujaOnda == true && volu > 0.05) {
          d = d + 4;
          String ondaLoop = (String)ultimoLoop.get("nombreLoop");
          HashMap<String, Object> ondaLugar = (HashMap)todosMisLoops.get(ondaLoop);
          String miOndaLugar = (String)ondaLugar.get("lugar");
          HashMap<String, Object> ondaCoordenadas = (HashMap)todosMisLugares.get(miOndaLugar);

          stroke(hu, su, bu, 100 - d / 90);
          float a = (500 * (d * d)) / ((d * d) + 50);
          strokeWeight(500 - a);
          noFill();
          if (float(width) / float(height) >= 1.6) {
            coordXOnda = origenX + map((Integer)ondaCoordenadas.get("coordX"), 0, 1280, 0, height * 1.6);
            coordYOnda = map((Integer)ondaCoordenadas.get("coordY"), 0, 800, 0, height);
            ellipse(coordXOnda, coordYOnda, d, d);
          }
          else if (float(width) / float(height) < 1.6) {
            coordXOnda = map((Integer)ondaCoordenadas.get("coordX"), 0, 1280, 0, width);
            coordYOnda = origenY + map((Integer)ondaCoordenadas.get("coordY"), 0, 800, 0, width / 1.6);
            ellipse(coordXOnda, coordYOnda, d, d);
          }
        }

        Iterator recorreMiAntropoloops = miAntropoloops.entrySet().iterator();
        while (recorreMiAntropoloops.hasNext ()) {
          for (int i = 0; i < miAntropoloops.size(); i++) {
            Map.Entry me = (Map.Entry)recorreMiAntropoloops.next();
            HashMap<String, Object> unClip = (HashMap)me.getValue();

            if (unClip.get("state") != null) {
              if ((Integer)unClip.get("state") == 2) {
                if (!soloState()) {
                  if ((Integer)unClip.get("mute") != null && (Integer)unClip.get("mute") == 0) {
                    String nCancion=(String)unClip.get("nombreLoop"); //nCancion = nombreLoop, que es el nombre del clip segun Ableton, o sea, el nombre del archivo
                    HashMap<String, Object> miCancion=(HashMap)todosMisLoops.get(nCancion);
                    String elLugar=(String)miCancion.get("lugar");
                    HashMap<String, Object> lugar=(HashMap)todosMisLugares.get(elLugar);

                    if (float(width) / float(height) >= 1.6) {
                      origenX = (width - (height * 1.6)) / 2;
                      origenY = 0;
                      coordX = origenX + map((Integer)lugar.get("coordX"), 0, 1280, 0, height * 1.6);
                      coordY = map((Integer)lugar.get("coordY"), 0, 800, 0, height);
                      ladoCaratula = height * 1.6 / 8;
                      finalX = width - (width - (height * 1.6)) / 2;
                      finalY = height;
                      ladoCuadrado = height / 13;
                    } else if (float(width) / float(height) < 1.6) {
                      origenX = 0;
                      origenY = (height - (width / 1.6)) / 2;
                      coordX = map((Integer)lugar.get("coordX"), 0, 1280, 0, width);
                      coordY = origenY + map((Integer)lugar.get("coordY"), 0, 800, 0, width / 1.6);
                      ladoCaratula = width / 8;
                      finalX = width;
                      finalY = height - (height - (width / 1.6)) / 2;
                      ladoCuadrado = (width / 1.6) / 13;
                    }

                    float alturaRect = ladoCaratula / 10;
                    int linSep = 3;
                    float alturaText = alturaRect - 2;
                    textSize(alturaText);

                    float h = (Float)unClip.get("colorH");
                    float s = (Float)unClip.get("colorS");
                    float b = (Float)unClip.get("colorB");
                    float vol = (Float)unClip.get("volume");

                    PImage miImagen = misImagenes.get(unClip.get("trackLoop") + "-" + unClip.get("clipLoop"));
                    int posicion = (Integer)unClip.get("trackLoop");
                    String fecha = (String)miCancion.get("fecha");

                    miRed[i] = new Red(coordX, coordY, (origenX + (ladoCaratula * posicion) + (textWidth(fecha)) + 7), origenY + ladoCaratula + linSep + alturaRect + linSep + alturaText, h, s, b, vol * 70);
                    miRed[i].dibujaRed();

                    misAbanicos[i] = new Abanico(vol * 110, h, s, b); // Tamaño círculos vol * tamaño

                    pushMatrix();
                    translate(coordX, coordY);
                    v = m / (60 / tempo * parseInt((Float)unClip.get("loopend")) * 1000 / 360);
                    float sp = radians(v);
                    rotate(sp);
                    misAbanicos[i].dibuja();

                    popMatrix();

                    textAlign(LEFT, CENTER);
                    if (vol <= 0.45) {
                      fill(h, s, b, vol * 223); //100/0.45 = 223
                      rect(origenX + (ladoCaratula * posicion), origenY + ladoCaratula + linSep, ladoCaratula, alturaRect);
                      text(fecha, 5 + (origenX + (ladoCaratula * posicion)), origenY + ladoCaratula + linSep + alturaRect + linSep + alturaText / 2);
                      fill(0, vol * 223);
                      text(elLugar, 5 + (origenX + (ladoCaratula * posicion)), origenY + ladoCaratula + alturaRect / 2 + 1);
                      tint(360, vol * 223);
                      image(miImagen, origenX + (ladoCaratula * posicion), origenY, ladoCaratula, ladoCaratula);
                      noTint();
                    } else  if (vol > 0.45) {
                      fill(h, s, b);
                      rect(origenX + (ladoCaratula * posicion), origenY + ladoCaratula + linSep, ladoCaratula, alturaRect);
                      text(fecha, 5 + (origenX + (ladoCaratula * posicion)), origenY + ladoCaratula + linSep + alturaRect + linSep + alturaText / 2);
                      fill(0);
                      text(elLugar, 5 + (origenX + (ladoCaratula * posicion)), origenY + ladoCaratula + alturaRect / 2 + 1);
                      image(miImagen, origenX + (ladoCaratula * posicion), origenY, ladoCaratula, ladoCaratula);
                    }

                    //Info cuadrado abajo derecha ultimo loop
                    textSize((ladoCuadrado - 13) / 3);
                    if ((Integer)ultimoLoop.get("mute")!= null) {
                      // int muteu = (Integer)ultimoLoop.get("mute");
                      if ((Integer)ultimoLoop.get("mute") == 0 && ultLoopParado == false) {
                        // Si el último loop está muteado no se dibuja
                        fill(hu, su, bu, volu * 225);
                        rect(finalX - ladoCuadrado, finalY - ladoCuadrado, ladoCuadrado, ladoCuadrado);

                        String esteLoop = (String)ultimoLoop.get("nombreLoop");
                        HashMap<String, Object> ultLoop = (HashMap)todosMisLoops.get(esteLoop);
                        String artista = (String)ultLoop.get("artista");
                        String titulo = (String)ultLoop.get("titulo");
                        String album = (String)ultLoop.get("album");
                        textAlign(RIGHT, CENTER);
                        fill(230, volu * 223);
                        text(titulo, finalX - (ladoCuadrado + 7), finalY - ((ladoCuadrado - 12) / 3 * 2.5 + 11));
                        text(artista, finalX - (ladoCuadrado + 7), finalY - ((ladoCuadrado - 12) / 3 * 1.5 + 9));
                        text(album, finalX - (ladoCuadrado + 7), finalY - ((ladoCuadrado - 12) / 3 * 0.5 + 6));
                        textAlign(LEFT, CENTER);

                        fill(0, 0, 17, volu * 223);
                        text("title", finalX - (ladoCuadrado - 4), finalY - ((ladoCuadrado - 12) / 3 * 2.5 + 11));
                        text("artist", finalX - (ladoCuadrado - 4), finalY - ((ladoCuadrado - 12) / 3 * 1.5 + 9));
                        text("album", finalX - (ladoCuadrado - 4), finalY - ((ladoCuadrado - 12) / 3 * 0.5 + 6));
                      }
                    } // Fin info cuadrado abajo derecha ultimo loop
                  }
                } else {
                  if ((Integer)unClip.get("solo") == 1) {
                    String nCancion = (String)unClip.get("nombreLoop");
                    HashMap<String, Object> miCancion = (HashMap)todosMisLoops.get(nCancion);
                    String elLugar = (String)miCancion.get("lugar");
                    HashMap<String, Object> lugar = (HashMap)todosMisLugares.get(elLugar);

                    if (float(width) / float(height) >= 1.6) {
                      coordX = (width - (height * 1.6)) / 2 + map((Integer)lugar.get("coordX"), 0, 1280, 0, height * 1.6);
                      coordY = map((Integer)lugar.get("coordY"), 0, 800, 0, height);
                      origenX = (width - (height * 1.6)) / 2;
                      origenY = 0;
                      ladoCaratula = height * 1.6 / 8;
                    } else if (float(width) / float(height) < 1.6) {
                      coordX = map((Integer)lugar.get("coordX"), 0, 1280, 0, width);
                      coordY = (height - (width / 1.6)) / 2 + map((Integer)lugar.get("coordY"), 0, 800, 0, width / 1.6);
                      origenX = 0;
                      origenY = (height - (width / 1.6)) / 2;
                      ladoCaratula = width / 8;
                    }
                    float alturaRect = ladoCaratula / 10;
                    int linSep = 3;
                    float alturaText = alturaRect - 2;
                    textSize(alturaText);

                    float h = (Float)unClip.get("colorH");
                    float s = (Float)unClip.get("colorS");
                    float b = (Float)unClip.get("colorB");
                    float vol = (Float)unClip.get("volume");
                    PImage miImagen = misImagenes.get(unClip.get("trackLoop") + "-" + unClip.get("clipLoop"));
                    int posicion = (Integer)unClip.get("trackLoop");
                    String fecha= (String)miCancion.get("fecha");

                    miRed[i]= new Red(coordX, coordY, (origenX + (ladoCaratula * posicion) + (textWidth(fecha)) + 7), origenY + ladoCaratula + linSep + alturaRect + linSep + alturaText, h, s, b, vol * 50);
                    miRed[i].dibujaRed();

                    misAbanicos[i]= new Abanico(vol * 110, h, s, b);

                    pushMatrix();
                    translate(coordX, coordY);
                    v = m / (60 / tempo * parseInt((Float)unClip.get("loopend")) * 1000 / 360);
                    float sp= radians(v);
                    rotate(sp);
                    misAbanicos[i].dibuja();
                    popMatrix();

                    textAlign(LEFT, CENTER);
                    if (vol <= 0.45) {
                      fill(h, s, b, vol * 223);
                      rect(origenX + (ladoCaratula * posicion), origenY + ladoCaratula + linSep, ladoCaratula, alturaRect);
                      text(fecha, 5 + (origenX + (ladoCaratula * posicion)), origenY + ladoCaratula + linSep + alturaRect + linSep + alturaText / 2);
                      fill(0, vol * 223);
                      text(elLugar, 5 + (origenX + (ladoCaratula * posicion)), origenY + ladoCaratula + alturaRect / 2 + 1);

                      tint(360, vol * 223);
                      image(miImagen, origenX + (ladoCaratula * posicion), origenY, ladoCaratula, ladoCaratula);
                      noTint();
                    } else  if (vol > 0.45) {
                      fill(h, s, b);
                      rect(origenX + (ladoCaratula * posicion), origenY + ladoCaratula + linSep, ladoCaratula, alturaRect);
                      text(fecha, 5 + (origenX + (ladoCaratula * posicion)), origenY + ladoCaratula + linSep + alturaRect + linSep + alturaText / 2);
                      fill(0);
                      text(elLugar, 5 + (origenX + (ladoCaratula * posicion)), origenY + ladoCaratula + alturaRect / 2 + 1);
                      image(miImagen, origenX + (ladoCaratula * posicion), origenY, ladoCaratula, ladoCaratula);
                    }
                  } // fin de (Integer)unClip.get("solo")==1
                } // fin de !soloState()
              } // fin de (Integer)unClip.get("state")==2))
            } // fin de unClip.get("state")!= null
          } // fin de for
        } // fin de while
      } // fin de miAntropoloops != null && drawing==true
      break;
  } // Fin de switch
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
    println("todosMisLoops: " + todosMisLoops);
  }
}
