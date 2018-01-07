void remapea() {

  OscMessage myMessage = new OscMessage("/live/name/clip");
  //oscP5.send(myMessage, myRemoteLocation);
    oscP5.send(myMessage);
  println("lanzo mensaje /live/name/clip");
} 

void pregunta() {
  println("+++++++++++++Ejecutando Pregunta++++++++++++++");

  for (int i=0; i<loopsIndexed.size(); i++) {
    //Pregunto por el loopend
    //Necesito iterar por loopsIndexed para mandar la pregunta con un orden determinado, 
    //ya que la respuesta me la da exclusivamente con el loopend, sin decirme ni el track, ni el clip
    //De esta forma, sé que la respuesta me la va a dar en el mismo orden que la mando, y por lo tanto
    //puedo hacer corresponder los datos del loopend con un track y un clip determinados
  
    String claveClip=loopsIndexed.get(i);

    OscMessage loopMessage = new OscMessage("/live/clip/loopend");
    int[] a = int(split(claveClip, '-'));
    loopMessage.add(a);
    //oscP5.send(loopMessage, myRemoteLocation);
    oscP5.send(loopMessage);
       
    //pregunto por el volumen inicial de cada track
    OscMessage volMessage = new OscMessage("/live/volume");
    int[] b = int(split(claveClip, '-'));
    volMessage.add(b[0]);
    //oscP5.send(volMessage, myRemoteLocation);
    oscP5.send(volMessage);
 
    //Pregunto por el estado inicial del solo
    OscMessage soloMessage = new OscMessage("/live/solo");
    int[] c = int(split(claveClip, '-'));
    soloMessage.add(c[0]);
    //oscP5.send(soloMessage, myRemoteLocation);
    oscP5.send(soloMessage);
    
    //Pregunto por el estado inicial del mute del Track
    OscMessage armMessage = new OscMessage("/live/mute");
    int[] d = int(split(claveClip, '-'));
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