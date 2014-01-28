/**
Clockwise Thoughts
 
 Rafael Redondo Tejedor CC - 11.2013
 */

import ddf.minim.*;
import ddf.minim.analysis.*;
import oscP5.*;
import netP5.*;

boolean fullscreen = true;
int imageWidth, imageHeight;

OscP5 oscP5;
NetAddress myRemoteLocation;

Minim minim;
AudioPlayer track1, track2, track3, track4;
BeatDetect beat1, beat2, beat3, beat4;
boolean beatDetected = false;

Particle particleHead = null; 
Particle p = null;
Particle pLast = null;
Particle pNew = null;

int particleCount = 0;
float diameterFactor = 0.5;
float velocityFactor = 0.1;
float creationFactor;
float creationCount = 0;
int screenX, screenY;
int marginX = 300, marginY = 80;
float zoomZ = 0, moveLR = 0, moveUD = 0;
PImage canvas;
float Saturation = 0.1;
int section = 0;
float myTint = 40;
int beatsCount1, beatsCount4, beats1Max = 20, beats4Max = 20;
float beatSpread;
long sectionTime = 0;
boolean spreadHorizontal = false, spreadOut = false;
boolean resetPressed = false;

void setup() {
  frameRate(30);
  size(screenX, screenY); 
  colorMode(HSB);
  noCursor();
  ellipseMode(RADIUS);
  canvas = loadImage("vignette_Fullscreen.png");

  tint(255, myTint);
  image(canvas, 0, 0);
  particleHead = new Particle(1, screenX*3/4, screenY/2, 0);
  particleHead.strokeW = 5; 
  particleHead.strokeL = 180;
  stroke(180, 200);
  particleHead.displayParticle();
  particleCount = 1;

  /* start oscP5, listening for incoming messages at port 9000 */
  oscP5 = new OscP5(this, 8000);
  myRemoteLocation = new NetAddress("192.168.1.130", 9000);
  oscReset();

  /* audio setup*/
  minim = new Minim(this);
  track1 =  minim.loadFile("track11.aif", 1024);
  track4 =  minim.loadFile("track41.aif", 1024);
  beat1 = new BeatDetect();
  beat4 = new BeatDetect();

  beatsCount1 = beats1Max;
  beatsCount4 = beats4Max;
  beatSpread = random(5, 10);

  track1.play();
  track4.play();
}

void draw() {
  /* beat detection */
  beat1.detect(track1.mix);
  beat4.detect(track4.mix);
  if (section == 0) {
    if ( beat1.isOnset() ) particleHead.strokeL = 50;
    else particleHead.strokeL = 180; 
    image(canvas, 0, 0);
    particleHead.xpos = ( particleHead.xpos - screenX/2 ) / 1.007 + screenX/2;
    particleHead.changeView(0, 0, 1.2);
    particleHead.displayParticle();
  } 
  else if (section == 1) {
    myTint = min(myTint+0.05, 255);
    tint(255, myTint);
    particleHead.strokeW = 1;
    image(canvas, 0, 0);
    Saturation += 1.12;   
    if ( beat1.isOnset() ) {
      particleHead.strokeL = 50;
//      particleHead.strokeW = 1;
      particleHead.saturation = Saturation;
    } 
    else {
      particleHead.strokeL = 180;
//      particleHead.strokeW = 0;
      particleHead.saturation = max(particleHead.saturation*0.88, 0);
    }
    particleHead.displayParticle();
  }
  else if (section == 2) {
    image(canvas, 0, 0);
    p = particleHead;
    pLast = null;
    while ( p != null )
    {
      if ( p.ypos < -p.diameter-marginY || p.ypos > screenY + marginY + p.diameter ) {
        if (pLast !=null) {
          pLast.next = p.next;
        } 
        else {
          particleHead = p.next;
          pLast = null;
        }
        particleCount--;
      } 
      else {
        if (  beatsCount4 > 0 && beat4.isOnset() && !beat1.isOnset() &&
          p.ypos < screenY && p.diameter % beatSpread < 2 && p.diameter > 15 ) {
          p.saturation = 255;
          beatsCount4--;
        }
        else { 
          p.saturation = max(p.saturation*0.8, 0);
        }
        /* Particle Displacement */
        p.ypos -= velocityFactor * p.diameter;
        p.xpos += (p.diameter % 4) - 2; // x-bias
        if (spreadHorizontal) p.xpos += 1.5*(p.diameter-25);
        if (spreadOut) {
          p.xpos += 5E-6*(p.xpos-screenX*0.5)*abs(p.xpos-screenX*0.5)*p.diameter;
          p.ypos += 5E-6*(p.ypos-screenY*0.5)*abs(p.ypos-screenY*0.5)*p.diameter;
        }
        p.changeView(moveLR, moveUD, zoomZ);
        /* Particle display*/
        p.displayParticle();
        pLast = p;
      }
      p = p.next;
    }    

    beatsCount1 = beats1Max;
    beatsCount4 = beats4Max; 
    beatSpread = random(8, 10);   
    creationCount--;

    if ( creationCount < 0 ) 
    {
      p = particleHead;
      pLast = null;
      float diameter = random(1, 100) * diameterFactor;
      diameter = (float)pow(diameter, 4)/100000;
      while ( p != null && p.diameter <= diameter ) {
        pLast = p;
        p = p.next;
      }

      pNew = new Particle(diameter, random(-marginX, screenX+marginX), screenY+marginY+diameter, 0);
      if ( particleCount == 0 ) {
        particleHead = pNew;
      } 
      else {
        pNew.next = p;
        if (pLast != null) {
          pLast.next = pNew;
        } 
        else {
          particleHead = pNew;
        }
      }
      creationCount = creationFactor;
      particleCount++;
    }
  }
  if (resetPressed) {
    zoomZ *= 0.9;
    moveUD *= 0.9;
    moveLR *= 0.9;
    if (abs(zoomZ)<0.01 && abs(moveUD)<0.01 && abs(moveLR)<0.01) {
      resetPressed = false;
      spreadHorizontal = false;
    }
  }
}

