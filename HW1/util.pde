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
    int decisionOver2 = 1 - x;   // Decision criterion divided by 2 evaluated at (r, 0)
  
    while (x >= y) {
      // Draw the circle using symmetry in all octants
      drawPoint(cx + x, cy + y, currentcolor);  // First octant
      drawPoint(cx + y, cy + x, currentcolor);  // Second octant
      drawPoint(cx - y, cy + x, currentcolor);  // Third octant
      drawPoint(cx - x, cy + y, currentcolor);  // Fourth octant
      drawPoint(cx - x, cy - y, currentcolor);  // Fifth octant
      drawPoint(cx - y, cy - x, currentcolor);  // Sixth octant
      drawPoint(cx + y, cy - x, currentcolor);  // Seventh octant
      drawPoint(cx + x, cy - y, currentcolor);  // Eighth octant
    
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

public void CGEllipse(float x, float y, float r1, float r2,color currentcolor) {
    // TODO HW1
    // You need to implement the "ellipse algorithm" in this section.
    // You can use the function ellipse(x, y, r1,r2); to verify the correct answer.
    // However, remember to comment out the function before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).

    
    stroke(currentcolor);
    noFill();
    ellipse(x,y,r1*2,r2*2);
    

}

public void CGCurve(Vector3 p1, Vector3 p2, Vector3 p3, Vector3 p4,color currentcolor) {
    // TODO HW1
    // You need to implement the "bezier curve algorithm" in this section.
    // You can use the function bezier(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x,
    // p4.y); to verify the correct answer.
    // However, remember to comment out before you submit your homework.
    // Otherwise, you will receive a score of 0 for this part.
    // Utilize the function drawPoint(x, y, color) to apply color to the pixel at
    // coordinates (x, y).

    
    stroke(currentcolor);
    noFill();
    bezier(p1.x,p1.y,p2.x,p2.y,p3.x,p3.y,p4.x,p4.y);
    
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
