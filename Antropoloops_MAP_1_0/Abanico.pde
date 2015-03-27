class Abanico {
  float d;
  float x, y, h, s, b;

  // Abanico constructor
  Abanico(float coorX, float coorY, float diam, float colorH, float colorS, float colorB) {
    x = coorX;
    y = coorY;
    d = diam;
    h = colorH;
    s = colorS;
    b = colorB;
  }

  void dibuja() {

    for (int i=0; i<20; i++) {  

      if (d<=40) {
        stroke(h, s, b);
        strokeWeight(1);
        line(0, 0, 0, -d*3/8);
        noStroke();
        fill(h, s, b, 25); 
        arc(0, 0, d*3/4, d*3/4, radians(i*24)-HALF_PI, radians(360)-HALF_PI);


        fill(h, s, b, 1);
        arc(0, 0, d*2, d*2, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
      }
      else if (40<d && d<=70) {
        stroke(h, s, b);
        strokeWeight(1);
        line(0, 0, 0, -(4*d-70)/6);
        noStroke();
        fill(h, s, b, 25); 
        arc(0, 0, (4*d-70)/3, (4*d-70)/3, radians(i*24)-HALF_PI, radians(360)-HALF_PI);


        fill(h, s, b, 1);
        arc(0, 0, d*2.5, d*2.5, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
      }
      else if (d>70 && d<=80) {
        stroke(h, s, b);
        strokeWeight(1);
        line(0, 0, 0, -(5*d-280)/2);
        noStroke();
        fill(h, s, b, 25); 
        arc(0, 0, 5*d-280, 5*d-280, radians(i*24)-HALF_PI, radians(360)-HALF_PI);

        fill(h, s, b, 1);
        arc(0, 0, d*2.5, d*2.5, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
      } 
      else if (d>80) {
        stroke(h, s, b);
        strokeWeight(1);
        line(0, 0, 0, -60);
        noStroke();
        fill(h, s, b, 25); 
        arc(0, 0, 120, 120, radians(i*24)-HALF_PI, radians(360)-HALF_PI);

        fill(h, s, b, 1);
        arc(0, 0, d*2.5, d*2.5, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
      }
    }
  }
}

