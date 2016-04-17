PImage imgD;
PImage imgI;
PImage imgTT;

float hite=70.0; // camera height
float BALL_R=7; // ball radius
int level=0;
int ypos;
int ptsW, ptsH;
final int largoTablero=100;
boolean[][] hueco=new boolean[8][largoTablero];
int numPointsW;
int numPointsH_2pi; 
int numPointsH;

float[] coorX;
float[] coorY;
float[] coorZ;
float[] multXZ;
float caida=BALL_R;
boolean gameover=false;

PFont font;
int score=0;
int xPos=300;
int row0=0;
int lastRow0=0;
float xx,yy;

void sortearTablero(int max, int level){
    for(int i=0;i<max;i++)
      for(int j=0;j<8;j++)
      hueco[j][i]=false;
    
    for (int row=0;row<(max/2);row++) {
      int ran = (int)random(0,6);
      int ran2 = (int)random(0,12);
      int ran3 = (int)random(0,18);
      int ran4 = (int)random(0,24);
      for(int col=0;col<7;col++)
       if(col!=ran && col!=ran2 && col!=ran3 && col!=ran4) hueco[col][row*2]=true;
     
      int ranHueco = (int)random(4-level,7);
      row+=(int)(ranHueco/2);
   }
}

void setup(){
 gameover=false;
 font=loadFont("2006-48.vlw");
 textFont(font,28.0);
 imgD = loadImage("Esquiador_dch.png");  // Load the image into the program
 imgTT = loadImage("tt.png");  // Load the image into the program
 imgI = loadImage("Esquiador_izq.png");  // Load the image into the program
 initializeSphere(20, 20);
 size(800,700,P3D);
 background(0);
 sortearTablero(largoTablero,0);
 for(int i=0;i<10;i++)
      for(int j=0;j<8;j++)
         hueco[j][i]=false;
}


void draw(){
  camera(0,ypos,hite,0,(ypos+400),0,0,-1,0);
  ambientLight(210,220,200);
  directionalLight(204, 204, 204, -.7, 1, 1.2);  
  lightFalloff(1.0, 0.0, 0.0) ;
  background(0);
  
  pushMatrix();
  textSize(32);
  fill(255, 108, 0, 255);
  translate(-30,ypos+500,180);
  rotateZ(PI);
  rotateX((PI*3.0/2.2));
  text("TechBossuGame",0,0);
  popMatrix();
  
  if(!gameover){
    if(score>1000)ypos=(frameCount%20000)*2;
    else ypos=(frameCount%20000);
    row0=(int)(ypos/20.0)+4;
    if(row0!=lastRow0)score+=5;
    lastRow0=row0;
    float mY=mouseY;
    xx = 60-mouseX/4.25; //Ball position left-right
    yy = ypos+80+((512.0-mY)/8.0); //Ball position front-back
    if(mY>500)mY=500;  
    if(xx<-60)xx=-60;
  }
  
  
  if(!gameover){
   //ellipse(xx,yy,10,10); 
    pushMatrix();
    translate(xx,yy,BALL_R);
    rotateX(-frameCount/20.0); // ball roll
    //sphereDetail(10);
    //fill(190,56,78);
    //sphere(BALL_R);
     noStroke();
     textureSphere(BALL_R, BALL_R, BALL_R, imgTT);
     stroke(0);
     popMatrix();
     
     pushMatrix();
      textSize(32);
      fill(255, 108, 0, 255);  
      translate(150,ypos+300,80);
      rotateZ(PI);
      rotateX((PI*3.0/2.2));
      text("Score: "+score,0,0);
      popMatrix();
  }else{
    //hacer que la bola caiga
     pushMatrix();
     translate(xx,yy++,caida--);
     rotateX(-frameCount/30.0); // ball roll
     noStroke();
     textureSphere(BALL_R, BALL_R, BALL_R, imgTT);
     stroke(0);
     popMatrix();
     
     //letreros GameOver
      pushMatrix();
      textSize(42);
      fill(250, 2, 3, 204);  
      translate(100,ypos+300,80);
      rotateZ(PI);
      rotateX((PI*3.0/2.2));
      text("GAME OVER\n       Score: "+score,0,0);
      println("GAME OVER"+caida);
      popMatrix();
  }
  
   println(row0);
  if((row0%largoTablero)==largoTablero-26){
    sortearTablero(largoTablero-26, (level++)%3);
  }
  for (int col=0;col<6;col++) {
    int x=-60+(20*col);
    for (int row=0;row<25;row++) {
      int y=20*(row+row0);
      // clip to visible region
        if(!hueco[col][(row+row0)%largoTablero]){
          fill(color(250,250,50),255-((y-ypos)/2));
          rect(x,y,20,20);
        }
    }
  }
 
  int row=(int)(yy/20.0);
  int col=(int)((xx+60)/20.0);
  if(hueco[col][row%largoTablero]){
    gameover=true;
  }
  //println(row+" , "+col+ " | "+ypos+ " , "+row0);
  fill(0);
}

void mouseClicked() {
  if (gameover) reset();
}
void reset(){
    frameCount=0;
    score=0;
    gameover=false;
    caida=BALL_R;
    setup();
}




void plotEsquiador(int centerX, int centerY, boolean der){
   //triangle(centerX-50,centerY+50,centerX+50,centerY+50,centerX,centerY-50);
   if(der)image(imgD, centerX, centerY, imgD.width/20, imgD.height/20);
   else image(imgI, centerX, centerY, imgD.width/20, imgD.height/20);
}




void initializeSphere(int numPtsW, int numPtsH_2pi) {

  // The number of points around the width and height
  numPointsW=numPtsW+1;
  numPointsH_2pi=numPtsH_2pi;  // How many actual pts around the sphere (not just from top to bottom)
  numPointsH=ceil((float)numPointsH_2pi/2)+1;  // How many pts from top to bottom (abs(....) b/c of the possibility of an odd numPointsH_2pi)

  coorX=new float[numPointsW];   // All the x-coor in a horizontal circle radius 1
  coorY=new float[numPointsH];   // All the y-coor in a vertical circle radius 1
  coorZ=new float[numPointsW];   // All the z-coor in a horizontal circle radius 1
  multXZ=new float[numPointsH];  // The radius of each horizontal circle (that you will multiply with coorX and coorZ)

  for (int i=0; i<numPointsW ;i++) {  // For all the points around the width
    float thetaW=i*2*PI/(numPointsW-1);
    coorX[i]=sin(thetaW);
    coorZ[i]=cos(thetaW);
  }
  
  for (int i=0; i<numPointsH; i++) {  // For all points from top to bottom
    if (int(numPointsH_2pi/2) != (float)numPointsH_2pi/2 && i==numPointsH-1) {  // If the numPointsH_2pi is odd and it is at the last pt
      float thetaH=(i-1)*2*PI/(numPointsH_2pi);
      coorY[i]=cos(PI+thetaH); 
      multXZ[i]=0;
    } 
    else {
      //The numPointsH_2pi and 2 below allows there to be a flat bottom if the numPointsH is odd
      float thetaH=i*2*PI/(numPointsH_2pi);

      //PI+ below makes the top always the point instead of the bottom.
      coorY[i]=cos(PI+thetaH); 
      multXZ[i]=sin(thetaH);
    }
  }
}

void textureSphere(float rx, float ry, float rz, PImage t) { 
  // These are so we can map certain parts of the image on to the shape 
  float changeU=t.width/(float)(numPointsW-1); 
  float changeV=t.height/(float)(numPointsH-1); 
  float u=0;  // Width variable for the texture
  float v=0;  // Height variable for the texture

  beginShape(TRIANGLE_STRIP);
  texture(t);
  for (int i=0; i<(numPointsH-1); i++) {  // For all the rings but top and bottom
    // Goes into the array here instead of loop to save time
    float coory=coorY[i];
    float cooryPlus=coorY[i+1];

    float multxz=multXZ[i];
    float multxzPlus=multXZ[i+1];

    for (int j=0; j<numPointsW; j++) { // For all the pts in the ring
      normal(-coorX[j]*multxz, -coory, -coorZ[j]*multxz);
      vertex(coorX[j]*multxz*rx, coory*ry, coorZ[j]*multxz*rz, u, v);
      normal(-coorX[j]*multxzPlus, -cooryPlus, -coorZ[j]*multxzPlus);
      vertex(coorX[j]*multxzPlus*rx, cooryPlus*ry, coorZ[j]*multxzPlus*rz, u, v+changeV);
      u+=changeU;
    }
    v+=changeV;
    u=0;
  }
  endShape();
}



class Generador {

  ArrayList<Vec2>lista=new ArrayList<Vec2>();
  
  int[][] laberinto;
  private  int ancho;
  private  int largo;


  public  int[][] generarLaberinto(int ancho, int largo){
    this.ancho=ancho;
    this.largo = largo;
    laberinto = new int[ancho][largo];
    generar(1, 1);
    return laberinto;
  }
  

  private void generar(int x, int z){
    //Obtener lista de vecinos aleatorios
    ArrayList<Vec2> vecinos = vecinosAleatorios(x, z);


    //Para todos los de la lista
    for(int i = 0;i<vecinos.size();i++){
      Vec2 vecino = vecinos.get(i);
      //Si no está visitado
      if(!(laberinto[vecino.x][vecino.z]>=1)){
        laberinto[vecino.x][vecino.z] = 1;
        
        Vec2 puntoMedio = new Vec2((vecino.x + x)/2, (vecino.z + z)/2);
        laberinto[puntoMedio.x][puntoMedio.z] = 1;
        lista.add(new Vec2(puntoMedio.x,puntoMedio.z));
        lista.add(new Vec2(vecino.x,vecino.z));
        //Llamar a generar para ese vecino
        generar(vecino.x, vecino.z);
      }
    }
  }


  private ArrayList<Vec2> vecinosAleatorios(int x, int z){
    boolean limiteDerecho = x >=ancho-3;
    boolean limiteAbajo = z <= 1;
    boolean limiteIzquierda = x <= 1;
    boolean limiteArriba = z >= largo-3;
    ArrayList<Vec2> resultado = new ArrayList<Vec2>();


    Vec2[] vecinos = new Vec2[4];

    vecinos[0] = new Vec2(x, z+2);
    vecinos[1] = new Vec2(x+2, z);
    vecinos[2] = new Vec2(x-2, z);
    vecinos[3] = new Vec2(x, z-2);
    if(!limiteArriba){

      resultado.add(vecinos[0]);
    }

    if(!limiteDerecho){

      resultado.add(vecinos[1]);
    }

    if(!limiteIzquierda){

      resultado.add(vecinos[2]);
    }

    if(!limiteAbajo){

      resultado.add(vecinos[3]);
    }

    int ale1 = (int)(Math.random()*20);

    for(int i = 0;i<ale1;i++){
      int ale2 = (int)(Math.random()*resultado.size());
      int ale3 = (int)(Math.random()*resultado.size());
      Vec2 uno =  resultado.get(ale2);
      resultado.set(ale2, resultado.get(ale3));
      resultado.set(ale3, uno);
    }

    return resultado;
  }
}




class Vec2 {
  int x;
  int z;
  
  public Vec2(int x, int z){
    this.x=x;
    this.z=z;
  }
} //