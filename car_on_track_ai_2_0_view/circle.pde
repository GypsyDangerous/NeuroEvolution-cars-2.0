class ball
{
  PVector 
    pos, 
    vel, 
    acc;
    
  ArrayList<PVector> 
    path;
    
  float 
    r;
    
  boolean 
    highlight = false;
    
  ball(float x, float y, float r)
  {
    pos = new PVector(x, y);
    vel = PVector.random2D();
    vel.mult(4);
    acc = new PVector();
    this.r = r;
    path = new ArrayList<PVector>();
  }

  ball(float x, float y)
  {
    this(x, y, 16);
  }

  void update()
  {
    path.add(pos.copy());
    pos.add(vel);
    vel.add(acc);
    acc.mult(0);
  }

  void applyForce(PVector f)
  {
    acc.add(f);
  }

  void bounce(rectangle r)
  {
    PVector point = r.pointofcollision(this);
    if (point != null)
    {
      PVector normal = PVector.sub(pos, point);
      PVector incidence = PVector.mult(vel, -1);

      incidence.normalize();
      normal.normalize();
      pos.add(normal);
      float dot = incidence.dot(normal);
      float m = vel.mag();
      vel.set(2*normal.x*dot - incidence.x, 2*normal.y*dot - incidence.y);
      vel.mult(m);
    }
  }

  //void bounce(hexagon r)
  //{
  //  PVector point = r.pointofcollision(this);
  //  if (point != null)
  //  {
  //    PVector normal = PVector.sub(pos, point);
  //    PVector incidence = PVector.mult(vel, -1);

  //    incidence.normalize();
  //    normal.normalize();
  //    pos.add(normal);
  //    float dot = incidence.dot(normal);
  //    float m = vel.mag();
  //    vel.set(2*normal.x*dot - incidence.x, 2*normal.y*dot - incidence.y);
  //    vel.mult(m);
  //  }
  //}

  void show()
  {
    if (highlight)
      fill(255, 0, 0);
    else
      fill(255);
    circle(pos.x, pos.y, r*2);
    noFill();
    beginShape();
    for (PVector p : path)
    {
      vertex(p.x, p.y);
    }
    endShape();
  }

  boolean intersectsLine(Line l)
  {
    return Lintersects(l.start, l.end, this);
  }

  PVector drag()
  {
    float dir = -.5*vel.magSq()*.00001;
    PVector force = vel.copy();
    force.setMag(dir);
    return force;
  }

  void edges()
  {
    if (pos.x +r > width)
    {
      pos.x = width-r;
      vel.x *= -1;
    }
    if (pos.x - r < 0)
    {
      pos.x = r;
      vel.x *= -1;
    }
    if (pos.y + r >= height)
    {
      pos.y = height-r;
      vel.y *= -1;
    }
    if (pos.y - r < 0)
    {
      pos.y = r;
      vel.y *= -1;
    }
  }
}
