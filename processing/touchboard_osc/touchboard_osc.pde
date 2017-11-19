
import oscP5.*;
import netP5.*;
import processing.serial.*;

Serial myPort;


OscP5 oscP5;
NetAddress madMapper;

String mymedia = "TEST VIDEO.pm4";


int rectX, rectY;
int rectSize = 90;
color rectColor, circleColor, baseColor;
color rectHighlight;
boolean rectOver = false;
boolean isplaying = false;


//void updateArrayOSC(int[] array, Object[] data) {
//  if (array == null || data == null) {
//    return;
//  }

//  for (int i = 0; i < min(array.length, data.length); i++) {
//    array[i] = (int)data[i];
//  }
//}

void setup() {
  oscP5 = new OscP5(this, 5000);
  madMapper = new NetAddress("127.0.0.1", 5001);


  printArray(Serial.list());
  myPort = new Serial(this, Serial.list()[0], 9600);
  
  
  size(640, 360);
  rectColor = color(0);
  rectHighlight = color(51);
  baseColor = color(102);
  rectX = width/2-rectSize-10;
  rectY = height/2-rectSize/2;

}

//void oscEvent(OscMessage oscMessage) {
//  if (oscMessage.checkAddrPattern("/touch")) {
//    updateArrayOSC(status, oscMessage.arguments());
//  }
//}

void sendMessage(String command) {
  OscMessage msg = new OscMessage("/medias/" + mymedia + "/"+ command);
  //msg.add(begin);
  println(command);
  oscP5.send(msg, madMapper);
}




void serialEvent( Serial myPort) {


}


void draw() {
  
  
  try 
  {
    if (myPort.available() > 0) 
    {
      String serialValue = myPort.readStringUntil('\n');
      serialValue = trim(serialValue);
      println(serialValue.equals("R"));
      if(serialValue.equals("R"))
      {
        sendMessage("play");
      }
      else if (serialValue.equals("r"))
      {
        sendMessage("pause");
      }   
    } 
  }
  catch (Exception e) {
    println("Initialization exception");
//    decide what to do here
  }  
 
  
  update(mouseX, mouseY);
  background(0);
  
  if (rectOver) {
    fill(rectHighlight);
  } else {
    fill(rectColor);
  }
  stroke(255);
  rect(rectX, rectY, rectSize, rectSize);
  
}


void update(int x, int y) {
  if ( overRect(rectX, rectY, rectSize, rectSize) ) {
    rectOver = true;
  } else {
    rectOver = false;
  }
}


boolean overRect(int x, int y, int width, int height)  {
  if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}

void mousePressed() {
  if (rectOver) {    
    if(!isplaying)
    {
      sendMessage("play");
      isplaying = true;
    }
    else
    {
      sendMessage("pause");
      isplaying = false;
    }
  }
}