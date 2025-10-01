
float t = 0;
PGraphics pg;
ArrayList<PVector> mouseHistory = new ArrayList<PVector>();

float smoothX, smoothY;
float prevSmoothX, prevSmoothY;
int historySize = 600;

void setupFIGURE_01() {
  pg = createGraphics(width, height, P2D);
  smoothX = width/2;
  smoothY = height/2;
  prevSmoothX = smoothX;
  prevSmoothY = smoothY;
  t = 0;
  mouseHistory.clear();
}

void FIGURE_01() {
  background (0);
  if (beat.isKick()) {
    print("si");
    fill (255);
    rect(0, 0, width, height);
  }

  if (lastScene != currentScene) {
    t = 0;
    smoothX = width/2;
    smoothY = height/2;
    prevSmoothX = smoothX;
    prevSmoothY = smoothY;
    mouseHistory.clear();
    lastScene = currentScene;
  }

  smoothX = lerp(smoothX, mouseX - width/2, 0.2);
  smoothY = lerp(smoothY, mouseY - height/2, 0.2);

  float movement = dist(smoothX, smoothY, prevSmoothX, prevSmoothY);


  float movementNormalized = constrain(movement / 3.0, 0, 1);
  int maxHead = 40;
  int headSize = int(round(movementNormalized * maxHead));


  if (mouseHistory.isEmpty()) {
    mouseHistory.add(new PVector(0, 0));
  }


  mouseHistory.add(new PVector(smoothX, smoothY));
  if (mouseHistory.size() > historySize) {
    mouseHistory.remove(0);
  }

  pg.beginDraw();
  pg.clear();
  pg.translate(width/2, height/2);

  int numLines = 150;
  float spacingRange = map(mouseY, 0, height, 10, 200);


  int recentStart = max(0, mouseHistory.size() - headSize);

  for (int i = 0; i < numLines; i++) {
    float offset = t + i * 0.5;
    float scale = 0.5 * (1 + 0.15 * sin(offset * 0.07 + t * 0.01));

    int historyIndex = 0;
    if (mouseHistory.size() > 1) {
      historyIndex = int(map(i, 0, numLines - 1, 0, mouseHistory.size() - 1));
      historyIndex = constrain(historyIndex, 0, mouseHistory.size() - 1);
    }
    PVector pos = mouseHistory.get(historyIndex);

    float spacing = map(i, 0, numLines, -spacingRange, spacingRange);

    float x1f = (x1(offset) + pos.x + spacing) * scale;
    float y1f = (y1(offset) + pos.y) * scale;
    float x2f = (x2(offset) + pos.x + spacing) * scale;
    float y2f = (y2(offset) + pos.y) * scale;

    x1f = constrain(x1f, -width/2, width/2);
    y1f = constrain(y1f, -height/2, height/2);
    x2f = constrain(x2f, -width/2, width/2);
    y2f = constrain(y2f, -height/2, height/2);


    if (headSize > 0 && historyIndex >= recentStart) {

      float a = 150;
      if (headSize > 1) {
        a = map(historyIndex, recentStart, mouseHistory.size()-1, 150, 255);
      }
      pg.stroke(255, 120, 120, a);
    } else {
      pg.stroke(255, 220);
    }

    pg.strokeWeight(2);
    pg.line(x1f, y1f, x2f, y2f);
  }

  pg.endDraw();
  image(pg, 0, 0);


  t += 0.5;
  prevSmoothX = smoothX;
  prevSmoothY = smoothY;
}


float x1(float tVal) {
  return sin(tVal / freqX1) * 100 + sin(tVal / 15.0) * 20;
}
float y1(float tVal) {
  return cos(tVal / freqY1) * 200 + sin(tVal / 105.0) * 30;
}
float x2(float tVal) {
  return sin(tVal / freqX2) * 500 + sin(tVal) * 2;
}
float y2(float tVal) {
  return cos(tVal / freqY2) * 170 + cos(tVal / 12.0) * 60;
}
