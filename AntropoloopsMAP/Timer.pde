class Timer {
  float savedTime;  // When Timer started
  float totalTime;  // How long Timer should last

  Timer(float pTotalTime)  {
    totalTime = pTotalTime;
  }

  //  Starting the timer
  void start() {
    savedTime = millis() / 1000.0; // When the Timer starts it stores the current time in seconds
  }
  
  // Starting the timer by changing its total time
  void start(float pTotalTime)  {
    totalTime = pTotalTime;
    start();
  }
  
  boolean isFinished() {
    //  Check how much time has passed
    float passedTime = millis() / 1000.0 - savedTime;
    return passedTime > totalTime;
  }
  
  float getDelay() {
     return totalTime;
  }
}