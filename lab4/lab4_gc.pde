int numSpiders = 5;
int numFrogs = 1;
int numAnts = 50;
ArrayList<Creature> creatures;
ArrayList<Food> Foods;
PVector airResistance = new PVector(0, 0.1);  
int foodSpawnCounter = 0;
int foodSpawnInterval = 420;  // New food every 420 frames (7 seconds)

void setup() {
  size(800, 600);
  creatures = new ArrayList<Creature>();
  Foods = new ArrayList<Food>();

  // Create spiders
  for (int i = 0; i < numSpiders; i++) {
    creatures.add(new Creature("spider", random(width), random(height), 3));
  }

  // Create frogs
  for (int i = 0; i < numFrogs; i++) {
    creatures.add(new Creature("frog", random(width), random(height), 5));
  }

  // Create ants
  for (int i = 0; i < numAnts; i++) {
    creatures.add(new Creature("ant", random(width), random(height), 1));
  }
}

void draw() {
   background(255, 223, 0);  

  // Spawn food at intervals
  if (foodSpawnCounter >= foodSpawnInterval) {
    Foods.add(new Food(random(width), 0));
    foodSpawnCounter = 0;
  }
  foodSpawnCounter++;

  // Update and display each piece of food
  for (int i = Foods.size() - 1; i >= 0; i--) {
    Food food = Foods.get(i);
    food.applyForce(airResistance);
    food.update();
    food.display();

    // Remove food that has reached the bottom
    if (food.location.y >= height) {
      Foods.remove(i);
    }
  }

  // Update and display each creature
  for (int i = creatures.size() - 1; i >= 0; i--) {
    Creature creature = creatures.get(i);
    creature.applyForce(PVector.mult(airResistance, creature.mass)); // Apply air resistance
    creature.update(Foods);
    creature.display();

    // Spider behavior: Eat ants
    if (creature.type.equals("spider")) {
      for (int j = creatures.size() - 1; j >= 0; j--) {
        Creature other = creatures.get(j);
        if (other.type.equals("ant")) {
          float distance = PVector.dist(creature.location, other.location);
          if (distance < 20) {
            creatures.remove(j);
            break;
          }
        }
      }
    }

    // Frog behavior: Attack spiders
    if (creature.type.equals("frog")) {
      for (int j = creatures.size() - 1; j >= 0; j--) {
        Creature other = creatures.get(j);
        if (other.type.equals("spider")) {
          float distance = PVector.dist(creature.location, other.location);
          if (distance < 50) {
            creatures.remove(j);
            break;
          }
        }
      }
    }
  }
}

class Creature {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float maxSpeed;
  float mass;
  String type;
  float lastDirectionChangeTime = 0;
  float directionChangeInterval = 3000;

  Creature(String type, float x, float y, float mass) {
    this.type = type;
    this.mass = mass;
    location = new PVector(x, y);
    velocity = PVector.random2D();
    acceleration = new PVector(0, 0);

    if (type.equals("spider")) maxSpeed = random(2, 3);
    else if (type.equals("frog")) maxSpeed = random(1.5, 2);
    else maxSpeed = random(1, 1.5);
  }

  void applyForce(PVector force) {
    PVector f = PVector.div(force, mass);
    acceleration.add(f);
  }

  void update(ArrayList<Food> Foods) {
    // Handle food interaction
    for (int i = Foods.size() - 1; i >= 0; i--) {
      Food food = Foods.get(i);
      float distance = PVector.dist(location, food.location);
      if (distance < 20) {
        Foods.remove(i);
        break;
      }
    }

    // Ants chasing food
    if (type.equals("ant")) chaseFood(Foods);

    // Update speed based on vertical movement
    updateSpeedBasedOnVerticalVelocity();

    // Update velocity and location
    velocity.add(acceleration);
    velocity.limit(maxSpeed);
    location.add(velocity);
    acceleration.mult(0);

    // Screen wrap-around
    if (location.x > width) location.x = 0;
    else if (location.x < 0) location.x = width;

    if (location.y > height) location.y = 0;
    else if (location.y < 0) location.y = height;

    // Random direction change
    if (millis() - lastDirectionChangeTime > directionChangeInterval) {
      changeDirectionRandomly();
      lastDirectionChangeTime = millis();
    }
  }

  void changeDirectionRandomly() {
    float randomAngle = random(TWO_PI);
    velocity = PVector.fromAngle(randomAngle).mult(maxSpeed);
  }

  void updateSpeedBasedOnVerticalVelocity() {
    if (type.equals("spider") || type.equals("frog")) {
      if (velocity.y > 0) maxSpeed = constrain(maxSpeed + 0.05, 1, 4);
      else if (velocity.y < 0) maxSpeed = constrain(maxSpeed - 0.05, 1, 3);
    }
  }

  void chaseFood(ArrayList<Food> Foods) {
    Food nearestFood = null;
    float closestDistance = Float.MAX_VALUE;

    for (Food food : Foods) {
      float distance = PVector.dist(location, food.location);
      if (distance < closestDistance && distance < 50) {
        closestDistance = distance;
        nearestFood = food;
      }
    }

    if (nearestFood != null) {
      PVector chase = PVector.sub(nearestFood.location, location);
      chase.normalize();
      chase.mult(0.3);
      applyForce(chase);
    }
  }

  void display() {
    if (type.equals("spider")) displaySpider();
    else if (type.equals("frog")) displayFrog();
    else displayAnt();
  }

  void displayAnt() {
    pushMatrix();
    translate(location.x, location.y);
    rotate(velocity.heading());
    fill(139, 69, 19);  // Brown
    ellipse(0, 0, 10, 5);  // Body
    ellipse(5, 0, 7, 4);   // Head
    line(-5, 0, -10, 0);   // Antennae
    popMatrix();
  }

  void displaySpider() {
    pushMatrix();
    translate(location.x, location.y);
    rotate(velocity.heading());
    fill(0);  // Black
    ellipse(0, 0, 20, 10);  // Body
    line(-10, -5, -20, -10);  // Legs
    line(-10, 5, -20, 10);
    line(10, -5, 20, -10);
    line(10, 5, 20, 10);
    popMatrix();
  }

  void displayFrog() {
    pushMatrix();
    translate(location.x, location.y);
    rotate(velocity.heading());
    fill(34, 139, 34);  // Green
    ellipse(0, 0, 30, 20);  // Body
    fill(255);  // White eyes
    ellipse(-5, -5, 5, 5);
    ellipse(5, -5, 5, 5);
    fill(0);  // Pupils
    ellipse(-5, -5, 2, 2);
    ellipse(5, -5, 2, 2);
    popMatrix();
  }
}

class Food {
  PVector location;
  PVector velocity;
  PVector acceleration;

  Food(float x, float y) {
    location = new PVector(x, y);
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void update() {
    velocity.add(acceleration);
    velocity.limit(1);
    location.add(velocity);
    acceleration.mult(0);
  }

  void display() {
    fill(255, 223, 0);  // Yellow for food
    ellipse(location.x, location.y, 8, 8);
  }
}
