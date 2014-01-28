/* incoming OSC messages */
void oscEvent(OscMessage theOscMessage) {
  if (theOscMessage.addrPattern().equals("/1/UpDownLeftRight")) {
    oscUpDownLeftRight(theOscMessage.get(0).floatValue(), theOscMessage.get(1).floatValue());
  } 
  else if (theOscMessage.addrPattern().equals("/1/zoom")) {
    oscZoom(theOscMessage.get(0).floatValue());
  } 
  else if (theOscMessage.addrPattern().equals("/1/section")) {
    oscSection();
  } 
  else if (theOscMessage.addrPattern().equals("/1/reset")) {
    oscReset();
  } 
  else if (theOscMessage.addrPattern().equals("/1/particles")) {
    oscParticles(theOscMessage.get(0).floatValue());
  }
  else if (theOscMessage.addrPattern().equals("/1/spreadHorizontal")) {
    oscSpreadHorizontal();
  }
  else if (theOscMessage.addrPattern().equals("/1/spreadOut")) {
    oscSpreadOut();
  }
}

void oscUpDownLeftRight(float UD, float LR) {
  moveLR = (float)pow(0.5-LR, 3) * 600;
  moveUD = (float)pow(UD-0.5, 3) * 900;
  println("LeftRight-UpDown = (" + moveLR + "," + moveUD +")");
}

void oscZoom(float zoom) {
  zoomZ = (float)pow(zoom - 0.5, 3) * 40;
  println("zoom = " + zoomZ);
}

void oscSection() {
  if ( millis() - sectionTime > 1000 ) { // avoids duplication
    section++;
    sectionTime = millis();
    if (section == 2) tint(255, 255);
    println("Next Section");
  }
}

void oscReset() {
  println("Reseting");
  resetPressed = true;

  oscParticles(0.5);
  OscMessage myMessage1 = new OscMessage("/1/UpDownLeftRight");
  OscMessage myMessage2 = new OscMessage("/1/zoom");
  OscMessage myMessage3 = new OscMessage("/1/particles");

  myMessage1.add(0.5); // left-right
  myMessage1.add(0.5); // up-down
  myMessage2.add(0.5);
  myMessage3.add(0.5);

  oscP5.send(myMessage1, myRemoteLocation); 
  oscP5.send(myMessage2, myRemoteLocation);
  oscP5.send(myMessage3, myRemoteLocation);
}

void oscParticles(float factor) {
  creationFactor = (1-factor)*(1-factor) * 40;
  println("Particle Factor = " + creationFactor);
}

void oscSpreadHorizontal() {
  spreadHorizontal = !spreadHorizontal;
  println("Spread Horizontal");
}

void oscSpreadOut() {
  spreadOut = !spreadOut;
  println("Spread Out");
}

