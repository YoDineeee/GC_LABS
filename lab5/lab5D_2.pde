ArrayList<Creature> creatures;
ArrayList<Resource> resources;

void setup() {
  size(800, 600);
  creatures = new ArrayList<Creature>();
  resources = new ArrayList<Resource>();

  // Add initial ants
  for (int i = 0; i < 10; i++) {
    creatures.add(new Ant(random(width), random(height)));
  }
  for (int i = 0; i < 5; i++) {
    creatures.add(new Predator(random(width), random(height)));
  }

  // Add initial resources
  for (int i = 0; i < 20; i++) {
    resources.add(new Resource(random(width), random(height), color(0, 255, 0))); // Green food
  }
}

void draw() {
  background(200, 220, 255);

  // Draw resources
  for (Resource r : resources) {
    r.display();
  }

  // Update and display creatures
  for (int i = creatures.size() - 1; i >= 0; i--) {
    Creature c = creatures.get(i);
    c.update();
    c.display();

    // Check for resource collision
    for (int j = resources.size() - 1; j >= 0; j--) {
      if (c.eat(resources.get(j))) {
        resources.remove(j); // Remove food when eaten
      }
    }

    // Check for predator-prey interaction
    if (c instanceof Predator) {
      Predator predator = (Predator) c;
      for (int k = creatures.size() - 1; k >= 0; k--) {
        if (creatures.get(k) != predator && predator.hunt(creatures.get(k))) {
          creatures.remove(k); // Remove prey if eaten
        }
      }
    }

    // Remove creature if health is 0
    if (c.health <= 0) {
      creatures.remove(i);
    }
  }

  // Add new resources occasionally
  if (frameCount % 60 == 0) {
    resources.add(new Resource(random(width), random(height), color(0, 255, 0)));
  }

  // Allow reproduction
  if (frameCount % 300 == 0) {
    for (Creature c : creatures) {
      if (c.canReproduce()) {
        creatures.add(c.reproduce());
      }
    }
  }
}

// Handle mouse interaction
void mousePressed() {
  if (mouseButton == LEFT) {
    resources.add(new Resource(mouseX, mouseY, color(0, 255, 0))); // Add food
  } else if (mouseButton == RIGHT) {
    creatures.add(new Ant(mouseX, mouseY)); // Add a new Ant
  }
}

// Base Resource class
class Resource {
  PVector location;
  int colorrr;

  Resource(float x, float y, int c) {
    location = new PVector(x, y);
    colorrr = c;
  }

  void display() {
    fill(colorrr);
    ellipse(location.x, location.y, 8, 8);
  }
}

// Base Creature class
abstract class Creature {
  PVector location, velocity;
  float health;
  float mutationChance;

  Creature(float x, float y) {
    location = new PVector(x, y);
    velocity = PVector.random2D();
    health = 255;
    mutationChance = 0.1; // 10% chance of mutation
  }

  void update() {
    location.add(velocity);
    velocity.add(PVector.random2D().mult(0.1));
    velocity.limit(2);

    // Stay within bounds
    if (location.x < 0 || location.x > width) velocity.x *= -1;
    if (location.y < 0 || location.y > height) velocity.y *= -1;

    // Decrease health over time
    health -= 0.2;
  }

  void display() {
    fill(255);
    ellipse(location.x, location.y, 20, 20);
  }

  boolean eat(Resource r) {
    if (PVector.dist(location, r.location) < 10) {
      health += 20; // Increase health when eating
      return true;
    }
    return false;
  }

  boolean canReproduce() {
    return health > 150;
  }

  abstract Creature reproduce(); // Defined by subclasses
}

// Ant class
class Ant extends Creature {
  Ant(float x, float y) {
    super(x, y);
  }

  @Override
  void display() {
    // Draw the ant body
    fill(0);
    ellipse(location.x, location.y, 15, 10); // Body
    fill(50);
    ellipse(location.x + 8, location.y - 5, 8, 8); // Head

    // Draw legs
    stroke(50);
    line(location.x - 6, location.y + 3, location.x - 12, location.y + 12); // Left front leg
    line(location.x + 6, location.y + 3, location.x + 12, location.y + 12); // Right front leg
    line(location.x - 6, location.y - 2, location.x - 12, location.y - 10); // Left middle leg
    line(location.x + 6, location.y - 2, location.x + 12, location.y - 10); // Right middle leg
    line(location.x - 7, location.y + 8, location.x - 13, location.y + 15); // Left back leg
    line(location.x + 7, location.y + 8, location.x + 13, location.y + 15); // Right back leg
  }

  @Override
  Creature reproduce() {
    health -= 10; // Reproduction cost
    return new Ant(location.x + random(-10, 10), location.y + random(-10, 10));
  }
}

// Predator class
class Predator extends Creature {
  Predator(float x, float y) {
    super(x, y);
  }

  @Override
  void display() {
    // Draw the predator body
    fill(200, 50, 50); // Red body
    ellipse(location.x, location.y, 15, 20); // Thorax
    fill(150, 0, 0);
    ellipse(location.x, location.y + 10, 10, 15); // Abdomen
    fill(255, 100, 100);
    ellipse(location.x, location.y - 10, 12, 12); // Head

    // Draw wings
    fill(200, 220, 255, 100); // Transparent light blue
    noStroke();
    arc(location.x - 8, location.y - 7, 20, 30, PI / 4, 3 * PI / 4); // Left wing
    arc(location.x + 8, location.y - 7, 20, 30, 3 * PI / 4, 5 * PI / 4); // Right wing

    // Draw legs
    stroke(150, 50, 50);
    line(location.x - 7, location.y + 5, location.x - 12, location.y + 18); // Left front leg
    line(location.x + 7, location.y + 5, location.x + 12, location.y + 18); // Right front leg
    line(location.x - 5, location.y + 8, location.x - 10, location.y + 20); // Left middle leg
    line(location.x + 5, location.y + 8, location.x + 10, location.y + 20); // Right middle leg

    // Draw mandibles
    stroke(100);
    line(location.x - 5, location.y - 12, location.x - 8, location.y - 15);
    line(location.x + 5, location.y - 12, location.x + 8, location.y - 15);
  }

  boolean hunt(Creature prey) {
    if (PVector.dist(location, prey.location) < 15) {
      health += 40; // Increase health when eating prey
      return true;
    }
    return false;
  }

  @Override
  Creature reproduce() {
    health -= 80; // Higher reproduction cost
    return new Predator(location.x + random(-10, 10), location.y + random(-10, 10));
  }
}
