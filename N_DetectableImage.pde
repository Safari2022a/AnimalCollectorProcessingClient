import http.requests.*;
import java.nio.ByteBuffer;

class N_DetectableImage extends N_ObjectBase {
    public PImage pImage;
    
    private boolean isDetected = false;
    public boolean showDetectResult = true;
    ArrayList<DetectRect> detectRects;
   
    N_DetectableImage(String imgPath, N_Vector2 position) {
        super();

        transform.setPosition(position);
        pImage = loadImage(imgPath);
        detectRects = new ArrayList<DetectRect>();
        detect(0.8);
    }

    //サーバーに画像を送信し、識別結果をdetectRectsに格納
    public void detect(float conf) {
        if (isDetected) return;

        // pImage.loadPixels();
        // String base64str = Utility.pixelsToBase64(pImage.pixels);
        // String jsonText = String.format("{\"img_base64\": \"%s\", \"width\": %d, \"height\": %d, \"conf\": %.5f}", base64str, pImage.width, pImage.height, conf);

        //通信関係の処理
        // PostRequest post = new PostRequest(Settings.baseURL + "animal-detect");
        // post.addHeader("Content-Type", "application/json");
        // post.addData(jsonText);
        // post.send(); //Httpリクエストを送信し、レスポンスが返ってくるまで待つ
        // print(post.getContent());
        // // print(post.getContent() instanceof String);

        String res = "{\"params\": [[\"dog\",0.30150464177131653,0.5088607668876648,0.5821759104728699,0.946835458278656,0.8615586757659912],[\"cat\",0.7913773059844971,0.5449367165565491,0.3697916567325592,0.8620253205299377,0.9362995624542236]]}";
        JSONObject resultJson = parseJSONObject(res);
        JSONArray jsonArray = resultJson.getJSONArray("params");
        

        detectRects.clear();
        for (int i = 0; i < 100; i++) {
            if (jsonArray.isNull(i)) break;
            ArrayList<Float> label = new ArrayList<Float>();
            JSONArray _jsonArray = jsonArray.getJSONArray(i);
            String cls = _jsonArray.getString(0);
            for (int j = 1; j < 6; j++) {
                if (_jsonArray.isNull(j)) break;
                label.add(_jsonArray.getFloat(j));
            }
            DetectRect detectRect = new DetectRect(cls, label, this);
            detectRects.add(detectRect);
        }
        
        isDetected = true;
        showDetectResult = true;
    }
    
    void draw() {
        image(pImage, transform.getPosition().x, transform.getPosition().y);

        if (showDetectResult) {
            for (int i = 0; i < detectRects.size(); i++) {
                detectRects.get(i).draw();
            }
        }
    }
}

class DetectRect extends N_ObjectBase {
    public final String cls;
    public final float w;
    public final float h;
    public final float x;
    public final float y;
    public final float conf;
    color rectColor = color(255, 80, 255);

    DetectRect(String cls, ArrayList<Float> label, N_DetectableImage image) {
        super();
        
        this.cls = cls;
        w = label.get(2) * image.pImage.width;
        h = label.get(3) * image.pImage.height;
        x = label.get(0) * image.pImage.width - w/2;
        y = label.get(1) * image.pImage.height - h/2;
        conf = label.get(4);

        transform.setParent(image.transform);
        transform.setLocalPosition(new N_Vector2(x, y));
    }

    public void draw() {
        strokeWeight(3);
        fill(rectColor);
        rect(transform.getPosition().x, transform.getPosition().y - 20, 80, 20);
        fill(255);
        textSize(16);
        String s = String.format("%s   %.2f", cls, conf);
        text(s, transform.getPosition().x, transform.getPosition().y - 8);
        noFill();
        stroke(rectColor);
        rect(transform.getPosition().x, transform.getPosition().y, w, h);
    }
}
