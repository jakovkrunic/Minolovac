import processing.sound.*;
SoundFile zvuk,eksplozija;

import java.util.ArrayList;

final int izbornik = 0;
final int playing = 1;
final int gameLost = 2;
final int gameWon = 3;
final int options = 4;
final int tezina = 5;

int gameState = izbornik; 


int velicinaPolja = 25;
int brojMina = 40;
int brojPreostalihMina = brojMina;
int cols, rows;
boolean firstClick = false;
int clock, clockAtStart;
boolean clockStarted = false;
int difficulty = 2;
boolean bezZvuka = false;
int w, h;
int smile_x=180,timer_x=343;

Cell[][] grid;

void setup() {
      
    size(400, 450);
    surface.setResizable(true);
    
    cols = width/velicinaPolja;
    rows = (height-50)/velicinaPolja;
  
    grid = new Cell[rows][cols];  
    for (int i = 0; i < rows; i++) 
    {
      for (int j = 0; j < cols; j++) 
      {
        grid[i][j] = new Cell(i * velicinaPolja, 50 + j * velicinaPolja, velicinaPolja);
      }
    }
   
}

void draw() {
  
  if(gameState == izbornik)
  {
    background(211,211,211);
    
    fill(152,152,152);
    rect(90,50,220,80);
    fill(200,0,0);
    textAlign(LEFT);
    textSize(40);
    text("New game", 100, 100);
    
    
    fill(152,152,152);
    rect(90,150,220,80);
    fill(200,0,0);
    textAlign(LEFT);
    textSize(40);
    text("Options", 120, 200);
    
    fill(152,152,152);
    rect(90,250,220,80);
    fill(200,0,0);
    textAlign(LEFT);
    textSize(40);
    text("Difficulty", 110, 300);
  }
 
  
  else if(gameState == playing){
    
    if(difficulty == 2)
    {
      surface.setSize(400, 450);
      smile_x=180; timer_x=343;
    }
    
    else if(difficulty == 1)
    {
      surface.setSize(225, 275);
      smile_x = 97; timer_x = 180;
    }
    
    else if(difficulty == 3)
    {
      surface.setSize(750, 450);
      smile_x=340; timer_x = 700;
    }
    
    
    background(211,211,211);
    PImage smile;
    smile = loadImage("smile.png");
    image(smile, smile_x, 7, 35, 35);
    
   
    fill(0);
    rect(7, 7, 70, 35);
    fill(200,0,0);
    textSize(25);
    textAlign(LEFT);
    text(str(brojPreostalihMina), 40, 35);
    
    
    if(clockStarted)
      clock = millis();
    
   
    fill(0);
    if(difficulty==3)
      rect(670, 7, 70, 35);
    else if(difficulty==2)
      rect(323, 7, 70, 35);
    else if(difficulty==1)
      rect(150, 7, 70, 35);
    fill(200,0,0);
    textSize(25);
    textAlign(LEFT);
    if((clock-clockAtStart)/1000 >=0)
      text(str((clock-clockAtStart)/1000), timer_x, 35);
    else
      text(str(0),timer_x,35);
    //println(clock);
    
    
    textAlign(CENTER,CENTER);
    textSize(14);
    
      
    for (int i = 0; i < rows; i++) 
      for (int j = 0; j < cols; j++)
      {
        grid[i][j].drawCell();
        if(grid[i][j].broj == 0 && grid[i][j].otvoreno)
          open_neighbours(i,j);
      }
    if(win())
    {
       gameState = gameWon;
    }
  }
  
  else if(gameState == gameLost)
  {
    for (int i = 0; i < rows; i++) 
      for (int j = 0; j < cols; j++)
      {
        grid[i][j].drawCell();
        if(grid[i][j].mina)
        {
          if(!grid[i][j].zastavica)
            grid[i][j].otvoreno = true;
            if(grid[i][j].pogodena)
            {  
               PImage mina;   
               mina = loadImage("minared.jpg");
               image(mina,  grid[i][j].x+1,  grid[i][j].y+1,  grid[i][j].velicina-1,  grid[i][j].velicina-1);
            }         
        }
        else if(!grid[i][j].mina && grid[i][j].zastavica)
        {
          PImage mina;   
          mina = loadImage("minacrossed.jpg");
          image(mina,  grid[i][j].x+1,  grid[i][j].y+1,  grid[i][j].velicina-1,  grid[i][j].velicina-1);
        }
      }
      if(!bezZvuka) zvuk.stop();
    //fill(0);
    //textSize(50);
    //text("Game over", 200, 200);
  }
  else if(gameState == gameWon)
  {
    for (int i = 0; i < rows; i++) 
      for (int j = 0; j < cols; j++)
        grid[i][j].drawCell();
    
    fill(0);
    text("YOU WON", width/2,height/2);
    zvuk.stop();
  }
  
  
  
  else if(gameState == options)
  {
    background(211,211,211);
    
    if(!bezZvuka)
      fill(0,152,0);
    
    else fill(152,152,152);
    
    rect(90,50,220,80);
    fill(200,0,0);
    textAlign(LEFT);
    textSize(40);
    text("Sound", 135, 100);
    
    
    if(bezZvuka)
      fill(0,152,0);
    
    else fill(152,152,152);
    
    rect(90,150,220,80);
    fill(200,0,0);
    textAlign(LEFT);
    textSize(40);
    text("No sound", 110, 200);
    
    fill(152,152,152);
    rect(90,250,220,80);
    fill(200,0,0);
    textAlign(LEFT);
    textSize(40);
    text("Back", 150, 300);
    
    // mozda ubaciti igru pomocu tipkovnice
  }
  
  
  else if(gameState == tezina)
  {
    background(211,211,211);
    
    if(difficulty == 1)
      fill(0,152,0);
    
    else fill(152,152,152);
    
    rect(90,50,250,80);
    fill(200,0,0);
    textAlign(LEFT);
    textSize(40);
    text("Begginer", 130, 100);
    
    
    if(difficulty == 2)
      fill(0,152,0);
    
    else fill(152,152,152);
    
    rect(90,150,250,80);
    fill(200,0,0);
    textAlign(LEFT);
    textSize(40);
    text("Intermediate", 95, 200);
    
    if(difficulty == 3)
      fill(0,152,0);
    
    else fill(152,152,152);
    
    rect(90,250,250,80);
    fill(200,0,0);
    textAlign(LEFT);
    textSize(40);
    text("Expert", 150, 300);
    
    
    
    fill(152,152,152);
    rect(90,350,250,80);
    fill(200,0,0);
    textAlign(LEFT);
    textSize(40);
    text("Back", 165, 400);
    
    // mozda ubaciti igru pomocu tipkovnice
  }
  
  
}

void mousePressed(){
  
  if(gameState == izbornik)
  {
    if(mouseX > 90 && mouseX < 310 && mouseY < 130 && mouseY > 50)
      gameState = playing;
    
    
    else if(mouseX > 90 && mouseX < 310 && mouseY < 230 && mouseY > 150)
      gameState = options;
    
    else if(mouseX > 90 && mouseX < 310 && mouseY < 330 && mouseY > 250)
      gameState = tezina;
  
  }
    
  else if(gameState == playing)
  {     
     // stisnut je smiley
    if(mouseX > smile_x  &&  mouseX < smile_x+35 && mouseY < 42 && mouseY > 7 )
    {
      gameState = playing;
      firstClick = false;
      //cols = width/velicinaPolja;
      //rows = (height-50)/velicinaPolja;
      brojPreostalihMina = brojMina;
      clockStarted = false;
      clockAtStart = millis();
      
      grid = new Cell[rows][cols];  
      for (int i = 0; i < rows; i++) 
      {
        for (int j = 0; j < cols; j++) 
        {
          grid[i][j] = new Cell(i * velicinaPolja, 50 + j * velicinaPolja, velicinaPolja);
        }
       }
       if(zvuk != null && !bezZvuka)
         zvuk.stop();
     }
    
    if(!firstClick && mouseY >= 50)
    {
      clockStarted = true;
      clockAtStart = millis();
      firstClick = true;
      set_mines(mouseX, mouseY);
      set_numbers();
      
      if(!bezZvuka)
      {
        zvuk = new SoundFile(this, "pozadinski zvuk.mp3");
        zvuk.loop();
      }
      
    }
  
    for (int i = 0; i < rows; i++) 
      for (int j = 0; j < cols; j++)
      {
          if(grid[i][j].isChosen(mouseX, mouseY) && (mouseButton == LEFT)
           && !grid[i][j].zastavica && !grid[i][j].otvoreno)
          {
            grid[i][j].otvoreno = true;
            
            if(grid[i][j].mina)
            {
              grid[i][j].pogodena = true;
              delay(200);
              gameState = gameLost;
              if(!bezZvuka)
              {
                eksplozija = new SoundFile(this, "eksplozija.mp3");
                eksplozija.play();
              }
            }
            else
            {
              if(grid[i][j].broj == 0)
                open_neighbours(i, j);
              
            }
   
          }
        
          else if(grid[i][j].isChosen(mouseX, mouseY) && (mouseButton == RIGHT)
                 && !grid[i][j].otvoreno)
          {
            if(grid[i][j].zastavica)
            {
              grid[i][j].zastavica = false;
              brojPreostalihMina++;
            }
           
             else 
             {
               grid[i][j].zastavica = true;
               brojPreostalihMina--;
             }
          }
          
          else if(grid[i][j].isChosen(mouseX, mouseY) && (mouseButton == CENTER)
                 && grid[i][j].otvoreno && neighbour_flags(i,j)!=grid[i][j].broj)
          {
            highlight_closed_neighbours(i,j);
          }
          else if(grid[i][j].isChosen(mouseX, mouseY) && (mouseButton == CENTER)
                 && grid[i][j].otvoreno && neighbour_flags(i,j)==grid[i][j].broj)
          {
            open_closed_neighbours(i,j);

          }

      }

  }
  
  else if(gameState == gameLost || gameState == gameWon)
  {
    if(mouseX > smile_x  &&  mouseX < smile_x+35 && mouseY < 42 && mouseY > 7)
    {
      gameState = playing;
      firstClick = false;
      //cols = width/velicinaPolja;
      //rows = (height-50)/velicinaPolja;
      brojPreostalihMina = brojMina;
      clockStarted = false;
      clockAtStart = millis();
      
      grid = new Cell[rows][cols];  
      for (int i = 0; i < rows; i++) 
      {
        for (int j = 0; j < cols; j++) 
        {
          grid[i][j] = new Cell(i * velicinaPolja, 50 + j * velicinaPolja, velicinaPolja);
        }
       }
       if(!bezZvuka)
         zvuk.stop();
     }
  }
  
  else if(gameState == options)
  {
    if(mouseX > 90 && mouseX < 310 && mouseY < 130 && mouseY > 50)
      bezZvuka = false;
    
    
    else if(mouseX > 90 && mouseX < 310 && mouseY < 230 && mouseY > 150)
      bezZvuka = true;
    
    else if(mouseX > 90 && mouseX < 310 && mouseY < 330 && mouseY > 250)
      gameState = izbornik;
    
  }
  
  else if(gameState == tezina)
  {
    if(mouseX > 90 && mouseX < 340 && mouseY < 130 && mouseY > 50)
    {
       difficulty = 1;
       brojMina = 16;
       brojPreostalihMina = brojMina;
       
       cols = 225/velicinaPolja;
       rows = 225/velicinaPolja;
    
       grid = new Cell[rows][cols];  
       for (int i = 0; i < rows; i++) 
       {
          for (int j = 0; j < cols; j++) 
          {
            grid[i][j] = new Cell(i * velicinaPolja, 50 + j * velicinaPolja, velicinaPolja);
          }
       }
     }
    
    else if(mouseX > 90 && mouseX < 340 && mouseY < 230 && mouseY > 150)
    { 
      difficulty = 2;
      brojMina = 40;
      brojPreostalihMina = brojMina;
      
      cols = 400/velicinaPolja;
      rows = 400/velicinaPolja;
    
      grid = new Cell[rows][cols];  
      for (int i = 0; i < rows; i++) 
      {
          for (int j = 0; j < cols; j++) 
          {
            grid[i][j] = new Cell(i * velicinaPolja, 50 + j * velicinaPolja, velicinaPolja);
          }
      }
    }
    
    else if(mouseX > 90 && mouseX < 340 && mouseY < 330 && mouseY > 250)
    {
       difficulty = 3;
       brojMina = 99;
       brojPreostalihMina = brojMina;
       
       cols = 400/velicinaPolja;
       rows = 750/velicinaPolja;
    
       grid = new Cell[rows][cols];  
       for (int i = 0; i < rows; i++) 
       {
          for (int j = 0; j < cols; j++) 
          {
            grid[i][j] = new Cell(i * velicinaPolja, 50 + j * velicinaPolja, velicinaPolja);
          }
       }
     }
     
    else if(mouseX > 90 && mouseX < 340 && mouseY < 430 && mouseY > 350)
      gameState = izbornik;
  }
  
}

void open_neighbours(int x, int y)
{
  ArrayList<Cell> susjedi = grid[x][y].getNeighbours();
  for(int k = 0; k < susjedi.size(); k++)
  {
    Cell susjed = susjedi.get(k);
    susjed.otvoreno = true;     
  }
  
}

//istakni zatvorene susjede (bez zastavice) 
void highlight_closed_neighbours(int x, int y)
{
  ArrayList<Cell> susjedi = grid[x][y].getNeighbours();
  for(int k = 0; k < susjedi.size(); k++)
  {
    Cell susjed = susjedi.get(k);
    if(!susjed.otvoreno && !susjed.zastavica)
    {
      susjed.istaknuta=true;
      susjed.drawCell();
    }
  }
  delay(100);
  highlight_back_closed_neighbours(x,y);
}

//vrati zatvorene susjede (bez zastavice) na zatvoreno polje 
void highlight_back_closed_neighbours(int x, int y)
{
  ArrayList<Cell> susjedi = grid[x][y].getNeighbours();
  for(int k = 0; k < susjedi.size(); k++)
  {
    Cell susjed = susjedi.get(k);
    if(!susjed.otvoreno && !susjed.zastavica)
    {
      susjed.istaknuta=false;
    }
  }
}

//otvori zatvorene susjede (bez zastavice) 
void open_closed_neighbours(int x, int y)
{
  boolean kraj=false;
  ArrayList<Cell> susjedi = grid[x][y].getNeighbours();
  for(int k = 0; k < susjedi.size(); k++)
  {
    Cell susjed = susjedi.get(k);
    if(!susjed.otvoreno && !susjed.zastavica)
    {
      susjed.otvoreno=true;
      if(susjed.mina)
      {
          susjed.pogodena = true;
          kraj = true;
      }
    }
  }
  if(kraj)
  {
    delay(200);
    gameState = gameLost;
    if(!bezZvuka)
    {
      eksplozija = new SoundFile(this, "eksplozija.mp3");
      eksplozija.play();
    }
  }
}

//izbroji koliko susjeda ima postavljenu zastavicu
int neighbour_flags(int x, int y)
{
  int br=0;
  ArrayList<Cell> susjedi = grid[x][y].getNeighbours();
  for(int k = 0; k < susjedi.size(); k++)
  {
    Cell susjed = susjedi.get(k);
    if(susjed.zastavica)
    {
      br++;
    }
  }
  return br;
}




void set_mines(int x, int y)
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

void set_numbers()
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

//funkcija koja nam otkriva je li sve zadovoljenu za pobjedu
boolean win()
{
  int opened=0;
  for (int i = 0; i < rows; i++) 
  {
    for (int j = 0; j < cols; j++) 
    {
      if(grid[i][j].otvoreno)
        opened++;
    }
  }
  if(opened==(rows*cols-brojMina))
  {
    for (int i = 0; i < rows; i++) 
    {
      for (int j = 0; j < cols; j++) 
      {
        if(!grid[i][j].otvoreno && !grid[i][j].zastavica)
        {
          grid[i][j].zastavica=true;
        }
      }
    }
  }
  
  if(opened==(rows*cols-brojMina))
    return true;
  else  
    return false;
}

/*void countMines()
{
  int br = 0;
  for(int i = 0; i < rows; ++i)
  for(int j = 0; j < cols; ++j)
  if(grid[i][j].mina)
  br++;
  
  println(br);
}*/
