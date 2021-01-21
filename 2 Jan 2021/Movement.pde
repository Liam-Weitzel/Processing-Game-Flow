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
    teleportrelease();
  }
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
      tpsize = tpsize - tpincrement/20;
      maxtpsizecd = maxtpsizecd - tpincrement/20;
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

void teleportrelease() {
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

void keycheck(float[] level) {
  
  if (keys[0] == true){
    if ((millis() - timelastgrounded) > 200) {
      jumped = 0;
    }
    if (grounded(level) == true || ((millis() - timelastgrounded) <= 200) && jumped == 0) {
      jumped = 1;
      velocity.y = velocity.y - 8; 
    }
  }
  
  if (keys[1] == true && keys[3] == false) {
    
    if (grounded(level) == true) {
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
    
    if (grounded(level) == true) {
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
  
  if (keys[1] == false && keys[3] == false && velocity.x >= 0 && grounded(level) == true) {
    velocity.x = velocity.x/2 - (0.1);
  } else if (keys[1] == false && keys[3] == false && velocity.x < 0 && grounded(level) == true) {
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

void playeranimation(float[] level) {
  if (keys[4] == false) {
    if (grounded(level) == false && velocity.x < -1) {
      if (currplayerimage != 0) {
        playeranimstate = 2;
        currplayerimage--;
      } else if (currplayerimage == 0) {
        playeranimstate = 2;
        currplayerimage = 33;
      } //rotate up left
    } else if (grounded(level) == false && velocity.x > 1) {
      if (currplayerimage != 0) {
        playeranimstate = 1;
        currplayerimage--;
      } else if (currplayerimage == 0) {
        playeranimstate = 1;
        currplayerimage = 33;
      } //rotate up right
    } else if (grounded(level) == false && velocity.x <= 1 && velocity.x >= -1) {
      if (currplayerimage != 0) {
        playeranimstate = 3;
        currplayerimage--;
      } else if (currplayerimage == 0) {
        playeranimstate = 3;
        currplayerimage = 33;
      } //rotate up
    }
    
    if (velocity.x > 0.1 && velocity.y == 0) {
      if (currplayerimage != 0) {
        playeranimstate = 0;
        currplayerimage--;
      } else if (currplayerimage == 0) {
        playeranimstate = 0;
        currplayerimage = 33;
      } //rotate right
    }
    
    if (velocity.x < -0.1 && velocity.y == 0) {
      if (currplayerimage != 33) {
        playeranimstate = 0;
        currplayerimage++;
      } else if (currplayerimage == 33) {
        playeranimstate = 0;
        currplayerimage = 0;
      } //rotate left
    }
  }
}
