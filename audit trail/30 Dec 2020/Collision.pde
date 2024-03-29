void collisioncheck(float[] level) {
  if (playerpos.x > width-(playersize/2)) {
    velocity.x = velocity.x * 0;
    playerpos.x = width-(playersize/2);
  } else if (playerpos.x < (0+(playersize/2))) {
    velocity.x = velocity.x * 0;
    playerpos.x = (0+(playersize/2));
  }
  
  if ((grounded(level) == true && (nearestfloor(level)-playerpos.y <= 20 || nearestroof(level)-playerpos.y <= 20)) || playerpos.y > height-(playersize/2)) {
    velocity.y = 0;
    float playerfloor = nearestfloor(level)-playerpos.y;
    float playerroof = nearestroof(level)-playerpos.y;
    float playersideleft = nearestside(level, 0)-playerpos.x;
    float playersideright = nearestside(level, 1)-playerpos.x;
    if (((playerfloor*playerfloor) > (playersideleft*playersideleft)) && ((playersideleft*playersideleft) < (playersideright*playersideright)) && ((playerroof*playerroof) > (playersideleft*playersideleft))) {
      playerpos.x = nearestside(level, 0)-(playersize/2)-0.0001;
      velocity.x = -1;
    } else if (((playerfloor*playerfloor) > (playersideright*playersideright)) && ((playersideleft*playersideleft) > (playersideright*playersideright)) && ((playerroof*playerroof) > (playersideright*playersideright))) {
      playerpos.x = nearestside(level, 1)+(playersize/2)+0.0001;
      velocity.x = 1;
    } else if (((playerfloor*playerfloor) < (playerroof*playerroof)) && ((playersideleft*playersideleft) > (playerfloor*playerfloor)) && ((playersideright*playersideright) > (playerfloor*playerfloor))) {
      playerpos.y = nearestfloor(level)-(playersize/2);
    } else if (((playerfloor*playerfloor) > (playerroof*playerroof)) && ((playersideleft*playersideleft) > (playerroof*playerroof)) && ((playersideright*playersideright) > (playerroof*playerroof))) {
      playerpos.y = nearestroof(level)+(playersize/2)+0.0001;
      velocity.y = 0;
    }
  } else if (playerpos.y < (0+(playersize/2))) {
    velocity.y = velocity.y * 0; 
    playerpos.y = (0+(playersize/2));
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
