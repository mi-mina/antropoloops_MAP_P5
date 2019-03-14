class Red {
  float a, x1, y1, x2, y2;
  color tC;

  Red(float tempx1, float tempy1, float tempx2, float tempy2, color trackColor, float alpha) {
    x1 = tempx1;
    y1 = tempy1;
    x2 = tempx2;
    y2 = tempy2;
    tC = trackColor;
    a = alpha;
  }

  void dibujaRed() {
    stroke(tC, a);
    // Grosor de laslíneas
    strokeWeight(2);
    line(x1, y1, x2, y2);
  }
}