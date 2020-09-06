
// sure wish I understood java import syntax but this works
import com.hamoid.*;
VideoExport videoExport;

public void settings() {
  size(800, 800);
  
}

void setup() {
  background(255); // we start with a white background
  frameRate(120);
  
  // set up video export
//   videoExport = new VideoExport(this);
//   videoExport.startMovie();
  
// color mode is HSB
// TODO: we can set custom ranges for each, 0-100% for sat/bright would improve comprehensibility
  colorMode(HSB);
  
  // as part of setup, let's uhhhh... create some organisms
  createOrganisms();
}

// ========================
// ITS GLOBAL VARIABLE TIME
// don't act like you're not excited
// =========================

int number_rows = 80;

// TODO, WTF: why does calculating row height not work?
// it's 12 when it's calculated as 800/8 which should be 100?
// int row_height = height)/number_rows;

// so we're hard coding it and have to change this and number_rows each time
int row_height = 10;

// define an empty array of Organisms
Organism[] _organismArray = {};


// main draw loop!
// we loop through each frame until we break
void draw() {

  // while the loop counter is less than the number of items in the array, do this
  for ( int i = 0; i < _organismArray.length; i ++){
    // we're establishing a temporary loop variable of organisms, called thisOrganism
    // each time through, it pulls out the one at the marker in the iteration loop
    Organism thisOrganism = _organismArray[i];
    
  // -- IN WHICH I GET AHEAD OF MY ABILITY --    
  // we're going to grab its neighbors so we can pick their hues
  // NOW! If I could just figure out how to iterate through the array that'd be a way to do this
    int prev_hue, next_hue;
    prev_hue = 0;
    next_hue = 0;

  // TODO: ??? why can't I do the Organism prevOrganism... thing 
  // ??? and then access prevOrganism outside the if loop?
  // ??? do I have to establish one and then set it to the... ? to get that to work?

    // we're going to grab previous one
    // this can be out of bounds if it's the first one, so we fudge
    // TODO: wrapping around would be cool as hell

    if (i==0){
      Organism prevOrganism = _organismArray[i];
      prev_hue = prevOrganism.cur_hue;
    } else {
    Organism prevOrganism = _organismArray[i-1];
      prev_hue = prevOrganism.cur_hue;
    }
    
    
    // then we're going to pull the next one in the array    
    // this can be out of bounds if it's the last one, so
    if (i==_organismArray.length){
      Organism nextOrganism = _organismArray[0];
      next_hue = nextOrganism.cur_hue;
    }
    // I should figure out how to do an if else loop in javascript
    
    if (i<_organismArray.length-1){
      Organism nextOrganism = _organismArray[i+1];
      next_hue = nextOrganism.cur_hue;
    }

  // Organism, draw thyself!
  thisOrganism.drawRect(i);

  // hand the organism the other organism's hues to do a calculation
  thisOrganism.calculateNewhue(prev_hue, next_hue);

  // and then we call it to update
  // which is where I'm putting things I'm working out
  thisOrganism.updateMe();
  }
  // uncomment this if we're saving video
  // videoExport.saveFrame();
}

// uncomment this if we're saving video
// void keyPressed() {
//   if (key == 'q') {
//     videoExport.endMovie();
//     exit();
//   }
// }

void createOrganisms(){  

  // called once at the start, should create a number of organisms equal to rows
  // we'll need to create one organism per row

    for ( int i = 0; i < number_rows; i += 1){

      // for each loop through, temporary organism variable and drop a new organism into it
      Organism thisOrganism = new Organism();
    
      // then add it to the array of organisms
      _organismArray = (Organism[])append(_organismArray, thisOrganism);
  }
}


class Organism {

  // how would you define yourself, as a series of variables?
  int true_hue; // the hue of the organism as expressed
  int cur_hue; // what it is right now
  float cur_bright; // the amount of energy the organism has, used for luminosity
  float cur_sat; // the number of turns the organism has, used for saturation (?)
  
  color current_color;
  
  // I was going to use these for tracking whether they're on the up or downswing
  boolean is_energetic;

  
  // let's define the starting values for an organism
  Organism(){
    true_hue = int(random(0,255));     // I'll note that if I try to use noise there, it seemingly goes all blue-greens
    cur_hue = true_hue;
    cur_bright = random(0,255);
    cur_sat = 255;
    is_energetic = true;
    current_color = color(cur_hue, cur_sat, cur_bright);
  }
  

// drawRect takes the current iteration number and uses that to figure out where we are
// then we draw a rectangle of the color of the organism

void drawRect(int iteration){
    int startx, starty;
    int targetx, targety;
    startx = 0;
    starty = 0 + (iteration * row_height);
    targetx = width;
    targety = (starty + row_height);
    noStroke();
    fill(current_color);
    rect(startx, starty, targetx, targety);

}

// calculateNewhue changes the organism's current color using the two neighbor hues passed in
void calculateNewhue(int prev_hue, int next_hue){
  // average those three numbers

  // I'm going to set these as variables b/c redoing the calc to experiment's a pain
  // the higher the neighbor variable it is, the more it'll contribute to the next hue
  // and similarly, the opposite
  // 
  int neighbor_multiplier = 1;
  int self_authenticity_multiplier = 1;
  int future_hue = 0;
  
  future_hue = (((prev_hue + next_hue)* neighbor_multiplier) + (true_hue*self_authenticity_multiplier))/((neighbor_multiplier*2)+self_authenticity_multiplier);
  cur_hue = future_hue;
  current_color = color(cur_hue, cur_sat, cur_bright);
  
  // println("curr", cur_hue, "prev", prev_hue, "next", next_hue, "future hue", future_hue);
  
    // here's a thing you could do
    // okay, let's get fancy and increase saturation and brightness if those colors are within x of each other
    
    //int threshold = 40;
    //float how_crazy = 0.1;
    //if ( (abs(prev_hue-cur_hue))<threshold){
    //  cur_bright = cur_bright + how_crazy;
    //  cur_sat = cur_sat + how_crazy;
    //}
}


// and here's where we can screw around with incrementing things
void updateMe(){
  
  // this is the loop where I'm doing the brightness thing
  // if it's too energetic, set it on the path back
  if (cur_bright > 254){
    is_energetic = false;
  }
  
  // but if it's too tired, set it to energetic
  if (cur_bright < 1){
    is_energetic = true;
  }
  
  if (is_energetic == true) {
    cur_bright += 1;
  } else {
    cur_bright = cur_bright -1;
  }
   
  // if we don't set the orgcolor to the new values it'll stick with the old
  current_color = color(cur_hue, cur_sat, cur_bright);

}

}  