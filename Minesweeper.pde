import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = 50;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean gameOver = false;
private int unmarkedBombs = NUM_BOMBS;
private int unclickedTiles = (NUM_ROWS * NUM_COLS) - (NUM_BOMBS);

void setup ()
{
  size(460, 460);
  textAlign(CENTER, CENTER);
  // make the manager
  Interactive.make( this );
  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int r = 0; r < NUM_ROWS; r ++)
  {
    for (int c = 0; c < NUM_COLS; c ++)
    {
      buttons[r][c] = new MSButton(r, c);
    }
  }
  for (int i = 0; i < NUM_BOMBS; i ++)
  {
    setBombs();
  }
}
public void setBombs()
{
  int r = (int)(Math.random() * NUM_ROWS);
  int c = (int)(Math.random() * NUM_COLS);
  if (!bombs.contains(buttons[r][c]))
  {
    bombs.add(buttons[r][c]);
  }else
  {
    setBombs();
  }
}
public void draw ()
{
  if (gameOver == false);
  {
    background(0);
  }
  if (isWon())
  {
    displayWinningMessage();
  }
}

public boolean isWon()
{
  if (unclickedTiles == 0)
  {
    return true;
  }else if (unmarkedBombs != 0)
  {
    return false;
  }else if (unmarkedBombs == 0)
  {
    for (int i = 0; i < bombs.size(); i ++)
    {
      if (!bombs.get(i).isMarked())
      {
        return false;
      }
    }
  }
  return true;
}
/*  for (int r = 0; r < NUM_ROWS; r ++)
 {
 for (int c = 0; c < NUM_COLS; c ++)
 {
 if(!buttons[r][c].isMarked() || !buttons[r][c].isClicked())
 {
 return false;
 }
 }
 return true;
 }
 //loops go through all the columns
 //if not all marked or clicked, return false, else return true
 //your code here
 return false;
 }*/
public void displayLosingMessage()
{
  for (int i = 0; i < bombs.size(); i ++)
  {
    if (bombs.get(i).isMarked() == false)
    {
      bombs.get(i).clicked = true;
    }
  }
  buttons[9][6].setLabel("Y");
  buttons[9][7].setLabel("O");
  buttons[9][8].setLabel("U");
  buttons[9][10].setLabel("L");
  buttons[9][11].setLabel("O");
  buttons[9][12].setLabel("S");
  buttons[9][13].setLabel("E");
  gameOver = true;
}
public void displayWinningMessage()
{
  buttons[9][6].setLabel("Y");
  buttons[9][7].setLabel("O");
  buttons[9][8].setLabel("U");
  buttons[9][10].setLabel("W");
  buttons[9][11].setLabel("I");
  buttons[9][12].setLabel("N");
  gameOver = true;
}

public class MSButton
{
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton ( int rr, int cc )
  {
    width = 460/NUM_COLS;
    height = 460/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height;
    label = "";
    marked = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isMarked()
  {
    return marked;
  }
  public boolean isClicked()
  {
    return clicked;
  }
  // called by manager

  public void mousePressed () 
  {
    if (gameOver == false)
    {
      if (mouseButton == LEFT && marked == false)
      {
        clicked = true;
        unclickedTiles --;
      }
      if (mouseButton == RIGHT && clicked == false)
      {
        marked = !marked;
        if (!isMarked())
        {
          unmarkedBombs ++;
        } else if (isMarked())
        {
          unmarkedBombs--;
        }
      }
    } else if (bombs.contains(this) && marked == false)
    {
      displayLosingMessage();
    } else if (countBombs(this.r, this.c) > 0)
    {
      setLabel(str(countBombs(this.r, this.c)));
    } else
    {
      for (int i = -1; i <= 1; i ++)
      {
        for (int j = -1; i <= 1; i ++)
        {
          if (isValid(r + i, c + j) && !buttons[r + i][c + j].isClicked())
          {
            buttons[r + i][c + j].mousePressed();
          }
        }
      }
    }
    /*  if (isValid(r, c - 1) && !buttons[r][c - 1].isClicked())
     buttons[r][c - 1].mousePressed();
     if (isValid(r, c + 1) && !buttons[r][c + 1].isClicked())
     buttons[r][c + 1].mousePressed();
     if (isValid(r - 1, c) && !buttons[r - 1][c].isClicked())
     buttons[r - 1][c].mousePressed();
     if (isValid(r + 1, c) && !buttons[r + 1][c].isClicked())
     buttons[r + 1][c].mousePressed();
     }*/
  }
  public void draw () 
  {  
    if (marked)
    {
      fill(0);
    } else if (clicked && bombs.contains(this))
    {
      fill(255, 0, 0);
    } else if (clicked)
      fill( 200 );
    else 
    fill( 100 );
    rect(x, y, width, height);
    fill(0);
    text(label, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    label = newLabel;
  }
  public boolean isValid(int r, int c)
  {
    if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
    {
      return true;
    }
    return false;
  }
  public int countBombs(int row, int col)
  {
    int numBombs = 0;
    //your code here
    for (int i = -1; i <= 1; i ++)
    {
      for (int j = -1; i <= 1; j ++)
      {
        if (isValid(row + i, col + j) && bombs.contains(buttons[row + i][col + j]))
        {
          numBombs ++;
        }
      }
    }
    return numBombs;
  }
}
/*    if (isValid(row + 1, col) && bombs.contains(buttons[row + 1][col]))
 numBombs += 1;
 if (isValid(row - 1, col) && bombs.contains(buttons[row - 1][col]))
 numBombs += 1;
 if (isValid(row, col + 1) && bombs.contains(buttons[row][col + 1]))
 numBombs += 1;
 if (isValid(row, col - 1) && bombs.contains(buttons[row][col - 1]))
 numBombs += 1;
 if (isValid(row + 1, col + 1) && bombs.contains(buttons[row + 1][col + 1]))
 numBombs += 1;
 if (isValid(row - 1, col + 1) && bombs.contains(buttons[row - 1][col + 1]))
 numBombs += 1;
 if (isValid(row + 1, col - 1) && bombs.contains(buttons[row + 1][col - 1]))
 numBombs += 1;
 if (isValid(row - 1, col - 1) && bombs.contains(buttons[row - 1][col -1]))
 numBombs += 1;
 return numBombs;
 }
 }*/