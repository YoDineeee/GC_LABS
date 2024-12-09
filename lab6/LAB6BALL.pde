PShape ball;
PImage txtr;
float Alpha;
float scaleFactor = 1.5;
float rotationSpeed = 0.01;

void setup() {
  size(500, 500, P3D);
  txtr = loadImage("Data/texture-02.jpg");
  ball = loadShape("Data/ball.obj");
  ball.setTexture(txtr); 
}

void draw() {
  background(0);

  pushMatrix();
  translate(width / 2, height / 2);
  rotate(Alpha);
  rotateY(Alpha / 2);
  scale(scaleFactor);
  shape(ball);
  popMatrix();

  Alpha += rotationSpeed;
}

void mousePressed() {
  if (scaleFactor == 1.5) {
    scaleFactor = 2.0;
    rotationSpeed = 0.05;
  } else {
    scaleFactor = 1.5;
    rotationSpeed = 0.01;
  }
}
