float pv1,pv2,pv3;

public void CGLine(float x1, float y1, float x2, float y2) {
    stroke(0);
    line(x1, y1, x2, y2);
}

public boolean outOfBoundary(float x, float y) {
    if (x < 0 || x >= width || y < 0 || y >= height)
        return true;
    return false;
}

public void drawPoint(float x, float y, color c) {
    int index = (int) y * width + (int) x;
    if (outOfBoundary(x, y))
        return;
    pixels[index] = c;
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}

boolean pnpoly(float x, float y, Vector3[] vertexes) {
    // TODO HW2
    // You need to check the coordinate p(x,v) if inside the vertexes.
    //return false;
    
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

public Vector3[] findBoundBox(Vector3[] v) {    
    // TODO HW2
    // You need to find the bounding box of the vertexes v.
    //Vector3 recordminV = new Vector3(1.0 / 0.0);
    //Vector3 recordmaxV = new Vector3(-1.0 / 0.0);
    //Vector3[] result = { recordminV, recordmaxV };
    //return result;
    
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

public Vector3[] Sutherland_Hodgman_algorithm(Vector3[] points, Vector3[] boundary) {
    //ArrayList<Vector3> input = new ArrayList<Vector3>();
    //ArrayList<Vector3> output = new ArrayList<Vector3>();
    //for (int i = 0; i < points.length; i += 1) {
    //    input.add(points[i]);
    //}

    //// TODO HW2
    //// You need to implement the Sutherland Hodgman Algorithm in this section.
    //// The function you pass 2 parameter. One is the vertexes of the shape "points".
    //// And the other is the vertexes of the "boundary".
    //// The output is the vertexes of the polygon.

    //output = input;

    //Vector3[] result = new Vector3[output.size()];
    //for (int i = 0; i < result.length; i += 1) {
    //    result[i] = output.get(i);
    //}
    //return result;
    
    
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
                //println("add:",next);
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
    
    //output = input;
    println(input.size());
    Vector3[] result = new Vector3[input.size()];
    for (int i = 0; i < input.size(); i++) {
        result[i] = input.get(i);
    }

    return result;   
}

private boolean isInside(Vector3 p, Vector3 a, Vector3 b) {
      //boundary = {(-1, -1, 0), (-1, 1, 0), (1, 1, 0), (1, -1, 0) };

    return (b.x - a.x) * (p.y - a.y) < (b.y - a.y) * (p.x - a.x);
}

private Vector3 intersect(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4) {
    float x1 = p1.x, y1 = p1.y;
    float x2 = p2.x, y2 = p2.y;
    float x3 = p3.x, y3 = p3.y;
    float x4 = p4.x, y4 = p4.y;
    //println(x3,y3,x4,y4);

    // Calculate the denominator (determinant)
    float denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4);

    // Check if lines are parallel (denominator is 0)
    if (denominator == 0) {
        return null; // Lines are parallel, so no intersection
    }

    // Calculate the numerator for Px
    float numeratorX = ((x1 * y2 - y1 * x2) * (x3 - x4)) - ((x1 - x2) * (x3 * y4 - y3 * x4));

    // Calculate the numerator for Py
    float numeratorY = ((x1 * y2 - y1 * x2) * (y3 - y4)) - ((y1 - y2) * (x3 * y4 - y3 * x4));

    // Calculate the intersection point coordinates
    float Px = numeratorX / denominator;
    float Py = numeratorY / denominator;

    return new Vector3(Px, Py, 0);
}

public float getDepth(float x, float y, Vector3[] vertex ) {
    boolean tntb = false; // The near the brighter?
    boolean Use_equation = true; // Use plane equation or gravity as depth function
    if(Use_equation) return getDepth_equation(x,y,vertex, tntb);
    else return getDepth_gravity(x,y,vertex, tntb);
}

private int callCount = 0; // 全局計數器
public float getDepth_equation(float x, float y, Vector3[] vertex, boolean tntb ) {
    // TODO HW3
    // You need to calculate the depth (z) in the triangle (vertex) based on the
    // positions x and y. and return the z value;
    //return 0.0;
    
    float d;
    float a;
    float b;
    float c;
    float result_z;
    Vector3 v1 = vertex[0];
    Vector3 v2 = vertex[1];
    Vector3 v3 = vertex[2];
    Vector3 v12 = new Vector3(v2.x-v1.x,v2.y-v1.y,v2.z-v1.z);
    Vector3 v13 = new Vector3(v3.x-v1.x,v3.y-v1.y,v3.z-v1.z);
    Vector3 planeNorm = Vector3.cross(v12,v13);
    a = planeNorm.x;
    b = planeNorm.y;
    c = planeNorm.z;
    d = -(a * v1.x + b * v1.y + c * v1.z);
    result_z = -(a*x + b*y + d)/c;
    if(tntb){
    result_z = (result_z + 1) / 2; //the near the brighter
    }else{
    result_z = 1 - (result_z + 1) / 2; //the farther the brighter
    }
    //if(v1.z!=pv1 && v2.z!=pv2 && v3.z!=pv3){
    //    println(" is ", v1.z, v2.z, v3.z, result_z);
    //    pv1 = v1.z;
    //    pv2 = v2.z;
    //    pv3 = v3.z;
       
    //}
    callCount++;
    if (max(v1.z, v2.z, v3.z) < cam_position.z && callCount % 100 == 0) {
        println("No way bro");
    }
    return result_z;
}

public float getDepth_gravity(float x, float y, Vector3[] vertex, boolean tntb) {
    // TODO HW3
    // You need to calculate the depth (z) in the triangle (vertex) based on the
    // positions x and y. and return the z value;
    //return 0.0;

    Vector3 v1 = vertex[0];
    Vector3 v2 = vertex[1];
    Vector3 v3 = vertex[2];


    float totalArea = triangleArea(v1.x, v1.y, v2.x, v2.y, v3.x, v3.y);


    float lambda1 = triangleArea(x, y, v2.x, v2.y, v3.x, v3.y) / totalArea;
    float lambda2 = triangleArea(v1.x, v1.y, x, y, v3.x, v3.y) / totalArea;
    float lambda3 = triangleArea(v1.x, v1.y, v2.x, v2.y, x, y) / totalArea;


    float result_z = lambda1 * v1.z + lambda2 * v2.z + lambda3 * v3.z;
    if(tntb){
    result_z = (result_z + 1) / 2; //the near the brighter
    }else{
    result_z = 1 - (result_z + 1) / 2; //the farther the brighter
    }
    callCount++;
    if (max(v1.z, v2.z, v3.z) < cam_position.z && callCount % 100 == 0) {
        println("No way bro");
    }
    return result_z;
    
}


private float triangleArea(float x1, float y1, float x2, float y2, float x3, float y3) {
    return Math.abs((x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2)) / 2.0f);
}


float[] barycentric(Vector3 P, Vector4[] verts) {

    Vector3 A = verts[0].homogenized();
    Vector3 B = verts[1].homogenized();
    Vector3 C = verts[2].homogenized();

    // TODO HW4
    // Calculate the barycentric coordinates of point P in the triangle verts using
    // the barycentric coordinate system.

    float[] result = { 0.0, 0.0, 0.0 };

    return result;
}
