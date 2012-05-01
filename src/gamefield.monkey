Import mojo

Import src.game
Import src.snake

Class GameField
	Private
	Field _cellSize:Int
	Field _countCellsX:Int, _countCellsY:Int
	Field _width:Int, _height:int
	Field _originX:Int, _originY:int
	Field _cells:Int[][]
	Field _snake:Snake
	field _eat:Coord
	
	Const EMPTY:int = 0
	Const SNAKE_HEAD:int = 1
	Const SNAKE_BODY:int = 2
	Const FOOD:int = 3
	
	Const ACTION_REFRESH = 1
	
	Method _create(cellSize:int, width:Int, height:Int)
		Self._cellSize = cellSize	
		Self._countCellsX = Ceil(width/Self._cellSize)
		Self._countCellsY = Ceil(height/Self._cellSize)
		Self._width = Self._countCellsX*Self._cellSize
		Self._height = Self._countCellsY*Self._cellSize
		Self._originX = Ceil(Abs(Self._width - DeviceWidth())*.5)
		Self._originY = Ceil(Abs(Self._height - DeviceHeight())*.5)
		Self._cells= new Int[Self._countCellsX][]
		
		For local i:=0 To Self._countCellsX - 1
			Self._cells[i] = new Int[Self._countCellsY]	
		Next
		
		Self._snake = new Snake(3, Ceil(Self._countCellsX*.52), Ceil(Self._countCellsY*.4), True)
		
		Self.GiveFood()
	End Method
	
	Public
	Method New(cellSize:int)
		Self._create(cellSize, DeviceWidth(), DeviceHeight())
	End
	
	Method New(cellSize:int, width:Int, height:Int)
		Self._create(cellSize, width, height)
	End
	
	Method SetOrigin(x:Int, y:Int)
		Self._originX = x
		Self._originY = y
	End Method
	
	Method SetOriginX(x:Int)
		Self._originX = x
	End Method
	
	Method SetOriginY(y:Int)
		Self._originY = y
	End Method
	
	Method Update:Void()
		
		For Local x:= 0 to Self._countCellsX - 1
			For Local y:= 0 to Self._countCellsY - 1
				Self._cells[x][y] = GameField.EMPTY
			Next
		Next
		
		Self._cells[Self._eat.x][Self._eat.y] = GameField.FOOD
		
		if(Self._eat.x = Self._snake.HeadX() And Self._eat.y = Self._snake.HeadY()) Then 
			Self._snake.Eat()
			Game.Interval-=2
			Game.Scores+=100
			Self.GiveFood()
		End If
		
		Self._snake.Update()
		
		if(Self._snake.HeadX() < 0 Or Self._snake.HeadX() > Self._countCellsX - 1) Then
			Game.SetState(Game.STATE_GAMEOVER)
			return
		End if
		
		if(Self._snake.HeadY() < 0 Or Self._snake.HeadY() > Self._countCellsY - 1) Then
			Game.SetState(Game.STATE_GAMEOVER)
			return
		End if
		
		Self._cells[Self._snake.HeadX()][Self._snake.HeadY()] = GameField.SNAKE_HEAD
		For Local c:=EachIn Self._snake.Body()
			if(c.x = Self._snake.HeadX() And c.y = Self._snake.HeadY()) Game.SetState(Game.STATE_GAMEOVER)
			Self._cells[c.x][c.y] = GameField.SNAKE_BODY
		Next
	End
	
	Method Draw()				
		For Local x:= 0 to Self._countCellsX - 1
			For Local y:= 0 to Self._countCellsY - 1
				Select(Self._cells[x][y])
					Case GameField.SNAKE_BODY, GameField.SNAKE_HEAD, GameField.FOOD
						SetColor(21, 36, 31)
						DrawRect(Self._originX + x*Self._cellSize + 1, Self._originY + y*Self._cellSize + 1 , Self._cellSize - 2, Self._cellSize - 2)
						SetColor(81,96,89)
						DrawRect(Self._originX + x*Self._cellSize + 2, Self._originY + y*Self._cellSize  + 2, Self._cellSize - 4, Self._cellSize - 4)
						SetColor(21, 36, 31)
						DrawRect(Self._originX + x*Self._cellSize + 4, Self._originY + y*Self._cellSize  + 4, Self._cellSize - 8, Self._cellSize - 8)
						SetColor(0, 0, 0)
				End	
			Next
		Next	
		
		SetColor(0, 0, 0)	
		DrawLine(Self._originX, Self._originY, Self._originX + Self._width, Self._originY)
		DrawLine(Self._originX + Self._width, Self._originY, Self._originX + Self._width, Self._originY + Self._height)	
		DrawLine(Self._originX + Self._width, Self._originY + Self._height, Self._originX, Self._originY + Self._height)	
	    DrawLine(Self._originX, Self._originY + Self._height, Self._originX, Self._originY)	
		DrawLine(Self._originX, Self._originY, Self._originX + Self._width, Self._originY)
		DrawLine(Self._originX + Self._width, Self._originY, Self._originX + Self._width, Self._originY + Self._height)	
		DrawLine(Self._originX + Self._width, Self._originY + Self._height, Self._originX, Self._originY + Self._height)	
	    DrawLine(Self._originX, Self._originY + Self._height, Self._originX, Self._originY)	
	End
	
	Method GetSnake:Snake()
		Return Self._snake
	End Method
	
	Method GiveFood:Void()
		Self._eat = New Coord()
		
		Repeat
			Self._eat.x = Rnd(0, self._countCellsX - 1)
			Self._eat.y = Rnd(0, self._countCellsY - 1)
			
			local e = true
			For Local c:=EachIn Self._snake.Body()
				if(c.x = Self._eat.x And c.y = Self._eat.y) e = false
			Next
			if(Self._snake.HeadX() = Self._eat.x And Self._snake.HeadY() = Self._eat.y) e = false
			
			if(e) Exit
		Forever
	End Method
End