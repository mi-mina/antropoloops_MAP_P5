boolean soloState() {

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