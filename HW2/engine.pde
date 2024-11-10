public class Engine {
    ShapeRenderer shapeRenderer;
    Inspector inspector;
    Hierarchy hierarchy;

    Vector3[] boundary = { new Vector3(-1, -1, 0), new Vector3(-1, 1, 0), new Vector3(1, 1, 0), new Vector3(1, -1, 0) };
    //Vector3[] boundary = {
    //    new Vector3(0, 0, 0),           // Top-left corner
    //    new Vector3(0, height, 0),      // Bottom-left corner
    //    new Vector3(width, height, 0),  // Bottom-right corner
    //    new Vector3(width, 0, 0)        // Top-right corner
    //};
    ArrayList<ShapeButton> shapeButton = new ArrayList<ShapeButton>();
    ShapeButton rectangleButton;
    ShapeButton starButton;

    public Engine() {
        shapeRenderer = new ShapeRenderer();
        inspector = new Inspector();
        hierarchy = new Hierarchy(shapeRenderer.shapes);

        initButton();

    }

    public void initButton() {
        rectangleButton = new ShapeButton(20, 10, 30, 30) {
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
            public Shape renderShape() {
                return new Rectangle();
            }
        };

        rectangleButton.setBoxAndClickColor(color(250), color(150));
        shapeButton.add(rectangleButton);

        starButton = new ShapeButton(60, 10, 30, 30) {
            @Override
            public void show() {
                super.show();
            }

            @Override
            public Shape renderShape() {
                return new Star();
            }
        };

        starButton.setImage(loadImage("star.png"));
        starButton.setBoxAndClickColor(color(250), color(150));
        shapeButton.add(starButton);
    }

    void run() {
        shapeRenderer.run();
        inspector.run();
        hierarchy.run();
        
        //CGLine( 245.0 , 275.0 , 245.0 , 325.0 );
        //CGLine( 245.0 , 325.0 , 295.0 , 325.0 );
        //CGLine( 295.0 , 325.0 , 295.0 , 275.0 );
        //CGLine( 295.0 , 275.0 , 245.0 , 275.0 );

        //CGLine( 295.0 , 300.0 , 277.725 , 305.61 );
        //CGLine( 277.725 , 305.61 , 277.725 , 323.77502 );
        //CGLine( 277.725 , 323.77502 , 267.0125 , 309.0925 );
        //CGLine( 267.0125 , 309.0925 , 249.775 , 314.69247 );
        //CGLine( 249.775 , 314.69247 , 260.415 , 300.05 );
        //CGLine( 260.415 , 300.05 , 249.775 , 285.4725 );
        //CGLine( 249.775 , 285.4725 , 267.0 , 291.0025 );
        //CGLine( 267.0 , 291.0025 , 277.725 , 276.225 );
        //CGLine( 277.725 , 276.225 , 277.725 , 294.4525 );
        //CGLine( 277.725 , 294.4525 , 295.0 , 300.0 );

        


        for (ShapeButton sb : shapeButton) {
            sb.run(() -> {
                shapeRenderer.addShape(sb.renderShape());
            });
        }

    }

}
