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

void setup() { 
 player = loadImage("player.png"); //spritesheet for player anims
 currplayerimage = 0;
 playeranimstate = 0;
 platforms = loadImage("platforms.png"); //spritesheet for wooden platforms
 
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
 
 float[] level1 = {width/2.2, height-2, (width-((width/2.2)*2)), 2, 0, 0, 0, 0, width-(width/2.2), height-5, width/2.2, 5, 0, height-5, width/2.2, 5, 220, height-300, width/2, 20, width-200, height/3, 200, 20, 50, height/5, 100, 20};
 //first rect is the finish
 //second rect is the finish blocker
 //second and third rects are the floor
 //last 6 are rects buttons (4) and rocketlaunchers (2)
 currlevel = level1;
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
  //rect(playerpos.x-(playersize/2), playerpos.y-(playersize/2), playersize, playersize);

  collisioncheck(currlevel);
  keycheck(currlevel);
  levelcheck();
  playeranimation(currlevel);

  image(player, playerpos.x-(playersize/2), playerpos.y-(playersize/2), (float) playersize, (float) playersize, (int) currplayerimage*16, (int) playeranims[playeranimstate], currplayerimage*16+16, playeranims[playeranimstate]+16);
  playerpos.add(velocity);
  velocity.add(gravity);
  
  drawlevel(currlevel,0,70,100,200,200,0);
  
  //rough win condition demo
  if (currlevelint == 2 && playerpos.x < width/3 && playerpos.y < height/3) {
    currlevel[4] = 0;
    currlevel[5] = 0;
    currlevel[6] = 0;
    currlevel[7] = 0;
  }
}

void levelcheck() {
  float[] finish = {currlevel[0], currlevel[1], currlevel[2], currlevel[3]};
  if (grounded(finish) == true && currlevelint == 1) {
    float[] level2 = {width/2.2, height-2, (width-((width/2.2)*2)), 2, width/2.2, height-5, (width-((width/2.2)*2)), 5, width-(width/2.2), height-5, width/2.2, 5, 0, height-5, width/2.2, 5, 0, height/2, 400, 20, 400+playersize, height/2+100, 150, 20, 550+(playersize*2), height/2+200, 150, 20};
    currlevel = level2;
    currlevelint = 2;
    playerpos = new PVector(width/2,0);
  } else if (grounded(finish) == true && currlevelint == 2) {
    float[] level3 = {width/2.2, height-2, (width-((width/2.2)*2)), 2, width/2.2, height-5, (width-((width/2.2)*2)), 5, width-(width/2.2), height-5, width/2.2, 5, 0, height-5, width/2.2, 5, 0, height-200, 401, 20, width/2+50, height-340, 200, 20, width-200, height-400, 200, 20};
    currlevel = level3;
    currlevelint = 3;
    playerpos = new PVector(width/2,0);
  }
}

void drawlevel(float[] level, int r, int g, int b, int rf, int gf, int bf) {
  fill(r,g,b);
  
  int a = 0;
  for (int i = 8; i < level.length; i = i+4) {
    a++;
    image(platforms, level[i], level[i+1], level[i+2], level[i+3], platdx[a], platdy[a], platw[a], plath[a]);
  }
  
  fill(rf, gf, bf);
  rect(level[4], level[5], level[6], level[7]);
  fill(r,g,b);
  
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
