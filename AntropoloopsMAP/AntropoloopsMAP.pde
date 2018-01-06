/* //<>//
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

HashMap<String, HashMap<String, Object>> miAntropoloops;
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
float masterVolume;
float coordX, coordY, coordXOnda, coordYOnda;
float origenX, origenY;
float ladoCaratula;
float ladoCuadrado;
float finalX;
float finalY;
String web;
int statePuntoRojo, statePuntoVerde;
boolean dibujaOnda, ultLoopParado, clipsLoaded;
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
  frameRate(10);

  mundi = loadImage("../1_BDatos/"+"mapa_1728x1080.jpg");
  colorMode(HSB, 360, 100, 100, 100);
  PFont font;
  font = loadFont("../1_BDatos/"+"ArialMT-20.vlw");
  textAlign(LEFT, CENTER);

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
  oscP5 = new OscP5(this, properties);
  //println("Estas son las propiedades "+properties.toString());

  statePuntoRojo = 0;
  statePuntoVerde = 0;
  dibujaOnda = false;
  clipsLoaded = false;
  timerPuntoRojo = new Timer(0);
  timerPuntoVerde = new Timer(0);
  timerOnda = new Timer(0);

  //**********Cargo los datos de las Bases de Datos***************
  misLoopsJSON = loadJSONArray ("../1_BDatos/"+"BDloops.txt");
  misLugaresJSON = loadJSONArray ("../1_BDatos/"+"BDlugares.txt");

  todosMisLoops = new HashMap<String, HashMap<String, Object>>();
  for (int i=0; i<misLoopsJSON.size(); i++) { 
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
  for (int i=0; i<misLugaresJSON.size(); i++) {
    HashMap<String, Object> coordenadas = new HashMap<String, Object>();
    coordenadas.put("coordX", misLugaresJSON.getJSONObject(i).getInt("coordX"));
    coordenadas.put("coordY", misLugaresJSON.getJSONObject(i).getInt("coordY"));
    todosMisLugares.put(misLugaresJSON.getJSONObject(i).getString("lugar"), coordenadas);
  }
  misImagenes = new HashMap<String, PImage>();
  ultimoLoop = new HashMap<String, Object>();
  web = "www.antropoloops.com";
  
  loopsIndexed =new ArrayList<String>();
  miAntropoloops = new HashMap();
  remapea();
  
  
  while (clipsLoaded == false) {
    println("cargando clips");
  }
  
  println("clipsLoaded", clipsLoaded);
  println("Pregunta ahora!");
  ct1=-1;
  println("Lanzo pregunta");
  pregunta();
  
}

//=======================================================================
void draw() {
  // println("framerate", frameRate);
  background(#2c2c2c);
  if (float(width)/float(height)>=1.6) { //El tamaño de la imagen de fondo es 1280x800. 1280/800=1.6
    image(mundi, (width-(height*1.6))/2, 0, height*1.6, height );
    fill(50);
    noStroke();
    rect(0, 0, width, height*1.6/8);
    textSize(height*1.6/8/13);
    fill(255);
    text(web, (width-(height*1.6))/2+10, height-28);
  }
  if (float(width)/float(height)<1.6) {
    image(mundi, 0, (height-(width/1.6))/2, width, width/1.6);
    fill(50);
    noStroke();
    rect(0, 0, width, (height-(width/1.6))/2+width/8);
    textSize(width/8/13);
    fill(255);
    text(web, 10, height-(height-(width/1.6))/2-28);
  }

  if (timerPuntoRojo.isFinished()) {
    statePuntoRojo = 0;
  } 
  if (timerPuntoVerde.isFinished()) {
    statePuntoVerde = 0;
  }
  if (timerOnda.isFinished()) {
    dibujaOnda = false;
  }

  fill(150);
  if (float(width)/float(height)>=1.6) {
    if (statePuntoRojo==1) {
      ellipse((width-(height*1.6))/2+textWidth(web)+30, height-20, 15, 15);
    }
  } else if (float(width)/float(height)<1.6) {
    if (statePuntoRojo==1) {      
      ellipse(textWidth(web)+30, height-(height-width/1.6)/2-20, 15, 15);
    }
  }

  fill(360);
  if (float(width)/float(height)>=1.6) {
    if (statePuntoVerde==1) {
      ellipse((width-(height*1.6))/2+textWidth(web)+30, height-20, 15, 15);
    }
  } else if (float(width)/float(height)<1.6) {
    if (statePuntoVerde==1) {
      ellipse(textWidth(web)+30, height-(height-width/1.6)/2-20, 15, 15);
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
      
      float hu;
      float su;
      float bu;
      float volu;
      
      if (!ultimoLoop.isEmpty()) {
        hu = (Float)ultimoLoop.get("colorH");
        su = (Float)ultimoLoop.get("colorS");
        bu = (Float)ultimoLoop.get("colorB");
        volu = (Float)ultimoLoop.get("volume");
        
        if (dibujaOnda == true && volu>0.05) {
          d = d+4;
          String ondaLoop=(String)ultimoLoop.get("nombreLoop");
          HashMap<String, Object> ondaLugar=(HashMap)todosMisLoops.get(ondaLoop);
          String miOndaLugar = (String)ondaLugar.get("lugar");
          HashMap<String, Object> ondaCoordenadas=(HashMap)todosMisLugares.get(miOndaLugar);
  
          stroke(hu, su, bu, 100-d/90);
          float a = (500*(d*d))/((d*d)+50);
          strokeWeight(500-a);
          noFill();
          if (float(width)/float(height)>=1.6) {
            coordXOnda =origenX+map( (Integer)ondaCoordenadas.get("coordX"), 0, 1280, 0, height*1.6);
            coordYOnda = map((Integer)ondaCoordenadas.get("coordY"), 0, 800, 0, height);
            ellipse(coordXOnda, coordYOnda, d, d);
          } else if (float(width)/float(height)<1.6) {
            coordXOnda = map((Integer)ondaCoordenadas.get("coordX"), 0, 1280, 0, width);
            coordYOnda = origenY+map((Integer)ondaCoordenadas.get("coordY"), 0, 800, 0, width/1.6);
            ellipse(coordXOnda, coordYOnda, d, d);
          }
        }
      }
 
      Iterator recorreMiAntropoloops = miAntropoloops.entrySet().iterator();  
      while (recorreMiAntropoloops.hasNext ()) { 
        for (int i = 0; i < miAntropoloops.size(); i++) {
          Map.Entry me = (Map.Entry)recorreMiAntropoloops.next();
          HashMap<String, Object> unClip = (HashMap)me.getValue();

          if (unClip.get("state") != null && (Integer)unClip.get("state") == 2) { // El clip state no es null y está sonando
            if (!soloState()) { // Solo state
              if ((Integer)unClip.get("mute")!=null && (Integer)unClip.get("mute")==0) {
                String nCancion=(String)unClip.get("nombreLoop"); //nCancion = nombreLoop, que es el nombre del clip segun Ableton, o sea, el nombre del archivo
                HashMap<String, Object> miCancion=(HashMap)todosMisLoops.get(nCancion);
                String elLugar=(String)miCancion.get("lugar");
                HashMap<String, Object> lugar=(HashMap)todosMisLugares.get(elLugar);

                if (float(width)/float(height)>=1.6) {
                  origenX = (width-(height*1.6))/2;
                  origenY = 0;
                  coordX = origenX+map((Integer)lugar.get("coordX"), 0, 1280, 0, height*1.6);
                  coordY = map((Integer)lugar.get("coordY"), 0, 800, 0, height);
                  ladoCaratula = height*1.6/8;
                  finalX = width-(width-(height*1.6))/2;
                  finalY = height;
                  ladoCuadrado = height/13;
                } else if (float(width)/float(height)<1.6) {
                  origenX = 0;
                  origenY = (height-(width/1.6))/2;
                  coordX = map((Integer)lugar.get("coordX"), 0, 1280, 0, width);
                  coordY = origenY+map((Integer)lugar.get("coordY"), 0, 800, 0, width/1.6);
                  ladoCaratula = width/8;
                  finalX = width;
                  finalY = height-(height-(width/1.6))/2;
                  ladoCuadrado = (width/1.6)/13;
                }
                float alturaRect = ladoCaratula/10;
                int linSep = 3;
                float alturaText = alturaRect-2;
                textSize(alturaText);


                float h = (Float)unClip.get("colorH");
                float s = (Float)unClip.get("colorS");
                float b = (Float)unClip.get("colorB");
                float vol = (Float)unClip.get("volume");

                PImage miImagen = misImagenes.get(unClip.get("trackLoop")+"-"+unClip.get("clipLoop"));
                int posicion = (Integer)unClip.get("trackLoop");
                String fecha= (String)miCancion.get("fecha");

                miRed[i]= new Red(coordX, coordY, (origenX+(ladoCaratula*posicion)+(textWidth(fecha))+7), origenY+ladoCaratula+linSep+alturaRect+linSep+alturaText, h, s, b, vol*70);
                miRed[i].dibujaRed();

                misAbanicos[i]= new Abanico(coordX, coordY, vol*110, masterVolume, h, s, b); // Tamaño círculos vol * tamaño    

                pushMatrix();
                translate(coordX, coordY);
                v = m/(60/tempo*parseInt((Float)unClip.get("loopend"))*1000/360);    
                float sp= radians(v);
                rotate(sp);
                misAbanicos[i].dibuja();

                popMatrix();

                // La transparencia de estos elementos depende ahora mismo del vol del track.
                // Hay que hacer que dependa también del marter volume
                // ahora mismo las cosas empiezan a desvanecer cuando el volumen del track baja de 0.45
                // 100 es el max que alcanza alpha
                // cuando masterVolume está a 0.85 debería ser como * 1

                // vol <= 0.45
                // 
                if (vol <= 0.45 || masterVolume <= 0.45) {
                  fill(h, s, b, vol); //100/0.45 = 223
                  // rect and text under cover image
                  rect(origenX+(ladoCaratula*posicion), origenY+ladoCaratula+linSep, ladoCaratula, alturaRect);
                  text(fecha, 5+(origenX+(ladoCaratula*posicion)), origenY+ladoCaratula+linSep+alturaRect+linSep+alturaText/2);
                  fill(0, vol*223);

                  text(elLugar, 5+(origenX+(ladoCaratula*posicion)), origenY+ladoCaratula+alturaRect/2+1);
                  tint(360, vol*223);
                  // cover image
                  image(miImagen, origenX+(ladoCaratula*posicion), origenY, ladoCaratula, ladoCaratula);
                  noTint();
                } else {
                  fill(h, s, b);
                  rect(origenX+(ladoCaratula*posicion), origenY+ladoCaratula+linSep, ladoCaratula, alturaRect);
                  text(fecha, 5+(origenX+(ladoCaratula*posicion)), origenY+ladoCaratula+linSep+alturaRect+linSep+alturaText/2);
                  fill(0);
                  text(elLugar, 5+(origenX+(ladoCaratula*posicion)), origenY+ladoCaratula+alturaRect/2+1);
                  image(miImagen, origenX+(ladoCaratula*posicion), origenY, ladoCaratula, ladoCaratula);
                }


                //Info mp3 abajo a la derecha
                textSize((ladoCuadrado-13)/3);
                if (!ultimoLoop.isEmpty()) {
                  if ((Integer)ultimoLoop.get("mute") != null) {
                    int muteu = (Integer)ultimoLoop.get("mute"); 
                    if (muteu == 0 && ultLoopParado == false) { //condicional para que no lo dibuje si se mutea ese loop
                      hu = (Float)ultimoLoop.get("colorH");
                      su = (Float)ultimoLoop.get("colorS");
                      bu = (Float)ultimoLoop.get("colorB");
                      volu = (Float)ultimoLoop.get("volume");
                      fill(hu, su, bu, volu*225);
                      rect(finalX-ladoCuadrado, finalY-ladoCuadrado, ladoCuadrado, ladoCuadrado);
  
                      String esteLoop=(String)ultimoLoop.get("nombreLoop");
                      HashMap<String, Object> ultLoop=(HashMap)todosMisLoops.get(esteLoop);
                      String artista = (String)ultLoop.get("artista");
                      String titulo = (String)ultLoop.get("titulo");
                      String album = (String)ultLoop.get("album");
                      textAlign(RIGHT, CENTER);
                      fill(230, volu*223);
                      text(titulo, finalX-(ladoCuadrado+7), finalY-((ladoCuadrado-12)/3*2.5+11));
                      text(artista, finalX-(ladoCuadrado+7), finalY-((ladoCuadrado-12)/3*1.5+9));
                      text(album, finalX-(ladoCuadrado+7), finalY-((ladoCuadrado-12)/3*0.5+6));
                      textAlign(LEFT, CENTER);
  
                      fill(0, 0, 17, volu*223);
                      text("title", finalX-(ladoCuadrado-4), finalY-((ladoCuadrado-12)/3*2.5+11));
                      text("artist", finalX-(ladoCuadrado-4), finalY-((ladoCuadrado-12)/3*1.5+9));
                      text("album", finalX-(ladoCuadrado-4), finalY-((ladoCuadrado-12)/3*0.5+6));
                    }
                  }
                }
              } // End of (Integer)unClip.get("mute")!=null && (Integer)unClip.get("mute")==0)
            } else { // End of !soloState() == true -> No está activo el solo
              if ((Integer)unClip.get("solo")==1) {
                String nCancion=(String)unClip.get("nombreLoop");
                HashMap<String, Object> miCancion=(HashMap)todosMisLoops.get(nCancion);
                String elLugar=(String)miCancion.get("lugar");
                HashMap<String, Object> lugar=(HashMap)todosMisLugares.get(elLugar);

                if (float(width)/float(height)>=1.6) {
                  coordX = (width-(height*1.6))/2+map((Integer)lugar.get("coordX"), 0, 1280, 0, height*1.6);
                  coordY = map((Integer)lugar.get("coordY"), 0, 800, 0, height);
                  origenX = (width-(height*1.6))/2;
                  origenY = 0;
                  ladoCaratula = height*1.6/8;
                } else if (float(width)/float(height)<1.6) {
                  coordX = map((Integer)lugar.get("coordX"), 0, 1280, 0, width);
                  coordY = (height-(width/1.6))/2+map((Integer)lugar.get("coordY"), 0, 800, 0, width/1.6);
                  origenX = 0;
                  origenY = (height-(width/1.6))/2;
                  ladoCaratula = width/8;
                }
                float alturaRect = ladoCaratula/10;
                int linSep = 3;
                float alturaText = alturaRect-2;
                textSize(alturaText);

                float h = (Float)unClip.get("colorH");
                float s = (Float)unClip.get("colorS");
                float b = (Float)unClip.get("colorB");
                float vol = (Float)unClip.get("volume");
                PImage miImagen = misImagenes.get(unClip.get("trackLoop")+"-"+unClip.get("clipLoop"));
                int posicion = (Integer)unClip.get("trackLoop");
                String fecha= (String)miCancion.get("fecha");

                miRed[i]= new Red(coordX, coordY, ( origenX+(ladoCaratula*posicion)+(textWidth(fecha))+7), origenY+ladoCaratula+linSep+alturaRect+linSep+alturaText, h, s, b, vol*50);
                miRed[i].dibujaRed();

                misAbanicos[i]= new Abanico(coordX, coordY, vol*100, masterVolume, h, s, b);

                pushMatrix();
                translate(coordX, coordY);
                v = m/(60/tempo*parseInt((Float)unClip.get("loopend"))*1000/360);    
                float sp= radians(v);
                rotate(sp);
                misAbanicos[i].dibuja();
                popMatrix();

                if (vol<=0.45) {
                  fill(h, s, b, vol*223);
                  rect(origenX+(ladoCaratula*posicion), origenY+ladoCaratula+linSep, ladoCaratula, alturaRect);
                  text(fecha, 5+(origenX+(ladoCaratula*posicion)), origenY+ladoCaratula+linSep+alturaRect+linSep+alturaText/2);
                  fill(0, vol*223);
                  text(elLugar, 5+(origenX+(ladoCaratula*posicion)), origenY+ladoCaratula+alturaRect/2+1);

                  tint(360, vol*223);
                  image(miImagen, origenX+(ladoCaratula*posicion), origenY, ladoCaratula, ladoCaratula);
                  noTint();
                } else  if (vol>0.45) {
                  fill(h, s, b);
                  rect(origenX+(ladoCaratula*posicion), origenY+ladoCaratula+linSep, ladoCaratula, alturaRect);
                  text(fecha, 5+(origenX+(ladoCaratula*posicion)), origenY+ladoCaratula+linSep+alturaRect+linSep+alturaText/2);
                  fill(0);
                  text(elLugar, 5+(origenX+(ladoCaratula*posicion)), origenY+ladoCaratula+alturaRect/2+1);
                  image(miImagen, origenX+(ladoCaratula*posicion), origenY, ladoCaratula, ladoCaratula);
                }
              } // End of (Integer)unClip.get("solo")==1)
            } // End of // End of !soloState() == false -> Está activo el solo
          } // End of unClip.get("state")!= null && (Integer)unClip.get("state")==2
        } // End of for loop
      } // End of Iterator
    } // End of (miAntropoloops != null && drawing==true)
    break;
  } // End of switch
}
    
void keyPressed() {
  if (key == '1') {
    loopsIndexed =new ArrayList<String>();
    miAntropoloops = new HashMap();
    remapea();
  } else if (key == '2') {
    ct1=-1;
    println("Lanzo pregunta");
    pregunta();
  } else if (key == '3') {
    drawing=true;
    println("draw running");
  }
}