
int velicinaPolja = 25;
int brojMina = 40;    //neka bude tocno mina koliko je tu zadano
int cols, rows;
boolean firstClick = false;

Cell[][] grid;


void setup() {
  size(400, 400);
  cols = width/velicinaPolja;
  rows = height/velicinaPolja;
  
  grid = new Cell[rows][cols];  //logicnije mi je [rows][cols], da budu retci i stupci kao u matrici
  for (int i = 0; i < rows; i++) 
  {
    for (int j = 0; j < cols; j++) 
    {
      grid[i][j] = new Cell(i * velicinaPolja, j * velicinaPolja, velicinaPolja);
    }
  }
  
  //set_mines(rows,cols);  //zasad je tu, kasnije cemo postavit mine nakon prvog klika
  //set_numbers(rows,cols);  //zasad je tu, kasnije cemo postavit brojeve nakon prvog klika
                            //u pravoj igri je prvi klik uvijek nula, mogli bi i mi tako
}

//postavi mine na random pozicije

void set_mines(int rows,int cols, int x, int y)
{
  int[] a = new int[cols*rows];
  for (int i = 0; i < a.length; i++)
    a[i] = i;
  
  for (int i = 0; i < a.length; i++) {
    int ridx = (int)random(0, a.length);
    int temp = a[i];
    a[i] = a[ridx];
    a[ridx] = temp;
  } 
  
  
  int br = 0;
  int k = 0;
 
 while(true)
 {
    if(!(grid[a[k]/cols][a[k]%cols].isChosen(x,y) || grid[a[k]/cols][a[k]%cols].isNeighbour(x,y))) 
    { 
      grid[a[k]/cols][a[k]%cols].mina=true; 
      br++;  
    }
    
    k++;
    if(br >= brojMina) break;
 }    

  
     
}


//postavi brojeve svim celijama

void set_numbers(int rows, int cols)
{
  for (int i = 0; i < rows; i++) 
  {
    for (int j = 0; j < cols; j++) 
    {
      grid[i][j].broj = neighbour_mines(i,j,rows,cols);
    }
  }  
}

//pomocna funkcija koja broji koliko ima susjednih mina neke celije

int neighbour_mines(int i, int j, int r, int c)
{
  if(grid[i][j].mina)
    return -1;
  
  int br = 0;
  
  if(i-1 >= 0 && j-1>=0)
    if(grid[i-1][j-1].mina) br++;
  if(i-1 >= 0)
    if(grid[i-1][j].mina) br++; 
  if(i-1 >= 0 && j+1<c)
    if(grid[i-1][j+1].mina) br++;
  if(j-1>=0)
    if(grid[i][j-1].mina) br++;
  if(j+1<c)
    if(grid[i][j+1].mina) br++;
  if(i+1<r && j-1>=0)
    if(grid[i+1][j-1].mina) br++;
  if(i+1<r)
    if(grid[i+1][j].mina) br++; 
  if(i+1<r && j+1<c)
    if(grid[i+1][j+1].mina) br++;
  return br;

}

void draw() {

  for (int i = 0; i < rows; i++) 
    for (int j = 0; j < cols; j++)
      grid[i][j].drawCell();
    
}

void mousePressed(){
  
  if(!firstClick)
  {
    firstClick = true;
    set_mines(rows, cols, mouseX, mouseY);
    set_numbers(rows, cols);
    countMines();
    
  }
  
  
  
  
 // else{
    for (int i = 0; i < rows; i++) 
      for (int j = 0; j < cols; j++)
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
   // }
}




void countMines()
{
  int br = 0;
  for(int i = 0; i < rows; ++i)
  for(int j = 0; j < cols; ++j)
  if(grid[i][j].mina)
  br++;
  
  println(br);
}

class Cell
{
  int x, y, velicina;
  boolean mina;
  boolean otvoreno;
  boolean zastavica;
  int broj;          //svaka celija koja nije mina ima broj (koliko ima mina u susjednim celijama)
  
  Cell(int x, int y, int velicina)
  {
    this.x = x;
    this.y = y;
    this.velicina = velicina;
    
    this.mina=false;
    this.otvoreno = true;
    this.zastavica = false;
    this.broj=-1;
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
 if(this.x+this.velicina <= nx  && this.x+2*this.velicina >= nx && this.y-this.velicina <= ny && this.y >= ny)
    return true;
 
  //gore lijevo
 if(this.x+this.velicina <= nx  && this.x+2*this.velicina >= nx && this.y+this.velicina <= ny && this.y+2*this.velicina >= ny)
    return true;
   
  //gore
 if(this.x+this.velicina >= nx  && this.x <= nx && this.y+this.velicina <= ny && this.y+2*this.velicina >= ny)
    return true;
    
   //gore desno
 if(this.x-this.velicina <= nx  && this.x >= nx && this.y+this.velicina <= ny && this.y+2*this.velicina >= ny)
    return true;
 
 //lijevo
 if(this.x+2*this.velicina >= nx  && this.x+this.velicina <= nx && this.y+this.velicina >= ny && this.y <= ny)
    return true;
    
    return false;
  
}
   
}
