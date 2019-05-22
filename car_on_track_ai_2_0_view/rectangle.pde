class rectangle
{
  PVector 
    pos, 
    size, 
    hsize, 
    psize, 
    phsize;

  ArrayList<Line> 
    sides;

  float 
    w, 
    h;

  rectangle(float x, float y, float w, float h)
  {
    pos = new PVector(x, y);
    this.w = w;
    this.h = h;
    size = new PVector(w, h);
    size.mult(.5);
    hsize = new PVector(-w, h);
    hsize.mult(.5);
    psize = size.copy();
    phsize = hsize.copy();
    generatesides();
  }

  void generatesides()
  {
    sides = new ArrayList<Line>();
    PVector a = PVector.sub(pos, size);
    PVector b = PVector.sub(pos, hsize);
    PVector c = PVector.add(pos, size);
    PVector d = PVector.add(pos, hsize);
    sides.add(new Line(a, b));
    sides.add(new Line(b, c));
    sides.add(new Line(c, d));
    sides.add(new Line(d, a));
  }

  void show()
  {
    for (Line l : sides)
    {
      l.showall();
      //l.shownormal();
    }
  }

  PVector pointofcollision(ball b)
  {
    for (Line l : sides)
    {
      if (l.intersectsC(b))
      {
        PVector norm = getNormalPointinline(b.pos, l.start, l.end);
        return  norm;
      }
    }
    return null;
  }

  void update()
  {
    generatesides();
  }

  void setR(float theta)
  {
    size = psize.copy();
    size.rotate(theta);
    hsize = phsize.copy();
    hsize.rotate(theta);
  }



  PVector closestpoint(PVector p)
  {
    float record = Float.POSITIVE_INFINITY;
    PVector closest = new PVector();
    for (Line l : sides)
    {
      PVector proj = getNormalPointinline(p, l.start, l.end);
      float d = p.dist(proj);
      if (d < record)
      {
        record = d;
        closest = proj.copy();
      }
    }
    return closest;
  }
}
