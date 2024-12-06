import javax.swing.JFileChooser;
import javax.swing.filechooser.FileNameExtensionFilter;

public Vector4 renderer_size;
static public float GH_FOV = 45.0f;
static public float GH_NEAR_MIN = 1e-3f;
static public float GH_NEAR_MAX = 1e-1f;
static public float GH_FAR = 1000.0f;

public boolean debug = true;

public float[] GH_DEPTH;
public PImage renderBuffer;

Engine engine;
Camera main_camera;
Vector3 cam_position;
Vector3 lookat;

void setup() {
    size(1000, 600);
    renderer_size = new Vector4(20, 50, 520, 550);
    cam_position = new Vector3(0, 0, -10);
    lookat = new Vector3(0, 0, 0);
    setDepthBuffer();
    main_camera = new Camera();
    engine = new Engine();

}

void setDepthBuffer(){
    renderBuffer = new PImage(int(renderer_size.z - renderer_size.x) , int(renderer_size.w - renderer_size.y));
    GH_DEPTH = new float[int(renderer_size.z - renderer_size.x) * int(renderer_size.w - renderer_size.y)];
    for(int i = 0 ; i < GH_DEPTH.length;i++){
        GH_DEPTH[i] = 1.0;
        renderBuffer.pixels[i] = color(1.0*250);
    }
}

void draw() {
    background(255);
    engine.run();
    cameraControl();
}

String selectFile() {
    JFileChooser fileChooser = new JFileChooser();
    fileChooser.setCurrentDirectory(new File("."));
    fileChooser.setFileSelectionMode(JFileChooser.FILES_ONLY);
    FileNameExtensionFilter filter = new FileNameExtensionFilter("Obj Files", "obj");
    fileChooser.setFileFilter(filter);

    int result = fileChooser.showOpenDialog(null);
    if (result == JFileChooser.APPROVE_OPTION) {
        String filePath = fileChooser.getSelectedFile().getAbsolutePath();
        return filePath;
    }
    return "";
}

void cameraControl(){
    // You can write your own camera control function here.
    // Use setPositionOrientation(Vector3 position,Vector3 lookat) to modify the ViewMatrix.
    // Hint : Use keyboard event and mouse click event to change the position of the camera.       
        

    
    float moveSpeed = 0.1f;   // 相机移动的速度
    float rotateSpeed = 0.01f; // 相机旋转的速度
    
    // 键盘控制：WASD 控制相机前后左右移动
    if (keyPressed) {
        if (key == 'w' || key == 'W') {
            cam_position.z += moveSpeed;  // 相机前移
        }
        if (key == 's' || key == 'S') {
            cam_position.z -= moveSpeed;  // 相机后移
        }
        if (key == 'a' || key == 'A') {
            cam_position.x += moveSpeed;  // 相机向左平移
        }
        if (key == 'd' || key == 'D') {
            cam_position.x -= moveSpeed;  // 相机向右平移
        }
        if (key == 'q' || key == 'Q') {
            cam_position.y += moveSpeed;  // 相机向右平移
        }
        if (key == 'e' || key == 'E') {
            cam_position.y -= moveSpeed;  // 相机向右平移
            
        }
        println(cam_position.x,cam_position.y,cam_position.z);
    }

    // 鼠标控制：控制相机的旋转
    //if (mousePressed) {
      
    //    // 水平旋转（绕y轴旋转）
    //    float deltaX = mouseX - pmouseX; // 鼠标水平移动的距离
    //    cam_position.x += deltaX * rotateSpeed;

    //    // 垂直旋转（绕x轴旋转）
    //    float deltaY = mouseY - pmouseY; // 鼠标垂直移动的距离
    //    cam_position.y -= deltaY * rotateSpeed;

    //    // 更新相机的朝向（旋转后的视角）
    //    lookat.x = cam_position.x + cos(cam_position.x); // 计算新的视线方向
    //    lookat.y = cam_position.y + sin(cam_position.y); // 计算新的视线方向
    //    lookat.z = 0; // 假设我们只在 x-y 平面旋转，相机的 z 方向保持不变
        
    //    println(cam_position.x,cam_position.y,cam_position.z);

    
        
    //}
    main_camera.setPositionOrientation(cam_position, lookat);

}
