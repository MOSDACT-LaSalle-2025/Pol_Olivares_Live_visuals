



// INSPIRED ON JOHNWHITEY'S 60'S VISUALS https://archive.org/details/experimentsinmotiongraphics
// TUTORIAL USED: https://www.youtube.com/watch?v=LaarVR1AOvs&t=6s
// seeeINSTRUCTIONS: Press 1 for FIGURE 01 / Press 2 for FIGURE 02 / Press 0 to return here / Press P to save frame / w,a,s,d, to control the values of FIGURE 01 / y and t keys for color red and white

import ddf.minim.*;
import ddf.minim.analysis.*;


int currentScene = 0;
int lastScene = -1;
float freqX1 = 10;
float freqY1 = 10;
float freqX2 = 10;
float freqY2 = 20;
Minim minim;
AudioPlayer song;
BeatDetect beat;


void setup() {

  noCursor();
  fullScreen(P2D);
  minim = new Minim(this);
  song = minim.loadFile("WHITEY.mp3", 1024);
  song.loop();
  beat = new BeatDetect();
  beat.setSensitivity(300);
  setupFIGURE_01();
}

void draw() {
  // beat.detect(song.mix);


  if (lastScene != currentScene) {
    if (currentScene == 1) {
      setupFIGURE_01();
    } else if (currentScene == 2) {
      setupFIGURE_02();
    }
    lastScene = currentScene;
  }


  // Draw scenes
  if (currentScene == 0) {
    drawMenu();
  } else if (currentScene == 1) {
    handleKeysFIGURE_01();
    FIGURE_01();
  } else if (currentScene == 2) {
    FIGURE_02();
  }
}

void keyPressed() {
  if (key == '0') currentScene = 0;
  if (key == '1') currentScene = 1;
  if (key == '2') currentScene = 2;
  if (key == '3') currentScene = 3;
  if (key == 't') {
    fill (255);
    rect (0, 0, width, height);
  }
  if (key == 'y') {
    fill (255, 0, 0);
    rect (0, 0, width, height);
  }

  if (key == 'p' || key == 'P') {
    saveFrame("frame-####.png");
  }

  if (currentScene == 1) {
    if (key == 'w') freqY1 += 1;
    if (key == 's') freqY1 = max(1, freqY1 - 1);
    if (key == 'a') freqX1 = max(1, freqX1 - 1);
    if (key == 'd') freqX1 += 1;
  }
}


void handleKeysFIGURE_01() {
  if (keyPressed) {
    if (key == 'w') freqY1 += 0.2;
    if (key == 's') freqY1 = max(1, freqY1 - 0.2);
    if (key == 'a') freqX1 = max(1, freqX1 - 0.2);
    if (key == 'd') freqX1 += 0.2;
  }
}

void drawMenu() {
  background(20);
  fill(255);
  textAlign(CENTER, CENTER);
  textSize(100);
  text("WHO IS JOHN WHITNEY?\nMUSIC: PEOPLE BY WHITEY ", width/2, height/2);
  // text("\nINSTRUCTIONS:\nPress 1 for FIGURE 01\nPress 2 for FIGURE 02\nPress 0 to return here\nPress P to save frame", width/2, height/2);
}
