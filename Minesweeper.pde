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
    textSize(18);
    text("Bombs remaining:" + unmarkedBombs, 100, 30);
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
    } else if (countBombs(r, c) > 0)
    {
      setLabel(str(countBombs(r, c)));
    } else
    {
      for (int i = -1; i <= 1; i ++)
      {
        for (int j = -1; j <= 1; j ++)
        {
          if (isValid(r + i, c + j) && !buttons[r + i][c + j].isClicked())
          {
            buttons[r + i][c + j].mousePressed();
          }
        }
      }
    }
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
      for (int j = -1; j <= 1; j ++)
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
