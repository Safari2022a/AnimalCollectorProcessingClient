import java.util.ArrayList;
import java.nio.ByteBuffer;

// import javax.xml.bind.DatatypeConverter;

static class Utility {
    static final String base64Table = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    static HashMap<Character, Integer> base64Hash;
    static Boolean hashCompleted = false;
    
    public static String pixelsToBase64(int[] pixels) {
        int n = pixels.length;
        byte[] bytes = new byte[3*n];
        for (int i = 0; i < n; i++) {
            color c = pixels[i];
            bytes[3*i] = (byte)(c >> 32 & 0xFF); //red
            bytes[3*i + 1] = (byte)(c >> 8 & 0xFF); //blue
            bytes[3*i + 2] = (byte)(c >> 16 & 0xFF); //green
        }

        // String t0 = DatatypeConverter.printBase64Binary(bytes);
        // String t1 = Utility.printBase64Binary(bytes);
        // println(t0.equals(t1));

        println(String.format("bytes len: %d", n));
        // return DatatypeConverter.printBase64Binary(bytes);
        return Utility.printBase64Binary(bytes); //クソ重いの何で？
    }

    public static int[] base64ToInts(String base64str) { //test用
        byte[] bytes = Utility.parseBase64Binary(base64str);

        int n = bytes.length / 4;
        
        int[] ints = new int[n];
        for (int i = 0; i < n; i++) {
            byte[] temp = new byte[4];
            for (int j = 0; j < 4; j++) {
                temp[j] = bytes[4*i + j];
            }
            ints[i] = ByteBuffer.wrap(temp).getInt();
        }
        return ints;
    }

    public static ArrayList<ArrayList<Float>> jsonArray2ToFloatList2(JSONArray jsonArray) {
        ArrayList<ArrayList<Float>> list = new ArrayList<ArrayList<Float>>();
        for (int i = 0; i < 100; i++) {
            if (jsonArray.isNull(i)) break;
            ArrayList<Float> _list = new ArrayList<Float>();
            JSONArray _jsonArray = jsonArray.getJSONArray(i);
            for (int j = 0; j < 10; j++) {
                if (_jsonArray.isNull(j)) break;
                _list.add(_jsonArray.getFloat(j));
            }
            list.add(_list);
        }
        return list;
    }

    public static String printBase64Binary(byte[] bytes) {
        String res = "";
        int n = bytes.length;

        int cnt6 = 0;
        String val = "";
        for (int i = 0; i < n; i++) {
            byte b = bytes[i];
            for (int j = 0; j < 8; j++) {
                val += String.format("%d", (b & 0x80)/0x80);
                b <<= 1;
                ++cnt6;
                
                if (cnt6 == 6) {
                    int k = Integer.parseInt(val, 2);
                    res += base64Table.charAt(k);
                    val = "";
                    cnt6 = 0;
                }
            }
        }
        
        if (val != "") {
            int t = val.length();
            for (int i = 0; i < 6 - t; i++) {
                val += "0";
            }
            int k = Integer.parseInt(val, 2);
            res += base64Table.charAt(k);
        }

        int eqN = 4 - (res.length() % 4);
        if (eqN != 4) {
            for (int i = 0; i < eqN; i++) {
                res += "=";
            }
        }

        return res;
    }

    public static  byte[] parseBase64Binary(String base64Str_) {
        Utility.setupBase64Hash();
        int eqN = 0;
        int n_ = base64Str_.length();
        for (int i = n_ - 1; i >= 0; i--) {
            if (base64Str_.charAt(i) != '=') break;
            ++eqN;
        }
        String base64Str = base64Str_.substring(0, base64Str_.length() - eqN);
        int n = base64Str.length();
        byte[] res = new byte[n*6/8]; //何でこれでいいのか分からない
        int pos = 0;
        int cnt8 = 0;
        String val = "";
        for (int i = 0; i < n; i++) {
            int b = base64Hash.get(base64Str.charAt(i));
            for (int j = 0; j < 6; j++) {
                // val += String.format("%d", (b & 0x80)/0x80);
                val += String.format("%d", (b & 0x20)/0x20);
                b <<= 1;
                ++cnt8;

                if (cnt8 == 8) {
                    res[pos++] = (byte)Integer.parseInt(val, 2);
                    cnt8 = 0;
                    val = "";
                }
            }
        }

        return res;
    }

    static void setupBase64Hash() {
        if (hashCompleted) return;
        
        Utility.base64Hash = new HashMap<Character, Integer>();
        int n = Utility.base64Table.length();
        for (int i = 0; i < n; i++) {
            Utility.base64Hash.put(Utility.base64Table.charAt(i), i);
        }
    }
}
