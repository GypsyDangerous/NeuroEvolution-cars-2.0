ArrayList<PVector> 
  trackpoints, 
  innertrackpoints, 
  goalpoints;

ArrayList<Line> 
  track, 
  innertrack, 
  goal, 
  bounds;

ArrayList<ArrayList<PVector>> midpoints;

OpenSimplexNoise 
  Noise;

PVector 
  start;

float 
  r, 
  s;

boolean 
  isLeft, 
  isRight, 
  isUp, 
  isDown, 
  minimap;

float 
  noiseMax, 
  offMax, 
  Width;

population 
  p;

ArrayList<PImage>  
  cars;

slider 
  speed;

textbox 
  info;

final color red = color(205, 0, 0);
final color darkgreen = #0B6623;
final color green = color(0, 255, 0);
final color white = color(255);
final color blue = color(0, 0, 255);
final color grey = color(51);

void setup()
{
  fullScreen();
  Width = 900;
  s = random(10000);
  Noise = new OpenSimplexNoise((long)s);

  noiseMax = 3;
  offMax = 150;

  info = new textbox(0, 0, 150, 100);

  cars = new ArrayList<PImage>();
  cars.add(loadImage("image.png"));
  for (int i = 1; i < 5; i++)
  {
    String name = "image ("+i+").png";
    cars.add(loadImage(name));
  }

  generatetrack();

  p = new population(100);

  speed = new slider(1, 5, 5, width/2, height-40, .1);
}


void draw()
{
  background(darkgreen);
  stroke(white);
  noFill();
  bounds = new ArrayList<Line>();
  bounds.addAll(track);
  bounds.addAll(innertrack);

  rectMode(CORNER);
  fill(blue);
  stroke(blue);
  rect(-1, -1, width+1, height/2);
  fill(51);
  stroke(51);
  rect(-1, height/2, width+1, height/2);

  speed.show();
  if (minimap)
  {
    p.fov();
    translate(-150, -25);
    scale(.5);
  } else
  {
    fill(darkgreen);
    stroke(darkgreen);
    rect(0, 0, width, height);
    p.showinfo();
  }

  speed.run();

  showtrack();


  p.show();

  for (int i = 0; i < speed.value(); i++)
    p.update();
}

void keyPressed()
{
  if (key == 't')
  {
    generatetrack();
    println(noiseMax);
  }
}

void showtrack()
{
  fill(grey);
  strokeWeight(5);

  float colorsep = 8;

  beginShape();
  for (PVector p : trackpoints)
  {
    curveVertex(p.x, p.y);
  }
  endShape(CLOSE);

  for (int i = 0; i < track.size(); i++)
  {
    Line p = track.get(i);
    if (floor(i / colorsep) % 2 == 0)
    {
      stroke(red);
    } else
      stroke(white);
    p.show();
  }

  fill(darkgreen);

  beginShape();
  for (PVector p : innertrackpoints)
  {
    curveVertex(p.x, p.y);
  }
  endShape(CLOSE);

  beginShape();
  for (int i = 0; i < innertrack.size(); i++)
  {
    Line p = innertrack.get(i);
    if (floor(i / colorsep) % 2 == 0)
    {
      stroke(red);
    } else
      stroke(white);
    p.show();
  }
  endShape(CLOSE);

  stroke(red);
  strokeWeight(5);
  goal.get(0).show();

  strokeWeight(3);
  stroke(white);
  noFill();
  for (ArrayList<PVector> a : midpoints)
  {
    beginShape();
    for (PVector p : a)
    {
      vertex(p.x, p.y);
    }
    endShape();
  }
}

void mouseClicked()
{
  minimap = !minimap;
}

void generatetrack()
{
  //initialize all the arraylists and the OpenSimplexNoise generator
  trackpoints = new ArrayList<PVector>();
  innertrackpoints = new ArrayList<PVector>();

  track = new ArrayList<Line>();
  innertrack = new ArrayList<Line>();

  goal = new ArrayList<Line>();
  midpoints = new ArrayList<ArrayList<PVector>>();
  s = random(10000);
  Noise = new OpenSimplexNoise((long)s);

  //generate the outer points of the track with polar coordinates and OpenSimplexNoise
  for (int i = 0; i < 360; i++)
  {
    float theta = map(i, 0, 360, 0, TWO_PI);
    float xoff = map(cos(theta), -1, 1, 0, noiseMax);
    float yoff = map(sin(theta), -1, 1, 0, noiseMax);
    float offset = map((float)Noise.eval(xoff, yoff, 5), -1, 1, -offMax, offMax);
    float r = Width/2.3 + offset;
    float x = (r*1.5)*cos(theta)+width/2;
    float y = r*sin(theta)+height/2;
    trackpoints.add(new PVector(x, y));
  }

  //generate the inner points of the track with polar coordinates and OpenSimplexNoise
  for (int i = 0; i < 360; i++)
  {
    float theta = map(i, 0, 360, 0, TWO_PI);
    float xoff = map(cos(theta), -1, 1, 0, noiseMax);
    float yoff = map(sin(theta), -1, 1, 0, noiseMax);
    float offset = map((float)Noise.eval(xoff, yoff, 5), -1, 1, -offMax, offMax);
    float r = Width/3.5 + offset;
    float x = (r*1.5)*cos(theta)+width/2;
    float y = r*sin(theta)+height/2;
    innertrackpoints.add(new PVector(x, y));
  }

  //generate a checkpoint every 32 degrees around the track
  for (int i = 0; i < trackpoints.size(); i++)
  {
    if (i % (36/2) == 0)
    {
      PVector a = trackpoints.get(i);
      PVector b = innertrackpoints.get(i);
      goal.add(new Line(a, b));
    }
  }

  //generate the points for the white midlines. just for the looks
  int index = 0;
  for (int i = 0; i < trackpoints.size(); i++)
  {
    if (i % (20) == 0)
    {
      midpoints.add(new ArrayList<PVector>());
      for (int j = 0; j < 10; j++)
      {
        ArrayList<PVector> points = midpoints.get(index);
        PVector a = trackpoints.get(i+j);
        PVector b = innertrackpoints.get(i+j);
        Line temp = new Line(a, b);
        points.add(temp.midpoint());
      }
      index++;
    }
  }

  //generate the lines that make up the outer track from the previously generated outer track points
  for (int i = 0; i < trackpoints.size(); i++)
  {
    int future = (i+1)%trackpoints.size();
    PVector a = trackpoints.get(i);
    PVector b = trackpoints.get(future);
    track.add(new Line(a, b));
  }

  //generate the lines that make up the outer track from the previously generated inner track points
  for (int i = 0; i < innertrackpoints.size(); i++)
  {
    int future = (i+1)%innertrackpoints.size();
    PVector a = innertrackpoints.get(i);
    PVector b = innertrackpoints.get(future);
    innertrack.add(new Line(a, b));
  }

  //the starting point is the midpoint of the first checkpoint
  start = goal.get(0).midpoint().copy();
}
