import java.util.ArrayList;
import javax.xml.bind.DatatypeConverter;

static class Utility {
    
    public static String pixelsToBase64(int[] pixels) {
        int n = pixels.length;
        byte[] bytes = new byte[3*n];
        for (int i = 0; i < n; i++) {
            color c = pixels[i];
            bytes[3*i] = (byte)(c >> 32 & 0xFF); //red
            bytes[3*i + 1] = (byte)(c >> 8 & 0xFF); //blue
            bytes[3*i + 2] = (byte)(c >> 16 & 0xFF); //green
        }
        return DatatypeConverter.printBase64Binary(bytes);
    }

    public static int[] base64ToInts(String base64str) { //test用
        byte[] bytes = DatatypeConverter.parseBase64Binary(base64str);

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

    // public static ArrayList<ArrayList<Float>> jsonArray2ToFloatList2(JSONArray jsonArray) {
    //     ArrayList<ArrayList<Float>> list = new ArrayList<ArrayList<Float>>();
    //     for (int i = 0; i < 100; i++) {
    //         if (jsonArray.isNull(i)) break;
    //         ArrayList<Float> _list = new ArrayList<Float>();
    //         JSONArray _jsonArray = jsonArray.getJSONArray(i);
    //         for (int j = 0; j < 10; j++) {
    //             if (_jsonArray.isNull(j)) break;
    //             _list.add(_jsonArray.getFloat(j));
    //         }
    //         list.add(_list);
    //     }
    //     return list;
    // }
}
