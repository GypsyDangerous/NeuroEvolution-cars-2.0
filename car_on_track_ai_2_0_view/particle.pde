class particle
{
  PVector 
    pos, 
    vel;

  ArrayList<ray> 
    rays;

  float 
    rotation, 
    speed, 
    fov, 
    r, 
    rayscale, 
    raycount, 
    range;

  boolean 
    highlight;

  particle(float x, float y, float view, float rc)
  {
    pos = new PVector(x, y);
    vel = new PVector();
    rays = new ArrayList<ray>();
    raycount = rc;
    range = 300;
    fov = radians(view);
    rayscale = fov/raycount;
    updatefov();
    r = 8;
  }

  particle(float x, float y)
  {
    this(x, y, 360, 8);
  }

  void updatefov(float fov)
  {
  }

  void updatefov()
  {
    for (float i = -fov/2; i < fov/2; i+=rayscale)
    {
      rays.add(new ray(pos, i));
    }
  }

  void Rotate(float theta)
  {
    rotation += theta;
  }

  void setR(float theta)
  {
    rotation = theta;
  }

  void move(float s)
  {
    speed = s;
  }

  void update()
  {
    int index = 0;
    for (float i = -(fov/2); i < (fov/2); i += rayscale)
    {
      rays.get(index).setangle(i+rotation);
      index++;
    }
    vel = PVector.fromAngle(rotation);
    vel.setMag(speed);
    pos.add(vel);
  }

  void look(Line bound)
  {
    for (ray r : rays)
    {
      PVector pt = r.cast(bound);
      if (pt.x != pos.x && pt.x != pos.x)
      {
        stroke(255, 25);
        strokeWeight(10);
        line(pos.x, pos.y, pt.x, pt.y);
        //strokeWeight(16); 
        //stroke(255);
        //circle(pt.x, pt.y, 16);
      }
    }
  }

  void look(ArrayList<Line> bounds)
  {

    for (ray r : rays)
    {
      PVector closest = PVector.add(pos, PVector.mult(r.dir, range));
      float record = range;
      for (Line b : bounds)
      {
        PVector pt = r.cast(b);
        if (pt != null)
        {
          float d = pt.dist(pos);
          if (d < record)
          {
            record = d;
            closest = pt;
          }
        }
      }
      if (closest != null)
      {
        stroke(255, 25);
        strokeWeight(10);

        line(pos.x, pos.y, closest.x, closest.y);
        //strokeWeight(10);
        //stroke(255);
        //point(closest.x, closest.y);
        strokeWeight(1);
      }
    }
  }

  ArrayList<Line> AlookB(ArrayList<Line> bounds)
  {
    ArrayList<Line> bound = new ArrayList<Line>();
    for (ray r : rays)
    {
      PVector closest = PVector.add(pos, PVector.mult(r.dir, range));
      float record = range;
      Line close = null;
      for (Line b : bounds)
      {
        PVector pt = r.cast(b);
        if (pt != null)
        {
          float d = pt.dist(pos);
          if (d < record)
          {
            record = d;
            closest = pt;
            close = b;
          }
        }
      }
      if (closest != null)
      {
        //line(pos.x, pos.y, closest.x, closest.y);
        if (!bound.contains(close) && close != null)
          bound.add(close);
      }
    }
    return bound;
  }

  ArrayList<PVector> AlookP(ArrayList<Line> bounds)
  {
    ArrayList<PVector> bound = new ArrayList<PVector>();
    for (ray r : rays)
    {
      PVector closest = PVector.add(pos, PVector.mult(r.dir, range));
      float record = range;
      for (Line b : bounds)
      {
        PVector pt = r.cast(b);
        if (pt != null)
        {
          float d = pt.dist(pos);
          if (d < record)
          {
            record = d;
            closest = pt;
          }
        }
      }
      if (closest != null)
      {
        //line(pos.x, pos.y, closest.x, closest.y);
        bound.add(closest);
      }
    }
    return bound;
  }

  boolean intersectsLine(Line bound)
  {
    return Lintersects(bound.start, bound.end, this);
  }

  boolean intersectsLine(ArrayList<Line> bounds)
  {
    for (Line bound : bounds)
    {
      if (intersectsLine(bound))
        return true;
    }
    return false;
  }

  void update(float x, float y)
  {
    pos.set(x, y);
  }

  void show()
  {

    //for (ray r : rays)
    //{
    //  r.show();
    //}
    if (highlight)
      fill(255, 0, 0);
    else
      fill(255);
    strokeWeight(1);
    circle(pos.x, pos.y, r*2);
  }
}

boolean Lintersects(PVector a, PVector b, particle c)
{
  PVector proj = getNormalPoint(c.pos, a, b);
  PVector line = PVector.sub(a, b);
  float liner = line.mag()+c.r;

  return c.pos.dist(proj) < c.r && (a.dist(proj) < liner && b.dist(proj) < liner);
}
