void setup() {
  // Set fullscreen mode and background color
  fullScreen();
  background(199); // background

  // Set rectangle drawing mode to center
  rectMode(CENTER);

  // Define the center of the sketch
  float centerX = width / 2;
  float centerY = height / 2;

  // Set the width and height of the rectangle using rx and ry
  float rectWidth = 190 * 2; // rx * 2
  float rectHeight = 145 * 2; // ry * 2

  // Set stroke color for the rectangle's border and lines
  stroke(0); // Black stroke for the rectangle
  strokeWeight(3); // Rectangle stroke thickness
  fill(150, 200, 255); // Light blue fill for rectangle

  // Draw the rectangle in the center
  rect(centerX, centerY, rectWidth, rectHeight);

  // Draw the diagonals
  stroke(255, 100, 100); // Red lines for diagonals
  strokeWeight(2); // Thinner line for diagonals
  line(centerX - rectWidth / 2, centerY - rectHeight / 2, centerX + rectWidth / 2, centerY + rectHeight / 2);
  line(centerX + rectWidth / 2, centerY - rectHeight / 2, centerX - rectWidth / 2, centerY + rectHeight / 2);

  // Draw the cross (horizontal and vertical lines)
  stroke(100, 255, 100); // Green lines for cross
  strokeWeight(4); // Thicker line for the cross
  line(centerX - rectWidth / 2, centerY, centerX + rectWidth / 2, centerY); // Horizontal line
  line(centerX, centerY - rectHeight / 2, centerX, centerY + rectHeight / 2); // Vertical line

  // Draw an arc in quadrant III inside the rectangle
  stroke(0, 0, 255); // Blue color for the arc
  strokeWeight(6); // Thicker stroke for arc
  noFill(); // No fill for the arc
  arc(centerX, centerY, rectWidth, rectHeight, PI, PI + QUARTER_PI); // Arc in quadrant III

  // Draw a chord inside the rectangle
  stroke(255, 165, 0); // Orange color for chord
  strokeWeight(5); // Medium stroke for chord
  arc(centerX, centerY, rectWidth, rectHeight, PI + HALF_PI, -HALF_PI, CHORD); // Chord from quadrant IV to middle of quadrant I

  // Draw a pie inside the rectangle
  stroke(128, 0, 128);
  strokeWeight(4); 
  fill(200, 200, 0); 
  arc(centerX, centerY, rectWidth - 15, rectHeight - 15, HALF_PI, PI + HALF_PI, PIE); // Pie from quadrant II to III

  // Draw a horizontally stretched ellipse on the right side
  stroke(255, 0, 0); 
  strokeWeight(3); 
  fill(0, 255, 255); 
  ellipse(centerX + rectWidth / 2 + 100, centerY, 300, 100); 

  // Draw a four-sided polygon (quad) on the right side of the window
  stroke(0, 255, 0); 
  strokeWeight(2);
  fill(255, 0, 255);
  quad(centerX + rectWidth / 2 + 50, centerY + 50,
       centerX + rectWidth / 2 + 200, centerY + 100,
       centerX + rectWidth / 2 + 250, centerY + 150,
       centerX + rectWidth / 2 + 100, centerY + 100);
}

void draw() {
  
}
