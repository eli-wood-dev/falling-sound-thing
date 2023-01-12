import ddf.minim.*;

BufferedReader reader;

PVector pos;
PVector siz;
PVector targetPos;
PVector targetSize;
PVector otherCircleSize;
int maxDist = 200;
Minim minim;
int currentColour = 3;
int currentMessage = 3;
//int fallerFrequency = 30;

int nextSpawnPoint = 0;

boolean fileRead = false;
boolean gameOver = false;
boolean spawn = true;

int score = 0;

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

ArrayList<Integer> spawnPoints;

AudioPlayer [] sound = new AudioPlayer[3];

void setup() {
  fallers = new ArrayList<Faller>();
  currentColours = new ArrayList<Integer>();
  pressed = new ArrayList<Boolean>();
  //size(500, 750);
  fullScreen();
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
  
  reader = createReader("input.txt");
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
  score += invert(m) * 100;
}

int assess(PVector p) {
  float dist = targetPos.dist(p);
  int value = 0;
  
  if (dist > maxDist) {
    value = 2;
  } else {
    value = round(map(dist, 0, maxDist, 0, 2));
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
  if(!fileRead) {
    spawnPoints = readFile();
  }
  
  if(spawn) {
    addFaller();
  }
  
  if(fallers.size() == 0 && !spawn) {
    gameOver = true;
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
  text(score, width - 100, 50);
  
  if(!gameOver) {
    for (int i = 0; i < fallers.size(); i++) {
      if (fallers.get(i).isGone() == true) {
        fallers.remove(i);
        currentColours.remove(i);
        pressed.remove(i);
      }
      fallers.get(i).fall(colours[currentColours.get(i)]);
      closingRing(targetPos, fallers.get(i).pos);
    }
  }
}

int invert(int points) { //makes it so hit give 2 and misses give 0
  int newPoints = 1;
  
  if(points == 0) {
    newPoints = 2;
  }
  if(points == 2) {
    newPoints = 0;
  }
  
  return newPoints;
}

void stop()
{
  for (int i = 0; i < sound.length; i++) {
    sound[i].close();
  }
  minim.stop();
  super.stop();
}

void addFaller() {
  if(spawnPoints.size() == 0) {
    spawn = false;
  } else if (spawnPoints.get(0) != 0 && frameCount % spawnPoints.get(0) == 0) {
    fallers.add(new Faller(pos, siz));
    currentColours.add(3);
    pressed.add(false);
    spawnPoints.remove(0);
  } else if(spawnPoints.get(0) == 0) {
    fallers.add(new Faller(pos, siz));
    currentColours.add(3);
    pressed.add(false);
    spawnPoints.remove(0);
  }
}

ArrayList<Integer> readFile() {
  ArrayList<Integer> data = new ArrayList<Integer>();
  String line;
  
  while(true) {
    try{
      line = reader.readLine();
    } catch(Exception e) {
      println(e);
      line = null;
    }
    if(line == null) {
      break;
    } else {
      try {
        data.add(Integer.parseInt(line));
      } catch(Exception e) {
        println(e);
      }
    }
  }
  fileRead = true;
  return data;
}
