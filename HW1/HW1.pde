ShapeButton lineButton;
ShapeButton circleButton;
ShapeButton polygonButton;
ShapeButton ellipseButton;
ShapeButton curveButton;
ShapeButton pencilButton;
ShapeButton eraserButton;
ShapeButton curveButton_stand;

ColorButton redButton;
ColorButton blueButton;
ColorButton greenButton;

Button clearButton;

ShapeRenderer shapeRenderer;
ArrayList<ShapeButton> shapeButton;
ArrayList<ColorButton> colorButton;
ArrayList<ColorButton> colorButton_custom;

float eraserSize = 10;
color currentColor = color(0);

public void setup() {
    size(1600, 900);
    background(255);
    shapeRenderer = new ShapeRenderer();
    initButton();
    cp5 = new ControlP5(this);
    cp5.addColorWheel("colorPicker", 290, 10, 50)
       .setRGB(color(255, 0, 0));
    cp5.addButton("addSelectedColor")
       .setPosition(350, 45)
       .setSize(60, 15)
       .setLabel("Add Color");
    sliderHandleX = sliderX + int(map(thickness, 1, 10, 0, sliderW));

}

public void draw() {
    //called automatically 60fps
    background(255);
    drawSlider();
    for (ColorButton cb : colorButton_custom) {
        
        cb.run(() -> {
            cb.beSelect();
            currentColor = cb.getColor();
            if (shapeRenderer.renderer != null) {
            shapeRenderer.renderer.setColor(currentColor);
          }
        });
    }
    
    
    for (ShapeButton sb : shapeButton) {
        //check all buttons in list
        sb.run(() -> {
            sb.beSelect();
            shapeRenderer.setRenderer(sb.getRendererType(),currentColor);
        });
    }

    clearButton.run(() -> {
        shapeRenderer.clear();
    });
    shapeRenderer.box.show();
    drawPoint(mouseX, mouseY, currentColor, thickness);

    shapeRenderer.run();

}

void resetButton() {
    for (ShapeButton sb : shapeButton) {
        sb.setSelected(false);
    }
}
void resetColorButton() {
    for (ColorButton cb : colorButton_custom) {
        cb.setSelected(false);
    }
}

public void initButton() {
    shapeButton = new ArrayList<ShapeButton>();
    colorButton = new ArrayList<ColorButton>();
    colorButton_custom = new ArrayList<ColorButton>();
    lineButton = new ShapeButton(10, 10, 30, 30) {
        @Override
        public void show() {
            super.show();
            stroke(0);
            line(pos.x + 2, pos.y + 2, pos.x + size.x - 2, pos.y + size.y - 2);
        }

        @Override
        public Renderer getRendererType() {
            return new LineRenderer();
        }
    };

    lineButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(lineButton);

    circleButton = new ShapeButton(45, 10, 30, 30) {
        @Override
        public void show() {
            super.show();
            stroke(0);
            circle(pos.x + size.x / 2, pos.y + size.y / 2, size.x - 2);
        }

        @Override
        public Renderer getRendererType() {
            return new CircleRenderer();
        }
    };
    circleButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(circleButton);

    polygonButton = new ShapeButton(80, 10, 30, 30) {
        @Override
        public void show() {
            super.show();
            stroke(0);
            line(pos.x + 2, pos.y + 2, pos.x + size.x - 2, pos.y + 2);
            line(pos.x + 2, pos.y + size.y - 2, pos.x + size.x - 2, pos.y + size.y - 2);
            line(pos.x + size.x - 2, pos.y + 2, pos.x + size.x - 2, pos.y + size.y - 2);
            line(pos.x + 2, pos.y + 2, pos.x + 2, pos.y + size.y - 2);
        }

        @Override
        public Renderer getRendererType() {
            return new PolygonRenderer();
        }

    };

    polygonButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(polygonButton);

    ellipseButton = new ShapeButton(115, 10, 30, 30) {
        @Override
        public void show() {
            super.show();
            stroke(0);
            ellipse(pos.x + size.x / 2, pos.y + size.y / 2, size.x - 2, size.y * 2 / 3);
        }

        @Override
        public Renderer getRendererType() {
            return new EllipseRenderer();
        }

    };

    ellipseButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(ellipseButton);

    curveButton = new ShapeButton(150, 10, 30, 30) {
        @Override
        public void show() {
            super.show();
            stroke(0);
            bezier(pos.x, pos.y, pos.x, pos.y + size.y, pos.x + size.x, pos.y, pos.x + size.x, pos.y + size.y);
        }

        @Override
        public Renderer getRendererType() {
            return new CurveRenderer();
        }

    };

    curveButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(curveButton);
    
    

    clearButton = new Button(width - 50, 10, 30, 30);
    clearButton.setBoxAndClickColor(color(250), color(150));
    clearButton.setImage(loadImage("clear.png"));

    pencilButton = new ShapeButton(185, 10, 30, 30) {
        @Override
        public Renderer getRendererType() {
            return new PencilRenderer();
        }
    };
    pencilButton.setImage(loadImage("pencil.png"));

    pencilButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(pencilButton);

    eraserButton = new ShapeButton(220, 10, 30, 30) {
        @Override
        public Renderer getRendererType() {
            return new EraserRenderer();
        }
    };
    eraserButton.setImage(loadImage("eraser.png"));

    eraserButton.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(eraserButton);
    
    
    curveButton_stand = new ShapeButton(255, 10, 30, 30) {
        @Override
        public void show() {
            super.show();
            stroke(0);
            bezier(pos.x, pos.y, pos.x + size.x, pos.y + size.y, pos.x, pos.y + size.y, pos.x + size.x, pos.y);
        }

        @Override
        public Renderer getRendererType() {
            return new CurveRenderer_stand();
        }

    };

    curveButton_stand.setBoxAndClickColor(color(250), color(150));
    shapeButton.add(curveButton_stand);
    
    // Color implementation (4x4 color palette)
    //int paletteSize = 10;
    //int padding = 2;
    //int startX = 600;
    //int startY = 10;
    
    //color[][] colors = {
    //    { color(255, 0, 0), color(0, 255, 0), color(0, 0, 255), color(255, 255, 0) },  
    //    { color(255, 165, 0), color(128, 0, 128), color(0, 255, 255), color(255, 192, 203) }, 
    //    { color(255, 255, 255), color(0, 0, 0), color(128, 128, 128), color(255, 105, 180) },
    //    { color(50, 205, 50), color(0, 128, 128), color(75, 0, 130), color(255, 20, 147) } 
    //};
    
    //for (int row = 0; row < colors.length; row++) {
    //    for (int col = 0; col < colors[row].length; col++) {
    //        ColorButton colorButton = new ColorButton(
    //            startX + (paletteSize + padding) * col,
    //            startY + (paletteSize + padding) * row,
    //            paletteSize,
    //            paletteSize,
    //            colors[row][col]
    //        );
    //        this.colorButton.add(colorButton);
    //    }
    //}
    
    ColorButton colorButton = new ColorButton(
                selectedColorsX + (color_idx++ * (paletteSize + horizontal_padding)),
                selectedColorsY,
                paletteSize,
                paletteSize,
                color(0,0,0)
                );
    colorButton.beSelect();
    colorButton_custom.add(colorButton);
    

    
  
    

}

public void keyPressed() {
    if (key == 'z' || key == 'Z') {
        shapeRenderer.popShape();
    }

}

void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    if (e < 0)
        eraserSize += 1;
    else if (e > 0)
        eraserSize -= 1;
    eraserSize = max(min(eraserSize, 100), 4);
}

boolean overRect(int x, int y, int width, int height) {
    return mouseX >= x && mouseX <= x + width && mouseY >= y && mouseY <= y + height;
}

void addSelectedColor() {
    color selectedColor = cp5.get(ColorWheel.class, "colorPicker").getRGB();
    
    //for (int i = 0; i < colorButton_custom.size(); i++) {
    //    fill(colorButton_custom.get(i).getColor());
    //    stroke(0);
    //    rect(selectedColorsX + (i * (paletteSize + padding)), selectedColorsY, paletteSize, paletteSize);
        
    //    // If a custom color is selected, set it as the current color
    //    if (mousePressed && overRect(selectedColorsX + (i * (paletteSize + padding)), selectedColorsY, paletteSize, paletteSize)) {
    //        currentColor = colorButton_custom.get(i).getColor();
    //        if (shapeRenderer.renderer != null) {
    //            shapeRenderer.renderer.setColor(currentColor);
    //        }
    //    }
    //}
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

    //customColors.add(selectedColor);  // Add the selected color to the custom palette
}

void drawSlider() {
    // Draw slider track
    fill(200);
    rect(sliderX, sliderY, sliderW, sliderH);
    
    // Draw slider handle
    fill(150);
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
