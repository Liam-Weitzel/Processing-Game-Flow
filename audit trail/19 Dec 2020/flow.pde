boolean[] keys;
char prevkey;
int tpsize;
int maxtpsize;
int maxtpsizecd;
int tpincrement;
PVector playerpos;
PVector velocity;
PVector gravity;
int playersize;
float tptox;
float tptoy;
int setuptime;
int timelasttp;
int timelastgrounded;
int jumped;

void setup() { 
 size (1000, 800);
 background(255);
 playerpos = new PVector(width/2,0);
 velocity = new PVector(0,0);
 gravity = new PVector(0,0.2);
 keys=new boolean[5];
 keys[0]=false;
 keys[1]=false;
 keys[2]=false;
 keys[3]=false;
 tpsize = 0;
 maxtpsize = 800;
 maxtpsizecd = 0;
 tpincrement = 20;
 playersize = 25;
 tptox = 0;
 tptoy = 0;
 setuptime = 0;
 timelasttp = 0;
 jumped = 0;
 timelastgrounded = 0;
}

void draw() {
  background(255);
  noStroke();
  fill(245);
  ellipse(playerpos.x, playerpos.y, maxtpsizecd/2, maxtpsizecd/2);
  fill(183, 204, 237);
  ellipse(playerpos.x, playerpos.y, tpsize, tpsize);
  fill(0,100,100);
  ellipse(playerpos.x, playerpos.y, playersize, playersize);
  //rect(playerpos.x-(playersize/2), playerpos.y-(playersize/2), playersize, playersize);
  playerpos.add(velocity);
  velocity.add(gravity);
  
  float[] level1 = {width/2.2, height-5, (width-((width/2.2)*2)), 5, width-(width/2.2), height-5, width/2.2, 5, 0, height-5, width/2.2, 5, 220, height-300, width/2, 20, width-200, height/3, 200, 20, 50, height/5, 100, 20};
  float[] level2 = {width/2.2, height-5, (width-((width/2.2)*2)), 5, width-(width/2.2), height-5, width/2.2, 5, 0, height-5, width/2.2, 5, 0, height/2, 400, 20, 400+playersize, height/2+100, 150, 20, 550+(playersize*2), height/2+200, 150, 20};
  float[] level3 = {width/2.2, height-5, (width-((width/2.2)*2)), 5, width-(width/2.2), height-5, width/2.2, 5, 0, height-5, width/2.2, 5, 0, height-200, 401, 20, width/2+50, height-340, 200, 20, width-200, height-400, 200, 20};
  drawlevel(level1,0,70,100,200,200,0);
  
  if (playerpos.x > width-(playersize/2)) {
    velocity.x = velocity.x * 0;
    playerpos.x = width-(playersize/2);
  } else if (playerpos.x < (0+(playersize/2))) {
    velocity.x = velocity.x * 0;
    playerpos.x = (0+(playersize/2));
  }
  
  if ((grounded(level1) == true && (nearestfloor(level1)-playerpos.y <= 20 || nearestroof(level1)-playerpos.y <= 20)) || playerpos.y > height-(playersize/2)) {
    velocity.y = 0;
    float playerfloor = nearestfloor(level1)-playerpos.y;
    float playerroof = nearestroof(level1)-playerpos.y;
    float playersideleft = nearestside(level1, 0)-playerpos.x;
    float playersideright = nearestside(level1, 1)-playerpos.x;
    if (((playerfloor*playerfloor) > (playersideleft*playersideleft)) && ((playersideleft*playersideleft) < (playersideright*playersideright)) && ((playerroof*playerroof) > (playersideleft*playersideleft))) {
      playerpos.x = nearestside(level1, 0)-(playersize/2)-0.0001;
      velocity.x = -1;
    } else if (((playerfloor*playerfloor) > (playersideright*playersideright)) && ((playersideleft*playersideleft) > (playersideright*playersideright)) && ((playerroof*playerroof) > (playersideright*playersideright))) {
      playerpos.x = nearestside(level1, 1)+(playersize/2)+0.0001;
      velocity.x = 1;
    } else if (((playerfloor*playerfloor) < (playerroof*playerroof)) && ((playersideleft*playersideleft) > (playerfloor*playerfloor)) && ((playersideright*playersideright) > (playerfloor*playerfloor))) {
      playerpos.y = nearestfloor(level1)-(playersize/2);
    } else if (((playerfloor*playerfloor) > (playerroof*playerroof)) && ((playersideleft*playersideleft) > (playerroof*playerroof)) && ((playersideright*playersideright) > (playerroof*playerroof))) {
      playerpos.y = nearestroof(level1)+(playersize/2)+0.0001;
      velocity.y = 0;
    } 
    
  } else if (playerpos.y < (0+(playersize/2))) {
    velocity.y = velocity.y * 0; 
    playerpos.y = (0+(playersize/2));
  }

  if (keys[0] == true){
    if ((millis() - timelastgrounded) > 200) {
      jumped = 0;
    }
    if (grounded(level1) == true || ((millis() - timelastgrounded) <= 200) && jumped == 0) {
      jumped = 1;
      velocity.y = velocity.y - 8; 
    }
  }
  if (keys[1] == true && keys[3] == false) {
    if (grounded(level1) == true) {
      if (velocity.x >= 0) {
        velocity.x = 0;
      }
      if (velocity.x >= - 3) {
        velocity.x = velocity.x - 0.6;
      }
    } else {
      if (velocity.x >= - 2) {
        velocity.x = velocity.x - 0.2;
      }
    }
  }
  if (keys[2] == true) {
    velocity.y = velocity.y + 0.6; 
  }
  if (keys[3] == true && keys[1] == false){
    if (grounded(level1) == true) {
      if (velocity.x <= -0) {
        velocity.x = 0;
      }
      if (velocity.x <= 3) {
        velocity.x = velocity.x + 0.6;
      }
    } else {
      if (velocity.x <= + 2) {
        velocity.x = velocity.x + 0.2;
      }
    }
  }
  if (keys[4] == true && maxtpsizecd >= playersize/2 && ((millis() - timelasttp) >= 500)){
    
    teleport();
  }
  if (keys[1] == false && keys[3] == false && velocity.x >= 0 && grounded(level1) == true) {
    velocity.x = velocity.x/2 - (0.1);
  } else if (keys[1] == false && keys[3] == false && velocity.x < 0 && grounded(level1) == true) {
    velocity.x = velocity.x/2 + (0.1);
  }
   
  if (velocity.y > 13) {
    velocity.y = 13;
  }
  
  if (keys[4] == false && maxtpsizecd <= maxtpsize) {
    maxtpsizecd = maxtpsizecd + (tpincrement/5);
  }
  key = prevkey;
}

void teleport(){
  velocity.y = 0;
  velocity.x = 0;
  if (prevkey == key) {
    if (tpsize <= (maxtpsizecd)) {
      tpsize = tpsize + tpincrement;
      maxtpsizecd = maxtpsizecd - tpincrement;
    }
    if (tpsize > (maxtpsizecd)) {
      tpsize = tpsize - tpincrement/10;
      maxtpsizecd = maxtpsizecd - tpincrement/10;
    }
  }
  
  if (dist(playerpos.x, playerpos.y, mouseX, mouseY) >= tpsize/2) {
    tptox = playerpos.x + cos(atan2(mouseY-playerpos.y, mouseX-playerpos.x)) * tpsize/2;
    tptoy = playerpos.y + sin(atan2(mouseY-playerpos.y, mouseX-playerpos.x)) * tpsize/2;
  } else {
    tptox = mouseX;
    tptoy = mouseY;
  }
  stroke(0,100,100);
  line(playerpos.x, playerpos.y, tptox, tptoy);
  ellipse(tptox, tptoy, playersize/4, playersize/4);
  
}

void keyPressed() {
  if (key=='w'){
    keys[0]=true;
  }
  if (key=='a'){
    keys[1]=true;
  }
  if (key=='s'){
    keys[2]=true;
  }
  if (key=='d'){
    keys[3]=true;
  }
  if (key==' '){
    keys[4]=true;
  }
}

void keyReleased() {
  if (key=='w'){
    keys[0]=false;
  }
  if (key=='a'){
    keys[1]=false;
  }
  if (key=='s'){
    keys[2]=false;
  }
  if (key=='d'){
    keys[3]=false;
  }
  if (key==' '){
    keys[4]=false;
    if ((millis() - timelasttp) >= 500) {
    if ((int)dist(mouseX, mouseY, playerpos.x, playerpos.y) <= (tpsize/2)) {
      tptox = mouseX;
      tptoy = mouseY;
      velocity.x = (tptox-playerpos.x)/40;
      velocity.y = (tptoy-playerpos.y)/40;
      playerpos.x = tptox;
      playerpos.y = tptoy;
    } else {
      /*
      float slope = (mouseY - playerpos.y)/(mouseX - playerpos.x);
      float r = tpsize/2;
      
      float origintomouse = atan2(mouseY-playerpos.y, mouseX-playerpos.x);
      float origintoplayer = atan2(playerpos.y, playerpos.x);
      */
      
      tptox = playerpos.x + cos(atan2(mouseY-playerpos.y, mouseX-playerpos.x)) * tpsize/2;
      tptoy = playerpos.y + sin(atan2(mouseY-playerpos.y, mouseX-playerpos.x)) * tpsize/2;
      velocity.x = (tptox-playerpos.x)/40;
      velocity.y = (tptoy-playerpos.y)/40;
      playerpos.x = tptox;
      playerpos.y = tptoy;
      /*
      float xdistance = sqrt(((r*r)/(1+slope)));
      if (mouseX > playerpos.x) {
        playerpos.x = playerpos.x+xdistance;
      }else if (mouseX < playerpos.x) {
        playerpos.x = playerpos.x-xdistance;
      }
      
      if (mouseY < playerpos.y) {
        playerpos.y = playerpos.y-sqrt(r*r-(xdistance*xdistance));
      }else if (mouseY > playerpos.y) {
        playerpos.y = playerpos.y+sqrt(r*r-(xdistance*xdistance));
      }
      */
    }
    tpsize = 0;
    timelasttp = millis();
  }
  }
}

float nearestfloor(float[] arr) {
  
  float[] rectx = new float[arr.length/4]; 
  float[] recty = new float[rectx.length]; 
  float[] rectw = new float[rectx.length]; 
  float[] recth = new float[rectx.length];
  
  int i2 = 0;
  for(int i = 0; i < arr.length; i = i + 4) {
    rectx[i2] = arr[i];
    recty[i2] = arr[i+1];
    rectw[i2] = arr[i+2];
    recth[i2] = arr[i+3];
    i2++;
  }
  
  for(int i = rectx.length-1; i >= 0; i--) {
    if (playerpos.y-5 <= recty[i]){
      
      if(playerpos.x <= rectx[i]+(rectw[i]/2)) {
        if ((playerpos.x+playersize/2 >= rectx[i]) && (playerpos.x+playersize/2 <= (rectx[i]+rectw[i]))) {
          return recty[i];
        }
      } else if (playerpos.x > rectx[i]+(rectw[i]/2)) {
        if ((playerpos.x-playersize/2 >= rectx[i]) && (playerpos.x-playersize/2 <= (rectx[i]+rectw[i]))) {
          return recty[i];
        }
      }
    }
  }
  
  return -1000;
}

float nearestroof(float[] arr) {
  
  float[] rectx = new float[arr.length/4]; 
  float[] recty = new float[rectx.length]; 
  float[] rectw = new float[rectx.length]; 
  float[] recth = new float[rectx.length];
  
  int i2 = 0;
  for(int i = 0; i < arr.length; i = i + 4) {
    rectx[i2] = arr[i];
    recty[i2] = arr[i+1];
    rectw[i2] = arr[i+2];
    recth[i2] = arr[i+3];
    i2++;
  }
  
  for(int i = rectx.length-1; i >= 0; i--) {
    if (playerpos.y+5 >= recty[i]){
      
      if(playerpos.x <= rectx[i]+(rectw[i]/2)) {
        if ((playerpos.x+playersize/2 >= rectx[i]) && (playerpos.x+playersize/2 <= (rectx[i]+rectw[i]))) {
          return recty[i]+recth[i];
        } 
      } else if(playerpos.x > rectx[i]+(rectw[i]/2)) {
        if ((playerpos.x-playersize/2 >= rectx[i]) && (playerpos.x-playersize/2 <= (rectx[i]+rectw[i]))) {
          return recty[i]+recth[i];
        } 
      }
    }
  }
  
  return -1000;
}

float nearestside(float[] arr, int side) {
  
  float[] rectx = new float[arr.length/4]; 
  float[] recty = new float[rectx.length]; 
  float[] rectw = new float[rectx.length]; 
  float[] recth = new float[rectx.length];
  
  int i2 = 0;
  for(int i = 0; i < arr.length; i = i + 4) {
    rectx[i2] = arr[i];
    recty[i2] = arr[i+1];
    rectw[i2] = arr[i+2];
    recth[i2] = arr[i+3];
    i2++;
  }
  
  if (side == 0) {
    for(int i = rectx.length-1; i >= 0; i--) {
      if (playerpos.x+5 >= rectx[i]){
        if ((playerpos.y >= recty[i]) && (playerpos.y <= (recty[i]+recth[i]))) {
          return rectx[i];
        }
      }
    }
  } else if (side == 1) {
    for(int i = rectx.length-1; i >= 0; i--) {
      if (playerpos.x-5 >= rectx[i]+rectw[i]){
        if ((playerpos.y >= recty[i]) && (playerpos.y <= (recty[i]+recth[i]))) {
          return rectx[i]+rectw[i];
        }
      }
    }
  }
  
  
  return -1000;
}

boolean grounded(float[] arr) {

  float[] rectx = new float[arr.length/4]; 
  float[] recty = new float[rectx.length]; 
  float[] rectw = new float[rectx.length]; 
  float[] recth = new float[rectx.length];
  
  int i2 = 0;
  for(int i = 0; i < arr.length; i = i + 4) {
    rectx[i2] = arr[i];
    recty[i2] = arr[i+1];
    rectw[i2] = arr[i+2];
    recth[i2] = arr[i+3];
    i2++;
  }
  
  for(int i = 0; i < rectx.length; i++) {
    if (circleRect(playerpos.x,playerpos.y,playersize/2, rectx[i],recty[i],rectw[i],recth[i]) == true) {
      float playerfloor = nearestfloor(arr)-playerpos.y;
      float playerroof = nearestroof(arr)-playerpos.y;
      float playersideleft = nearestside(arr, 0)-playerpos.x;
      float playersideright = nearestside(arr, 1)-playerpos.x;
      if (((playerfloor*playerfloor) < (playerroof*playerroof)) && ((playersideleft*playersideleft) > (playerfloor*playerfloor)) && ((playersideright*playersideright) > (playerfloor*playerfloor))) {
        timelastgrounded = millis();
      }
      return true;
    }
  }

  return false;
}

void drawlevel(float[] level, int r, int g, int b, int rf, int gf, int bf) {
  fill(r,g,b);
  
  for (int i = 4; i < level.length; i = i+4) {
    rect(level[i], level[i+1], level[i+2], level[i+3]);
  }
  
  fill(rf, gf, bf);
  rect(level[0], level[1], level[2], level[3]);
  fill(r,g,b);
  
  if (level[14] == 400) {
    fill(0, 102, 153);
    textSize(32);
    text("Press SPACE to teleport to the mouse.", width/3-20, height/3);
    text("Use the rockets to activate the yellow buttons.", width/3-90, height/3+40);
    text("And try not to blow up.", width/3+90, height/3+80);
    fill(r,g,b);
  }
}

boolean circleRect(float cx, float cy, float radius, float rx, float ry, float rw, float rh) {
  // temporary variables to set edges for testing
  float testX = cx;
  float testY = cy;

  if (cx < rx) {
    testX = rx; // test left edge
  } else if (cx > rx+rw) {
    testX = rx+rw; // right edge
  }
  
  if (cy < ry) {
    testY = ry; // top edge
  } else if (cy > ry+rh) {
    testY = ry+rh; // bottom edge
  }

  // get distance from closest edges
  float distX = cx-testX;
  float distY = cy-testY;
  float distance = sqrt( (distX*distX) + (distY*distY) );

  // if the distance is less than the radius, collision!
  if (distance <= radius) {
    return true;
  }
  return false;
}
