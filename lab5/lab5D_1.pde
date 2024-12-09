Ant ant;

void setup() {
  size(800, 600);
  ant = new Ant();
}

void draw() {
  background(200, 220, 255);
  ant.update();
  ant.display();
}

class Ant {
  PVector location;  // Position of the ant
  PVector velocity;  // Velocity
  PVector acceleration;  // Acceleration
  float angle;  // Angle of movement
  float amplitude;  // Amplitude for leg movement

  Ant() {
    location = new PVector(width / 2, height / 2);
    velocity = new PVector(random(-2, 2), random(-2, 2));
    acceleration = new PVector(0, 0);
    angle = 0;
    amplitude = 5;
  }

  void update() {
    // Randomly change acceleration for natural movement
    if (frameCount % 30 == 0) {
      acceleration = new PVector(random(-0.05, 0.05), random(-0.05, 0.05));
    }

    // Add acceleration to velocity
    velocity.add(acceleration);
    // Limit velocity for smooth movement
    velocity.limit(3);

    // If mouse is pressed, move toward the mouse
    if (mousePressed) {
      PVector mouse = new PVector(mouseX, mouseY);
      PVector direction = PVector.sub(mouse, location);
      direction.setMag(0.1);  // Adjust strength of attraction
      velocity.add(direction);
    }

    // Update location
    location.add(velocity);

    // Keep the ant within the window bounds
    if (location.x < 0 || location.x > width) {
      velocity.x *= -1;
    }
    if (location.y < 0 || location.y > height) {
      velocity.y *= -1;
    }

    // Update the angle of movement based on speed
    angle += map(velocity.mag(), 0, 3, 0.05, 0.1);
  }

  void display() {
    // Ant body
    fill(0);
    ellipse(location.x, location.y, 15, 10);

    // Ant head
    fill(0);
    ellipse(location.x + 8, location.y - 5, 8, 8);

    // Ant eyes
    fill(255, 0, 0);
    ellipse(location.x + 10, location.y - 7, 3, 3);
    ellipse(location.x + 6, location.y - 7, 3, 3);

    // Ant legs (6 legs)
    float legOffsetX = sin(angle) * amplitude;
    float legOffsetY = cos(angle) * amplitude;

    // Front legs
    line(location.x - 4, location.y - 3, location.x - 12, location.y - 12);
    line(location.x - 4, location.y + 3, location.x - 12, location.y + 12);

    // Middle legs
    line(location.x - 8, location.y - 2, location.x - 16, location.y - 10);
    line(location.x - 8, location.y + 2, location.x - 16, location.y + 10);

    // Back legs
    line(location.x - 12, location.y - 1, location.x - 20, location.y - 8);
    line(location.x - 12, location.y + 1, location.x - 20, location.y + 8);

    // Antenna
    stroke(0);
    line(location.x + 5, location.y - 7, location.x + 12, location.y - 15);
    line(location.x + 5, location.y - 3, location.x + 12, location.y - 10);
  }
}
