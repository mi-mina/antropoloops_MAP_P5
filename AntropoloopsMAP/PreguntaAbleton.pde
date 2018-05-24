void remapea() {
  OscMessage myMessage = new OscMessage("/live/name/clip");
  oscP5.send(myMessage);
  println("lanzo mensaje /live/name/clip");
}

void pregunta() {
  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // Preguntas generales, independientes de un clip en concreto
  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  println("+++++++++++++Lanzando preguntas generales++++++++++++++");

  // Pregunto por el tempo
  OscMessage tempoMessage = new OscMessage("/live/tempo");
  oscP5.send(tempoMessage);

  // Lanzo mensaje para parar el play general automáticamente por si estaba funcionando,
  // para que cuando se lanze un clip playStop = 2 y se dibujen los círculos
  OscMessage masterStopMessage = new OscMessage("/live/stop");
  oscP5.send(masterStopMessage);
  OscMessage masterPlayMessage = new OscMessage("/live/play");
  oscP5.send(masterPlayMessage);

  println("+++++++++++++Fin preguntas generales++++++++++++++");

  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  // Preguntas asociadas a clips concretos
  // ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  println("+++++++++++++ Lanzando preguntas sobre cada clip en loopsIndexed ++++++++++++++");
  for (int i = 0; i < loopsIndexed.size(); i++) {
    //Pregunto por el loopend
    //Necesito iterar por loopsIndexed para mandar la pregunta con un orden determinado,
    //ya que la respuesta me la da exclusivamente con el loopend, sin decirme ni el track, ni el clip
    //De esta forma, sé que la respuesta me la va a dar en el mismo orden que la mando, y por lo tanto
    //puedo hacer corresponder los datos del loopend con un track y un clip determinados

    String claveClip=loopsIndexed.get(i);
    int[] a = int(split(claveClip, '-'));

    OscMessage loopMessage = new OscMessage("/live/clip/loopend");
    loopMessage.add(a);
    oscP5.send(loopMessage);

    //pregunto por el volumen inicial de cada track
    OscMessage volMessage = new OscMessage("/live/volume");
    volMessage.add(a[0]);
    oscP5.send(volMessage);

    //Pregunto por el estado inicial del solo
    OscMessage soloMessage = new OscMessage("/live/solo");
    soloMessage.add(a[0]);
    oscP5.send(soloMessage);

    //Pregunto por el estado inicial del mute del Track
    OscMessage armMessage = new OscMessage("/live/mute");
    armMessage.add(a[0]);
    oscP5.send(armMessage);
  }
}