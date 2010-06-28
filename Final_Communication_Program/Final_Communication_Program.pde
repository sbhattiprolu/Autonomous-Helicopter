#include <Wire.h>
#include <string.h>
#include <stdio.h>


uint8_t outbuf[6]; // array to store arduino output
uint8_t init_sequence[6];
char storebuf[200]; //array to store arduino input (transmitted from PC)
int cnt = 0;
int ledPin = 13;
int counter=0;
void
receiveEvent (int howMany)
{
  //Serial.println("Recieve Event");
//  while (Wire.available ())
  {
      int c = Wire.receive (); // receive byte as an integer
      if(c!=0){
        Serial.print("Rec : 0x");
        Serial.println(c,HEX);
      }
      
  }//
}

void
requestEvent ()
{
  Serial.print(".");
  if(counter==0){
  init_sequence[0]=00;
  init_sequence[1]=00;
  init_sequence[2]=0xA4;
  init_sequence[3]=0x20;
  init_sequence[4]=00;
  init_sequence[5]=00;
  Wire.send(init_sequence,6);
  counter++;
  }
  // Send some data back to the wiimote to be transmitted back to PC
  else{
  outbuf[0] = nunchuk_encode_byte(126); // joystick X
  outbuf[1] = nunchuk_encode_byte(124); // joystick Y
  outbuf[2] = nunchuk_encode_byte(100); // Axis X
  outbuf[3] = nunchuk_encode_byte(100); // Axis Y
  outbuf[4] = nunchuk_encode_byte(100); // Axis Z
  outbuf[5] = nunchuk_encode_byte(1); // Press C button, by te[5] is buttons 
  //C,Z and accelaration data
  //outbuf[5] = nunchuk_encode_byte(2); // Press Z button
  //outbuf[5] = nunchuk_encode_byte(0); // Press Z and C button
  Wire.send (outbuf, 6); // send data packet
}
}
void
setup ()
{
  Serial.begin (115200);
  Serial.print ("Finished setup\n");
  Wire.begin (0x52); // join i2c bus with address 0x52
  Wire.onReceive (receiveEvent); // register event
  Wire.onRequest (requestEvent); // register event
}


// Print the input data we have recieved
void
print ()
{
  int s = 0;

  Serial.println ("Start data dump");
  int a = strlen (storebuf); // Get the lenght of the buffer, then print it out one character at a time
  while (s < (a - 1))
    {
      Serial.print (storebuf[s]);
      s++;
    }

  cnt = 0;
  strcpy (storebuf, ""); // empty out the storage buffer
  Serial.println ("End data dump");
}

void
loop ()
{
  
//  delay (100);
  


}

// Encode data to format that most wiimote drivers except
// only needed if you use one of the regular wiimote drivers
char
nunchuk_encode_byte (char x)
{
  x = x - 0x17;
  x = (x ^ 0x17);
  return x;
}

