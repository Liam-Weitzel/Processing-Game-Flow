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
 float[] level1 = {width/2.2, height-5, (width-((width/2.2)*2)), 5, width-(width/2.2), height-5, width/2.2, 5, 0, height-5, width/2.2, 5, 220, height-300, width/2, 20, width-200, height/3, 200, 20, 50, height/5, 100, 20};
 float[] level2 = {width/2.2, height-5, (width-((width/2.2)*2)), 5, width-(width/2.2), height-5, width/2.2, 5, 0, height-5, width/2.2, 5, 0, height/2, 400, 20, 400+playersize, height/2+100, 150, 20, 550+(playersize*2), height/2+200, 150, 20};
 float[] level3 = {width/2.2, height-5, (width-((width/2.2)*2)), 5, width-(width/2.2), height-5, width/2.2, 5, 0, height-5, width/2.2, 5, 0, height-200, 401, 20, width/2+50, height-340, 200, 20, width-200, height-400, 200, 20};
 currlevel = level1;
}

void draw() {
  background(255);
  drawplayer();
  playerpos.add(velocity);
  velocity.add(gravity);
  
  drawlevel(currlevel,0,70,100,200,200,0);

  collisioncheck(currlevel);
  keycheck(currlevel);
  
  
  //Rough version of level changing start
  float[] finish = {width/2.2, height-5, (width-((width/2.2)*2)), 5};
  if (grounded(finish) == true) {
    float[] level2 = {width/2.2, height-5, (width-((width/2.2)*2)), 5, width-(width/2.2), height-5, width/2.2, 5, 0, height-5, width/2.2, 5, 0, height/2, 400, 20, 400+playersize, height/2+100, 150, 20, 550+(playersize*2), height/2+200, 150, 20};
    currlevel = level2;
  }
  
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

void drawplayer() {
  noStroke();
  fill(245);
  ellipse(playerpos.x, playerpos.y, maxtpsizecd/2, maxtpsizecd/2);
  fill(183, 204, 237);
  ellipse(playerpos.x, playerpos.y, tpsize, tpsize);
  fill(0,100,100);
  ellipse(playerpos.x, playerpos.y, playersize, playersize);
  //rect(playerpos.x-(playersize/2), playerpos.y-(playersize/2), playersize, playersize);
}
