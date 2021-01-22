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

float[] currlevel;
int[] currlevelturrets;
int[] currlevelbuttons;
int[] staticbuttons;
float[] staticlevel;
int currlevelint;

PImage player;
int currplayerimage;
int[] playeranims = {128, 176, 240, 192};
int playeranimstate;

PImage platforms;
int[] platdx = {22, 23, 25, 24, 22, 23, 25, 24, 22, 23, 25, 24, 22, 23, 25, 24};
int[] platdy = {16, 81, 147, 218, 16, 81, 147, 218, 16, 81, 147, 218, 16, 81, 147, 218};
int[] platw = {288, 386, 483, 198, 288, 386, 483, 198, 288, 386, 483, 198, 288, 386, 483, 198};
int[] plath = {56, 121, 187, 258, 56, 121, 187, 258, 56, 121, 187, 258, 56, 121, 187, 258};

PImage projectile_grey;
PImage projectile_red;
PImage projectile_yellow;
PImage projectile_blue;
PImage projectile_redyellow;
PImage turrets;

int turretw;
int turreth;
int col;
int orient;
int turretypos;
int turretxpos;

int[] turretcolor = {0,15,30,45,60};
int[] orientation = {0,13,26,41};

ArrayList<Integer> rocketid = new ArrayList<Integer>();
ArrayList<Integer> rocketcolor = new ArrayList<Integer>();
ArrayList<PVector> rocketvelocity = new ArrayList<PVector>();
ArrayList<PVector> rocketpos = new ArrayList<PVector>();
ArrayList<Float> rocketturning = new ArrayList<Float>();
ArrayList<Integer> rocketcurrimage = new ArrayList<Integer>();
ArrayList<Float> rocketmaxspeed = new ArrayList<Float>();
int id = 0;

PImage explosion_grey;
PImage explosion_red;
PImage explosion_yellow;
PImage explosion_blue;
PImage explosion_redyellow;
ArrayList<Float> explosionsx = new ArrayList<Float>();
ArrayList<Float> explosionsy = new ArrayList<Float>();
ArrayList<Integer> explosionscolor = new ArrayList<Integer>();
ArrayList<Integer> explosionscurrimg = new ArrayList<Integer>();

PImage bloodleft;
PImage bloodright;
int currdeathimg;
float leftright = 0;
boolean dead;
int deadtime;
int hitexplosion;
int gamestate;

void setup() {
 player = loadImage("sprites/player.png"); //spritesheet for player anims
 currplayerimage = 0;
 playeranimstate = 0;
 
 platforms = loadImage("sprites/platforms.png"); //spritesheet for wooden platforms
 
 projectile_grey = loadImage("sprites/projectile_grey.png"); //spritesheet for grey turret projectile
 projectile_red = loadImage("sprites/projectile_red.png"); //spritesheet for red turret projectile
 projectile_yellow = loadImage("sprites/projectile_yellow.png"); //spritesheet for yellow turret projectile
 projectile_blue = loadImage("sprites/projectile_blue.png"); //spritesheet for blue turret projectile
 projectile_redyellow = loadImage("sprites/projectile_redyellow.png"); //spritesheet for redyellow turret projectile
 turrets = loadImage("sprites/turretsv4.png"); //spritesheet for turrets
 
 explosion_grey = loadImage("sprites/explosiongrey.png");
 explosion_red = loadImage("sprites/explosionred.png");
 explosion_yellow = loadImage("sprites/explosionyellow.png");
 explosion_blue = loadImage("sprites/explosionblue.png");
 explosion_redyellow = loadImage("sprites/explosionredyellow.png");
 
 bloodleft = loadImage("sprites/bloodleft.png");
 bloodright = loadImage("sprites/bloodright.png");
 currdeathimg = 0;
  
 size(1000, 800);
 background(255);
 
 playerpos = new PVector(width/2,0);
 velocity = new PVector(0,0);
 gravity = new PVector(0,0.2);
 
 keys=new boolean[5];
 keys[0]=false;
 keys[1]=false;
 keys[2]=false;
 keys[3]=false;
 keys[4]=false;
 
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
 
 float[] level1 = {width/2.2, height-1, (width-((width/2.2)*2)), 1, 0, 0, 0, 0, width-(width/2.2), height-5, width/2.2, 5, 0, height-5, width/2.2, 5, 220, height-300, width/2, 20, width-200, height/3, 200, 20, 50, height/5, 100, 20};
 //first rect is the finish
 //second rect is the platform blocking the finish
 //third and fourth rects are the floor
 
 int[] level1buttons = {0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0};
 
 int[] level1turrets = {};
 //first param: turret xpos
 //second param: turret ypos
 //third param: down, up, right, left
 //fourth param: red, yellow, blue, redyellow, grey
 //fifth param: leave 0
 
 staticlevel = level1;
 currlevel = level1;
 currlevelturrets = level1turrets;
 staticbuttons = level1buttons;
 currlevelbuttons = level1buttons;
 currlevelint = 1;
 
 dead = false;
 hitexplosion = 0;
 gamestate = 1;
}

void draw() {
  if (gamestate == 0) {
    if (dead == false) {
      background(255);
      noStroke();
      fill(245);
      ellipse(playerpos.x, playerpos.y, maxtpsizecd/2, maxtpsizecd/2);
      fill(183, 204, 237);
      ellipse(playerpos.x, playerpos.y, tpsize, tpsize);
      fill(0,100,100);
      
      collisioncheck(currlevel);
      keycheck(currlevel);
      levelcheck();
      playeranimation(currlevel);    
      
      //drawing player
      image(player, playerpos.x-(playersize/2), playerpos.y-(playersize/2), (float) playersize, (float) playersize, (int) currplayerimage*16, (int) playeranims[playeranimstate], currplayerimage*16+16, playeranims[playeranimstate]+16);
      playerpos.add(velocity);
      velocity.add(gravity);
      
      drawprojectiles(currlevelturrets, currlevel);
      drawturrets(currlevelturrets);
      drawlevel(currlevel,0,70,100,200,200,0);
      drawbuttons(currlevelbuttons,0,70,100,200,200,0);
      drawexplosions();
      playerexplosioncollision();
      projectile_tpsize();
      buttonprojectilecollision(currlevelbuttons);
      
      //general win condition
      if (allzeros(currlevelbuttons)) {
        currlevel[4] = 0;
        currlevel[5] = 0;
        currlevel[6] = 0;
        currlevel[7] = 0;
      } else if (allzeros(currlevelbuttons) == false) {
        currlevel[4] = staticlevel[4];
        currlevel[5] = staticlevel[5];
        currlevel[6] = staticlevel[6];
        currlevel[7] = staticlevel[7];
      }
    } else if (dead == true) {
      playerdeathanimation();
      drawexplosions();
      if (millis() - deadtime >= 2000) {
        playerpos = new PVector(width/2,0);
        velocity = new PVector(0,0);
        currdeathimg = 0;
        dead = false;
        resetrockets();
        resetexplosions();
        for (int i = 0; i < currlevelbuttons.length; i++) {
          currlevelbuttons[i] = staticbuttons[i];
        }
      }
    }
  } else if (gamestate == 1) {
    background(255);
    fill(0, 102, 153);
    textSize(60);
    text("Flow", width/2-70, height/2-height/3);
    textSize(32);
    text("CSCore1 processing game", width/3-40, height/2-height/3+60);
  
    text("Controls:", width/3+90, height/3);
    
    rect(width/2-30, height/3+150, 60, 60);
    rect(width/2-100, height/3+150, 60, 60);
    rect(width/2+40, height/3+150, 60, 60);
    rect(width/2-30, height/3+80, 60, 60);
    
    fill(255);
    text("W", width/2-30+16, height/3+80+43);
    text("A", width/2-100+19, height/3+150+43);
    text("S", width/2-30+22, height/3+150+43);
    text("D", width/2+40+20, height/3+150+43);
    fill(0, 102, 153);

    ellipse(width/2+width/4, height/3+130, 130, 230);
    line(width/2+width/4-63, height/3+100, width/2+width/4+63, height/3+100);
    line(width/2+width/4, height/3+100, width/2+width/4, height/3+15);

    rect(width/2-75, height/2+height/6, 150, 80);
    fill(255);
    text("start", width/2-35, height/2+height/6+50);
    fill(0, 102, 153);
  }
}

void mouseClicked() {
  if (gamestate == 1 && mouseX >= width/2-75 && mouseX <= width/2-75+150 && mouseY >= height/2+height/6 && mouseY <= height/2+height/6+80) {
    gamestate = 0;
  }
}

boolean allzeros(int[] arr) {
  for(int i = 0; i < arr.length; i++) {
    if (arr[i] != 0) {
      return false;
    }
  }
  return true;
}

void buttonprojectilecollision(int[] buttons) {
  for (int i = 0; i < explosionsx.size(); i++) {
    for (int i2 = 0; i2 < buttons.length; i2 = i2 + 4) {
      if (circleRect(explosionsx.get(i), explosionsy.get(i), 40, buttons[i2], buttons[i2+1], buttons[i2+2], buttons[i2+3]) == true) {
        buttons[i2] = 0;
        buttons[i2+1] = 0;
        buttons[i2+2] = 0;
        buttons[i2+3] = 0;
      }
    }
    
  }
}

void drawbuttons(int[] buttons, int r, int g, int b, int rf, int gf, int bf) {
  fill(rf, gf, bf);
  for (int i = 0; i < buttons.length; i = i+4) {
    rect(buttons[i], buttons[i+1], buttons[i+2], buttons[i+3]);
  }
  fill(r,g,b);
}

void projectile_tpsize() {
  for (int i = 0; i < rocketid.size(); i++) {
    if (circleRect(playerpos.x, playerpos.y, tpsize/2, rocketpos.get(i).x, rocketpos.get(i).y, 25, 25) && keys[4] == true) {
      //circle(playerpos.x, playerpos.y, tpsize);
      //System.out.println("inside");
      rocketvelocity.set(i, new PVector(rocketvelocity.get(i).x*0.7, rocketvelocity.get(i).y*0.7));
    }
  }
}

void playerexplosioncollision() {
  for (int i = 0; i < explosionsx.size(); i++) {
    if (circleRect(explosionsx.get(i), explosionsy.get(i), 25, playerpos.x-(playersize/2), playerpos.y-(playersize/2), playersize, playersize) == true && explosionscurrimg.get(i) <= 10) {
      leftright = random(0,2);
      hitexplosion = i;
      dead = true;
      deadtime = millis();
    }
  }
}

void playerdeathanimation() {
  int spritesheetx = 0;
  if (currdeathimg <= 3) {
    spritesheetx = currdeathimg*512;
  } else if (currdeathimg > 3 && currdeathimg < 7) {
    spritesheetx = (currdeathimg-3)*512;
  } else if (currdeathimg > 7 && currdeathimg < 11) {
    spritesheetx = (currdeathimg-7)*512;
  } else if (currdeathimg > 11 && currdeathimg < 15) {
    spritesheetx = (currdeathimg-11)*512;
  } //what row of the spritesheet to use for the next sprite
  
  int spritesheety = (int) (currdeathimg/4)*512;
  if (currdeathimg < 16) {
    currdeathimg++;
  } else if (currdeathimg >= 16) {
  } //what column of the spritesheet to use for the next sprite
  
  if (leftright < 1) {
    image(bloodright, playerpos.x-(90*0.35), playerpos.y-(90*0.5), 90, 90, spritesheetx, spritesheety, spritesheetx+512, spritesheety+512);
  } else if (leftright >= 1) {
    image(bloodleft, playerpos.x-(90*0.65), playerpos.y-(90*0.5), 90, 90, spritesheetx, spritesheety, spritesheetx+512, spritesheety+512);
  }
}

void drawprojectiles(int[] currlevelturretsarr, float[] currlevelarr) {
  
  for(int i = 0; i < currlevelturretsarr.length; i = i+5) {
    
    if (lineofsight(currlevelarr, currlevelturretsarr[i]+11, currlevelturretsarr[i+1]+12)) {
      
    int rocketposx = currlevelturretsarr[i];
    int rocketposy = currlevelturretsarr[i+1];
    int orientation = currlevelturretsarr[i+2];
    int launchercolor = currlevelturretsarr[i+3];
    int elapsed = millis() - currlevelturretsarr[i+4];

    int intialvelocity = 0;
    int cooldown = 0;
    float turning = 0;
    float maxspeed = 0;
    
    if (launchercolor == 0) { //red
      intialvelocity = 2;
      maxspeed = 4;
      cooldown = 1000;
      turning = 0.007;
    } else if (launchercolor == 1) { //yellow
      intialvelocity = 2;
      cooldown = 3000;
      maxspeed = 3;
      turning = 0.003;
    } else if (launchercolor == 2) { //blue
      intialvelocity = 3;
      cooldown = 2000;
      turning = 0.0001;
      maxspeed = 3;
    } else if (launchercolor == 3) { //redyellow
      intialvelocity = 5;
      cooldown = 8000;
      turning = 0.01;
      maxspeed = 5;
    } else if (launchercolor == 4) { //grey
      intialvelocity = 3;
      cooldown = 4000;
      turning = 0.00007;
      maxspeed = 3;
    }
    
    PVector velocityvector = new PVector(0,0);
    
    if (orientation == 0) { //down
      velocityvector = new PVector(0, intialvelocity);
    } else if (orientation == 1) { //up
      velocityvector = new PVector(0, -intialvelocity);
    } else if (orientation == 2) { //right
      velocityvector = new PVector(intialvelocity, 0);
    } else if (orientation == 3) { //left
      velocityvector = new PVector(-intialvelocity, 0);
    }
    
    if (elapsed >= cooldown){
      rocketid.add(id);
      rocketcolor.add(launchercolor);
      rocketvelocity.add(velocityvector);
      rocketpos.add(new PVector(rocketposx, rocketposy));
      rocketturning.add(turning);
      currlevelturretsarr[i+4] = millis();
      rocketcurrimage.add(0);
      rocketmaxspeed.add(maxspeed);
      id++;
    }
    
    }
  }
  
  for(int i = 0; i < rocketid.size(); i++) { 
    if (rocketpos.get(i).x - playerpos.x > 0 && rocketvelocity.get(i).x >= - rocketmaxspeed.get(i)) {
      rocketvelocity.get(i).x = rocketvelocity.get(i).x - (rocketpos.get(i).x-playerpos.x)*rocketturning.get(i);
    } else if (rocketpos.get(i).x - playerpos.x < 0 && rocketvelocity.get(i).x <= rocketmaxspeed.get(i)) {
      rocketvelocity.get(i).x = rocketvelocity.get(i).x + (playerpos.x-rocketpos.get(i).x)*rocketturning.get(i);
    } //turn in x

    if (rocketpos.get(i).y - playerpos.y > 0 && rocketvelocity.get(i).y >= -rocketmaxspeed.get(i)) {
      rocketvelocity.get(i).y = rocketvelocity.get(i).y - (rocketpos.get(i).y-playerpos.y)*rocketturning.get(i);
    } else if (rocketpos.get(i).y - playerpos.y < 0 && rocketvelocity.get(i).y <= rocketmaxspeed.get(i)) {
      rocketvelocity.get(i).y = rocketvelocity.get(i).y + (playerpos.y-rocketpos.get(i).y)*rocketturning.get(i);
    } //turn in y
    
    rocketpos.get(i).add(rocketvelocity.get(i)); //change rocket position according to velocity
    
    int spritesheetx = 0;
    if (rocketcurrimage.get(i) <= 7) {
      spritesheetx = rocketcurrimage.get(i)*75;
    } else if (rocketcurrimage.get(i) > 7 && rocketcurrimage.get(i) < 15) {
      spritesheetx = (rocketcurrimage.get(i)-7)*75;
    } else if (rocketcurrimage.get(i) > 15 && rocketcurrimage.get(i) < 23) {
      spritesheetx = (rocketcurrimage.get(i)-15)*75;
    } else if (rocketcurrimage.get(i) > 23 && rocketcurrimage.get(i) < 31) {
      spritesheetx = (rocketcurrimage.get(i)-23)*75;
    } else if (rocketcurrimage.get(i) > 31 && rocketcurrimage.get(i) < 39) {
      spritesheetx = (rocketcurrimage.get(i)-31)*75;
    } else if (rocketcurrimage.get(i) > 39 && rocketcurrimage.get(i) < 47) {
      spritesheetx = (rocketcurrimage.get(i)-39)*75;
    } else if (rocketcurrimage.get(i) > 47 && rocketcurrimage.get(i) < 55) {
      spritesheetx = (rocketcurrimage.get(i)-47)*75;
    } else if (rocketcurrimage.get(i) > 55 && rocketcurrimage.get(i) < 63) {
      spritesheetx = (rocketcurrimage.get(i)-55)*75;
    } //what row of the spritesheet to use for the next sprite
    
    int spritesheety = (int) (rocketcurrimage.get(i)/8)*75;
    if (rocketcurrimage.get(i) < 63) {
      rocketcurrimage.set(i, rocketcurrimage.get(i) + 1);
    } else if (rocketcurrimage.get(i) >= 63) {
      rocketcurrimage.set(i, 0);
    } //what column of the spritesheet to use for the next sprite
    
    if (rocketcolor.get(i) == 0) {
      image(projectile_red, rocketpos.get(i).x, rocketpos.get(i).y, 25, 25, spritesheetx, spritesheety, spritesheetx+75, spritesheety+75);
    } else if (rocketcolor.get(i) == 1) {
      image(projectile_yellow, rocketpos.get(i).x, rocketpos.get(i).y, 25, 25, spritesheetx, spritesheety, spritesheetx+75, spritesheety+75);
    } else if (rocketcolor.get(i) == 2) {
      image(projectile_blue, rocketpos.get(i).x, rocketpos.get(i).y, 25, 25, spritesheetx, spritesheety, spritesheetx+75, spritesheety+75);
    } else if (rocketcolor.get(i) == 3) {
      image(projectile_redyellow, rocketpos.get(i).x, rocketpos.get(i).y, 25, 25, spritesheetx, spritesheety, spritesheetx+75, spritesheety+75);
    } else if (rocketcolor.get(i) == 4) {
      //fill(255,255,255);
      //ellipse(rocketpos.get(i).x+12, rocketpos.get(i).y+12, 20, 20);  
      image(projectile_grey, rocketpos.get(i).x, rocketpos.get(i).y, 25, 25, spritesheetx, spritesheety, spritesheetx+75, spritesheety+75);
    } //drawing the projectile
    
    //removing rockets when out of bounds
    if (rocketpos.get(i).x+25 > width || rocketpos.get(i).y+25 > height || rocketpos.get(i).x < 0 || rocketpos.get(i).y < 0) {
      removeprojectile(i);
    }
  }
  
  projectilecollision(currlevelarr);
}

void projectilecollision(float[] currlevelarr) {
  for (int i = rocketid.size()-1; i >= 0; i--) {
    if (circleRect(rocketpos.get(i).x+12.5, rocketpos.get(i).y+12.5, 7, playerpos.x-(playersize/2), playerpos.y-(playersize/2), playersize, playersize) == true) {
      removeprojectile(i);
    }
  }
  
  for (int i = rocketid.size()-1; i >= 0; i--) {
    float[] rectx = new float[currlevelarr.length/4]; 
    float[] recty = new float[rectx.length]; 
    float[] rectw = new float[rectx.length]; 
    float[] recth = new float[rectx.length];
    
    int i2 = 0;
    for(int i3 = 0; i3 < currlevelarr.length; i3 = i3 + 4) {
      rectx[i2] = currlevelarr[i3];
      recty[i2] = currlevelarr[i3+1];
      rectw[i2] = currlevelarr[i3+2];
      recth[i2] = currlevelarr[i3+3];
      i2++;
    } //splits map array into 4 equal arrays that contain x, y, width and height of each rect at index i
    
    //iterates over each rect in map and checks if rocket(i) is collodig with it
    for(int i1 = 0; i1 < rectx.length; i1++) { 
      if (circleRect(rocketpos.get(i).x+12.5,rocketpos.get(i).y+12.5,10, rectx[i1],recty[i1],rectw[i1],recth[i1]) == true) {
        removeprojectile(i);
        break;
      }
    }
  }
}

boolean drawexplosions() {
  for(int i = 0; i < explosionsx.size(); i++) {
   
    if (explosionscurrimg.get(i) < 40) {
      explosionscurrimg.set(i, explosionscurrimg.get(i) + 1);
    } else if (explosionscurrimg.get(i) >= 40) {
      removeexplosion(i);
      return true;
    } //what column of the spritesheet to use for the next sprite
    
    int spritesheetx = 0;
    int spritesheety = (int) (explosionscurrimg.get(i)/8)*67;
    if (explosionscurrimg.get(i) <= 7) {
      spritesheetx = explosionscurrimg.get(i)*74;
    } else if (explosionscurrimg.get(i) > 7 && explosionscurrimg.get(i) < 15) {
      spritesheetx = (explosionscurrimg.get(i)-7)*74;
    } else if (explosionscurrimg.get(i) > 15 && explosionscurrimg.get(i) < 23) {
      spritesheetx = (explosionscurrimg.get(i)-15)*74;
    } else if (explosionscurrimg.get(i) > 23 && explosionscurrimg.get(i) < 31) {
      spritesheetx = (explosionscurrimg.get(i)-23)*74;
    } else if (explosionscurrimg.get(i) > 31 && explosionscurrimg.get(i) < 39) {
      spritesheetx = (explosionscurrimg.get(i)-31)*74;
    } else if (explosionscurrimg.get(i) > 39 && explosionscurrimg.get(i) < 47) {
      spritesheetx = (explosionscurrimg.get(i)-39)*74;
    } //what row of the spritesheet to use for next spire
    
    if (explosionscolor.get(i) == 0) {
      image(explosion_red, explosionsx.get(i)-(51/2), explosionsy.get(i)-(51/2), 80, 80, spritesheetx, spritesheety, spritesheetx+74, spritesheety+70);
    } else if (explosionscolor.get(i) == 1) {
      image(explosion_yellow, explosionsx.get(i)-(51/2), explosionsy.get(i)-(51/2), 80, 80, spritesheetx, spritesheety, spritesheetx+74, spritesheety+70);
    } else if (explosionscolor.get(i) == 2) {
      image(explosion_blue, explosionsx.get(i)-(51/2), explosionsy.get(i)-(51/2), 80, 80, spritesheetx, spritesheety, spritesheetx+74, spritesheety+70);
    } else if (explosionscolor.get(i) == 3) {
      image(explosion_redyellow, explosionsx.get(i)-(51/2), explosionsy.get(i)-(51/2), 80, 80, spritesheetx, spritesheety, spritesheetx+74, spritesheety+70);
    } else if (explosionscolor.get(i) == 4) {
      image(explosion_grey, explosionsx.get(i)-(51/2), explosionsy.get(i)-(51/2), 80, 80, spritesheetx, spritesheety, spritesheetx+74, spritesheety+70);
    }
    //explosionscurrimg.set(i, explosionscurrimg.get(i)+1);
  }
  
  return true;
}

void removeexplosion(int i) {
  explosionsx.remove(i);
  explosionsy.remove(i);
  explosionscolor.remove(i);
  explosionscurrimg.remove(i);
}

void removeprojectile(int i) {
  explosionsx.add(rocketpos.get(i).x);
  explosionsy.add(rocketpos.get(i).y);
  explosionscolor.add(rocketcolor.get(i));
  explosionscurrimg.add(0);
  
  rocketid.remove(i);
  rocketcolor.remove(i);
  rocketmaxspeed.remove(i);
  rocketvelocity.remove(i);
  rocketpos.remove(i);
  rocketturning.remove(i);
  rocketcurrimage.remove(i);
}

void drawturrets(int[] currlevelturretsarr) {
  for (int i = 0; i < currlevelturretsarr.length; i = i+5) {
  turretxpos = currlevelturretsarr[i];
  turretypos = currlevelturretsarr[i+1];
  orient = currlevelturretsarr[i+2];
  col = currlevelturretsarr[i+3];
  
  if (orientation[orient] == 26 || orientation[orient] == 41) {
    turretw = 14;
    turreth = 12;
  } else {
    turretw = 12;
    turreth = 14;
  }
  
  image(turrets, turretxpos, turretypos, turretw*2, turreth*2, orientation[orient], turretcolor[col], orientation[orient]+turretw, turretcolor[col]+turreth);
  }
}

void levelcheck() {
  float[] finish = {currlevel[0], currlevel[1], currlevel[2], currlevel[3]};
  
  if (grounded(finish) == true && currlevelint == 1) {
    float[] level2 = {width/2.2, height-1, (width-((width/2.2)*2)), 1, width/2.2, height-5, (width-((width/2.2)*2)), 5, width-(width/2.2), height-5, width/2.2, 5, 0, height-5, width/2.2, 5, 0, height/2, 400, 20, 400+playersize, height/2+100, 150, 20, 550+(playersize*2), height/2+200, 150, 20};
    int[] level2turrets = {50, height/2+19, 0, 4, 0, 320, height/2+19, 0, 4, 0};
    int[] level2buttons = {width/4-80,height-15,10,10, width/4-60,height-15,10,10, width/4-40,height-15,10,10, width/4-20,height-15,10,10};

    arrayCopy(level2, staticlevel);
    currlevel = level2;
    arrayCopy(level2buttons, staticbuttons);
    currlevelbuttons = level2buttons;
    currlevelturrets = level2turrets;
    currlevelint = 2;
    
    playerpos = new PVector(width/2,0);
    resetrockets();
    resetexplosions();
  } else if (grounded(finish) == true && currlevelint == 2) {
    float[] level3 = {width/2.2, height-1, (width-((width/2.2)*2)), 1, width/2.2, height-5, (width-((width/2.2)*2)), 5, width-(width/2.2), height-5, width/2.2, 5, 0, height-5, width/2.2, 5, 0, height-200, 400, 20, width/2-50, height-300, 300, 20, width-200, height-400, 200, 20};
    int[] level3turrets = {(int) (0.2*width), 0, 0, 4, 0, (int) (0.8*width), 0, 0, 4, 0};
    int[] level3buttons = {90,height-210,10,10, 110,height-210,10,10, width-120,height-410,10,10, width-100,height-410,10,10};
    
    arrayCopy(level3, staticlevel);
    currlevel = level3;
    arrayCopy(level3buttons, staticbuttons);
    currlevelbuttons = level3buttons;
    currlevelturrets = level3turrets;
    currlevelint = 3;
    
    playerpos = new PVector(width/2,0);
    resetrockets();
    resetexplosions();
  }
}

void drawlevel(float[] level, int r, int g, int b, int rf, int gf, int bf) {
  fill(r,g,b);
  
  //drawing all platforms
  int a = 0;
  for (int i = 8; i < level.length; i = i+4) {
    a++;
    image(platforms, level[i], level[i+1], level[i+2], level[i+3], platdx[a], platdy[a], platw[a], plath[a]);
  }
  
  //drawing platform blocking the finish
  fill(rf, gf, bf);
  rect(level[4], level[5], level[6], level[7]);
  fill(r,g,b);
  
  //drawing level specific text
  if (currlevelint == 1) {
    fill(0, 102, 153);
    rect(width/2-7, height-230, 14, 160);
    triangle(width/2-20, height-70, width/2+20, height-70, width/2, height-30);
    fill(r,g,b);
  } else if (currlevelint == 2) {
    fill(0, 102, 153);
    textSize(32);
    text("It seems the exit is blocked.", width/3+50, height/3-40);
    text("Press SPACE to teleport to the mouse.", width/3-20, height/3);
    text("Use the rockets to activate the yellow buttons.", width/3-90, height/3+40);
    text("And try not to blow up.", width/3+90, height/3+80);
    fill(r,g,b);
  }
}

void resetrockets() {
  rocketid = new ArrayList<Integer>();
  rocketcolor = new ArrayList<Integer>();
  rocketvelocity = new ArrayList<PVector>();
  rocketpos = new ArrayList<PVector>();
  rocketturning = new ArrayList<Float>();
  rocketmaxspeed = new ArrayList<Float>();
  rocketcurrimage = new ArrayList<Integer>();
  id = 0;
}

void resetexplosions() {
  explosionsx = new ArrayList<Float>();
  explosionsy = new ArrayList<Float>();
  explosionscolor = new ArrayList<Integer>();
  explosionscurrimg = new ArrayList<Integer>();
}
