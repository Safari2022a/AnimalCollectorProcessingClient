import http.requests.*;

class N_DetectableImage extends N_ObjectBase {
    public PImage pImage;
    
    private boolean isDetected = false;
    public boolean showDetectResult = true;
    ArrayList<DetectRect> detectRects;

    static final float shrinkRatio = 5;
   
    N_DetectableImage(PImage pImage, N_Vector2 position) {
        super();

        transform.setPosition(position);
        this.pImage = pImage;
        detectRects = new ArrayList<DetectRect>();
        detect(0.8);
    }

    N_DetectableImage(String imgPath, N_Vector2 position) {
        this(loadImage(imgPath), position);
    }
    
    public ArrayList<PImage> getCrops() {
        ArrayList<PImage> res = new ArrayList<PImage>();
        for (int i = 0; i < detectRects.size(); i++) {
            DetectRect dr = detectRects.get(i);
            res.add(pImage.get((int)dr.x, (int)dr.y, (int)dr.w, (int)dr.h));
        }
        return res;
    }

    //サーバーに画像を送信し、識別結果をdetectRectsに格納
    public void detect(float conf) {
        if (isDetected) return;
        PImage _pImage = pImage.get();
        _pImage.resize(_pImage.width/(int)shrinkRatio, _pImage.height/(int)shrinkRatio);

        _pImage.loadPixels();
        int t0_0 = millis();
        String base64str = Utility.pixelsToBase64(_pImage.pixels);
        int t0_1 = millis();
        println(String.format("time: %d", t0_1 - t0_0));
        String jsonText = String.format("{\"img_base64\": \"%s\", \"width\": %d, \"height\": %d, \"conf\": %.5f}", base64str, _pImage.width, _pImage.height, conf);

        //通信関係の処理
        PostRequest post = new PostRequest(N_Settings.baseURL + "animal-detect");
        post.addHeader("Content-Type", "application/json");
        post.addData(jsonText);
        post.send(); //Httpリクエストを送信し、レスポンスが返ってくるまで待つ

        // String res = "{\"params\": [[\"dog\",0.30150464177131653,0.5088607668876648,0.5821759104728699,0.946835458278656,0.8615586757659912],[\"cat\",0.7913773059844971,0.5449367165565491,0.3697916567325592,0.8620253205299377,0.9362995624542236]]}";
        // JSONObject resultJson = parseJSONObject(res);
        JSONObject resultJson = parseJSONObject(post.getContent());
        JSONArray jsonArray = resultJson.getJSONArray("params");

        println(resultJson);
        
        detectRects.clear();
        for (int i = 0; i < 6; i++) {
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
        //大枠
        strokeWeight(3);
        fill(rectColor);
        rect(transform.getPosition().x, transform.getPosition().y - 20, 80, 20);
        
        //左上の四角
        String s = String.format("%s   %.2f", cls, conf);
        fill(255);
        textSize(16);
        text(s, transform.getPosition().x, transform.getPosition().y - 8);
        noFill();
        stroke(rectColor);
        rect(transform.getPosition().x, transform.getPosition().y, w, h);
    }
}
