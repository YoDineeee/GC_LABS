int cols = 20, rows = 20;
Tile[][] grid; // Grid for the world
ArrayList<Creature> creatures = new ArrayList<>();
int tileSize;

void setup() {
  size(600, 600);
  tileSize = width / cols;

  // Initialize grid
  grid = new Tile[cols][rows];
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      float r = random(1);
      TileType type = (r < 0.1) ? TileType.FOOD : (r < 0.2) ? TileType.WATER : TileType.LAND;
      grid[i][j] = new Tile(i, j, type);
    }
  }

  // Add creatures
  for (int i = 0; i < 20; i++) {
    creatures.add(new Creature(random(width), random(height)));
  }
}

void draw() {
  background(220);

  // Display grid
  for (int i = 0; i < cols; i++) {
    for (int j = 0; j < rows; j++) {
      grid[i][j].display();
    }
  }

  // Update and display creatures
  for (int i = creatures.size() - 1; i >= 0; i--) {
    Creature c = creatures.get(i);
    c.updateState(creatures);
    c.update();
    c.display();

    // Check for food
    int gridX = floor(c.location.x / tileSize);
    int gridY = floor(c.location.y / tileSize);
    if (gridX >= 0 && gridX < cols && gridY >= 0 && gridY < rows) {
      if (grid[gridX][gridY].type == TileType.FOOD) {
        c.eat();
        grid[gridX][gridY].type = TileType.LAND; // Remove food
      }
    }

    // Remove creature if health <= 0
    if (c.health <= 0) {
      creatures.remove(i);
    }
  }

  // Regenerate food
  if (frameCount % 30 == 0) {
    int x = int(random(cols));
    int y = int(random(rows));
    grid[x][y].type = TileType.FOOD;
  }
}

// Tile for the world grid
class Tile {
  int x, y;
  TileType type;

  Tile(int x, int y, TileType type) {
    this.x = x;
    this.y = y;
    this.type = type;
  }

  void display() {
    switch (type) {
      case LAND: fill(200, 200, 150); break;
      case WATER: fill(100, 150, 255); break;
      case FOOD: fill(0, 255, 0); break;
    }
    rect(x * tileSize, y * tileSize, tileSize, tileSize);
  }
}

// Types of tiles
enum TileType {
  LAND, WATER, FOOD
}

// Creature Class
class Creature {
  PVector location, velocity;
  float health;
  State state;

  Creature(float x, float y) {
    location = new PVector(x, y);
    velocity = PVector.random2D();
    health = 100;
    state = State.HEALTHY;
  }

  void update() {
    location.add(velocity);
    velocity.add(PVector.random2D().mult(0.1));
    velocity.limit(2);

    // Stay within bounds
    if (location.x < 0 || location.x > width) velocity.x *= -1;
    if (location.y < 0 || location.y > height) velocity.y *= -1;

    // Decrease health
    health -= 0.1;
  }

  void updateState(ArrayList<Creature> neighbors) {
    int healthyCount = 0, hungryCount = 0, tiredCount = 0;

    for (Creature neighbor : neighbors) {
      if (neighbor == this) continue; // Skip self
      float d = PVector.dist(location, neighbor.location);
      if (d < 50) { // Check neighbors
        switch (neighbor.state) {
          case HEALTHY: healthyCount++; break;
          case HUNGRY: hungryCount++; break;
          case TIRED: tiredCount++; break;
        }
      }
    }

    // Update state based on CA-inspired rules
    if (hungryCount > healthyCount && hungryCount > tiredCount) {
      state = State.HUNGRY;
    } else if (tiredCount > healthyCount) {
      state = State.TIRED;
    } else {
      state = State.HEALTHY;
    }
  }

  void eat() {
    health += 20;
    if (health > 100) health = 100;
  }

  void display() {
    pushMatrix();
    translate(location.x, location.y);

    // Draw ant body (purple and pink)
    fill(128, 0, 128); // Purple body
    ellipse(0, 0, 12, 6); // Body

    // Draw legs (dark purple)
    stroke(75, 0, 130);
    line(-6, 3, -10, 8); // Left front leg
    line(6, 3, 10, 8);   // Right front leg
    line(-6, -3, -10, -8); // Left back leg
    line(6, -3, 10, -8);   // Right back leg

    // Draw antennae (light purple)
    stroke(255, 182, 193); // Light pink
    line(-5, -4, -8, -8); // Left antenna
    line(5, -4, 8, -8);   // Right antenna

    // Draw head (light pink)
    fill(255, 182, 193); 
    ellipse(0, -6, 6, 6); // Head

    popMatrix();

    // Display health
    fill(0);
    textSize(10);
    text(int(health), location.x - 5, location.y - 10);
  }
}

// Creature states
enum State {
  HEALTHY, HUNGRY, TIRED
}
