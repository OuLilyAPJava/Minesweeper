import de.bezier.guido.*;
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int NUM_BOMBS = 50;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

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
  setBombs();
}
public void setBombs()
{
  while (bombs.size() < NUM_BOMBS)
  {
    int r = (int)(Math.random() * NUM_ROWS);
    int c = (int)(Math.random() * NUM_COLS);
    if (!bombs.contains(buttons[r][c]))
    {
      bombs.add(buttons[r][c]);
    }
    System.out.println(r + "," + c);
  }
}

public void draw ()
{
  background( 0 );
  if (isWon())
  {
    displayWinningMessage();
  }
}
public boolean isWon()
{
  for (int r = 0; r < NUM_ROWS; r ++)
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
}
public void displayLosingMessage()
{
  buttons[9][6].setLabel("Y");
  buttons[9][7].setLabel("O");
  buttons[9][8].setLabel("U");
  buttons[9][10].setLabel("L");
  buttons[9][11].setLabel("O");
  buttons[9][12].setLabel("S");
  buttons[9][13].setLabel("E");
}
public void displayWinningMessage()
{
  buttons[9][6].setLabel("Y");
  buttons[9][7].setLabel("O");
  buttons[9][8].setLabel("U");
  buttons[9][10].setLabel("W");
  buttons[9][11].setLabel("I");
  buttons[9][12].setLabel("N");
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
    clicked = true;
    //your code here
    if (keyPressed == true)
    {
      if (marked == false)
      {
        clicked = false;
      }
    } else if (bombs.contains(this))
    {
      if (mousePressed == true && mouseButton == RIGHT)
      {
      }else
      {
        displayLosingMessage();
      }
    } else if (countBombs(this.r, this.c) > 0)
    {
      setLabel(""+countBombs(this.r, this.c));
    } else
    {
      if (isValid(r, c - 1) && !buttons[r][c - 1].isClicked())
        buttons[r][c - 1].mousePressed();
      if (isValid(r, c + 1) && !buttons[r][c + 1].isClicked())
        buttons[r][c + 1].mousePressed();
      if (isValid(r - 1, c) && !buttons[r - 1][c].isClicked())
        buttons[r - 1][c].mousePressed();
      if (isValid(r + 1, c) && !buttons[r + 1][c].isClicked())
        buttons[r + 1][c].mousePressed();
    }
  }
  public void draw () 
  {  
    if (marked)
    {
      fill(0);
    }else if (clicked && bombs.contains(this))
    {
      if (mousePressed == true && (mouseButton == RIGHT))
      {
        fill(0);
      }
      fill(255, 0, 0);
    }else if (clicked)
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
    if (isValid(row + 1, col) && bombs.contains(buttons[row + 1][col]))
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
}