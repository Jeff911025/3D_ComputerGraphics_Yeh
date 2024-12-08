# Model Transformation

# Perspective Rendering

# Camera Transformation

# Depth Buffer

# Backculling
![back-culling](https://github.com/user-attachments/assets/d89cdbca-2626-4ab0-b7cf-ea13384831b7)

Calculate the angle between view direction and the plane normal vector, if cosine < 0 it implies that plane is invisible.  
In GameObject::debugDraw: 
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
