public class Faller {
  PVector pos;
  PVector siz;
  
  public Faller(PVector pos, PVector siz) {
    this.pos = pos.copy();
    this.siz = siz.copy();
  }
  
  
  void fall(color colour) {
    if (pos.y - siz.y <= height) {
      pos.y += 5;
    }
    
    strokeWeight(0);
    
    fill(colour);
    ellipse(pos.x, pos.y, siz.x, siz.y);
  }
  
  PVector pos() {
    return pos;
  }
}
