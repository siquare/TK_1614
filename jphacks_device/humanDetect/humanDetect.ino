/*
  ASCII table

 Prints out byte values in all possible formats:
 * as raw binary values
 * as ASCII-encoded decimal, hex, octal, and binary values

 For more on ASCII, see http://www.asciitable.com and http://en.wikipedia.org/wiki/ASCII

 The circuit:  No external hardware needed.

 created 2006
 by Nicholas Zambetti
 modified 9 Apr 2012
 by Tom Igoe

 This example code is in the public domain.

 <http://www.zambetti.com>

 */

int buttonPin = 4;
bool humanDetected = false;
int buttonState = 0;
int count = 0;
void setup() {
  //Initialize serial and wait for port to open:
    pinMode(buttonPin, INPUT);
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  // prints title with ending line break
  //Serial.println("ASCII Table ~ Character Map");
}

// first visible ASCIIcharacter '!' is number 33:
int thisByte = 33;
// you can also write ASCII characters in single quotes.
// for example. '!' is the same as 33, so you could also use this:
//int thisByte = '!';

void loop() {
  // prints value unaltered, i.e. the raw binary version of the
  // byte. The serial monitor interprets all bytes as
  // ASCII, so 33, the first number,  will show up as '!'
    buttonState = digitalRead(buttonPin);
    Serial.print("");
    
    if (buttonState == HIGH) 
    {      
      count+= 20;
      delay(100);
    }
    else if(buttonState == LOW)
    {
      count -= 5;
      delay(100);
    }
    if(count > 100)
    {
      Serial.print("detected");
      count = 0;
      delay(10000);    
    }
    delay(200);

    

    
}
