void keyPressed() 
{
  if (key == 'z') {
    zoomZ += 0.5;
    println("Zoom = " + zoomZ);
  } 
  else if (key == 'x') {
    zoomZ -= 0.5;
    println("Zoom = " + zoomZ);
  } 
  else if (key == 's') {
    section++;
    if (section == 2) tint(255, 255);
    println("Next section");
  }
  else if (key == 'v') {
    creationFactor = 1;
    println("Creation = " + creationFactor);
  }
  else if (key == 'b') {
    creationFactor = 30;
    println("Creation = " + creationFactor);
  }
  else if (key == 'n') {
    creationFactor = 10000;
    println("Creation = " + creationFactor);
  }
  else if (key == 'r') {
    resetPressed = true;
    println("Reset");
  }
  else if (key == 'q' || key == ' ') {
    stop();
    println("Quit");
  }
  else if (key == 'h') {
    spreadHorizontal = !spreadHorizontal;
    println("Spread horizontal");
  }
  else if (key == 'o') {
    spreadOut = !spreadOut;
    println("Spread Out");
  }

  if (key == CODED) {
    if (keyCode == UP) {
      moveUD += 1;
      println("Move Up-Down = " + moveUD);
    } 
    else if (keyCode == DOWN) {
      moveUD -= 1;
      println("Move Up-Down = " + moveUD);
    } 
    else if (keyCode == RIGHT) {
      moveLR -= 5;
      println("Move Left-Right = " + moveLR);
    }  
    else if (keyCode == LEFT) {
      moveLR += 5;
      println("Move Left-Right = " + moveLR);
    }
  }
}

boolean sketchFullScreen() {
  if (fullscreen) {
    imageWidth = screenX = 1280;
    imageHeight = screenY = 800;
  }
  else {
    imageWidth = screenX = 1264;
    imageHeight = screenY = 711;
  }
  return fullscreen;
}

void stop()
{
  // always close Minim audio classes when you are finished with them
  track1.close();
  track4.close();
  // always stop Minim before exiting
  minim.stop();

  super.stop();

  exit();
}

