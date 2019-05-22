class Line
{
  PVector 
    start, 
    end;

  Line(float a, float b, float c, float d)
  {
    start = new PVector(a, b);
    end = new PVector(c, d);
  }

  Line(PVector a, PVector b)
  {
    start = a.copy();
    end = b.copy();
  }

  PVector thisline()
  {
    return PVector.sub(end, start);
  }

  void set(PVector a, PVector b)
  {
    start.set(a);
    end.set(b);
  }

  float distto(PVector point)
  {
    PVector proj = getNormalPointinline(point, start, end);
    return point.dist(proj);
  }


  void show()
  {
    line(start.x, start.y, end.x, end.y);
  }

  void shownormal()
  {
    PVector n = normal();
    n.mult(50);
    n = PVector.sub(midpoint(), n);
    line(midpoint().x, midpoint().y, n.x, n.y);
  }

  void showmidpoint()
  {
    circle(midpoint().x, midpoint().y, 5);
  }

  void showall()
  {
    show();
    shownormal();
    showmidpoint();
  }

  PVector normal()
  {
    PVector l = thisline();
    PVector normal = new PVector(-l.y, l.x);
    normal.normalize();
    return normal;
  }

  float length()
  {
    return start.dist(end);
  }

  PVector midpoint()
  {
    PVector mid = PVector.add(start, end);
    mid.div(2);
    return mid;
  }

  boolean intersectsLine(Line l)
  {
    return intersectionpointLine(l) != null;
  }

  PVector intersectionpointLine(Line l)
  {
    float x1 = l.start.x;
    float y1 = l.start.y;
    float x2 = l.end.x;
    float y2 = l.end.y;

    float x3 = start.x;
    float y3 = start.y;
    float x4 = end.x;
    float y4 = end.y;

    float den = (x1 - x2) * (y3 - y4)-(y1-y2) * (x3-x4);
    if (den == 0)
    {
      return null;
    }

    float t = ((x1-x3)*(y3 - y4)-(y1 - y3) * (x3-x4))/den;
    float u = -((x1-x2)*(y1 - y3)-(y1 - y2) * (x1-x3))/den;

    if (t > 0 && t < 1 && u > 0 && u < 1)
    {
      PVector p = new PVector(x1 + t * (x2-x1), y1 + t * (y2-y1));
      return p;
    } else return null;
  }

  boolean intersectsC(ball c)
  {
    return Lintersects(start, end, c);
  }
}
