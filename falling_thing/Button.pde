public class Button {
  PVector pos;
  PVector siz;
  boolean pressed = false;
  String text;
  color colour;
  
  public Button(PVector pos, PVector siz, color colour) {
    this.pos = pos.copy();
    this.siz = siz.copy();
    this.colour = colour;
  }
  
  public Button(PVector pos, PVector siz, color colour, String text) {
    this.pos = pos.copy();
    this.siz = siz.copy();
    this.text = text;
    this.colour = colour;
  }
  
  void draw() {
    rectMode(CENTER);
    fill(colour);
    rect(pos.x, pos.y, siz.x, siz.y);
    if(text != null) {
      textAlign(CENTER, CENTER);
      fill(0);
      textSize(25);
      text(text, pos.x, pos.y);
    }
  }
  
  void check() {
    if(mouseX >= pos.x - siz.x/2 && mouseX <= pos.x + siz.x/2 && mouseY >= pos.y - siz.y/2 && mouseY <= pos.y + siz.y/2) {
      pressed = true;
    } else {
      pressed = false;
    }
  }
  
  boolean isPressed() {
    return pressed;
  }
}
