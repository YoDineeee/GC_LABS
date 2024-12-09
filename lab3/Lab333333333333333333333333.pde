ArrayList<PVector> points;
float sunX = 100; // Sun position X
float sunY = 70; // Sun position Y
float sunZ = -70; // Sun position Z (for distancing)
Mover player1, player2;
Ball football;
BlueCircle blueCircle;

void setup() {
  size(800, 600, P3D); // Set P3D for 3D objects display
  background(135, 206, 235); // Sky
  player1 = new Mover(200, height / 2);
  player2 = new Mover(600, height / 2);
  football = new Ball((player1.location.x + player2.location.x) / 2, (player1.location.y + player2.location.y) / 2);
  blueCircle = new BlueCircle((player1.location.x + player2.location.x) / 2, (height / 2) - 50);
}

void draw() {
  background(135, 206, 235); // Update background every frame
  drawFootballPitch(); // Draw football pitch

  player1.update();
  player2.update();
  football.update(player1.location, player2.location);
  blueCircle.update(player1.location, player2.location); // Update blue circle position

  player1.display();
  player2.display();
  football.display();
  blueCircle.display(); // Display blue circle
}

void drawFootballPitch() {
  // Draw the football pitch
  fill(0, 128, 0); // Grass color
  rect(0, 0, width, height); // Pitch
  stroke(255); // White lines
  strokeWeight(5);
  line(width / 2, 0, width / 2, height); // Center line
  ellipse(width / 2, height / 2, 100, 100); // Center circle
  line(0, height / 2 - 40, 40, height / 2 - 40); // Left goal line
  line(width, height / 2 - 40, width - 40, height / 2 - 40); // Right goal line
}

class Mover {
  PVector location;
  float speed;

  Mover(float x, float y) {
    location = new PVector(x, y);
    speed = 2; // Speed of the players
  }

  void update() {
    // Randomly move the player left or right
    location.x += random(-speed, speed);
    location.x = constrain(location.x, 100, width - 100); // Keep players on the pitch
  }

  void display() {
    fill(250, 212, 243); // Player color
    ellipse(location.x, location.y, 30, 30); // Player body
    fill(0); // Head color
    ellipse(location.x, location.y - 20, 15, 15); // Head
  }
}

class Ball {
  PVector location;
  float speed;

  Ball(float x, float y) {
    location = new PVector(x, y);
    speed = 3; // Speed of the football
  }

  void update(PVector player1Pos, PVector player2Pos) {
    // Move football back and forth between players
    float distanceToPlayer1 = dist(location.x, location.y, player1Pos.x, player1Pos.y);
    float distanceToPlayer2 = dist(location.x, location.y, player2Pos.x, player2Pos.y);

    if (distanceToPlayer1 < 30) {
      location.x += speed; // Move towards player 2
    } else if (distanceToPlayer2 < 30) {
      location.x -= speed; // Move towards player 1
    }

    // Keep the football within the pitch
    location.x = constrain(location.x, 0, width);
    location.y = height / 2; // Keep the ball at the same height
  }

  void display() {
    fill(255, 0, 0); // Football color
    ellipse(location.x, location.y, 20, 20); // Football
  }
}

class BlueCircle {
  PVector location;
  float speed;
  boolean movingRight = true; // Direction of movement

  BlueCircle(float x, float y) {
    location = new PVector(x, y);
    speed = 2; // Speed of the blue circle
  }

  void update(PVector player1Pos, PVector player2Pos) {
    // Move back and forth between player 1 and player 2
    if (movingRight) {
      location.x += speed; // Move right
      if (location.x >= player2Pos.x) {
        movingRight = false; // Change direction
      }
    } else {
      location.x -= speed; // Move left
      if (location.x <= player1Pos.x) {
        movingRight = true; // Change direction
      }
    }
  }

  void display() {
    fill(0, 0, 255); // Blue color
    ellipse(location.x, location.y, 40, 40); // Blue circle
  }
}
