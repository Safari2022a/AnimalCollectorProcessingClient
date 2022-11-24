
public class N_Vector2 {
    public float x;
    public float y;

    N_Vector2() {}

    N_Vector2(float x, float y) {
        this.x = x;
        this.y = y;
    }

    public N_Vector2 add(N_Vector2 other) {
        return new N_Vector2(x + other.x, y + other.y);
    }
    
    public N_Vector2 sub(N_Vector2 other) {
        return new N_Vector2(x - other.x, y - other.y);
    }
}
