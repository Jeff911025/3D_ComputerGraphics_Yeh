public class Camera extends GameObject {
    Matrix4 projection = new Matrix4();
    Matrix4 worldView = new Matrix4();
    int wid;
    int hei;
    float near;
    float far;

    Camera() {
        wid = 256;
        hei = 256;
        worldView.makeIdentity();
        projection.makeIdentity();
        transform.position = new Vector3(0, 0, -50);
        name = "Camera";
    }

    Matrix4 inverseProjection() {
        Matrix4 invProjection = Matrix4.Zero();
        float a = projection.m[0];
        float b = projection.m[5];
        float c = projection.m[10];
        float d = projection.m[11];
        float e = projection.m[14];
        invProjection.m[0] = 1.0f / a;
        invProjection.m[5] = 1.0f / b;
        invProjection.m[11] = 1.0f / e;
        invProjection.m[14] = 1.0f / d;
        invProjection.m[15] = -c / (d * e);
        return invProjection;
    }

    Matrix4 Matrix() {
        return projection.mult(worldView);
    }

    void setSize(int w, int h, float n, float f) {
        wid = w;
        hei = h;
        near = n;
        far = f;
        
        // TODO HW3
        // This function takes four parameters, which are 
        // the width of the screen, the height of the screen
        // the near plane and the far plane of the camera.
        // Where GH_FOV has been declared as a global variable.
        // Finally, pass the result into projection matrix.

        projection = Matrix4.Identity();
        
        
        float aspect = (float) w / (float) h;
        float tanHalfFOV = (float) tan(radians(GH_FOV));
        
        //Matric from web
        
        //projection.m[0] = 1.0f / (aspect * tanHalfFOV);
        //projection.m[1] = 0.0f;
        //projection.m[2] = 0.0f;
        //projection.m[3] = 0.0f;
   
        //projection.m[4] = 0.0f;
        //projection.m[5] = 1.0f / tanHalfFOV;
        //projection.m[6] = 0.0f;
        //projection.m[7] = 0.0f;
    
        //projection.m[8] = 0.0f;
        //projection.m[9] = 0.0f;
        //projection.m[10] = -(f + n) / (f - n);
        //projection.m[11] = -1.0f;
    
        //projection.m[12] = 0.0f;
        //projection.m[13] = 0.0f;
        //projection.m[14] = -(2.0f * f * n) / (f - n);
        //projection.m[15] = 0.0f;
        
        //from teacher
        
        projection.m[0] = 1.0f;         
        projection.m[1] = 0.0f;
        projection.m[2] = 0.0f;
        projection.m[3] = 0.0f;
    
        projection.m[4] = 0.0f;
        projection.m[5] = aspect;   
        projection.m[6] = 0.0f;
        projection.m[7] = 0.0f;
    
        projection.m[8] = 0.0f;
        projection.m[9] = 0.0f;
        projection.m[10] = (n / (n - f)) * tanHalfFOV; 
        projection.m[11] = (f / (f - n)) * tanHalfFOV;   
    
        projection.m[12] = 0.0f;
        projection.m[13] = 0.0f;
        projection.m[14] = tanHalfFOV;   
        projection.m[15] = 0.0f;
        
        
        //Parallel projection
        //projection.m[10] = 0.0f;

    }

    void setPositionOrientation(Vector3 pos, float rotX, float rotY) {
        worldView = Matrix4.RotX(rotX).mult(Matrix4.RotY(rotY)).mult(Matrix4.Trans(pos.mult(-1)));
    }

    void setPositionOrientation() {
        worldView = Matrix4.RotX(transform.rotation.x).mult(Matrix4.RotY(transform.rotation.y))
                .mult(Matrix4.Trans(transform.position.mult(-1)));
    }

    void setPositionOrientation(Vector3 pos, Vector3 lookat) {
        // TODO HW3
        // This function takes two parameters, which are the position of the camera and
        // the point the camera is looking at.
        // We uses topVector = (0,1,0) to calculate the eye matrix.
        // Finally, pass the result into worldView matrix.

        worldView = Matrix4.Identity();
        Vector3 topVector = Vector3.UnitY(); // topVector = (0,1,0)
        Vector3 forward = Vector3.sub(lookat, pos).unit_vector();
        Vector3 right = Vector3.cross(topVector, forward).unit_vector();
        Vector3 up = Vector3.cross(forward, right);
    
        Matrix4 GlobalRotationMatrix = new Matrix4();
        //GlobalRotationMatrix.m[0] = right.x();   GlobalRotationMatrix.m[1] = up.x();   GlobalRotationMatrix.m[2] = -forward.x();   GlobalRotationMatrix.m[3] = 0;
        //GlobalRotationMatrix.m[4] = right.y();   GlobalRotationMatrix.m[5] = up.y();   GlobalRotationMatrix.m[6] = -forward.y();   GlobalRotationMatrix.m[7] = 0;
        //GlobalRotationMatrix.m[8] = right.z();   GlobalRotationMatrix.m[9] = up.z();   GlobalRotationMatrix.m[10] = -forward.z();  GlobalRotationMatrix.m[11] = 0;
        //GlobalRotationMatrix.m[12] = 0;          GlobalRotationMatrix.m[13] = 0;       GlobalRotationMatrix.m[14] = 0;             GlobalRotationMatrix.m[15] = 1;
        GlobalRotationMatrix.m[0] = right.x();     GlobalRotationMatrix.m[1] = right.y();  GlobalRotationMatrix.m[2] = right.z();    GlobalRotationMatrix.m[3] = 0;
        GlobalRotationMatrix.m[4] = up.x();        GlobalRotationMatrix.m[5] = up.y();     GlobalRotationMatrix.m[6] = up.z();       GlobalRotationMatrix.m[7] = 0;
        GlobalRotationMatrix.m[8] = forward.x();   GlobalRotationMatrix.m[9] = forward.y();GlobalRotationMatrix.m[10] = forward.z(); GlobalRotationMatrix.m[11] = 0;
        GlobalRotationMatrix.m[12] = 0;            GlobalRotationMatrix.m[13] = 0;         GlobalRotationMatrix.m[14] = 0;           GlobalRotationMatrix.m[15] = 1;
    
        Matrix4 translation = new Matrix4(); // Translate the eye/camera to (0,0,0)
        translation.m[0] = 1; translation.m[1] = 0; translation.m[2] = 0; translation.m[3] = -pos.x();
        translation.m[4] = 0; translation.m[5] = 1; translation.m[6] = 0; translation.m[7] = -pos.y();
        translation.m[8] = 0; translation.m[9] = 0; translation.m[10] = 1; translation.m[11] = pos.z();
        translation.m[12] = 0; translation.m[13] = 0; translation.m[14] = 0; translation.m[15] = 1;
        Matrix4 mirrorXMatrix = new Matrix4();
        mirrorXMatrix.m[0] = -1; mirrorXMatrix.m[1] = 0;  mirrorXMatrix.m[2] = 0;  mirrorXMatrix.m[3] = 0;
        mirrorXMatrix.m[4] =  0; mirrorXMatrix.m[5] = 1;  mirrorXMatrix.m[6] = 0;  mirrorXMatrix.m[7] = 0;
        mirrorXMatrix.m[8] =  0; mirrorXMatrix.m[9] = 0;  mirrorXMatrix.m[10] = 1; mirrorXMatrix.m[11] = 0;
        mirrorXMatrix.m[12] = 0; mirrorXMatrix.m[13] = 0; mirrorXMatrix.m[14] = 0; mirrorXMatrix.m[15] = 1;
        
        worldView = mirrorXMatrix.mult(GlobalRotationMatrix).mult(translation);
        
    }
}
