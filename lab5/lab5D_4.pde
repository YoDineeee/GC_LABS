int maxFruits = 50;  
int maxLeaves = 300;
ArrayList<Leaf> leaves = new ArrayList<>();
ArrayList<Fruit> fruits = new ArrayList<>();
Ant ant; // Changed fly to ant
boolean wind = false;

void setup() {
  size(800, 600);
  noStroke(); // Prevent stroke for cleaner visuals
  
  // Generate the fractal tree once in setup
  //generateTree(width / 2, height, -PI / 2, 8, 120, 10); 
  
  ant = new Ant(random(width), 0); // Initialize the ant at the top with a random x position
  noStroke(); // Disable strokes for smoother graphics
}

void draw() {
  // Clear the background, keeping the sky color
  background(200, 230, 255); 
  
  // Draw tree every frame to make sure it shows on top of the background
  generateTree(width / 2, height, -PI / 2, 8, 120, 10);
  
  // Draw leaves
  for (Leaf leaf : leaves) {
    leaf.display();
    if (wind) leaf.fall();  // Make leaves fall during wind
  }

  // Draw fruits
  for (Fruit fruit : fruits) {
    fruit.display();
  }

  // Move and display the ant
  ant.move();
  ant.eat(fruits); // Ant eats the fruits it comes across
  ant.display();

  // Draw ground
  drawGround();
}

void generateTree(float x, float y, float angle, int depth, float length, float thickness) {
  if (depth == 0) {
    // Add leaves and fruits at the end of the branch
     if (leaves.size() < maxLeaves) {
      leaves.add(new Leaf(x, y)); // Add a leaf
    }
    if (fruits.size() < maxFruits && random(1) < 0.4) {
      fruits.add(new Fruit(x, y)); // 40% chance of a fruit, but only if under maxFruits
    }
    return;
  }

  float x2 = x + cos(angle) * length;
  float y2 = y + sin(angle) * length;

  // Draw the branch with varying thickness
  stroke(100, 50, 0);
  strokeWeight(thickness);
  line(x, y, x2, y2);

  // Recur for child branches with thinner branches
  generateTree(x2, y2, angle - random(PI / 8, PI / 6), depth - 1, length * 0.7, thickness * 0.7);
  generateTree(x2, y2, angle + random(PI / 8, PI / 6), depth - 1, length * 0.7, thickness * 0.7);
}

void keyPressed() {
  if (key == 'w' || key == 'W') {
    wind = !wind; // Toggle wind on/off
    if (wind) applyWind(); // Apply wind effect
  }
}

// Apply wind effect, only some leaves will fall
void applyWind() {
  for (Leaf leaf : leaves) {
    if (random(1) < 0.3) { // 30% chance for each leaf to fall
      leaf.startFalling();
    }
  }
}

// Draw ground
void drawGround() {
  fill(100, 200, 100);
  rect(0, height - 20, width, 20); // Ground color
}

// Leaf class
class Leaf {
  float x, y;
  float speed = 0;
  boolean falling = false;

  Leaf(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void display() {
    fill(34, 139, 34); // Forest green color
    ellipse(x, y, 12, 18); // Draw leaf as an oval
  }

  void startFalling() {
    falling = true;
  }

  void fall() {
    if (falling) {
      speed += 0.1;          // Simulate gravity
      y += speed;
      x += random(-1, 1);    // Drift left or right
      if (y > height - 20) { // Stop at the ground
        y = height - 20;
        speed = 0;
        falling = false; // Leaf stops moving
      }
    }
  }
}

// Fruit class
class Fruit {
  float x, y;

  Fruit(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void display() {
    fill(255, 100, 100); // Red color for the fruit
    ellipse(x, y, 15, 15); // Draw fruit as a red circle
  }
}

// Ant class
class Ant {
  float x, y;
  float speed = 1.5; // Speed of the ant
  float targetX, targetY; // Target coordinates (the base of the tree)

  Ant(float x, float y) {
    this.x = x;
    this.y = y;
    this.targetX = width / 2; // Target set to the tree base (centered on x-axis)
    this.targetY = height - 20; // The y-position of the ground
  }

  void display() {
    fill(150, 75, 0); // Ant body color (brown)
    ellipse(x, y, 12, 8); // Draw the body of the ant
    fill(0); // Ant's legs
    ellipse(x - 5, y + 4, 4, 4); // Left leg
    ellipse(x + 5, y + 4, 4, 4); // Right leg
  }

  void move() {
    // Move towards the tree (fixed target)
    float angle = atan2(targetY - y, targetX - x); // Calculate the angle towards the tree
    x += cos(angle) * speed; // Move x position
    y += sin(angle) * speed; // Move y position
  }

  void eat(ArrayList<Fruit> fruits) {
    for (int i = fruits.size() - 1; i >= 0; i--) {
      if (dist(x, y, fruits.get(i).x, fruits.get(i).y) < 10) {
        fruits.remove(i); // Remove fruit if it's close to the ant
      }
    }
  }
}
