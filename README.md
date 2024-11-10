# Completed tasks
+ Translation Matrix, Scaling Matrix, and rotation Matrix
+ pnpoly
+ bounding box finding
+ Sutherland_Hodgman_algorithm

# Screenshots

<p>
    <img src="https://github.com/user-attachments/assets/cf86f883-41b8-4183-b076-342d79cc54be" alt="example" width="40%">
</p>



# Details
## Translation Matrix, Scaling Matrix, and rotation Matrix
Following this 

<p>
    <img src="https://github.com/user-attachments/assets/702108f4-f103-40ff-9926-3b0e94de6576" alt="example" width="40%">
</p>
<details>
  <summary>Expand</summary>
  
```processing
  void makeRotZ(float a) {
    makeIdentity();
    m[0] = cos(a);
    m[1] = -sin(a);
    m[4] = sin(a);
    m[5] = cos(a);

  }
  
  void makeTrans(Vector3 t) {
    makeIdentity();
    m[3] = t.x;
    m[7] = t.y;
    m[11] = t.z;
    
  }
  void makeScale(Vector3 s) {
    makeIdentity();
    m[0] = s.x;
    m[5] = s.y;
    m[10] = s.z;
  }
  ```
</details>

## pnpoly
Intuitive method for checking
```processing
boolean pnpoly(float x, float y, Vector3[] vertexes) {
    boolean inside = false;
    int i,j;
    for (i = 0, j = vertexes.length - 1; i < vertexes.length; j = i++) {
        if ((vertexes[i].y > y) != (vertexes[j].y > y) &&
            (x < (vertexes[j].x - vertexes[i].x) * (y - vertexes[i].y) / (vertexes[j].y - vertexes[i].y) + vertexes[i].x)) {
            inside = !inside;
        }
    }
    return inside;

}
```
## bounding box

<details>
  <summary>Expand</summary>
  
```processing
public Vector3[] findBoundBox(Vector3[] v) {    
    float minX = Float.MAX_VALUE;
    float minY = Float.MAX_VALUE;
    float maxX = Float.MIN_VALUE;
    float maxY = Float.MIN_VALUE;

    for (Vector3 vertex : v) {
        if (vertex.x < minX) minX = vertex.x;
        if (vertex.y < minY) minY = vertex.y;
        if (vertex.x > maxX) maxX = vertex.x;
        if (vertex.y > maxY) maxY = vertex.y;
    }    
    Vector3 recordminV = new Vector3(minX, minY, 0);
    Vector3 recordmaxV = new Vector3(maxX, maxY, 0);
    Vector3[] result = { recordminV, recordmaxV };
    return result;

}
```
</details>

## Sutherland_Hodgman_algorithm

Following [this blog post](https://blog.csdn.net/m0_56494923/article/details/128512626)

### Main function

Iteratively checks each boundary edge and clips the polygon by replacing it with the intersected points.
<details>
  <summary>Expand</summary>
  
```processing
public Vector3[] Sutherland_Hodgman_algorithm(Vector3[] points, Vector3[] boundary) {
    ArrayList<Vector3> input = new ArrayList<Vector3>();
    
    for (int i = 0; i < points.length; i += 1) {
        input.add(points[i]);
    }
    for (int i = 0; i < boundary.length; i++) {
       Vector3 a = boundary[i];
       Vector3 b = boundary[(i + 1) % boundary.length];
       ArrayList<Vector3> output = new ArrayList<Vector3>();
       for (int j = 0; j < input.size(); j++) {
           Vector3 current = input.get(j);
           Vector3 next = input.get((j + 1) % input.size());
  
           boolean currentInside = isInside(current, a, b);
           boolean nextInside = isInside(next, a, b);
           
           if (currentInside && nextInside) {
                output.add(next);
                println("add:",next);
            } else if (currentInside && !nextInside) {
              println("in to out");
                output.add(intersect(current, next, a, b));
                println("add:",intersect(current, next, a, b));
            } else if (!currentInside && nextInside) {
                println("out to in");
                output.add(intersect(current, next, a, b));
                output.add(next);
                println("add:",intersect(current, next, a, b));
                println("add:",next);
            }
        }
      input = new ArrayList<Vector3>(output);
    }
    Vector3[] result = new Vector3[input.size()];
    for (int i = 0; i < input.size(); i++) {
        result[i] = input.get(i);
    }
    return result;
}
```
</details>

### check inside or outside

<p>
    <img src="https://github.com/user-attachments/assets/e1949ff8-ffea-4e9c-8c7b-00ee50cde6b3" alt="example" width="40%">
</p>

<details>
<summary>Expand</summary>
  
```processing
private boolean isInside(Vector3 p, Vector3 a, Vector3 b) {
    return (b.x - a.x) * (p.y - a.y) < (b.y - a.y) * (p.x - a.x);
}
```
</details>


### calculate intersects
<p>
    <img src="https://github.com/user-attachments/assets/798f4cbd-5afa-4969-b38b-035af1e738bf" alt="example" width="40%">
</p>

<details>
  <summary>Expand</summary>
  
```processing
private Vector3 intersect(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4) {
    float x1 = p1.x, y1 = p1.y;
    float x2 = p2.x, y2 = p2.y;
    float x3 = p3.x, y3 = p3.y;
    float x4 = p4.x, y4 = p4.y;

    float denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);

    if (denominator == 0) {
        return null; // Lines are parallel, so no intersection
    }

    float numeratorX = ((x1 * y2 - y1 * x2) * (x3 - x4)) - ((x1 - x2) * (x3 * y4 - y3 * x4));
    float numeratorY = ((x1 * y2 - y1 * x2) * (y3 - y4)) - ((y1 - y2) * (x3 * y4 - y3 * x4));

    // Calculate the intersection point coordinates
    float Px = numeratorX / denominator;
    float Py = numeratorY / denominator;
    return new Vector3(Px, Py, 0);
}
```
</details>


