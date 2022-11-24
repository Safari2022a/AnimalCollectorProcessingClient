
public class N_Transform {
    // static int instanceCnt = 0;
    // final int id;

    private N_Transform parent = null;

    public N_Transform getParent() { return parent; }
    public void setParent(N_Transform parent) { this.parent = parent; }

    private N_Vector2 position;
    public N_Vector2 getPosition() { return position; }
    public void setPosition(N_Vector2 position) {
        this.position = position;
        localPosition = position;
        if (parent != null)
            localPosition = localPosition.sub(parent.position);
    }

    private N_Vector2 localPosition;
    public N_Vector2 getLocalPosition() { return localPosition; }
    public void setLocalPosition(N_Vector2 localPosition) {
        this.localPosition = localPosition;
        position = localPosition;
        if (parent != null)
            position = position.add(parent.getPosition());
    }

    N_Transform() {
        position = new N_Vector2();
        localPosition = new N_Vector2();
        // id = instanceCnt++;
    }
}
