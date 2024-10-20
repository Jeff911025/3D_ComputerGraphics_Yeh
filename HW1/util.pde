public void CGLine(float x1, float y1, float x2, float y2,color currentcolor, float thickness) {
    int dx = int(abs(x2 - x1));
    int dy = int(abs(y2 - y1));
    int sx = (x1 < x2) ? 1 : -1;
    int sy = (y1 < y2) ? 1 : -1; 
    int err = dx - dy;
    int e2;
    while(true){
      
      drawPoint(x1,y1,currentcolor, thickness);
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

public void CGCircle(float cx, float cy, float r,color currentcolor, float thickness) {
    int x = int(r);
    int y = 0;
    int decisionOver2 = 1 - int(r);   // Decision criterion divided by 2 evaluated at (r, 0)
  
    while (x >= y) {
      drawPoint(cx + x, cy + y, currentcolor, thickness);  // 1 octant
      drawPoint(cx + y, cy + x, currentcolor, thickness);  // 2 octant
      drawPoint(cx - y, cy + x, currentcolor, thickness);  // 3 octant
      drawPoint(cx - x, cy + y, currentcolor, thickness);  // 4 octant
      drawPoint(cx - x, cy - y, currentcolor, thickness);  // 5 octant
      drawPoint(cx - y, cy - x, currentcolor, thickness);  // 6 octant
      drawPoint(cx + y, cy - x, currentcolor, thickness);  // 7 octant
      drawPoint(cx + x, cy - y, currentcolor, thickness);  // 8 octant
    
      
  
      if (decisionOver2 <= 0) {
        decisionOver2 += 2 * y + 3;  // Change in decision criterion for y -> y + 1
        y++;
      } else {
        x--;
        y++;
        decisionOver2 += 2 * (y - x) + 5;  // Change for x -> x - 1 and y -> y + 1
      }
    }

    
    //stroke(0);
    //noFill();
    //circle(x,y,r*2);
    
}

public void CGEllipse(float xc, float yc, float r1, float r2,color currentcolor, float thickness) {
        float x = 0;
        float y = r2;
        float p1 = sq(r2) - sq(r1) * r2 + 0.25 * sq(r1);
    
        float dx = 2 * sq(r2) * x;
        float dy = 2 * sq(r1) * y;
    
        // Region 1
        while (dx < dy) {
            drawSymmetricEllipsePoints(xc, yc, x, y,currentcolor, thickness);
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
            drawSymmetricEllipsePoints(xc, yc, x, y,currentcolor, thickness);
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

public void CGCurve(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4,color currentcolor, float thickness) {
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

        drawPoint(x, y, currentcolor, thickness);

        t += step;
    }

    
    //stroke(currentcolor);
    //noFill();
    //bezier(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,p4.x,p4.y);
    
}


public void CGEraser(Vector3 p1, Vector3 p2) {
    color eraserColor = color(250); 
    //loop is too slow
    for (float x = p1.x; x <= p2.x; x++) {
        for (float y = p1.y; y <= p2.y; y++) {
            drawPoint(x, y, eraserColor, 1); 
        }
    }
    
    
    //can't use rect()
    //stroke(eraserColor);
    //fill(eraserColor);
    //rect(p1.x,p1.y,p2.x-p1.x,p2.y-p1.y);
    
    
    //not very precise
    //float stepSize = 5;
    //for (float y = p1.y; y <= p2.y; y += stepSize) {
    //    CGLine(p1.x, y, p2.x, y, eraserColor, stepSize);  // Erase by drawing a horizontal line
    //}
    
    // vertex also prohibit
    //drawRect(p1.x,p1.y,p2.x-p1.x,p2.y-p1.y,true, eraserColor);
    
    
}

public void drawRect(float x, float y, float w, float h, boolean fillRect, color c) {
    
    if (fillRect) {
        stroke(c);
        beginShape();
        vertex(x, y);
        vertex(x + w, y);
        vertex(x + w, y + h);
        vertex(x, y + h);
        endShape(CLOSE);
        stroke(currentColor);
    }
    
    
    //line(x, y, x + w, y);
    //line(x + w, y, x + w, y + h);
    //line(x + w, y + h, x, y + h);
    //line(x, y + h, x, y);
}

public void drawPoint(float x, float y, color c) {
    drawPoint(x, y, c, 1);
}
public void drawPoint(float x, float y, color c, float thickness) {
    stroke(c);
    strokeWeight(thickness);
    point(x, y);
    strokeWeight(1);
}

public float distance(Vector3 a, Vector3 b) {
    Vector3 c = a.sub(b);
    return sqrt(Vector3.dot(c, c));
}
void drawSymmetricEllipsePoints(float xc, float yc, float x, float y,color currentcolor, float thickness) {
    drawPoint(xc + x, yc + y, currentcolor, thickness);
    drawPoint(xc - x, yc + y, currentcolor, thickness);
    drawPoint(xc + x, yc - y, currentcolor, thickness);
    drawPoint(xc - x, yc - y, currentcolor, thickness);
}

public float estimateCurveLength(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4) {
    int numSegments = 100;
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

        length += dist(prevX, prevY, x, y);
        prevX = x;
        prevY = y;
    }

    return length;
}
