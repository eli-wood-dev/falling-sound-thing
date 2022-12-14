import ddf.minim.*;

PVector pos;
PVector siz;
PVector targetPos;
PVector targetSize;
PVector otherCircleSize;
int maxDist = 200;
Minim minim;
int currentColour = 3;
int currentMessage = 3;

String [] messages = {
  "Perfect!",
  "Close!",
  "Miss!",
  ""
};

color [] colours = {
  color(0, 255, 0, 100),
  color(150, 150, 0, 100),
  color(255, 0, 0, 100),
  color(0, 0, 255, 100)
};

color [] outlineColours = {
  color(0, 255, 0),
  color(150, 150, 0),
  color(255, 0, 0),
  color(0, 0, 255)
};

ArrayList<Faller> fallers;
ArrayList<Integer>currentColours;
ArrayList<Boolean>pressed;

AudioPlayer [] sound = new AudioPlayer[3];

void setup() {
  fallers = new ArrayList<Faller>();
  currentColours = new ArrayList<Integer>();
  pressed = new ArrayList<Boolean>();
  size(500, 750);
  textSize(25);
  pos = new PVector(width/2, 0);
  siz = new PVector(100, 100);
  targetSize = new PVector(100, 100);
  targetPos = new PVector(width/2, height - 100);
  otherCircleSize = new PVector(0, 0);
  minim = new Minim(this);
  for (int i = 0; i < sound.length; i++) {
    sound[i] = minim.loadFile("sound"+i+".wav");
  }
}

void keyPressed() {
  if (key == ' ') {
    checkFaller();
  }
}

void mousePressed() {
  checkFaller();
}

void checkFaller () {
  int m;
  if (getLowestFaller(fallers, pressed) == null) {
    m = 2;
  } else {
    m = assess(getLowestFaller(fallers, pressed).pos);
    currentColours.set(getLowestFallerNum(fallers, pressed), m);
    pressed.set(getLowestFallerNum(fallers, pressed), true);
  }
  println(m);
  sound[m].play();
  sound[m].rewind();
  currentMessage = m;
}

int assess(PVector p) {
  float dist = targetPos.dist(p);
  int value = 0;
  
  if (dist > maxDist) {
    value = sound.length-1;
  } else {
    value = round(map(dist, 0, maxDist, 0, sound.length-1));
  }
  return value;
}

void closingRing(PVector posA, PVector p) {
  if (p.y < targetPos.y) {
    PVector sizA = new PVector(0, 0);
    
    float dist = targetPos.dist(p);
    sizA.x = map(dist, 0, height, targetSize.x, min(width, height));
    sizA.y = map(dist, 0, height, targetSize.y, min(width, height));
    
    noFill();
    strokeWeight(2);
    stroke(outlineColours[assess(p)]);
    ellipse(posA.x, posA.y, sizA.x, sizA.y);
  }
}

Faller getLowestFaller(ArrayList<Faller> fallers, ArrayList<Boolean> pressed) {
  float max = 0;
  
  for (int i = 0; i < fallers.size(); i++) {
    if (fallers.get(i).pos.y < height && !pressed.get(i)) {
      max = max(max, fallers.get(i).pos.y);
    }
  }
  
  for (int i = 0; i < fallers.size(); i++) {
    if (fallers.get(i).pos.y == max) {
      return fallers.get(i);
    }
  }
  
  //shouldn't get here
  return null;
}

int getLowestFallerNum(ArrayList<Faller> fallers, ArrayList<Boolean> pressed) {
  float max = 0;
  
  for (int i = 0; i < fallers.size(); i++) {
    if (fallers.get(i).pos.y < height && !pressed.get(i)) {
      max = max(max, fallers.get(i).pos.y);
    }
  }
  
  for (int i = 0; i < fallers.size(); i++) {
    if (fallers.get(i).pos.y == max) {
      return i;
    }
  }
  
  //shouldn't get here
  return 0;
}

void draw () {
  /*
  pos.y += 5;
  if (pos.y - siz.y >= height) {
    pos.y = 0 - siz.y;
    spacePressed = false;
    currentColour = 3;
  }
  */
  
  if (frameCount % 60 == 0) {
    fallers.add(new Faller(pos, siz));
    currentColours.add(3);
    pressed.add(false);
  }
  
  background(0);
  strokeWeight(0);
  fill(255, 0, 0);
  ellipse(targetPos.x, targetPos.y, siz.x, siz.y);
  /*
  fill(colours[currentColour]);
  ellipse(pos.x, pos.y, siz.x, siz.y);
  */
  
  fill(255);
  text(messages[currentMessage], width - 100, 25);
  
  for (int i = 0; i < fallers.size(); i++) {
    fallers.get(i).fall(colours[currentColours.get(i)]);
    closingRing(targetPos, fallers.get(i).pos);
  }
}

void stop()
{
  for (int i = 0; i < sound.length; i++) {
    sound[i].close();
  }
  minim.stop();
  super.stop();
}
