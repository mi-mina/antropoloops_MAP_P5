class Abanico {
  float d;
  float x, y, h, s, b;
  float stopAngle = radians(360) - HALF_PI;

  // Abanico constructor
  Abanico(float coorX, float coorY, float diam, float colorH, float colorS, float colorB) {
    x = coorX;
    y = coorY;
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
      stroke(h, s, b);
      strokeWeight(1);

      if (float(width)/float(height) >= 1.6) {

        if (d <= 40) {
          line(0, 0, 0, -d * 3 / 8 * rHeight * 1.2);

          noStroke();
          fill(h, s, b, 25);
          arc(0, 0, d * 3 / 4 * rHeight, d * 3 / 4 * rHeight, startAngle, stopAngle);
          fill(h, s, b, 2);
          arc(0, 0, d * 2 * rHeight, d * 2 * rHeight, startAngle, stopAngle);
        } else if (40 < d && d <= 70) {
          line(0, 0, 0, -(4 * d - 70) / 6 * rHeight * 1.2);

          noStroke();
          fill(h, s, b, 25);
          arc(0, 0, (4 * d - 70) / 3 * rHeight, (4 * d - 70) / 3 * rHeight, startAngle, stopAngle);
          fill(h, s, b, 2);
          arc(0, 0, d * 2.5 * rHeight, d * 2.5 * rHeight, startAngle, stopAngle);
        } else if (d > 70 && d <= 80) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -(5 * d - 280) / 2 * rHeight * 1.2);
          noStroke();
          fill(h, s, b, 25);
          arc(0, 0, (5 * d - 280) * rHeight, (5 * d - 280) * rHeight, startAngle, stopAngle);
          fill(h, s, b, 2);
          arc(0, 0, d * 2.5 * rHeight, d * 2.5 * rHeight, startAngle, stopAngle);
        } else if (d > 80) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -60 * rHeight * 1.2);
          noStroke();
          fill(h, s, b, 25);
          arc(0, 0, 120 * rHeight, 120 * rHeight, startAngle, stopAngle);
          fill(h, s, b, 2);
          arc(0, 0, d * 2.5 * rHeight, d * 2.5 * rHeight, startAngle, stopAngle);
        }
      } else {
        if (d <= 40) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -d * 3 / 8 * rWidth * 1.2);
          noStroke();
          fill(h, s, b, 25);
          arc(0, 0, d * 3 / 4 * rWidth, d * 3 / 4 * rWidth, startAngle, stopAngle);
          fill(h, s, b, 2);
          arc(0, 0, d * 2 * rWidth, d * 2 * rWidth, startAngle, stopAngle);
        } else if (40 < d && d <= 70) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, - (4 * d - 70) / 6 * rWidth * 1.2);
          noStroke();
          fill(h, s, b, 25);
          arc(0, 0, (4 * d - 70) / 3 * rWidth, (4 * d - 70) / 3 * rWidth, startAngle, stopAngle);
          fill(h, s, b, 2);
          arc(0, 0, d * 2.5 * rWidth, d * 2.5 * rWidth, startAngle, stopAngle);
        } else if (d > 70 && d <= 80) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -(5 * d - 280) / 2 * rWidth * 1.2);
          noStroke();
          fill(h, s, b, 25);
          arc(0, 0, (5 * d - 280) * rWidth, (5 * d - 280) * rWidth, startAngle, stopAngle);
          fill(h, s, b, 2);
          arc(0, 0, d * 2.5 * rWidth, d * 2.5 * rWidth, startAngle, stopAngle);
        } else if (d > 80) {

          line(0, 0, 0, -60 * rWidth * 1.2);
          noStroke();
          fill(h, s, b, 25);
          arc(0, 0, 120 * rWidth, 120 * rWidth, startAngle, stopAngle);
          fill(h, s, b, 2);
          arc(0, 0, d * 2.5 * rWidth, d * 2.5 * rWidth, startAngle, stopAngle);
        }
      }
    }
  }
}
