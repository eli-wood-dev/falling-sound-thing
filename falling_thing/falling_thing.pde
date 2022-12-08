import ddf.minim.*;

PVector pos;
PVector siz;
PVector targetPos;
PVector targetSize;
int maxDist = 200;
Minim minim;
boolean spacePressed = false;
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

AudioPlayer [] sound = new AudioPlayer[3];

void setup() {
  size(500, 750);
  noStroke();
  textSize(25);
  pos = new PVector(width/2, 0);
  siz = new PVector(100, 100);
  targetSize = new PVector(100, 100);
  targetPos = new PVector(width/2, height - 100);
  minim = new Minim(this);
  for (int i = 0; i < sound.length; i++) {
    sound[i] = minim.loadFile("sound"+i+".wav");
  }
}

void keyPressed() {
  if (key == ' '  && spacePressed == false) {
    spacePressed = true;
    int m;
    m = assess(pos);
    println(m);
    sound[m].play();
    sound[m].rewind();
    currentColour = m;
    currentMessage = m;
  }
}

int assess(PVector p) {
  float limit = targetSize.y/2;
  float dist = targetPos.dist(p);
  int value = 0;
  
  if (dist > limit) {
    value = sound.length-1;
  } else {
    value = round(map(dist, 0, limit, 0, sound.length-1));
  }
  return value;
}


void draw () {
  pos.y += 5;
  if (pos.y - siz.y >= height) {
    pos.y = 0 - siz.y;
    spacePressed = false;
    currentColour = 3;
  }
  
  
  
  background(0);
  fill(255, 0, 0);
  ellipse(targetPos.x, targetPos.y, siz.x, siz.y);
  fill(colours[currentColour]);
  ellipse(pos.x, pos.y, siz.x, siz.y);
  fill(255);
  text(messages[currentMessage], width - 100, 25);
}

void stop()
{
  for (int i = 0; i < sound.length; i++) {
    sound[i].close();
  }
  minim.stop();
  super.stop();
}
