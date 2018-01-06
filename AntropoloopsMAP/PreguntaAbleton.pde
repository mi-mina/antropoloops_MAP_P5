void remapea() {
  // Le pregunto a Ableton por /live/name/clip
  
  // Declaro el mensaje
  // Me contesta en la forma (int track, int clip, string name)
  OscMessage myMessage = new OscMessage("/live/name/clip");
  
  // Lanzo el mensaje
  oscP5.send(myMessage);
  println("lanzando mensaje /live/name/clip para saber qué clips están presentes y guardarlos en loopIndexed");
} 

void pregunta() {
  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // Preguntas generales, independientes de un clip en concreto
  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
  println("+++++++++++++Lanzando preguntas generales++++++++++++++");
  
  // Pregunto por el tempo
  OscMessage tempoMessage = new OscMessage("/live/tempo");
  oscP5.send(tempoMessage);
  
  // Pregunto por el master volume
  OscMessage masterVolumeMessage = new OscMessage("/live/master/volume");
  oscP5.send(masterVolumeMessage);
  
  // Lanzo mensaje para parar el play general automáticamente por si estaba funcionando,
  // para que cuando se lanze un clip playStop = 2 y se dibujen los círculos
  OscMessage masterStopMessage = new OscMessage("/live/stop");
  oscP5.send(masterStopMessage);
  OscMessage masterPlayMessage = new OscMessage("/live/play");
  oscP5.send(masterPlayMessage);
  
  println("+++++++++++++Fin preguntas generales++++++++++++++");
  println("+++++++++++++ Lanzando preguntas sobre cada clip en loopsIndexed ++++++++++++++");
  
  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // Preguntas asociadas a clips concretos
  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

  // Necesito iterar por loopsIndexed para mandar la pregunta con un orden determinado. 
  // El problema lo tengo con loopend ya que la respuesta me la da exclusivamente con el loopend, sin decirme ni el track, ni el clip
  // De esta forma, sé que la respuesta me la va a dar en el mismo orden que la mando, y por lo tanto
  // puedo hacer corresponder los datos del loopend con un track y un clip determinados
  for (int i = 0; i < loopsIndexed.size(); i++) {
    String claveClip = loopsIndexed.get(i); // Ej: 2-1
    int[] a = int(split(claveClip, '-'));
    
    // Pregunto por el volumen inicial de cada track
    OscMessage volMessage = new OscMessage("/live/volume");
    volMessage.add(a[0]);
    oscP5.send(volMessage);
 
    // Pregunto por el estado inicial del solo
    OscMessage soloMessage = new OscMessage("/live/solo");
    soloMessage.add(a[0]);
    oscP5.send(soloMessage);
    
    // Pregunto por el estado inicial del mute del Track
    OscMessage armMessage = new OscMessage("/live/mute");
    armMessage.add(a[0]);
    oscP5.send(armMessage);
    
    // Pregunto por el loopend
    OscMessage loopMessage = new OscMessage("/live/clip/loopend");
    loopMessage.add(a);
    oscP5.send(loopMessage);
  }
  
  println("+++++++++++++Fin de preguntas sobre cada clip en loopsIndexed++++++++++++++");
}