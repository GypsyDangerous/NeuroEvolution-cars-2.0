class car extends rectangle
{
  PVector 
    vel, 
    acc;

  float 
    dir, 
    lapcount, 
    fitness, 
    counter, 
    LIFESPAN;

  int 
    inputcount, 
    outputcount, 
    goalindex = 1, 
    carindex;

  float[] 
    inputs;

  particle 
    sight, 
    view;

  NeuralNetwork 
    brain;

  car(float x, float y, float w, float h, NeuralNetwork copy)
  {
    super(x, y, w, h);
    vel = PVector.fromAngle(HALF_PI);
    vel.mult(.1);
    acc = new PVector();
    sight = new particle(pos.x, pos.y);
    inputcount = 8;
    outputcount = 3;
    LIFESPAN = 150;
    view = new particle(front().x, front().y, 90, 600);
    view.range = width/2;
    inputs = new float[inputcount];
    carindex = int(random(cars.size()));
    if (copy != null)
    {
      brain = copy.copy();
    } else brain = new NeuralNetwork(inputcount, 64, outputcount);
  }

  car(float x, float y, float w, float h)
  {
    this(x, y, w, h, null);
  }

  void update()
  {
    pos.add(vel);
    vel.add(acc);
    vel.limit(10);//5);
    acc.mult(0);

    counter++;

    //if (this == p.best(p.agents))
    //  sight.look(bounds);

    sight.update();
    sight.pos.set(pos);
    sight.setR(vel.heading());

    view.update();
    view.pos.set(front());
    view.setR(vel.heading());

    turn();
    setR(vel.heading()+HALF_PI);

    checkgoal();

    super.update();
  }

  void applyforce(PVector f)
  {
    acc.add(f);
  }

  void mutate()
  {
    brain.mutate(.1);
  }

  void calcfitness()
  {
    fitness = pow(2, fitness);
  }

  PVector front()
  {
    return sides.get(0).midpoint();
  }

  boolean hitwall()
  {
    for (Line l : bounds)
    {
      for (Line s : sides)
      {
        if (l.intersectsLine(s))
        {
          return true;
        }
      }
    }
    return counter > LIFESPAN;
  }

  void fov()
  {
    ArrayList<PVector> vision = view.AlookP(bounds);
    float[] scene = new float[vision.size()];
    float w = width/scene.length*1.069;
    for (int i = 0; i < scene.length; i++)
    {
      ray r = view.rays.get(i);
      float theta = vel.heading()-r.dir.heading();
      scene[i] = front().dist(vision.get(i))*cos(theta);
    }
    pushMatrix();
    //translate(150, 25);
    //scale(2);
    for (int i = 0; i < scene.length; i++)
    {
      float h = map(scene[i], 0, view.range, height, 0);
      float c = map(scene[i], 0, view.range, 255, 0);
      fill(c);
      noStroke();
      rectMode(CENTER);
      rect(i*w+w/2, height/2, w+1, h);
    }
    popMatrix();
  }

  void think()
  {
    ArrayList<PVector> vision = sight.AlookP(bounds);

    for (int i = 0; i < 8; i++)
    {
      inputs[i] = map(pos.dist(vision.get(i)), 0, sight.range, 1, 0);
    }

    float[] guess = brain.feedforward(inputs);


    float steer = map(guess[0], 0, 1, -radians(15), radians(15));
    float gas = map(guess[1], 0, 1, 0, .5);
    float brakeforce = map(guess[2], 0, 1, .5, 1);

    steer(steer);
    accelerate(gas);
    brake(brakeforce);
  }

  void checkgoal()
  {
    for (Line s : sides)
    {
      Line l = goal.get(goalindex);
      if (l.intersectsLine(s))
      {
        if (goalindex == 0)
        {
          lapcount++;
          fitness += 50*lapcount;
        } else
          fitness += 50;
        counter = 0;
        goalindex++;
        goalindex %= goal.size();
      }
    }
  }

  void accelerate(float pow)
  {
    acc = PVector.fromAngle(vel.heading());
    acc.setMag(pow);
  }

  void brake(float pow)
  {
    if (vel.mag() > .01)
    {
      pow = constrain(abs(pow), 0, 1);
      vel.mult(pow);
    }
  }

  void turn()
  {
    vel.rotate(dir);
  }

  void steer(float theta)
  {
    dir = theta;
  }

  void show()
  {
    Line l = goal.get(goalindex);
    stroke(white);
    strokeWeight(1);
    if (goalindex == 0)
    {
      stroke(green);
      strokeWeight(5);
    }
    if (this == p.best(p.agents))
      l.show();
    if (this == p.best(p.agents) && minimap)
    {
      view.look(bounds);
    }
    pushMatrix();
    translate(pos.x, pos.y);
    if (this == p.best(p.agents))
    {
      scale(2);
    }
    rotate(vel.heading());
    imageMode(CENTER);
    image(cars.get(constrain(carindex, 0, cars.size())), 0, 0, h, w);
    popMatrix();
    //super.show();
  }
}
