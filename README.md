# Model Transformation
Just multiply the translation, rotation x, rotation y, rotation z, and the scale matrices.  
```math
T_{world} = T_{translation}\cdot T_{rotation} \cdot T_{scale}
```
```processing
Matrix4 localToWorld() {    
    Matrix4 scaleMatrix = Matrix4.Scale(transform.scale);
    Matrix4 rotationZ = Matrix4.RotZ(transform.rotation.z);
    Matrix4 rotationX = Matrix4.RotX(transform.rotation.x);
    Matrix4 rotationY = Matrix4.RotY(transform.rotation.y);
    Matrix4 rotationMatrix = rotationZ.mult(rotationX).mult(rotationY);
    Matrix4 translationMatrix = Matrix4.Trans(transform.position);
    return translationMatrix.mult(rotationMatrix).mult(scaleMatrix);
}
```
# Perspective Rendering
![image](https://github.com/user-attachments/assets/841a89b3-d889-4989-b957-3b8f275cb032)  
Follows what teacher taught, constructing the matrix as:  
```processing
        projection.m[0] = 1.0f;         
        projection.m[1] = 0.0f;
        projection.m[2] = 0.0f;
        projection.m[3] = 0.0f;
    
        projection.m[4] = 0.0f;
        projection.m[5] = aspect;   
        projection.m[6] = 0.0f;
        projection.m[7] = 0.0f;
    
        projection.m[8] = 0.0f;
        projection.m[9] = 0.0f;
        projection.m[10] = (n / (n - f)) * tanHalfFOV; 
        projection.m[11] = (f / (f - n)) * tanHalfFOV;   
    
        projection.m[12] = 0.0f;
        projection.m[13] = 0.0f;
        projection.m[14] = tanHalfFOV;   
        projection.m[15] = 0.0f;
```
This matrix transforms points from projection space to image space.
# Camera Transformation
Follows teacher's instruction:
![image](https://github.com/user-attachments/assets/083a5414-600d-4947-8dee-e6594fbe7e7c)

```processing
void setPositionOrientation(Vector3 pos, Vector3 lookat) {
        worldView = Matrix4.Identity();
        Vector3 topVector = Vector3.UnitY(); // topVector = (0,1,0)
        Vector3 forward = Vector3.sub(lookat, pos).unit_vector();
        Vector3 right = Vector3.cross(topVector, forward).unit_vector();
        Vector3 up = Vector3.cross(forward, right);
        Matrix4 GlobalRotationMatrix = new Matrix4();
        GlobalRotationMatrix.m[0] = right.x();    GlobalRotationMatrix.m[1] = right.y();   GlobalRotationMatrix.m[2] = right.z();    GlobalRotationMatrix.m[3] = 0;
        GlobalRotationMatrix.m[4] = up.x();       GlobalRotationMatrix.m[5] = up.y();      GlobalRotationMatrix.m[6] = up.z();       GlobalRotationMatrix.m[7] = 0;
        GlobalRotationMatrix.m[8] = forward.x();  GlobalRotationMatrix.m[9] = forward.y(); GlobalRotationMatrix.m[10] = forward.z(); GlobalRotationMatrix.m[11] = 0;
        GlobalRotationMatrix.m[12] = 0;           GlobalRotationMatrix.m[13] = 0;          GlobalRotationMatrix.m[14] = 0;           GlobalRotationMatrix.m[15] = 1;
        Matrix4 mirrorXMatrix = new Matrix4();
        mirrorXMatrix.m[0] = -1; mirrorXMatrix.m[1] = 0;  mirrorXMatrix.m[2] = 0;  mirrorXMatrix.m[3] = 0;
        mirrorXMatrix.m[4] =  0; mirrorXMatrix.m[5] = 1;  mirrorXMatrix.m[6] = 0;  mirrorXMatrix.m[7] = 0;
        mirrorXMatrix.m[8] =  0; mirrorXMatrix.m[9] = 0;  mirrorXMatrix.m[10] = 1; mirrorXMatrix.m[11] = 0;
        mirrorXMatrix.m[12] = 0; mirrorXMatrix.m[13] = 0; mirrorXMatrix.m[14] = 0; mirrorXMatrix.m[15] = 1;
        
        worldView = mirrorXMatrix.mult(GlobalRotationMatrix).mult(translation);
    }
```
# Depth Buffer
Calculates the depth of a point in a triangle and allows for visualization control.  
The appearance of depth (darker or lighter depending on proximity) can be toggled using the ```tntb``` boolean. Additionally, you can choose between two depth calculation methods by setting the ```Use_equation``` boolean.
```processing
public float getDepth(float x, float y, Vector3[] vertex ) {
    boolean tntb = true; // The near the brighter?
    boolean Use_equation = true; // Use plane equation or gravity as depth function
    if(Use_equation) return getDepth_equation(x,y,vertex, tntd);
    else return getDepth_gravity(x,y,vertex, tntd);
}
```
![zbuffer](https://github.com/user-attachments/assets/53ce4711-6db7-4edb-9cb5-bfb5f1962ad7)

# Backculling
![back-culling](https://github.com/user-attachments/assets/d89cdbca-2626-4ab0-b7cf-ea13384831b7)

Calculate the angle between view direction and the plane normal vector, if cosine < 0 it implies that plane is invisible.  
Implementation is at GameObject::debugDraw, the crucial concept: 
```processing
 ...
float dotProduct = Vector3.dot(normal, viewDir);
if (dotProduct < 0) {
    continue;
}
...
```
```normal``` is the calculated normal vector of the triangle plane. ```viewDir``` represents teh vector from camera position to the center of the triangle plane.
# Camera Control
### Camera position
- w/W : Camera move forward  
- a/A : Camera move backward  
- s/S : Camera move left  
- d/D : Camera move backward  
- q/Q : Camera move up  
- e/E : Camera move down  
### Camera lookat
- i/I : Camera look forward  
- k/K : Camera look backward  
- j/J : Camera look left  
- l/L : Camera move backward  
- u/U : Camera look up  
- o/O : Camera look down  

# Some observation
##  backculling and depthbuffer 1
The center of gravity based depth buffer appears to lead to unsatisfied back culling.
##  backculling and depthbuffer 2
When object is not deeper than you (no matter the view of you, facing or backing), the object will still appear on screen in a inversed control manner and back culling works abnormal. May take more time to fix.
In both util::getDepth_gravity and util::getDepth_equation:
```processing
if (max(v1.z, v2.z, v3.z) < cam_position.z && callCount % 100 == 0) {
        println("No way bro");
}
```
Once the z of camera position is greater than one of the triangle vertex, the warning message will be printed.
