class Abanico {
  float d;
  float x, y, h, s, b;
  
  // Abanico constructor
  Abanico(float coorX, float coorY, float diam, float colorH, float colorS, float colorB) {
    x = coorX;
    y = coorY;
    d = diam*0.8;
    h = colorH;
    s = colorS;
    b = colorB;
  }

  void dibuja() {

    for (int i=0; i<20; i++) {
      if (float(width)/float(height)>=1.6) {  

        if (d<=40) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -d*3/8*height/800*1.2);
          noStroke();
          fill(h, s, b, 25); 
          arc(0, 0, d*3/4*height/800, d*3/4*height/800, radians(i*24)-HALF_PI, radians(360)-HALF_PI);


          fill(h, s, b, 2);
          arc(0, 0, d*2*height/800, d*2*height/800, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
        } else if (40<d && d<=70) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -(4*d-70)/6*height/800*1.2);
          noStroke();
          fill(h, s, b, 25); 
          arc(0, 0, (4*d-70)/3*height/800, (4*d-70)/3*height/800, radians(i*24)-HALF_PI, radians(360)-HALF_PI);


          fill(h, s, b, 2);
          arc(0, 0, d*2.5*height/800, d*2.5*height/800, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
        } else if (d>70 && d<=80) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -(5*d-280)/2*height/800*1.2);
          noStroke();
          fill(h, s, b, 25); 
          arc(0, 0, (5*d-280)*height/800, (5*d-280)*height/800, radians(i*24)-HALF_PI, radians(360)-HALF_PI);

          fill(h, s, b, 2);
          arc(0, 0, d*2.5*height/800, d*2.5*height/800, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
        } else if (d>80) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -60*height/800*1.2);
          noStroke();
          fill(h, s, b, 25); 
          arc(0, 0, 120*height/800, 120*height/800, radians(i*24)-HALF_PI, radians(360)-HALF_PI);

          fill(h, s, b, 2);
          arc(0, 0, d*2.5*height/800, d*2.5*height/800, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
        }
      } else if (float(width)/float(height)<1.6) {  

        if (d<=40) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -d*3/8*width/1280*1.2);
          noStroke();
          fill(h, s, b, 25); 
          arc(0, 0, d*3/4*width/1280, d*3/4*width/1280, radians(i*24)-HALF_PI, radians(360)-HALF_PI);


          fill(h, s, b, 2);
          arc(0, 0, d*2*width/1280, d*2*width/1280, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
        } else if (40<d && d<=70) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -(4*d-70)/6*width/1280*1.2);
          noStroke();
          fill(h, s, b, 25); 
          arc(0, 0, (4*d-70)/3*width/1280, (4*d-70)/3*width/1280, radians(i*24)-HALF_PI, radians(360)-HALF_PI);


          fill(h, s, b, 2);
          arc(0, 0, d*2.5*width/1280, d*2.5*width/1280, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
        } else if (d>70 && d<=80) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -(5*d-280)/2*width/1280*1.2);
          noStroke();
          fill(h, s, b, 25); 
          arc(0, 0, (5*d-280)*width/1280, (5*d-280)*width/1280, radians(i*24)-HALF_PI, radians(360)-HALF_PI);

          fill(h, s, b, 2);
          arc(0, 0, d*2.5*width/1280, d*2.5*width/1280, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
        } else if (d>80) {
          stroke(h, s, b);
          strokeWeight(1);
          line(0, 0, 0, -60*width/1280*1.2);
          noStroke();
          fill(h, s, b, 25); 
          arc(0, 0, 120*width/1280, 120*width/1280, radians(i*24)-HALF_PI, radians(360)-HALF_PI);

          fill(h, s, b, 2);
          arc(0, 0, d*2.5*width/1280, d*2.5*width/1280, radians(i*24)-HALF_PI, radians(360)-HALF_PI);
        }
      }
      
      
      
    }
  }
}