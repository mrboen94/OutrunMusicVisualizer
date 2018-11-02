/*
 * Author: Mathias Bøe
 * Freely based on the code by the code of Daniel Shiffman
 *       http://codingtra.in
 *       http://patreon.com/codingtrain
 *       https://youtu.be/IKB1hWWedMk
*/

import processing.sound.*;
Amplitude amp;
SoundFile sound;

PImage sun;
int cols, rows;
int scl = 20;
int w = 3000;
int h = 2600;
float angle = 2;
int modulator = 50;

float flying = 0;
float reverseFlight;

float[][] terrain;

void setup() {
  amp = new Amplitude(this);
  sound = new SoundFile(this, "mp3.mp3");
  sound.loop();
  amp.input(sound);
  sun = loadImage("sun.jpg");
  size(630, 630, P3D);
  cols = w / scl;
  rows = h/ scl;
  terrain = new float[cols][rows];
  smooth(4);
}


void draw() {


  flying -= 0.2;
  reverseFlight += 0.2;

  float yoff = flying;
  float yyoff = reverseFlight;
  for (int y = 0; y < rows; y++) {
    float xxoff = 0;
    float xoff = 0;
    float ampSound = amp.analyze()*modulator;
    for (int x = 0; x < cols; x++) {
      if (x < ((rows/2)+7) || x > ((rows/2)+13)) {
        terrain[x][y] = map(noise(xoff, yoff), 0, 1, -50, 50);
      } else {
        terrain[x][y] = map(noise(xxoff, yyoff), 0, 1, -1*ampSound, ampSound);
      }
      xxoff += 0.2;
      xoff += 0.2;
    }
    yyoff += 0.2;
    yoff += 0.2;
  }



  background(sun);
  stroke(255, 70*amp.analyze(), 255);
  fill(0);

  translate(width/2, height/2+50);
  rotateX(PI/angle);
  translate(-w/2, -h/2);
  for (int y = 0; y < rows-1; y++) {
    beginShape(TRIANGLE_STRIP);
    for (int x = 0; x < cols; x++) {
      vertex(x*scl, y*scl, terrain[x][y]);
      vertex(x*scl, (y+1)*scl, terrain[x][y+1]);
      //rect(x*scl, y*scl, scl, scl);
    }
    endShape();
  }
  if (keyPressed) {
    keyPressed();
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      angle += 0.01;
    }
    if (keyCode == DOWN) {
      angle -= 0.01;
    }
    if (keyCode == RETURN || keyCode == ENTER) {
      angle = 2;
      modulator = 50;
    }
    if (keyCode == LEFT) {
      modulator -= 1;
    }
    if (keyCode == RIGHT) {
      modulator += 1;
    }
  }
}
