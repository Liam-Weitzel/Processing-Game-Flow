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
ArrayList<Integer> rocketblastradius = new ArrayList<Integer>();
ArrayList<Integer> rocketcurrimage = new ArrayList<Integer>();
ArrayList<Float> rocketmaxspeed = new ArrayList<Float>();
int id = 0;

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
 
 int[] level1turrets = {};
 //first param: turret xpos
 //second param: turret ypos
 //third param: down, up, right, left
 //fourth param: red, yellow, blue, redyellow, grey
 //fifth param: leave 0
 
 currlevel = level1;
 currlevelturrets = level1turrets;
 currlevelint = 1;
}

void draw() {
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
  
  //rough win condition demo
  if (currlevelint == 2 && playerpos.x < width/3 && playerpos.y < height/3) {
    currlevel[4] = 0;
    currlevel[5] = 0;
    currlevel[6] = 0;
    currlevel[7] = 0;
  }
}

void drawprojectiles(int[] currlevelturretsarr, float[] currlevelarr) {
  
  for(int i = 0; i < currlevelturretsarr.length; i = i+5) {
    
    int rocketposx = currlevelturretsarr[i];
    int rocketposy = currlevelturretsarr[i+1];
    int orientation = currlevelturretsarr[i+2];
    int launchercolor = currlevelturretsarr[i+3];
    int elapsed = millis() - currlevelturretsarr[i+4];

    int intialvelocity = 0;
    int cooldown = 0;
    float turning = 0;
    int blastradius = 0;
    float maxspeed = 0;
    
    if (launchercolor == 0) { //red
      intialvelocity = 2;
      maxspeed = 4;
      cooldown = 1000;
      turning = 0.007;
      blastradius = 30;
    } else if (launchercolor == 1) { //yellow
      intialvelocity = 2;
      cooldown = 3000;
      maxspeed = 3;
      turning = 0.003;
      blastradius = 30;    
    } else if (launchercolor == 2) { //blue
      intialvelocity = 2;
      cooldown = 2000;
      turning = 0.0001;
      maxspeed = 2;
      blastradius = 30;    
    } else if (launchercolor == 3) { //redyellow
      intialvelocity = 2;
      cooldown = 4000;
      turning = 0.01;
      maxspeed = 3;
      blastradius = 30;
    } else if (launchercolor == 4) { //grey
      intialvelocity = 2;
      cooldown = 5000;
      turning = 0.001;
      maxspeed = 2;
      blastradius = 30;
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
      rocketblastradius.add(blastradius);
      currlevelturretsarr[i+4] = millis();
      rocketcurrimage.add(0);
      rocketmaxspeed.add(maxspeed);
      id++;
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
    if (rocketpos.get(i).x+12 > width || rocketpos.get(i).y+12 > height || rocketpos.get(i).x+12 < 0 || rocketpos.get(i).y+12 < 0) {
      rocketid.remove(i);
      rocketcolor.remove(i);
      rocketmaxspeed.remove(i);
      rocketvelocity.remove(i);
      rocketpos.remove(i);
      rocketturning.remove(i);
      rocketblastradius.remove(i);
      rocketcurrimage.remove(i);
    }
   
    //check if rockets colliding with anything if true, remove them from rocketslist
    //implement blast radius
    //playerdeath
    //startscreen
    //slow velocity when inside the teleporting radius
    //yellow buttons
    //destroy when in blastradius
    //win conditions on yellow buttons
  }
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
    
    currlevel = level2;
    currlevelturrets = level2turrets;
    currlevelint = 2;
    
    playerpos = new PVector(width/2,0);
    resetrockets();
  } else if (grounded(finish) == true && currlevelint == 2) {
    float[] level3 = {width/2.2, height-1, (width-((width/2.2)*2)), 1, width/2.2, height-5, (width-((width/2.2)*2)), 5, width-(width/2.2), height-5, width/2.2, 5, 0, height-5, width/2.2, 5, 0, height-200, 400, 20, width/2-50, height-300, 300, 20, width-200, height-400, 200, 20};
    int[] level3turrets = {(int) (0.2*width), 0, 0, 3, 0, (int) (0.8*width), 0, 0, 2, 0};
    currlevel = level3;
    currlevelturrets = level3turrets;
    currlevelint = 3;
    
    playerpos = new PVector(width/2,0);
    resetrockets();
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
  if (currlevelint == 2) {
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
  rocketblastradius = new ArrayList<Integer>();
  rocketcurrimage = new ArrayList<Integer>();
  id = 0;
}
