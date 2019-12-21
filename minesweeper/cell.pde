






class Cell
{
  int x, y, velicina;
  boolean mina;
  boolean otvoreno;
  boolean zastavica;
  int broj;          //svaka celija koja nije mina ima broj (koliko ima mina u susjednim celijama)
  
  boolean pogodena = false;
  
  Cell(int x, int y, int velicina)
  {
    this.x = x;
    this.y = y;
    this.velicina = velicina;
    
    this.mina = false;
    this.otvoreno = false;
    this.zastavica = false;
    this.broj = -1;
  }
  
  void drawCell() 
  { 
    fill(200,200,200);
    stroke(0);
    rect(this.x, this.y, this.velicina, this.velicina); 
    if(this.otvoreno)
    {
      if(this.mina)
      {
        //fill(0);
        //ellipse(this.x + this.velicina*0.5, this.y + this.velicina*0.5,
          //this.velicina*0.5, this.velicina*0.5);
          
           PImage mina;
           mina = loadImage("mina.jpg");
           image(mina, this.x+1, this.y+1, this.velicina-1, this.velicina-1);
      }
      
      else
      {
        fill(127);
        rect(this.x, this.y, this.velicina, this.velicina);
        if(this.broj>0)
        {
          switch(this.broj) {
            case 1: 
              fill(0,0,255);  
              break;
            case 2: 
              fill(0,255,0);  
              break;
            case 3: 
              fill(255,0,0);  
              break;
            case 4: 
              fill(0,0,139);  
              break;
            case 5: 
              fill(165,42,42);  
              break;
            case 6: 
              fill(0,255,255);  
              break;
            case 7: 
              fill(0);  
              break;
            case 8: 
              fill(255);  
              break;
          }
          
          text(str(this.broj), this.x+this.velicina/2, this.y+this.velicina/2);
          textSize(14);
          textAlign(CENTER, CENTER);
        }
      }
    }
    
    else if(this.zastavica)
      {
        //fill(255,0,0);
        //ellipse(this.x + this.velicina*0.5, this.y + this.velicina*0.5,
          //          this.velicina*0.5, this.velicina*0.5);
          PImage zastavica;
          zastavica = loadImage("zastavica.png");
          image(zastavica, this.x+1, this.y+1, this.velicina-1, this.velicina-1);
      }
      
   }
   
   boolean isChosen(int x, int y)
   {
     if(this.x < x && this.x + this.velicina > x
          && this.y < y && this.y + this.velicina > y)
          return true;
          
          return false;
   }
   
   
  boolean isNeighbour(int nx, int ny)
  {
    //dolje desno
    if(this.x-this.velicina <= nx  && this.x >= nx && this.y-this.velicina <= ny && this.y >= ny)
      return true;
  
    //desno
    if(this.x-this.velicina <= nx  && this.x >= nx && this.y+this.velicina >= ny && this.y <= ny)
      return true;
 
   //dolje
   if(this.x+this.velicina >= nx  && this.x <= nx && this.y-this.velicina <= ny && this.y >= ny)
      return true;  
 
    //dolje lijevo
   if(this.x+this.velicina <= nx  && this.x+2*this.velicina > nx && this.y-this.velicina <= ny && this.y >= ny)
      return true;
 
    //gore lijevo
   if(this.x+this.velicina <= nx  && this.x+2*this.velicina > nx && this.y+this.velicina <= ny && this.y+2*this.velicina > ny)
      return true;
   
    //gore
   if(this.x+this.velicina >= nx  && this.x <= nx && this.y+this.velicina <= ny && this.y+2*this.velicina > ny)
      return true;
    
     //gore desno
   if(this.x-this.velicina <= nx  && this.x >= nx && this.y+this.velicina <= ny && this.y+2*this.velicina > ny)
      return true;
 
   //lijevo
   if(this.x+2*this.velicina > nx  && this.x+this.velicina <= nx && this.y+this.velicina >= ny && this.y <= ny)
      return true;
    
      return false;
  
  }
  
  
  ArrayList<Cell> getNeighbours()
  {
    ArrayList<Cell> susjedi = new ArrayList();
    
    for(int i = 0; i < rows; i++)
      for(int j = 0; j < cols; j++)
        if(grid[i][j].isNeighbour(this.x, this.y))
          susjedi.add(grid[i][j]);
 
    
    return susjedi;

  }
  
  
   
}
