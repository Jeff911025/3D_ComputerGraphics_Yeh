# Model Transformation

# Perspective Rendering

# Camera Transformation

# Depth Buffer
Calculates the depth of a point in a triangle and allows for visualization control.  
The appearance of depth (darker or lighter depending on proximity) can be toggled using the ```tntd``` boolean. Additionally, you can choose between two depth calculation methods by setting the ```Use_equation``` boolean.
```processing
public float getDepth(float x, float y, Vector3[] vertex ) {
    boolean tntd = true; // The near the darker?
    boolean Use_equation = true; // Use plane equation or gravity as depth function
    if(Use_equation) return getDepth_equation(x,y,vertex, tntd);
    else return getDepth_gravity(x,y,vertex, tntd);
}
```
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

# Camera Control
### Camera position
w/W : Camera move forward  
a/A : Camera move backward  
s/S : Camera move left  
d/D : Camera move backward  
q/Q : Camera move up  
e/E : Camera move down  
### Camera lookat
i/I : Camera look forward  
ak/K : Camera look backward  
j/J : Camera look left  
l/L : Camera move backward  
u/U : Camera look up  
o/O : Camera look down  

# Some observation
When object is beyond the view, the object will still appear on screen in a inversed control manner, which is abnormal. May take time to fix.
