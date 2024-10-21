# Completed tasks
## Basic
+ CGLine()
+ CGCircle()
+ CGEllipse()
+ CGCurve()
+ CGEraser()


## Bonus
+ color palette function
+ thickness selection bar function
+ Another type of beizer curve (different order when specify points)
+ Allow only 3 control points beizer curve (Just right click when you have specify 3 points)
+ util.estimateCurveLength() predicts the length of curve, avoiding the disconnection problem.

# Screenshoot

![image](https://github.com/user-attachments/assets/6f771789-0af6-4f8f-8b8f-a3e8eede1e8a)


# Complementation
## Color palette
![image](https://github.com/user-attachments/assets/21c3aac5-29ab-43cf-b3b2-780558b9a666)

Use ControlP5 library for palette GUI, the selected color will be appened to the grid. When it's full, the first(oldest) color in the grid will be replaced.
```java
void addSelectedColor() {
    color selectedColor = cp5.get(ColorWheel.class, "colorPicker").getRGB();
    if(color_idx < total_palette_num){
    ColorButton colorButton = new ColorButton(
                selectedColorsX + ((color_idx%palette_per_line) * (paletteSize + horizontal_padding)),
                selectedColorsY + (color_idx++/palette_per_line)*vertical_padding,
                paletteSize,
                paletteSize,
                selectedColor
            );
    colorButton_custom.add(colorButton);
    }else{
      int i = color_idx++ % total_palette_num;
      colorButton_custom.get(i).setColor(selectedColor);
    }
}
```
```java
public void draw() {
              .
              .
              .
              .
    for (ColorButton cb : colorButton_custom) {
        
        cb.run(() -> {
            cb.beSelect();
            currentColor = cb.getColor();
            if (shapeRenderer.renderer != null) {
            shapeRenderer.renderer.setColor(currentColor);
          }
        });
    }
              .
              .
              .
              .
```


## thickness bar
![image](https://github.com/user-attachments/assets/2b7de75c-b214-4b73-b36e-59747873bece)

Use built-in function to draw the toggle bar.
```
void drawSlider() {
    // Draw slider track
    fill(200);
    stroke(0);
    rect(sliderX, sliderY, sliderW, sliderH);
    
    // Draw slider handle
    fill(150);
    stroke(0);
    ellipse(sliderHandleX, sliderY + sliderH / 2, sliderH, sliderH);  // Make the handle circular
    
    // Update thickness based on slider position
    thickness = map(sliderHandleX, sliderX, sliderX + sliderW, 1, 10);  // Thickness range from 1 to 10
    
    // Display current thickness value on screen
    fill(0);
    textSize(12);
    text("Thickness: " + nf(thickness, 1, 2), sliderX + sliderW + 10, sliderY + sliderH / 2);
}

void mouseDragged() {
    // Check if the mouse is dragging within the slider bounds
    if (mouseY > sliderY && mouseY < sliderY + sliderH) {
        // Only move the handle if the mouse is within the slider's width
        if (mouseX >= sliderX && mouseX <= sliderX + sliderW) {
            sliderHandleX = mouseX;  // Update the position of the slider handle
        }
    }
}
```
Make users preview the thickness, shown at the mouse pointer.
```java
public void draw() {
              .
              .
              .
              .
    drawPoint(mouseX, mouseY, currentColor, thickness);
}
```

## Another type of beizer curve (different order when specify points)
![image](https://github.com/user-attachments/assets/c89559eb-66fa-4a0f-a2b4-8185f50a5a35)

The order in TA provided code and GIF is (p1, p4, p2, p2), that is, first point we choose is p1, and the second point will be p4. I add another Render named CurveRenderer_stand, which order is (p1, p2, p3, p4), this can easier control the curve shape.

```java
class CurveRenderer_stand implements Renderer{
  private boolean once;
  private int times;
  private Vector3 cp1;
  private Vector3 cp2;
  private Vector3 cp3;
  private Vector3 cp4;
  private color currentColor;
  @Override
    public void setColor(color c) {
        currentColor = c;  
    }
  @Override
  public void render(){
      if(!shapeRenderer.checkInBox(new Vector3(mouseX,mouseY,0))) return;
      if(mousePressed&& mouseButton == LEFT){
          if(!once){   
              switch(times){
                case 0:
                  cp1 = new Vector3(mouseX,mouseY,0);
                  break;
                case 1:
                  cp2 = new Vector3(mouseX,mouseY,0);
                  break;
                case 2:
                  cp3 = new Vector3(mouseX,mouseY,0);
                  break;
                case 3:
                  cp4 = new Vector3(mouseX,mouseY,0);
                  shapeRenderer.addShape(new fourcCurve(cp1,cp2,cp3,cp4, currentColor, thickness));
                 
                  break;
              }
              times += 1;
              times %=4;
              once = true;
          }
      }else if(mousePressed&& mouseButton == RIGHT){
        if(times==3){
          shapeRenderer.addShape(new fourcCurve(cp1,cp2,cp3,cp3, currentColor, thickness));
          
        }
      times = 0;      
      }
      else{
          once = false;
      }
      Vector3 cp = new Vector3(mouseX,mouseY,0);
      if(times==0) return;
      if(times==1) CGCurve(cp1,cp1,cp ,cp,currentColor, thickness);
      if(times==2) CGCurve(cp1,cp2,cp ,cp,currentColor, thickness);
      if(times==3) CGCurve(cp1,cp2,cp3 ,cp,currentColor, thickness);
      
  }
}
```
## 3 control point beizer curve
![image](https://github.com/user-attachments/assets/0486ca9d-6d01-4660-ba92-f924aa0ce617)

Originally if we specified 3 control point and right click the mouse, it default to cancel drawing. I modified it and now both kind of beizer curver tool support draw curve with only 3 points, just right click the mouse when you've choosed 3 control points. The modification is also shown above.

## util.estimateCurveLength()
<p>
    <img src="https://github.com/user-attachments/assets/bab3eea0-77b1-485d-a5d9-9c00ea459af6" alt="example" width="40%">
    <img src="https://github.com/user-attachments/assets/e68dfbf8-cabf-4c5e-9563-bbbdf95e232e" alt="example" width="40%">
</p>
A fix size of step will make the curve looks disconnected. This function can estimate the length of the curve, dynamically adjust the step, make the curve looks more continuous.

```java
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
```

### Assistance of LLMs

I asked ChatGPT for some java syntax, for example in python we can set default args

```python
def drawPoint(x, y, c, thickness = 1):
```

but in java 

```java
public void drawPoint(float x, float y, color c) {
    drawPoint(x, y, c, 1);
}
public void drawPoint(float x, float y, color c, float thickness) {
                                    .
                                    .
                                    .
```
The util.estimateCurveLength() is done by LLM as well. The other functions I also chat with them, conveying my idea, and ask them when I'm faced with bugs.

### Other changes and observation

# Eraser size

The eraser size range is (10,50) now. 

# Lag issue

It becomes lag if ShapeRenderer save too many shapes, especially when using erasers.

```java
class EraserRenderer implements Renderer{
  private color currentColor;
  @Override
    public void setColor(color c) {
        currentColor = c;  
    }
  @Override
  public void render(){
      if(!shapeRenderer.checkInBox(new Vector3(mouseX,mouseY,0))) return;
      noFill();
      stroke(0);
      rect(mouseX - eraserSize/2,mouseY - eraserSize/2,eraserSize,eraserSize);
      if(mousePressed&& mouseButton == LEFT){
          shapeRenderer.addShape(new EraseArea(new Vector3(mouseX - eraserSize/2,mouseY - eraserSize/2,0),new Vector3(mouseX + eraserSize/2,mouseY + eraserSize/2,0)));
      }
  }
}
```
In my opinion, the issue is caused since the EraseArea is being continusly added to shapeRenderer if users keep clicking LEFT button. If the EraserRenderer should act as PencilRenderer, only when button was released will the shape added to shapeRenderer, this problem may be solved. 

But I have no time to try it >_< I have to make deadline with for other homework. 

Using drawRect function (implemented using vertex) can also ease the lag.
```java
public void CGEraser(Vector3 p1, Vector3 p2) {
    color eraserColor = color(250); 
    //loop is too slow
    //for (float x = p1.x; x <= p2.x; x++) {
    //    for (float y = p1.y; y <= p2.y; y++) {
    //        drawPoint(x, y, eraserColor, 1); 
    //    }
    //}
    
    // vertex also prohibit
    drawRect(p1.x,p1.y,p2.x-p1.x,p2.y-p1.y,true, eraserColor);
}
```
