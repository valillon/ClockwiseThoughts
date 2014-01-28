class Particle {

  float diameter, radius;
  int Color = (int)random(0,255);                // color ball
  float saturation, strokeL, strokeW;
  float xpos, ypos, zpos;
  Particle next;
  
  Particle(float diam, float x, float y, float z) {
    diameter = diam;
    radius = diameter/2;
    saturation = 0;
    strokeW = 1;
    strokeL = 255;
    xpos = x;
    ypos = y;
    zpos = z;
    next = null;
  }

  /* Particle display */
  void displayParticle() {
    stroke(strokeL, 50);
    strokeWeight(strokeW);
    fill(Color, saturation, min((int)pow(diameter, 1.5) + 60, 240));
    ellipse(xpos+(float)cos(ypos/20)*50/diameter, ypos, diameter, diameter);
  }
  
  void changeView(float LR, float UD, float zoom) {
    if (LR != 0) {
      xpos += LR*diameter/100;
    }
    if (UD != 0) { 
      ypos += UD;
    } 
    if (zoom != 0 ) {
      diameter += zoom*diameter/100;
      radius = diameter/2;
    }
  }  
}
