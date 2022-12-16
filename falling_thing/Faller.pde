public class Faller {
  PVector pos;
  PVector siz;
  boolean gone = false;
  
  public Faller(PVector pos, PVector siz) {
    this.pos = pos.copy();
    this.siz = siz.copy();
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
  }
  
  PVector pos() {
    return pos;
  }
  
  boolean isGone() {
    return gone;
  }
}
