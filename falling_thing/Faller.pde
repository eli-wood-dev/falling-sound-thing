public class Faller {
  PVector pos;
  PVector siz;
  boolean gone = false;
  PImage image;
  boolean hasImage = false;
  float speed;
  
  public Faller(PVector pos, PVector siz, float speed) {
    this.pos = pos.copy();
    this.siz = siz.copy();
    this.speed = speed;
  }
  
  public Faller(PVector pos, PVector siz, PImage image, float speed) {
    this.pos = pos.copy();
    this.siz = siz.copy();
    this.speed = speed;
    this.image = image;
    hasImage = true;
  }
  
  
  void fall(color colour) {
    if (pos.y - siz.y <= height) {
      pos.y += speed;
    } else {
      gone = true;
    }
    
    strokeWeight(0);
    
    fill(colour);
    ellipse(pos.x, pos.y, siz.x, siz.y);
    if(hasImage) {
      image(image, pos.x, pos.y, siz.x, siz.y);
    }
  }
  
  PVector pos() {
    return pos;
  }
  
  boolean isGone() {
    return gone;
  }
}
