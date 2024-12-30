public class PhongVertexShader extends VertexShader {
    Vector4[][] main(Object[] attribute, Object[] uniform) {
        Vector3[] aVertexPosition = (Vector3[]) attribute[0];
        Vector3[] aVertexNormal = (Vector3[]) attribute[1];
        Vector3 albedo = (Vector3)attribute[2];
        Vector3 kdksm = (Vector3)attribute[3];
        Matrix4 MVP = (Matrix4) uniform[0];
        Matrix4 M = (Matrix4) uniform[1];
        Vector4[] gl_Position = new Vector4[3];
        Vector4[] w_position = new Vector4[3];
        Vector4[] w_normal = new Vector4[3];
        Vector4[] illumination = new Vector4[3];

        for (int i = 0; i < gl_Position.length; i++) {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            w_position[i] = M.mult(aVertexPosition[i].getVector4(1.0));
            w_normal[i] = M.mult(aVertexNormal[i].getVector4(0.0));
        }

        Vector4[][] result = { gl_Position, w_position, w_normal };
        return result;
        
        //Vector4 I = lighting(w_position, w_normal, albedo, kdksm);
        //illumination[0] = I; illumination[1] = I; illumination[2] = I;
        
        //Vector4[][] result = {gl_Position, illumination};
        //return result;
        
    }
}





public class PhongFragmentShader extends FragmentShader{
    Vector4 main(Object[] varying){
        Vector3 gl_Position = (Vector3)varying[0];
        Vector3 w_position = (Vector3)varying[1]; // vertex coordinate
        Vector3 w_normal = (Vector3)varying[2];   // vertex normal
        Vector3 albedo = (Vector3) varying[3];    //
        Vector3 kdksm = (Vector3) varying[4];
        Vector3 illumination = new Vector3();
        
        Light light = basic_light;
        Camera cam = main_camera;
        
        Vector4 I = lighting(w_position, w_normal, albedo, kdksm);
        illumination = (Vector3) I.xyz() ;
        //System.out.println("Fragment Position: " + w_position);
        //System.out.println("Fragment w_normal: " + w_normal);
        return new Vector4(illumination, 1.0);
        
        
        ////ambient
        //Vector3 ambient = light.light_color.product(AMBIENT_LIGHT);
        
        ////diffuse
        //w_normal = w_normal.unit_vector();                                               //N
        //Vector3 light_direction = light.transform.position.sub(w_position).unit_vector();  //L
        //float NL = Vector3.dot(w_normal,light_direction);                                //N·L
        //Vector3 diffuse = light.light_color.mult(kdksm.x).mult(NL);                      //kd(N·L)
        
        ////specular
        //Vector3 V = cam.transform.position.sub(w_position);                                         //V
        //Vector3 H = Vector3.add(light_direction,V).dive(Vector3.add(light_direction,V).length()); //H = L+V / |L+V|
        //float HN = Math.max(0.0f, (float) Math.pow(Vector3.dot(H, w_normal), kdksm.z));           //(H·N)^m and if less than 0 then 0.
        //Vector3 specular = light.light_color.mult(kdksm.y).mult(HN);
        //Vector3 IaId = albedo.product(ambient.add(diffuse));
        //Vector3 I = IaId.add(specular);
        //Vector4 result = new Vector4(I,1.0);
        //return result;
        
        
        
        
        
    }
}


public class FlatVertexShader extends VertexShader {
    float[] abg = {1f/3,1f/3,1f/3};
    Vector4[][] main(Object[] attribute, Object[] uniform) {
        Vector3[] aVertexPosition = (Vector3[])attribute[0];
        Vector3[] aVertexNormal = (Vector3[])attribute[1];
        Vector3 albedo = (Vector3)attribute[2];
        Vector3 kdksm = (Vector3)attribute[3];
        Matrix4 MVP = (Matrix4)uniform[0];
        Matrix4 M = (Matrix4)uniform[1];
        Vector4[] gl_Position = new Vector4[3];
        Vector4[] w_position = new Vector4[3];
        Vector4[] illumination = new Vector4[3];

        // TODO HW4
        // Here you have to complete Flat shading.
        // We have instantiated the relevant Material, and you may be missing some
        // variables.
        // Please refer to the templates of Phong Material and Phong Shader to complete
        // this part.

        // Note: Here the first variable must return the position of the vertex.
        // Subsequent variables will be interpolated and passed to the fragment shader.
        // The return value must be a Vector4.
        for(int i=0;i<gl_Position.length;i++){
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            w_position[i] = M.mult(aVertexPosition[i].getVector4(1.0));
        }
        Vector3 position = interpolation(abg, w_position).xyz();
        Vector3 w_normal = Vector3.cross(
                Vector3.sub(w_position[1].xyz(), w_position[0].xyz()), Vector3.sub(w_position[2].xyz(), w_position[0].xyz())).unit_vector();
        //System.out.println("Fragment Position: " + position);
        Vector4 I = lighting(position, w_normal, albedo, kdksm);
        illumination[0] = I; illumination[1] = I; illumination[2] = I;
        
        Vector4[][] result = {gl_Position, illumination};
        
        return result;
    }
}




public class FlatFragmentShader extends FragmentShader {
    Vector4 main(Object[] varying) {
        Vector3 position = (Vector3)varying[0];
        Vector3 illumination = (Vector3)varying[1];
        return new Vector4(illumination,1.0);
    }
}


public class GouraudVertexShader extends VertexShader {
    Vector4[][] main(Object[] attribute, Object[] uniform) {        
        Vector3[] aVertexPosition = (Vector3[])attribute[0];
        Vector3[] aVertexNormal = (Vector3[])attribute[1];
        Vector3 albedo = (Vector3)attribute[2];
        Vector3 kdksm = (Vector3)attribute[3];
        Matrix4 MVP = (Matrix4)uniform[0];
        Matrix4 M = (Matrix4)uniform[1];
        Vector4[] gl_Position = new Vector4[3];
        Vector4[] w_position = new Vector4[3];
        Vector4[] illumination = new Vector4[3];
        Vector4[] w_normal = new Vector4[3];
        
        
        for (int i = 0; i < gl_Position.length; i++) {
            gl_Position[i] = MVP.mult(aVertexPosition[i].getVector4(1.0));
            w_position[i] = M.mult(aVertexPosition[i].getVector4(1.0));
            w_normal[i] = M.mult(aVertexNormal[i].getVector4(0.0));
        }
        
        Vector4 I0 = lighting(w_position[0].xyz(), w_normal[0].xyz(), albedo, kdksm);
        illumination[0] = I0; 
        Vector4 I1 = lighting(w_position[1].xyz(), w_normal[1].xyz(), albedo, kdksm);
        illumination[1] = I1; 
        Vector4 I2 = lighting(w_position[2].xyz(), w_normal[2].xyz(), albedo, kdksm);
        illumination[2] = I2;
        
        Vector4[][] result = {gl_Position, illumination};
        
        return result;
    }
}

public class GouraudFragmentShader extends FragmentShader {
    Vector4 main(Object[] varying) {
        Vector3 position = (Vector3) varying[0];
        Vector3 illumination = (Vector3)varying[1];
        return new Vector4(illumination,1.0);
        
        
    }
}


public Vector4 lighting(Vector3 w_position, Vector3 w_normal, Vector3 albedo, Vector3 kdksm) {
      Vector3 lightVector = Vector3.sub(basic_light.transform.position, w_position);
      Vector3 viewVector = Vector3.sub(lookat, main_camera.transform.position);
      float normalDot = Vector3.dot(w_normal, lightVector);
      
      Vector3 I = Vector3.mult(Vector3.mult(1.0f, AMBIENT_LIGHT), albedo);      // ambient light
      
      if (normalDot > 0) {
          float d = lightVector.length();
          float fatt = 1 / (0.1f + 0.1f * d + 0.1f * d * d);
          Vector3 diffuseLight = Vector3.mult(basic_light.light_color, new Vector3((normalDot < 0) ? 0 : normalDot));
          diffuseLight = Vector3.mult(albedo, Vector3.mult(kdksm.x * fatt, diffuseLight)); // Kd
          I = Vector3.add(I, diffuseLight);
          
          //Vector3 reflectVector = Vector3.mult(2 * normalDot, w_normal);
          Vector3 halfVector = Vector3.add(lightVector, viewVector).unit_vector();
          Vector3 specularLight = Vector3.mult(pow(Vector3.dot(halfVector, w_normal), kdksm.z), basic_light.light_color);
          specularLight = Vector3.mult(kdksm.y * fatt, specularLight);    // Ks
          I = Vector3.add(I, specularLight);  
      }
      
      // limit I value
      if (I.x > 1) I.x = 1;
      if (I.y > 1) I.y = 1;
      if (I.z > 1) I.z = 1;
      
      return new Vector4(I, 1.0);
}
