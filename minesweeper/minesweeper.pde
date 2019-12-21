
import java.util.ArrayList;
import java.util.List;



int velicinaPolja = 25;
int brojMina = 40;  
int cols, rows;
boolean firstClick = false;

Cell[][] grid;


void setup() {
  size(400, 400);
  cols = width/velicinaPolja;
  rows = height/velicinaPolja;
  
  grid = new Cell[rows][cols];  
  for (int i = 0; i < rows; i++) 
  {
    for (int j = 0; j < cols; j++) 
    {
      grid[i][j] = new Cell(i * velicinaPolja, j * velicinaPolja, velicinaPolja);
    }
  }
  
}


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
      {
        grid[i][j].drawCell();
        if(grid[i][j].broj == 0 && grid[i][j].otvoreno)
          open_neighbours(i,j);
      }
    
}

void mousePressed(){
  
  if(!firstClick)
  {
    firstClick = true;
    set_mines(rows, cols, mouseX, mouseY);
    set_numbers(rows, cols);
    countMines();
    
  }
  
  
  
    for (int i = 0; i < rows; i++) 
      for (int j = 0; j < cols; j++)
      {
        if(grid[i][j].isChosen(mouseX, mouseY) && (mouseButton == LEFT)
           && !grid[i][j].zastavica && !grid[i][j].otvoreno)
          {
            grid[i][j].otvoreno = true;
            
            if(grid[i][j].broj == 0)
              open_neighbours(i, j);
   
          }
        
          else if(grid[i][j].isChosen(mouseX, mouseY) && (mouseButton == RIGHT)
                 && !grid[i][j].otvoreno)
          {
            if(grid[i][j].zastavica)
             grid[i][j].zastavica = false;
           
             else grid[i][j].zastavica = true;
          } 
      }
  
}


void open_neighbours(int x, int y)
{
  ArrayList<Cell> susjedi = grid[x][y].getNeighbours();
  for(int k = 0; k < susjedi.size(); k++)
  {
    Cell susjed = susjedi.get(k);
    susjed.otvoreno = true;
    
    //if(susjed.x >= 0 && susjed.x <= rows && susjed.y >= 0 && susjed.y <= cols && susjed.broj == 0)
      //open_neighbours(susjed.x, susjed.y);
     
    }
   
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
