
int velicinaPolja = 25;
int brojMina = 40;
int cols, rows;

Cell[][] grid;

/* Boje za brojeve mina
1 blue
2 green
3 red
4 dark blue
5 brown
6 Cyan
7 Black
8 Grey*/

void setup() {
  size(400, 400);
  cols = width/velicinaPolja;
  rows = height/velicinaPolja;
  
  grid = new Cell[cols][rows];
  for (int i = 0; i < cols; i++) 
  {
    for (int j = 0; j < rows; j++) 
    {
      grid[i][j] = new Cell(i * velicinaPolja, j * velicinaPolja, velicinaPolja);
    }
  }
  
  
}

void draw() {

  for (int i = 0; i < cols; i++) 
    for (int j = 0; j < rows; j++)
      grid[i][j].drawCell();
    
}



void mousePressed(){
  
  for (int i = 0; i < cols; i++) 
    for (int j = 0; j < rows; j++)
    {
      if(grid[i][j].isChosen(mouseX, mouseY) && (mouseButton == LEFT)
         && !grid[i][j].zastavica && !grid[i][j].otvoreno)
        grid[i][j].otvoreno = true;
        
        else if(grid[i][j].isChosen(mouseX, mouseY) && (mouseButton == RIGHT)
                 && !grid[i][j].otvoreno)
        {
          if(grid[i][j].zastavica)
           grid[i][j].zastavica = false;
           
           else grid[i][j].zastavica = true;
        } 
    }
}

class Cell
{
  int x, y, velicina;
  boolean mina;
  boolean otvoreno;
  boolean zastavica;
  
  Cell(int x, int y, int velicina)
  {
    this.x = x;
    this.y = y;
    this.velicina = velicina;
    
    if(random(1) <= 0.15625) this.mina = true;
    else this.mina = false;
    
    this. otvoreno = false;
    this.zastavica = false;
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
        fill(0);
        ellipse(this.x + this.velicina*0.5, this.y + this.velicina*0.5,
                    this.velicina*0.5, this.velicina*0.5);
      }
      
      else
      {
        fill(127);
        rect(this.x, this.y, this.velicina, this.velicina);
      }
    }
    
    else if(this.zastavica)
      {
        fill(255,0,0);
        ellipse(this.x + this.velicina*0.5, this.y + this.velicina*0.5,
                    this.velicina*0.5, this.velicina*0.5);
      }
      
   }
   
   boolean isChosen(int x, int y)
   {
     if(this.x < x && this.x + this.velicina > x
          && this.y < y && this.y + this.velicina > y)
          return true;
          
          return false;
   }
  
  
}
