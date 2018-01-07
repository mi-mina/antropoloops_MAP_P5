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

  void dibujaRed() {
    stroke(h, s, b, a);
    strokeWeight(2);
    line(x1, y1, x2, y2);
  }
}