float animationProgress = 0; // Track the animation progress (0 = infinity, 1 = circle)
boolean isAnimating = false; // Flag to check if animation is active
float rotationAngle = 0; // Angle for rotation

void setup() {
  size(400, 400); // Set canvas size
}

void draw() {
  // Draw the sky (light blue)
  fill(173, 216, 230); // Light blue color for the sky
  rect(0, 0, width, height / 2); // Fill top half with light blue

  // Draw the ground (green)
  fill(0, 128, 0); // Green color for the ground
  rect(0, height / 2, width, height / 2); // Fill bottom half with green

  translate(width / 2, height / 2); // Center the rotation
  rotate(rotationAngle); // Apply rotation

  drawLogo(); // Draw the logo in its current state
  
  // Draw a line underneath the logo with fading effect
  stroke(0, 51, 153, (1 - animationProgress) * 255); // Dark blue stroke for the line with alpha based on animation progress
  strokeWeight(4);
  line(-110, 110, 110, 110); // Draw the line under the logo
  
  updateAnimation(); // Update animation progress and rotation
}

void drawLogo() {
  // Calculate size based on animation progress
  float rectWidth = lerp(210, 210, animationProgress); // Keep width constant for the circle
  float rectHeight = lerp(280, 210, animationProgress); // Keep height constant for the circle
  float radius = lerp(80, 105, animationProgress); // Corner radius

  // Draw the large dark blue rounded rectangle or circle
  fill(0, 51, 153); // Dark blue color
  noStroke();
  
  if (animationProgress < 1) {
    rect(-rectWidth / 2, -rectHeight / 2, rectWidth, rectHeight, radius, radius, radius, 0); // Draw rectangle
  } else {
    ellipse(0, 0, rectWidth, rectHeight); // Draw circle when animation is complete
  }

  // Draw the infinity symbol if animation is not complete
  stroke(0, 51, 153); // Dark blue stroke for the infinity symbol
  strokeWeight(8);
  noFill();
  
  if (animationProgress < 1) {
    drawAnimatedInfinitySymbol(); // Draw infinity symbol
  }
  
  // Draw the two light blue circles and the rest of the logo
  drawCircles();
}

// Function to draw the animated infinity symbol
void drawAnimatedInfinitySymbol() {
  float w = lerp(100, 50, animationProgress); // Width of each loop (smaller as it transitions)
  float h = 50; // Height stays the same
  
  beginShape();
  // Left loop
  vertex(-w, 0);
  bezierVertex(-w, -h, 0, -h, 0, 0);
  // Right loop
  bezierVertex(0, h, w, h, w, 0);
  bezierVertex(w, -h, 0, -h, 0, 0);
  bezierVertex(0, h, -w, h, -w, 0);
  endShape();
}

// Draw the light blue circles and inner elements
void drawCircles() {
  fill(173, 216, 230); // Light blue color
  noStroke();
  float circleDiameter = 120; // Diameter of the light blue circles
  float offset = circleDiameter / 2.5; // Adjusted offset for closer circles
  
  // Calculate the positions of the two light blue circles
  float angle = radians(135); // Convert angle to radians
  float x1 = cos(angle) * offset; // Left circle position
  float y1 = sin(angle) * offset;
  float x2 = -cos(angle) * offset; // Right circle position
  float y2 = -sin(angle) * offset;
  
  // Draw the light blue circles
  ellipse(x1, y1, circleDiameter, circleDiameter);
  ellipse(x2, y2, circleDiameter, circleDiameter);
  
  // Draw a white ring filling three-quarters of the left light blue circle
  fill(255); // White color for the ring
  arc(x1, y1, circleDiameter, circleDiameter, -HALF_PI, TWO_PI + TWO_PI, PIE); // Left circle ring
  
  // Draw a white ring filling 60% of the right light blue circle
  arc(x2, y2, circleDiameter, circleDiameter, HALF_PI, TWO_PI + HALF_PI * 0., PIE); // Right circle ring
  
  // Draw two dark blue circles inside the light blue circles
  fill(0, 51, 153); // Dark blue inner circles
  float innerCircleDiameter = 60; // Diameter of the inner dark blue circles
  ellipse(x1, y1, innerCircleDiameter, innerCircleDiameter);
  ellipse(x2, y2, innerCircleDiameter, innerCircleDiameter);
}

// Mouse press detection for starting the animation
void mousePressed() {
  isAnimating = true; // Start the animation when the mouse is pressed
}

// Update the animation progress and rotation angle
void updateAnimation() {
  if (isAnimating) {
    // Update animation progress
    animationProgress += 0.02; // Increase progress
    rotationAngle -= 0.05; // Rotate counter-clockwise
    
    // Check if rotation has reached 180 degrees (π radians)
    if (animationProgress > 1) {
      animationProgress = 1; // Cap at 1 (circle)
    }
  } else {
    animationProgress -= 0.02; // Reset animation
    rotationAngle -= 0.05; // Rotate counter-clockwise
    if (animationProgress < 0) {
      animationProgress = 0; // Cap at 0 (infinity symbol)
      rotationAngle = 0; // Reset rotation
    }
  }
}
