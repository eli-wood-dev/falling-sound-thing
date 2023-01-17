public class Faller {
  PVector pos;
  PVector siz;
  boolean gone = false;
  PImage image;
  boolean hasImage = false;
  
  public Faller(PVector pos, PVector siz) {
    this.pos = pos.copy();
    this.siz = siz.copy();
  }
  
  public Faller(PVector pos, PVector siz, PImage image) {
    this.pos = pos.copy();
    this.siz = siz.copy();
    this.image = image;
    hasImage = true;
  }
  
  
  void fall(color colour) {
    if (pos.y - siz.y <= height) {
      pos.y += 5;
    } else {
      gone = true;
    }
    
    strokeWeight(0);
    
    fill(colour);
    ellipse(pos.x, pos.y, siz.x, siz.y);
    if(hasImage) {
      image(image, pos.x, pos.y, siz.x/1.5, siz.y/1.5);
    }
  }
  
  PVector pos() {
    return pos;
  }
  
  boolean isGone() {
    return gone;
  }
}
