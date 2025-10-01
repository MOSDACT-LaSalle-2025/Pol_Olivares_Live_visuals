
PGraphics pg2;
float t2 = 0;
float bgShift2 = 0;
int historySize2 = 800;
ArrayList<PVector> mouseHistory2 = new ArrayList<PVector>();
ArrayList<Integer> colorHistory2 = new ArrayList<Integer>();

float smoothX2, smoothY2, prevSmoothX2, prevSmoothY2;


float hueValue2 = 0;
float hueStep2 = 2;
float speedThreshold2 = 0.6;
int maxLines2 = 150;
int baseLines2 = 20;
int lastScene2 = -1;

void setupFIGURE_02() {
  pg2 = createGraphics(width, height, P2D);
  smoothX2 = prevSmoothX2 = width/2;
  smoothY2 = prevSmoothY2 = height/2;

  for (int i = 0; i < baseLines2; i++) {
    mouseHistory2.add(new PVector(0, 0));
    colorHistory2.add(color(255));
  }
}


void FIGURE_02() {
  if (lastScene2 != currentScene) {
    t2 = 0;
    smoothX2 = prevSmoothX2 = width/2;
    smoothY2 = prevSmoothY2 = height/2;
    mouseHistory2.clear();
    colorHistory2.clear();
    for (int i = 0; i < baseLines2; i++) {
      mouseHistory2.add(new PVector(0, 0));
      colorHistory2.add(color(255));
    }
    lastScene2 = currentScene;
  }

  smoothX2 = lerp(smoothX2, mouseX, 0.25);
  smoothY2 = lerp(smoothY2, mouseY, 0.25);

  float dsx = smoothX2 - prevSmoothX2;
  float dsy = smoothY2 - prevSmoothY2;
  float speed = sqrt(dsx*dsx + dsy*dsy);
  prevSmoothX2 = smoothX2;
  prevSmoothY2 = smoothY2;

  int newColor = color(255);
  if (speed > speedThreshold2) {
    hueValue2 = (hueValue2 + hueStep2) % 255;
    pushStyle();
    colorMode(HSB, 255);
    newColor = color(hueValue2, 255, 255);
    popStyle();
  }

  mouseHistory2.add(new PVector(smoothX2 - width/2, smoothY2 - height/2));
  colorHistory2.add(newColor);

  if (mouseHistory2.size() > historySize2) {
    mouseHistory2.remove(0);
    colorHistory2.remove(0);
  }

  pg2.beginDraw();
  pg2.clear();
  pg2.translate(width/2, height/2);
  pg2.colorMode(RGB, 255);

  int numLines = min(maxLines2, mouseHistory2.size());
  float spacingRange = map(mouseY, 0, height, 10, 200);

  for (int i = 0; i < numLines; i++) {
    float offset = t2 + i * 0.5;
    float scale = 0.5 * (1 + 0.15 * sin(offset * 0.07 + t2 * 0.01));

    int historyIndex = int(map(i, 0, numLines - 1, 0, mouseHistory2.size() - 1));
    PVector pos = mouseHistory2.get(historyIndex);

    float spacing = map(i, 0, numLines, -spacingRange, spacingRange);

    float x1f = (x3(offset) + pos.x + spacing) * scale;
    float y1f = (y3(offset) + pos.y + spacing) * scale;
    float x2f = (x4(offset) + pos.x + spacing) * scale;
    float y2f = (y4(offset) + pos.y + spacing) * scale;

    x1f = constrain(x1f, -width/2, width/2);
    y1f = constrain(y1f, -height/2, height/2);
    x2f = constrain(x2f, -width/2, width/2);
    y2f = constrain(y2f, -height/2, height/2);

    int c = colorHistory2.get(historyIndex);
    int faded = lerpColor(c, color(255), 0.025);
    colorHistory2.set(historyIndex, faded);

    pg2.stroke(faded, 220);
    pg2.strokeWeight(2);
    pg2.line(x1f, y1f, x2f, y2f);
  }

  pg2.endDraw();
  t2 += 0.5;
  image(pg2, 0, 0);
}

void bg2() {
  pg2.beginDraw();
  for (int y = 0; y < height; y++) {
    float inter = map(y, 0, height, 0, 1);
    float eased = pow(inter, 1.8);

    float redVal = 120 + 60 * sin(bgShift2 * 0.005);
    int c1 = color(redVal, 20, 20);
    int c2 = color(0, 0, 0);

    pg2.stroke(lerpColor(c1, c2, eased));
    pg2.line(0, y, width, y);
  }
  pg2.endDraw();
}


float x3(float t) {
  return sin(t / 10) * 100 + sin(t / 15) * 20;
}
float y3(float t) {
  return cos(t / 10) * 200 + sin(t / 105) * 30;
}
float x4(float t) {
  return sin(t / 10) * 500 + sin(t) * 2;
}
float y4(float t) {
  return cos(t / 20) * 170 + cos(t / 12) * 60;
}
