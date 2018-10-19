import processing.serial.*;
import processing.video.*;
Serial myPort;  // Create object from Serial class
String val;     // Data received from the serial port
float numStore = 0; //start with a default and continue to store the last in case of a 'null'
float num;

float r = width/2; // radius
float a = 0; // angle
float current_mouseX = 0;
float current_mouseY = 0;

// Size of each cell in the grid
int cellSize = 1;
// Number of columns and rows in our system
int cols, rows;
// Variable for capture device
Capture video;

float closestGreenLocationX;
float closestGreenLocationY;

void setup()
{
  size(800, 800);
  cols = width / cellSize;
  rows = height / cellSize;
  colorMode(HSB, 360, 100, 100);
  // I know that the first port in the serial list on my mac
  // is Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[2]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
  video = new Capture(this, width, height);
  video.start(); 
  delay(1000);
  background(0, 0, 100);
  noStroke();
}

void draw()
{
  videoStuff();
  if ( myPort.available() > 0) 
  {  // If data is available,
    val = myPort.readStringUntil('\n');         // read it and store it in val
  } 
  println(val); //print it out in the console
  if (val == null) {
    num = numStore;
  } else {
    num = float(val);
    numStore = num;
  }
  fill(num, 100, 100);
  color_circle();
  //fill(0,0,100,5);
  //rect(0,0,height,width);
}

void color_circle() {
  //translate(width/2, height/2);
  float cx = width/2; // center of circle x coordinate
  float cy = height/2; // center of circle y coordinate

  if (closestGreenLocationX != 0 && closestGreenLocationY != 0) {
    current_mouseX += (closestGreenLocationX - current_mouseX)/5;
    current_mouseY += (closestGreenLocationY - current_mouseY)/5;
    a = degrees(atan2(current_mouseY-height/2, current_mouseX-width/2));
    float a2 = a+10;
    fill(num, 100, 100); // use angle for the value of hue
    if ((sqrt(sq(closestGreenLocationX-width/2)+sq(closestGreenLocationY-height/2))<width*.4)) {
      arc(cx, cy, width*.8, height*.8, radians(a), radians(a2));
    }
  }
}

void videoStuff () {
  if (video.available()) {
    video.read();
    video.loadPixels();

    float closestDistance = 60; // initalize to largest possible value to start
    closestGreenLocationX = 0;
    closestGreenLocationY = 0;

    // Begin loop for columns
    for (int i = 0; i < cols; i++) {
      // Begin loop for rows
      for (int j = 0; j < rows; j++) {

        // Where are we, pixel-wise?
        int x = i*cellSize;
        int y = j*cellSize;
        int loc = (video.width - x - 1) + y*video.width; // Reversing x to mirror the image

        float h = hue(video.pixels[loc]);
        float s = saturation(video.pixels[loc]);
        float b = brightness(video.pixels[loc]);

        float distance = dist(h, s, b, 150, 100, 100);

        if (distance < closestDistance) {
          closestDistance = distance;
          closestGreenLocationX = x;
          closestGreenLocationY = y;
          print("closestDistance");
          println(int(closestDistance));
        }

        //Code for drawing a rect
        //fill(h, s, b);
        //noStroke();
        //rect(x, y, cellSize, cellSize);
      }
    }
  }
  //fill(150, 100, 100);
  //ellipse(closestGreenLocationX, closestGreenLocationY, 10, 10);
  //draw erasing rectangles
  fill(0, 0, 100);
  rect(0, 0, width, 10);
  rect(0, height-10, width, 10);
  rect(0, 0, 10, height);
  rect(width-10, 0, 10, height);

  // draw ticks
  fill(0, 0, 0);
  rect(closestGreenLocationX-1, 0, 3, 10); // top border tick
  rect(closestGreenLocationX-1, height-10, 3, 10); // bottom border tick
  rect(0, closestGreenLocationY-1, 10, 3);
  rect(width-10, closestGreenLocationY-1, 10, 3);
  //fill(100,50,50);
}
