public void CGLine(float x1, float y1, float x2, float y2,color currentcolor) {
    int dx = int(abs(x2 - x1));
    int dy = int(abs(y2 - y1));
    int sx = (x1 < x2) ? 1 : -1;
    int sy = (y1 < y2) ? 1 : -1; 
    int err = dx - dy;
    int e2;
    while(true){
      
      drawPoint(x1,y1,currentcolor);
      if (x1 == x2 && y1 == y2) break;
       e2 = 2 * err;
    
    if (e2 > -dy) {
      err -= dy;
      x1 += sx;
    }
    
    if (e2 < dx) {
      err += dx;
      y1 += sy;
    }
  }

    
    
     //stroke(0);
     //noFill();
     //line(x1,y1,x2,y2);
     
    
}

public void CGCircle(float cx, float cy, float r,color currentcolor) {
    int x = int(r);
    int y = 0;
    int decisionOver2 = 1 - int(r);   // Decision criterion divided by 2 evaluated at (r, 0)
  
    while (x >= y) {
      drawPoint(cx + x, cy + y, currentcolor);  // 1 octant
      drawPoint(cx + y, cy + x, currentcolor);  // 2 octant
      drawPoint(cx - y, cy + x, currentcolor);  // 3 octant
      drawPoint(cx - x, cy + y, currentcolor);  // 4 octant
      drawPoint(cx - x, cy - y, currentcolor);  // 5 octant
      drawPoint(cx - y, cy - x, currentcolor);  // 6 octant
      drawPoint(cx + y, cy - x, currentcolor);  // 7 octant
      drawPoint(cx + x, cy - y, currentcolor);  // 8 octant
    
      y++;
  
      if (decisionOver2 <= 0) {
        decisionOver2 += 2 * y + 1;  // Change in decision criterion for y -> y + 1
      } else {
        x--;
        decisionOver2 += 2 * (y - x) + 1;  // Change for x -> x - 1 and y -> y + 1
      }
    }

    
    //stroke(0);
    //noFill();
    //circle(x,y,r*2);
    
}

public void CGEllipse(float xc, float yc, float r1, float r2,color currentcolor) {
        float x = 0;
        float y = r2;
        float p1 = sq(r2) - sq(r1) * r2 + 0.25 * sq(r1);
    
        float dx = 2 * sq(r2) * x;
        float dy = 2 * sq(r1) * y;
    
        // Region 1
        while (dx < dy) {
            drawSymmetricEllipsePoints(xc, yc, x, y,currentcolor);
            if (p1 < 0) {
                x++;
                dx += 2 * sq(r2);
                p1 += dx + sq(r2);
            } else {
                x++;
                y--;
                dx += 2 * sq(r2);
                dy -= 2 * sq(r1);
                p1 += dx - dy + sq(r2);
            }
        }
    
        // Region 2
        float p2 = sq(r2) * sq(x + 0.5) + sq(r1) * sq(y - 1) - sq(r1) * sq(r2);
        while (y >= 0) {
            drawSymmetricEllipsePoints(xc, yc, x, y,currentcolor);
            if (p2 > 0) {
                y--;
                dy -= 2 * sq(r1);
                p2 += sq(r1) - dy;
            } else {
                x++;
                y--;
                dx += 2 * sq(r2);
                dy -= 2 * sq(r1);
                p2 += dx - dy + sq(r1);
            }
        }
    
    //stroke(currentcolor);
    //noFill();
    //ellipse(x,y,r1*2,r2*2);
}

public void CGCurve(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4,color currentcolor) {
    float t = 0.0;
    //float step = 0.005;
    float totalLength = estimateCurveLength(p1, p2, p3, p4);
    float step = 1.0 / (totalLength *5);

    while (t <= 1.0) {
        float x = pow(1 - t, 3) * p1.x +
                  3 * pow(1 - t, 2) * t * p2.x +
                  3 * (1 - t) * pow(t, 2) * p3.x +
                  pow(t, 3) * p4.x;

        float y = pow(1 - t, 3) * p1.y +
                  3 * pow(1 - t, 2) * t * p2.y +
                  3 * (1 - t) * pow(t, 2) * p3.y +
                  pow(t, 3) * p4.y;

        drawPoint(x, y, currentcolor);

        t += step;
    }

    
    //stroke(currentcolor);
    //noFill();
    //bezier(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,p4.x,p4.y);
    
}



public void CGEraser(Vector3 p1, Vector3 p2) {
    // TODO HW1
    // You need to erase the scene in the area defined by points p1 and p2 in this
    // section.
    // p1 ------
    // |       |
    // |       |
    // ------ p2
    // The background color is color(250);
    // You can use the mouse wheel to change the eraser range.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).

}

public void drawPoint(float x, float y, color c) {
    stroke(c);
    point(x, y);
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}
void drawSymmetricEllipsePoints(float xc, float yc, float x, float y,color currentcolor) {
    drawPoint(xc + x, yc + y, currentcolor);
    drawPoint(xc - x, yc + y, currentcolor);
    drawPoint(xc + x, yc - y, currentcolor);
    drawPoint(xc - x, yc - y, currentcolor);
}

public float estimateCurveLength(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4) {
    int numSegments = 100;  // 通过分段来估算曲线长度
    float length = 0.0;
    float prevX = p1.x;
    float prevY = p1.y;

    for (int i = 1; i <= numSegments; i++) {
        float t = i / (float) numSegments;

        float x = pow(1 - t, 3) * p1.x +
                  3 * pow(1 - t, 2) * t * p2.x +
                  3 * (1 - t) * pow(t, 2) * p3.x +
                  pow(t, 3) * p4.x;

        float y = pow(1 - t, 3) * p1.y +
                  3 * pow(1 - t, 2) * t * p2.y +
                  3 * (1 - t) * pow(t, 2) * p3.y +
                  pow(t, 3) * p4.y;

        // 计算相邻点之间的距离并累加
        length += dist(prevX, prevY, x, y);
        prevX = x;
        prevY = y;
    }

    return length;
}
