class Abanico {
  float d1;
  float d2;
  float f;
  color tC;
  float stopAngle = radians(360) - HALF_PI;

  // Abanico constructor
  Abanico(float vol, float effect, float filter, color trackColor) {
    d1 = vol * 100;
    d2 = effect;
    f = filter;
    tC = trackColor;
  }

  void dibuja() {
    float relativeMessure;
    float relativeWidth = float(width) / 1280;
    float relativeHeight = float(height) / 800;
    if (float(width)/float(height) >= 1.6) {
      relativeMessure = relativeHeight;
    } else {
      relativeMessure = relativeWidth;
    }

    int slicesTotal = 15;
    int slices = int(map(f, 135, 20, 0, slicesTotal));
    float step = 360 / slicesTotal;

    for (int i = slices; i < slicesTotal; i++) {
      float startAngle = radians(i * step) - HALF_PI; // HALF_PI = 3.14 / 2 = 1.57
      float diamVolumeCircle = 0.0;
      if (d1 <= 40) {
        diamVolumeCircle = d1 * 3 / 4 * relativeMessure;
      } else if (40 < d1 && d1 <= 70) {
        diamVolumeCircle = (4 * d1 - 70) / 3 * relativeMessure;
      } else if (d1 > 70 && d1 <= 80) {
        diamVolumeCircle = (5 * d1 - 280) * relativeMessure;
      } else if (d1 > 80) {
        diamVolumeCircle = 120 * relativeMessure;
      }
      float diamTransCircle = diamVolumeCircle * 1.6;
      float yLine = -diamTransCircle / 2;
      float diamEffectCircle = diamTransCircle + diamTransCircle * d2;

      // line
      stroke(tC);
      strokeWeight(1);
      line(0, 0, 0, yLine);
      noStroke();

      // volume circle
      fill(tC, 20);
      arc(0, 0, diamVolumeCircle, diamVolumeCircle, startAngle, stopAngle);

      // translucent circle
      fill(tC, 2);
      arc(0, 0, diamTransCircle, diamTransCircle, startAngle, stopAngle);

      // effect circle
      fill(tC, 2);
      arc(0, 0, diamEffectCircle, diamEffectCircle, startAngle, stopAngle);
    }
  }
}
