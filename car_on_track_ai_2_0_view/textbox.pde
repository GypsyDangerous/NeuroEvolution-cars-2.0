class textbox
{

  ArrayList<String> titles, info;
  PVector pos;
  float txtsize, index, w, h;
  textbox(float x, float y, float w, float h)
  {
    pos = new PVector(x, y);
    this.w = w;
    this.h = h;
    txtsize = w/8;
    titles = new ArrayList<String>();
    info = new ArrayList<String>();
  }

  void add(String t, String i)
  {
    titles.add(t);
    info.add(i);
  }

  void add(float t, float i)
  {
    add(t+"", i+"");
  }

  void update(String t, String i, int index)
  {
    if (index >= titles.size())
    {
      add(t, i);
    } else
    {
      titles.set(index, t);
      info.set(index, i);
    }
  }

  void clear()
  {
    titles.clear();
    info.clear();
  }

  void show()
  {
    fill(51, 200);
    rect(pos.x, pos.y, w, h);
    fill(255);
    stroke(255);
    //textAlign(CENTER, CENTER);
    h = txtsize*titles.size()+txtsize;
    textSize(txtsize/1.5);
    for (int i = 0; i < titles.size(); i++)
    {
      String txt = titles.get(i) + ": " + info.get(i);
      text(txt, pos.x+txtsize/2, pos.y+txtsize+(txtsize*i));
    }
  }
}
