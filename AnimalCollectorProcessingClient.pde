import java.util.Arrays;
N_DetectableImage image;

void setup() {
    size(1280, 1200);
    // size(400 , 400);
    // image = new N_DetectableImage("./images/dog_and_cat.png", new N_Vector2(50, 50));
    image = new N_DetectableImage(loadImage("./images/dog_and_cat.png"), new N_Vector2(50, 50));
    // byte[] bytes = {(byte)1};

    // String t0 = DatatypeConverter.printBase64Binary(bytes);
    // String t1 = Utility.printBase64Binary(bytes);
    // byte[] bytesT = Utility.parseBase64Binary(t1);

    // println(bytes);
    // println(t1);
    // println(bytesT);
    // println(Arrays.equals(bytes, bytesT));
    // println(bytes);
    // println(t0.length());
    // println(t0);
    // println();
    // println(t0.length());
    // println(t1);

    // println(t0.equals(t1));
}

void draw() {
  background(0);
  image.draw();
  // ArrayList<PImage> l = image.getCrops();
  // image(l.get(0), 0, 0);
  // image(l.get(1), 100, 100);
}

void mouseClicked() {
  // image.detect(0.6);
  image.showDetectResult = !image.showDetectResult;
}
