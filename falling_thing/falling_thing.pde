import ddf.minim.*;

PVector pos;
PVector siz;
PVector targetPos;
int maxDist = 200;
Minim minim;

AudioPlayer [] sound = new AudioPlayer[3];

void setup() {
  size(500, 750);
  noStroke();
  pos = new PVector(width/2, 0);
  siz = new PVector(200, 100);
  targetPos = new PVector(width/2, height - 100);
  
  minim = new Minim(this);
  for (int i = 0; i < sound.length; i++) {
    sound[i] = minim.loadFile("sound"+i+".wav");
  }
}

void keyPressed() {
  if (key == ' ') {
    int m;
    if (dist(pos.x, pos.y, targetPos.x, targetPos.y) > maxDist) {
      m = sound.length-1;
    } else {
      m = round(map(dist(pos.x, pos.y, targetPos.x, targetPos.y), 0, maxDist, 0, sound.length-1));
    }
    println(m);
    sound[m].play();
    sound[m].rewind();
  }
}

void draw () {
  pos.y += 5;
  if (pos.y - siz.y >= height) {
    pos.y = 0 - siz.y;
  }
  
  
  
  background(0);
  fill(255, 0, 0);
  ellipse(targetPos.x, targetPos.y, siz.x, siz.y);
  fill(255);
  ellipse(pos.x, pos.y, siz.x, siz.y);
}

void stop()
{
  for (int i = 0; i < sound.length; i++) {
    sound[i].close();
  }
  minim.stop();
  super.stop();
}
