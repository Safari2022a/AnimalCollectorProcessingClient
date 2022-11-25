N_DetectableImage image;

void setup() {
    size(1880, 1200);
    image = new N_DetectableImage("./images/people.png", new N_Vector2(50, 50));
}

void draw() {
  background(0);
  image.draw();
}

void mouseClicked() {
  image.detect(0.6);
  image.showDetectResult = !image.showDetectResult;
}
