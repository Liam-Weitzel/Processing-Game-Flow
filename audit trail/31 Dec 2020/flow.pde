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

void drawturrets(int[] currlevelturretsarr) {
  for (int i = 0; i < currlevelturretsarr.length; i = i+4) {
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
    int[] level2turrets = {50, height/2+19, 0, 4, 320, height/2+19, 0, 4};
    
    currlevel = level2;
    currlevelturrets = level2turrets;
    currlevelint = 2;
    
    playerpos = new PVector(width/2,0);
  } else if (grounded(finish) == true && currlevelint == 2) {
    float[] level3 = {width/2.2, height-1, (width-((width/2.2)*2)), 1, width/2.2, height-5, (width-((width/2.2)*2)), 5, width-(width/2.2), height-5, width/2.2, 5, 0, height-5, width/2.2, 5, 0, height-200, 400, 20, width/2-50, height-300, 300, 20, width-200, height-400, 200, 20};
    int[] level3turrets = {(int) (0.2*width), 0, 0, 4, (int) (0.8*width), 0, 0, 4};
    
    currlevel = level3;
    currlevelturrets = level3turrets;
    currlevelint = 3;
    
    playerpos = new PVector(width/2,0);
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
