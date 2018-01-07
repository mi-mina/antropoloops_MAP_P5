class Abanico {
  float d;
  float h, s, b;
  float stopAngle = radians(360) - HALF_PI;

  // Abanico constructor
  Abanico(float diam, float colorH, float colorS, float colorB) {
    d = diam * 0.8;
    h = colorH;
    s = colorS;
    b = colorB;
  }

  void dibuja() {
    float rWidth = float(width) / 1280;
    float rHeight = float(height) / 800;

    for (int i = 0; i < 20; i++) {
      float startAngle = radians(i * 24) - HALF_PI;
      float yLine = 0.0;
      float dArc1 = 0.0;
      float dArc2 = 0.0;

      if (float(width)/float(height) >= 1.6) {
        if (d <= 40) {
          yLine = -d * rHeight * 1.2 * 3 / 8;
          dArc1 = d * rHeight * 3 / 4;
          dArc2 = d * rHeight * 2;
        } else if (40 < d && d <= 70) {
          yLine = -(4 * d - 70) / 6 * rHeight * 1.2;
          dArc1 = (4 * d - 70) / 3 * rHeight;
          dArc2 = d * rHeight * 2.5;
        } else if (d > 70 && d <= 80) {
          yLine = -(5 * d - 280) / 2 * rHeight * 1.2;
          dArc1 = (5 * d - 280) * rHeight;
          dArc2 = d * rHeight * 2.5;
        } else if (d > 80) {
          yLine = -60 * rHeight * 1.2;
          dArc1 = 120 * rHeight;
          dArc2 = d * rHeight * 2.5;
        }
      } else {
        if (d <= 40) {
          yLine = -d * 3 / 8 * rWidth * 1.2;
          dArc1 = d * 3 / 4 * rWidth;
          dArc2 = d * rHeight * 2;
        } else if (40 < d && d <= 70) {
          yLine = -(4 * d - 70) / 6 * rWidth * 1.2;
          dArc1 = (4 * d - 70) / 3 * rWidth;
          dArc2 = d * rHeight * 2.5;
        } else if (d > 70 && d <= 80) {
          yLine = -(5 * d - 280) / 2 * rWidth * 1.2;
          dArc1 = (5 * d - 280) * rWidth;
          dArc2 = d * rHeight * 2.5;
        } else if (d > 80) {
          yLine = -60 * rWidth * 1.2;
          dArc1 = 120 * rWidth;
          dArc2 = d * rHeight * 2.5;
        }
      }
      stroke(h, s, b);
      strokeWeight(1);
      line(0, 0, 0, yLine);
      noStroke();
      fill(h, s, b, 25);
      arc(0, 0, dArc1, dArc1, startAngle, stopAngle);
      fill(h, s, b, 2);
      arc(0, 0, dArc2, dArc2, startAngle, stopAngle);
    }
  }
}
