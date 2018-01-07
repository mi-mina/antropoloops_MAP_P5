import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import oscP5.*; 
import netP5.*; 
import java.util.Map; 
import java.util.Iterator; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class AntropoloopsMAP extends PApplet {

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
public void setup() {
  
  if (frame != null) {
    frame.setResizable(true);
    frameRate(7);
  }

  mundi = loadImage("mapa_1728x1080.jpg");
  colorMode(HSB, 360, 100, 100, 100);
  PFont font;
  font= loadFont("ArialMT-20.vlw");
  textAlign(LEFT, CENTER);

// oscP5 = new OscP5(this, inPort);
// myRemoteLocation = new NetAddress("localhost", outPort);
  
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
  
}

//=======================================================================
public void draw() {

  background(0xff2c2c2c);
  if (PApplet.parseFloat(width)/PApplet.parseFloat(height)>=1.6f) { //El tama\u00f1o de la imagen de fondo es 1280x800. 1280/800=1.6
    image(mundi, (width-(height*1.6f))/2, 0, height*1.6f, height );
    fill(50);
    noStroke();
    rect(0, 0, width, height*1.6f/8);
    textSize(height*1.6f/8/13);
    fill(255);
    text(web, (width-(height*1.6f))/2+10, height-28);
    fill(150);
    text("www.mi-mina.com", (width-(height*1.6f))/2+10, height-13);
  }
  if (PApplet.parseFloat(width)/PApplet.parseFloat(height)<1.6f) {
    image(mundi, 0, (height-(width/1.6f))/2, width, width/1.6f);
    fill(50);
    noStroke();
    rect(0, 0, width, (height-(width/1.6f))/2+width/8);
    textSize(width/8/13);
    fill(255);
    text(web, 10, height-(height-(width/1.6f))/2-28);
    fill(150);
    text("www.mi-mina.com", 10, height-(height-(width/1.6f))/2-13);
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
  if (PApplet.parseFloat(width)/PApplet.parseFloat(height)>=1.6f) {
    if (statePuntoRojo==1) {
      ellipse((width-(height*1.6f))/2+textWidth(web)+30, height-20, 15, 15);
    }
  }
  else if (PApplet.parseFloat(width)/PApplet.parseFloat(height)<1.6f) {
    if (statePuntoRojo==1) {      
      ellipse(textWidth(web)+30, height-(height-width/1.6f)/2-20, 15, 15);
    }
  }

  fill(360);
  if (PApplet.parseFloat(width)/PApplet.parseFloat(height)>=1.6f) {
    if (statePuntoVerde==1) {
      ellipse((width-(height*1.6f))/2+textWidth(web)+30, height-20, 15, 15);
    }
  }
  else if (PApplet.parseFloat(width)/PApplet.parseFloat(height)<1.6f) {
    if (statePuntoVerde==1) {
      ellipse(textWidth(web)+30, height-(height-width/1.6f)/2-20, 15, 15);
    }
  }

  switch(playStop) {
  case 1:
    break;

  case 2:
     
      if (miAntropoloops != null && drawing==true) {
      
      misAbanicos = new Abanico[miAntropoloops.size()];
      miRed = new Red[miAntropoloops.size()];
      m = millis();



      float hu = (Float)ultimoLoop.get("colorH");
      float su = (Float)ultimoLoop.get("colorS");
      float bu = (Float)ultimoLoop.get("colorB");
      float volu = (Float)ultimoLoop.get("volume");

      if (dibujaOnda == true && volu>0.05f) {
        d = d+4;
        String ondaLoop=(String)ultimoLoop.get("nombreLoop");
        HashMap<String, Object> ondaLugar=(HashMap)todosMisLoops.get(ondaLoop);
        String miOndaLugar = (String)ondaLugar.get("lugar");
        HashMap<String, Object> ondaCoordenadas=(HashMap)todosMisLugares.get(miOndaLugar);

        stroke(hu, su, bu, 100-d/90);
        float a = (500*(d*d))/((d*d)+50);
        strokeWeight(500-a);
        noFill();
        if (PApplet.parseFloat(width)/PApplet.parseFloat(height)>=1.6f) {
          coordXOnda =origenX+map( (Integer)ondaCoordenadas.get("coordX"), 0, 1280, 0, height*1.6f);
          coordYOnda = map((Integer)ondaCoordenadas.get("coordY"), 0, 800, 0, height);
          ellipse(coordXOnda, coordYOnda, d, d);
        }
        else if (PApplet.parseFloat(width)/PApplet.parseFloat(height)<1.6f) {
          coordXOnda = map((Integer)ondaCoordenadas.get("coordX"), 0, 1280, 0, width);
          coordYOnda = origenY+map((Integer)ondaCoordenadas.get("coordY"), 0, 800, 0, width/1.6f);
          ellipse(coordXOnda, coordYOnda, d, d);
        }
      }



      Iterator recorreMiAntropoloops = miAntropoloops.entrySet().iterator();  
      while (recorreMiAntropoloops.hasNext ()) { 
        for (int i = 0; i < miAntropoloops.size(); i++) {

          Map.Entry me = (Map.Entry)recorreMiAntropoloops.next();
          HashMap<String, Object> unClip = (HashMap)me.getValue();

          if (unClip.get("state")!= null) {

            if ((Integer)unClip.get("state")==2) {
              if (!soloState()) {
                if ((Integer)unClip.get("mute")!=null && (Integer)unClip.get("mute")==0) {     


                  String nCancion=(String)unClip.get("nombreLoop"); //nCancion = nombreLoop, que es el nombre del clip segun Ableton, o sea, el nombre del archivo
                  HashMap<String, Object> miCancion=(HashMap)todosMisLoops.get(nCancion);
                  String elLugar=(String)miCancion.get("lugar");
                  HashMap<String, Object> lugar=(HashMap)todosMisLugares.get(elLugar);

                  if (PApplet.parseFloat(width)/PApplet.parseFloat(height)>=1.6f) {
                    origenX = (width-(height*1.6f))/2;
                    origenY = 0;
                    coordX = origenX+map((Integer)lugar.get("coordX"), 0, 1280, 0, height*1.6f);
                    coordY = map((Integer)lugar.get("coordY"), 0, 800, 0, height);
                    ladoCaratula = height*1.6f/8;
                    finalX = width-(width-(height*1.6f))/2;
                    finalY = height;
                    ladoCuadrado = height/13;
                  } 
                  else if (PApplet.parseFloat(width)/PApplet.parseFloat(height)<1.6f) {
                    origenX = 0;
                    origenY = (height-(width/1.6f))/2;
                    coordX = map((Integer)lugar.get("coordX"), 0, 1280, 0, width);
                    coordY = origenY+map((Integer)lugar.get("coordY"), 0, 800, 0, width/1.6f);
                    ladoCaratula = width/8;
                    finalX = width;
                    finalY = height-(height-(width/1.6f))/2;
                    ladoCuadrado = (width/1.6f)/13;
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

                  misAbanicos[i]= new Abanico(coordX, coordY, vol*110, h, s, b); // Tama\u00f1o c\u00edrculos vol * tama\u00f1o    

                  pushMatrix();
                  translate(coordX, coordY);
                  v = m/(60/tempo*parseInt((Float)unClip.get("loopend"))*1000/360);    
                  float sp= radians(v);
                  rotate(sp);
                  misAbanicos[i].dibuja();

                  popMatrix();

                  if (vol<=0.45f) {
                    fill(h, s, b, vol*223); //100/0.45 = 223
                    rect(origenX+(ladoCaratula*posicion), origenY+ladoCaratula+linSep, ladoCaratula, alturaRect);
                    text(fecha, 5+(origenX+(ladoCaratula*posicion)), origenY+ladoCaratula+linSep+alturaRect+linSep+alturaText/2);
                    fill(0, vol*223);
                    text(elLugar, 5+(origenX+(ladoCaratula*posicion)), origenY+ladoCaratula+alturaRect/2+1);
                    tint(360, vol*223);
                    image(miImagen, origenX+(ladoCaratula*posicion), origenY, ladoCaratula, ladoCaratula);
                    noTint();
                  }
                  else  if (vol>0.45f) {
                    fill(h, s, b);
                    rect(origenX+(ladoCaratula*posicion), origenY+ladoCaratula+linSep, ladoCaratula, alturaRect);
                    text(fecha, 5+(origenX+(ladoCaratula*posicion)), origenY+ladoCaratula+linSep+alturaRect+linSep+alturaText/2);
                    fill(0);
                    text(elLugar, 5+(origenX+(ladoCaratula*posicion)), origenY+ladoCaratula+alturaRect/2+1);
                    image(miImagen, origenX+(ladoCaratula*posicion), origenY, ladoCaratula, ladoCaratula);
                  }
            

                  //Info mp3 abajo a la derecha
                  textSize((ladoCuadrado-13)/3);
                  
                 if ( (Integer)ultimoLoop.get("mute")!=null) {
                    int muteu = (Integer)ultimoLoop.get("mute"); 
                    if (muteu == 0 && ultLoopParado == false) { //condicional para que no lo dibuje si se mutea ese loop
                      fill(hu, su, bu, volu*225);
                      rect(finalX-ladoCuadrado, finalY-ladoCuadrado, ladoCuadrado, ladoCuadrado);

                      String esteLoop=(String)ultimoLoop.get("nombreLoop");
                      HashMap<String, Object> ultLoop=(HashMap)todosMisLoops.get(esteLoop);
                      String artista = (String)ultLoop.get("artista");
                      String titulo = (String)ultLoop.get("titulo");
                      String album = (String)ultLoop.get("album");
                      textAlign(RIGHT, CENTER);
                      fill(230, volu*223);
                      text(titulo, finalX-(ladoCuadrado+7), finalY-((ladoCuadrado-12)/3*2.5f+11));
                      text(artista, finalX-(ladoCuadrado+7), finalY-((ladoCuadrado-12)/3*1.5f+9));
                      text(album, finalX-(ladoCuadrado+7), finalY-((ladoCuadrado-12)/3*0.5f+6));
                      textAlign(LEFT, CENTER);

                      fill(0, 0, 17, volu*223);
                      text("title", finalX-(ladoCuadrado-4), finalY-((ladoCuadrado-12)/3*2.5f+11));
                      text("artist", finalX-(ladoCuadrado-4), finalY-((ladoCuadrado-12)/3*1.5f+9));
                      text("album", finalX-(ladoCuadrado-4), finalY-((ladoCuadrado-12)/3*0.5f+6));
                    }
                 }
                }
                  }
                  else {
                    if ((Integer)unClip.get("solo")==1) {
                      String nCancion=(String)unClip.get("nombreLoop");
                      HashMap<String, Object> miCancion=(HashMap)todosMisLoops.get(nCancion);
                      String elLugar=(String)miCancion.get("lugar");
                      HashMap<String, Object> lugar=(HashMap)todosMisLugares.get(elLugar);

                      if (PApplet.parseFloat(width)/PApplet.parseFloat(height)>=1.6f) {
                        coordX = (width-(height*1.6f))/2+map((Integer)lugar.get("coordX"), 0, 1280, 0, height*1.6f);
                        coordY = map((Integer)lugar.get("coordY"), 0, 800, 0, height);
                        origenX = (width-(height*1.6f))/2;
                        origenY = 0;
                        ladoCaratula = height*1.6f/8;
                      } 
                      else if (PApplet.parseFloat(width)/PApplet.parseFloat(height)<1.6f) {
                        coordX = map((Integer)lugar.get("coordX"), 0, 1280, 0, width);
                        coordY = (height-(width/1.6f))/2+map((Integer)lugar.get("coordY"), 0, 800, 0, width/1.6f);
                        origenX = 0;
                        origenY = (height-(width/1.6f))/2;
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

                      misAbanicos[i]= new Abanico(coordX, coordY, vol*110, h, s, b);

                      pushMatrix();
                      translate(coordX, coordY);
                      v = m/(60/tempo*parseInt((Float)unClip.get("loopend"))*1000/360);    
                      float sp= radians(v);
                      rotate(sp);
                      misAbanicos[i].dibuja();
                      popMatrix();

                      if (vol<=0.45f) {
                        fill(h, s, b, vol*223);
                        rect(origenX+(ladoCaratula*posicion), origenY+ladoCaratula+linSep, ladoCaratula, alturaRect);
                        text(fecha, 5+(origenX+(ladoCaratula*posicion)), origenY+ladoCaratula+linSep+alturaRect+linSep+alturaText/2);
                        fill(0, vol*223);
                        text(elLugar, 5+(origenX+(ladoCaratula*posicion)), origenY+ladoCaratula+alturaRect/2+1);
                       
                        tint(360, vol*223);
                        image(miImagen, origenX+(ladoCaratula*posicion), origenY, ladoCaratula, ladoCaratula);
                        noTint();
                      }
                      else  if (vol>0.45f) {
                        fill(h, s, b);
                        rect(origenX+(ladoCaratula*posicion), origenY+ladoCaratula+linSep, ladoCaratula, alturaRect);
                        text(fecha, 5+(origenX+(ladoCaratula*posicion)), origenY+ladoCaratula+linSep+alturaRect+linSep+alturaText/2);
                        fill(0);
                        text(elLugar, 5+(origenX+(ladoCaratula*posicion)), origenY+ladoCaratula+alturaRect/2+1);
                        image(miImagen, origenX+(ladoCaratula*posicion), origenY, ladoCaratula, ladoCaratula);
                      }
                    }
                  }
                }
              }
            }
          }
        }
        break;
      }
    }

    public void keyPressed() {
      if (key == '1') {
        loopsIndexed =new ArrayList<String>();
        miAntropoloops = new HashMap();
        remapea();
      }
      else if (key == '2') {
        ct1=-1;
        println("Lanzo pregunta");
        pregunta();
      } 
      else if (key == '3') {
        drawing=true;
        println("draw running");
      }
      else if (key == '4') {
        println(loopsIndexed);
      }
      else if (key == '5') {
        println(todosMisLoops);
      }
    }
class Abanico {
  float d;
  float x, y, h, s, b;
  
  // Abanico constructor
  Abanico(float coorX, float coorY, float diam, float colorH, float colorS, float colorB) {
    x = coorX;
    y = coorY;
    d = diam*0.8f;
    h = colorH;
    s = colorS;
    b = colorB;
  }

  public void dibuja() {

    for (int i=0; i<20; i++) {
      if (PApplet.parseFloat(width)/PApplet.parseFloat(height)>=1.6f) {  

        if (d<=40) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -d*3/8*height/800*1.2f);
          noStroke();
          fill(h, s, b, 25); 
          arc(0, 0, d*3/4*height/800, d*3/4*height/800, radians(i*24)-HALF_PI, radians(360)-HALF_PI);


          fill(h, s, b, 2);
          arc(0, 0, d*2*height/800, d*2*height/800, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
        } else if (40<d && d<=70) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -(4*d-70)/6*height/800*1.2f);
          noStroke();
          fill(h, s, b, 25); 
          arc(0, 0, (4*d-70)/3*height/800, (4*d-70)/3*height/800, radians(i*24)-HALF_PI, radians(360)-HALF_PI);


          fill(h, s, b, 2);
          arc(0, 0, d*2.5f*height/800, d*2.5f*height/800, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
        } else if (d>70 && d<=80) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -(5*d-280)/2*height/800*1.2f);
          noStroke();
          fill(h, s, b, 25); 
          arc(0, 0, (5*d-280)*height/800, (5*d-280)*height/800, radians(i*24)-HALF_PI, radians(360)-HALF_PI);

          fill(h, s, b, 2);
          arc(0, 0, d*2.5f*height/800, d*2.5f*height/800, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
        } else if (d>80) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -60*height/800*1.2f);
          noStroke();
          fill(h, s, b, 25); 
          arc(0, 0, 120*height/800, 120*height/800, radians(i*24)-HALF_PI, radians(360)-HALF_PI);

          fill(h, s, b, 2);
          arc(0, 0, d*2.5f*height/800, d*2.5f*height/800, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
        }
      } else if (PApplet.parseFloat(width)/PApplet.parseFloat(height)<1.6f) {  

        if (d<=40) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -d*3/8*width/1280*1.2f);
          noStroke();
          fill(h, s, b, 25); 
          arc(0, 0, d*3/4*width/1280, d*3/4*width/1280, radians(i*24)-HALF_PI, radians(360)-HALF_PI);


          fill(h, s, b, 2);
          arc(0, 0, d*2*width/1280, d*2*width/1280, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
        } else if (40<d && d<=70) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -(4*d-70)/6*width/1280*1.2f);
          noStroke();
          fill(h, s, b, 25); 
          arc(0, 0, (4*d-70)/3*width/1280, (4*d-70)/3*width/1280, radians(i*24)-HALF_PI, radians(360)-HALF_PI);


          fill(h, s, b, 2);
          arc(0, 0, d*2.5f*width/1280, d*2.5f*width/1280, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
        } else if (d>70 && d<=80) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -(5*d-280)/2*width/1280*1.2f);
          noStroke();
          fill(h, s, b, 25); 
          arc(0, 0, (5*d-280)*width/1280, (5*d-280)*width/1280, radians(i*24)-HALF_PI, radians(360)-HALF_PI);

          fill(h, s, b, 2);
          arc(0, 0, d*2.5f*width/1280, d*2.5f*width/1280, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
        } else if (d>80) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -60*width/1280*1.2f);
          noStroke();
          fill(h, s, b, 25); 
          arc(0, 0, 120*width/1280, 120*width/1280, radians(i*24)-HALF_PI, radians(360)-HALF_PI);

          fill(h, s, b, 2);
          arc(0, 0, d*2.5f*width/1280, d*2.5f*width/1280, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
        }
      }
      
      
      
    }
  }
}
public boolean soloState() {

  HashMap<String, Integer> soloState = new HashMap<String, Integer>();
  Iterator soloInfo = miAntropoloops.entrySet().iterator();  
  while (soloInfo.hasNext ()) { 
    for (int i = 0; i < miAntropoloops.size(); i++) {
      Map.Entry me = (Map.Entry)soloInfo.next();
      HashMap<String, Object> soloClip = (HashMap)me.getValue();


      soloState.put(Integer.toString(i), (Integer)soloClip.get("solo"));
      if (soloState.containsValue(1)==true) {
      }
    }
  }

  return soloState.containsValue(1);
}
public void remapea() {

  OscMessage myMessage = new OscMessage("/live/name/clip");
  //oscP5.send(myMessage, myRemoteLocation);
    oscP5.send(myMessage);
  println("lanzo mensaje /live/name/clip");
} 

public void pregunta() {
  println("+++++++++++++Ejecutando Pregunta++++++++++++++");

  for (int i=0; i<loopsIndexed.size(); i++) {
    //Pregunto por el loopend
    //Necesito iterar por loopsIndexed para mandar la pregunta con un orden determinado, 
    //ya que la respuesta me la da exclusivamente con el loopend, sin decirme ni el track, ni el clip
    //De esta forma, s\u00e9 que la respuesta me la va a dar en el mismo orden que la mando, y por lo tanto
    //puedo hacer corresponder los datos del loopend con un track y un clip determinados
  
    String claveClip=loopsIndexed.get(i);

    OscMessage loopMessage = new OscMessage("/live/clip/loopend");
    int[] a = PApplet.parseInt(split(claveClip, '-'));
    loopMessage.add(a);
    //oscP5.send(loopMessage, myRemoteLocation);
    oscP5.send(loopMessage);
       
    //pregunto por el volumen inicial de cada track
    OscMessage volMessage = new OscMessage("/live/volume");
    int[] b = PApplet.parseInt(split(claveClip, '-'));
    volMessage.add(b[0]);
    //oscP5.send(volMessage, myRemoteLocation);
    oscP5.send(volMessage);
 
    //Pregunto por el estado inicial del solo
    OscMessage soloMessage = new OscMessage("/live/solo");
    int[] c = PApplet.parseInt(split(claveClip, '-'));
    soloMessage.add(c[0]);
    //oscP5.send(soloMessage, myRemoteLocation);
    oscP5.send(soloMessage);
    
    //Pregunto por el estado inicial del mute del Track
    OscMessage armMessage = new OscMessage("/live/mute");
    int[] d = PApplet.parseInt(split(claveClip, '-'));
    armMessage.add(d[0]);
    //oscP5.send(armMessage, myRemoteLocation);
    oscP5.send(armMessage);
  }

  //Pregunto por el tempo
  OscMessage tempoMessage = new OscMessage("/live/tempo");
  //oscP5.send(tempoMessage, myRemoteLocation);
  oscP5.send(tempoMessage);
  println("+++++++++++++Fin Pregunta++++++++++++++");
}
class Red {
  float h, s, b, a, x1, y1,  x2, y2;

  Red(float tempx1, float tempy1, float tempx2, float tempy2, float colorH, float colorS, float colorB, float alpha) {
    x1=tempx1;
    y1=tempy1;
    x2=tempx2;
    y2=tempy2;
    h = colorH;
    s = colorS;
    b = colorB;
    a = alpha;
  }

  public void dibujaRed() {
    stroke(h, s, b, a);
    strokeWeight(2);
    line(x1, y1, x2, y2);
  }
}
//Todos los Eventos que escuchamos de Ableton

public void oscEvent(OscMessage theOscMessage) {
  String path=theOscMessage.addrPattern();

  //Nos da la info de todos los clips que hay (track, clip, name, color) 
  if (path.equals("/live/name/clip")) {
    println("+++++++++++++Oyendo "+path+"++++++++++++++++");
    timerPuntoRojo.start(1);
    statePuntoRojo = 1;

    HashMap<String, Object> infoLoop = new HashMap<String, Object>();
    infoLoop.put("trackLoop", theOscMessage.arguments()[0]);
    infoLoop.put("clipLoop", theOscMessage.arguments()[1]);
    infoLoop.put("nombreLoop", theOscMessage.arguments()[2]);
    infoLoop.put("colorS", random(50, 100));
    infoLoop.put("colorB", random(80, 100));

    if ((Integer)theOscMessage.arguments()[0]==0) {
      infoLoop.put("colorH", random(105, 120));
    } 
    else if ((Integer)theOscMessage.arguments()[0]==1) {
      infoLoop.put("colorH", random(145, 160));
    }
    else if ((Integer)theOscMessage.arguments()[0]==2) {
      infoLoop.put("colorH", random(300, 315));
    }
    else if ((Integer)theOscMessage.arguments()[0]==3) {
      infoLoop.put("colorH", random(330, 345));
    }
    else if ((Integer)theOscMessage.arguments()[0]==4) {
      infoLoop.put("colorH", random(190, 205));
    }
    else if ((Integer)theOscMessage.arguments()[0]==5) {
      infoLoop.put("colorH", random(210, 225));
    }
    else if ((Integer)theOscMessage.arguments()[0]==6) {
      infoLoop.put("colorH", random(25, 40));
    }
    else if ((Integer)theOscMessage.arguments()[0]==7) {
      infoLoop.put("colorH", random(50, 65));
    }

    miAntropoloops.put(infoLoop.get("trackLoop")+"-"+infoLoop.get("clipLoop"), infoLoop); 
    println(infoLoop.get("trackLoop")+"-"+infoLoop.get("clipLoop"), "/", infoLoop);
    //infoLoop.get("nombreLoop")

    loopsIndexed.add(infoLoop.get("trackLoop")+"-"+infoLoop.get("clipLoop"));
    //println(loopsIndexed);

    PImage unaImagen = loadImage((String)infoLoop.get("nombreLoop")+".jpg");

    misImagenes.put(infoLoop.get("trackLoop")+"-"+infoLoop.get("clipLoop"), unaImagen);
  }
  
  // Me avisa cuando live/name/clip ha terminado de lanzar mensajes
  // Es un path que he a\u00f1adido yo a LiveOSC
  if (path.equals("/live/name/clip/done")) {
   println("***********DONE************");
   //println(theOscMessage.arguments()[0]);
  }

  //Aqu\u00ed escuchamos si un clip cambia de estado (no clip (0), has clip (1), playing (2), triggered (3))
  if (path.equals("/live/clip/info")) {
    int claveTrack = theOscMessage.get(0).intValue();
    int claveClip = theOscMessage.get(1).intValue();
    int state = (Integer)theOscMessage.get(2).intValue();
    println(claveTrack+"-"+claveClip+": "+state);
    
    miAntropoloops.get(claveTrack+"-"+claveClip).put("state", state);

    if (state == 2) {
      ultimoLoop = miAntropoloops.get(claveTrack+"-"+claveClip);
      println(ultimoLoop);
      timerOnda.start(5);
      dibujaOnda = true;
      ultLoopParado = false;
        
     float dvolu = (Float)ultimoLoop.get("volume")*100;
      if (dvolu<=40) {
        d = dvolu*3/4;
      } 
      else if (40<dvolu && dvolu<=70) {
        d = (4*dvolu-70)/3;
      }
      else if (dvolu>70 && dvolu<=80) {
        d= 5*dvolu-280;
      }else if(dvolu > 80){
      d = 120;
      }
      
      
     }
      if (state == 1) {
        if((Integer)ultimoLoop.get("trackLoop")==claveTrack && (Integer)ultimoLoop.get("clipLoop")==claveClip){
        ultLoopParado = true;
        }
      }
  }

  if (path.equals("/live/play")) {
    playStop = theOscMessage.get(0).intValue();
  }

  if (path.equals("/live/clip/loopend")) {
    timerPuntoVerde.start(1);
    statePuntoVerde = 1;

    ct1 = ct1 + 1;
    String idTrackClip=loopsIndexed.get(ct1);
    miAntropoloops.get(idTrackClip).put("loopend", theOscMessage.get(0).floatValue());
    //println("loopend "+theOscMessage.get(0).floatValue());
  }

  if (path.equals("/live/volume")) {
    for (int i=0; i<loopsIndexed.size(); i++) {
      String claveClip=loopsIndexed.get(i);
      int[] a = PApplet.parseInt(split(claveClip, '-'));
      if (a[0] == theOscMessage.get(0).intValue()) {
        miAntropoloops.get(claveClip).put("volume", theOscMessage.get(1).floatValue());
        //println("volume "+theOscMessage.get(0).intValue()+" "+theOscMessage.get(1).floatValue());
       }
    }
  }

  if (path.equals("/live/solo")) {
    for (int i=0; i < loopsIndexed.size(); i++) {
      String claveClip=loopsIndexed.get(i);
      int[] a = PApplet.parseInt(split(claveClip, '-'));
      if (a[0] == theOscMessage.get(0).intValue()) {
        miAntropoloops.get(claveClip).put("solo", theOscMessage.get(1).intValue());
      }
    }
  }

  if (path.equals("/live/mute")) {
    for (int i=0; i < loopsIndexed.size(); i++) {
      String claveClip=loopsIndexed.get(i);
      int[] a = PApplet.parseInt(split(claveClip, '-'));
      if (a[0] == theOscMessage.get(0).intValue()) {
        miAntropoloops.get(claveClip).put("mute", theOscMessage.get(1).intValue());
        //println("mute "+theOscMessage.get(1).intValue());
      }
    }
  }

  if (path.equals("/live/tempo")) {
    timerPuntoVerde.start(1);
    statePuntoVerde = 1;

    tempo = theOscMessage.get(0).floatValue();
    println("tempo: OK");
  }
}
class Timer {
  float savedTime;  // When Timer started
  float totalTime;  // How long Timer should last

  Timer(float pTotalTime)  {
    totalTime = pTotalTime;
  }

  //  Starting the timer
  public void start() {
    savedTime = millis() / 1000.0f; // When the Timer starts it stores the current time in seconds
  }
  
  // Starting the timer by changing its total time
  public void start(float pTotalTime)  {
    totalTime = pTotalTime;
    start();
  }
  
  public boolean isFinished() {
    //  Check how much time has passed
    float passedTime = millis() / 1000.0f - savedTime;
    return passedTime > totalTime;
  }
  
  public float getDelay() {
     return totalTime;
  }
}
  public void settings() {  size(displayWidth, displayHeight); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "AntropoloopsMAP" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
