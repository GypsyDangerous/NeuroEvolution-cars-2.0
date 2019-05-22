class population
{
  ArrayList<car> 
    agents;

  ArrayList<car>
    dead;

  float 
    size, 
    gen;


  population(float s)
  {
    size = s;
    agents = new ArrayList<car>();
    dead = new ArrayList<car>();
    for (int i = 0; i < size; i++)
    {
      agents.add(new car(start.x, start.y, 12.5, 25));
    }
  }

  void show()
  {
    for (car c : agents)
    {
      c.show();
    }
  }

  void fov()
  {
    if (agents.size() > 0)
      best(agents).fov();
  }

  void update()
  {
    for (car c : agents)
    {
      c.update(); 
      c.think();
    }
    if (agents.size() <= 0)
    {
      nextgeneration();
    }
    for (int i = agents.size()-1; i >= 0; i--)
    {
      car c = agents.get(i);
      if (c.hitwall())
      {
        dead.add(c);
        agents.remove(i);
      }
    }
  }

  void nextgeneration()
  {
    gen++;
    calcfitness();
    for (int i = 0; i < size; i++)
    {
      agents.add(pickone());
    }
    //agents.add(best(dead));
    dead.clear();
  }

  void showinfo()
  {
    textAlign(CENTER, CENTER);
    textSize(32);
    fill(255);
    stroke(255);
    text("generation: " + gen, 150, 50);
    if (agents.size() > 0)
    {
      text("best lap: " + best(agents).lapcount, 150, 100);
      text("best vel: " + best(agents).vel.mag(), 150, 150);
    }
  }

  car best(ArrayList<car> pop)
  {
    float record = Float.POSITIVE_INFINITY;
    car best = pop.get(0);
    for (int i = 0; i < pop.size(); i++)
    {
      car c = pop.get(i);
      if (c.fitness > record)
      {
        record = c.fitness;
        best = c;
      }
    }
    return best;
  }

  void calcfitness()
  {
    float sum = 0;
    for (car b : dead)
    {
      b.calcfitness();
    }

    for (car b : dead)
    {
      sum += b.fitness;
    }

    for (car b : dead)
    {
      b.fitness = b.fitness/sum;
    }
  }

  car pickone()
  {
    int index = 0;
    float r = random(1);
    while (r > 0) 
    {
      r -= dead.get(index).fitness;
      index++;
    }
    index--;
    car b = dead.get(index);
    car child = new car(start.x, start.y, 12.5, 25, b.brain);
    child.mutate();
    //child
    return child;
  }
}
