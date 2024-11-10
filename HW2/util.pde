public void CGLine(float x1, float y1, float x2, float y2) {
    // TODO HW1
    // Please paste your code from HW1 CGLine.
    
    Vector3 lineVector = new Vector3(x2-x1, y2-y1, 0);
    float[] startPoint = {x1, y1};
    float lineLength = lineVector.norm();
    Vector3 lineUnitVector = lineVector.unit_vector();
    for (int i = 0; i < lineLength; i++) {
        drawPoint(startPoint[0], startPoint[1], color(0, 0, 0));
        startPoint[0] += lineUnitVector.x();
        startPoint[1] += lineUnitVector.y();
    }
    
    //  x1 = int(x1);
    //  y1 = int(y1);
    //  x2 = int(x2);
    //  y2 = int(y2);
    //  int dx = int(abs(x2 - x1));
    //  int dy = int(abs(y2 - y1));
    //  int sx = (x1 < x2) ? 1 : -1;
    //  int sy = (y1 < y2) ? 1 : -1; 
    //  int err = dx - dy;
    //  int e2;
    //  while(true){
        
    //    drawPoint(x1,y1,color(0,0,0));
    //    if (x1 == x2 && y1 == y2) break;
    //     e2 = 2 * err;
      
    //  if (e2 > -dy) {
    //    err -= dy;
    //    x1 += sx;
    //  }
      
    //  if (e2 < dx) {
    //    err += dx;
    //    y1 += sy;
    //  }
    //}

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
    // You need to check the coordinate p(x,v) if inside the vertices. 
    // If yes return true, vice versa.int i, j;
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
    // You need to find the bounding box of the vertices v.
    // r1 -------
    //   |   /\  |
    //   |  /  \ |
    //   | /____\|
    //    ------- r2    
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


    Vector3 recordminV = new Vector3(0);
    Vector3 recordmaxV = new Vector3(999);
    Vector3[] result = { recordminV, recordmaxV };
    return result;

}

//public Vector3[] Sutherland_Hodgman_algorithm(Vector3[] points, Vector3[] boundary) {
//    ArrayList<Vector3> input = new ArrayList<Vector3>();
//    ArrayList<Vector3> output = new ArrayList<Vector3>();
//    for (int i = 0; i < points.length; i += 1) {
//        input.add(points[i]);
//    }

//    // TODO HW2
//    // You need to implement the Sutherland Hodgman Algorithm in this section.
//    // The function you pass 2 parameter. One is the vertexes of the shape "points".
//    // And the other is the vertices of the "boundary".
//    // The output is the vertices of the polygon.

//    output = input;

//    Vector3[] result = new Vector3[output.size()];
//    for (int i = 0; i < result.length; i += 1) {
//        result[i] = output.get(i);
//    }
//    return result;
//}

public Vector3[] Sutherland_Hodgman_algorithm(Vector3[] points, Vector3[] boundary) {
    ArrayList<Vector3> input = new ArrayList<Vector3>();
    
    for (int i = 0; i < points.length; i += 1) {
        input.add(points[i]);
    }
    //for(int i = 0; i < points.length; i += 1){
    //println(i,"is",points[i]);}
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

// Helper to check if a point is inside a boundary edge
private boolean isInside(Vector3 p, Vector3 a, Vector3 b) {
      //boundary = {(-1, -1, 0), (-1, 1, 0), (1, 1, 0), (1, -1, 0) };

    return (b.x - a.x) * (p.y - a.y) < (b.y - a.y) * (p.x - a.x);
}

// Helper to calculate the intersection point between a line segment and an edge
//private Vector3 intersect(Vector3 p, Vector3 q, Vector3 a, Vector3 b) {
//    //float A1 = q.y - p.y;
//    //float B1 = p.x - q.x;
//    //float C1 = A1 * p.x + B1 * p.y;
//    //float A2 = b.y - a.y;
//    //float B2 = a.x - b.x;
//    //float C2 = A2 * a.x + B2 * a.y;
//    //float det = A1 * B2 - A2 * B1;
//    //if (det == 0) {
//    //    return p; // Parallel lines, return one point
//    //}
//    //float x = (B2 * C1 - B1 * C2) / det;
//    //float y = (A1 * C2 - A2 * C1) / det;
    
//    float A = p.x * q.y - p.y - q.x;
//    float B = a.x * b.y - a.y - b.x;
//    float C = p.x - q.x;
//    float D = a.x - b.x;
//    float E = p.y - q.y;
//    float F = a.y - b.y;
//    float det = C * F - E * D;
//    if (det == 0) {
//        return p; // Parallel lines, return one point
//    }
//    float x = (A * D - B * C) / det;
//    float y = (A * F - B * E) / det;
    

    
//    return new Vector3(x, y, 0);
//}
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
