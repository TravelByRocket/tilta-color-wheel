#include "SparkFunLIS3DH.h"
#include "Wire.h"
#include "SPI.h"
#include "math.h"

float accX;
float accY;
float accZ;
float angle;


LIS3DH myIMU; //Default constructor is I2C, addr 0x19.

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  delay(1000); //relax...
  Serial.println("Processor came out of reset.\n");

  //Call .begin() to configure the IMU
  myIMU.begin();
}

void loop()
{
  accX = myIMU.readFloatAccelX();
  accY = myIMU.readFloatAccelY();
  accZ = myIMU.readFloatAccelZ();

  angle = atan2(accY,accZ);

  if (angle < 0) {
    angle = 2*3.1415926 + angle;
  }

// don't adjust the color of the wand is not being held near level
  if (sqrt(sq(accY)+sq(accZ)) > 0.85) {
    // Serial.println(sqrt(sq(accY)+sq(accZ)));
    Serial.println((angle/(2*3.1415926))*360, 2); //angle in degrees
    // Serial.println();
  }
  delay(100);
}
