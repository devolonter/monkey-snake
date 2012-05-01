Class Direction
	Const NONE:Int = 0
	Const UP:Int = 1
	Const RIGHT:Int = 2
	Const DOWN:Int = 3
	Const LEFT:Int = 4
End

Class Coord
	field x:int, y:int
	
	Method New(x,y)
		Self.x = x
		Self.y = y
	End Method
End Class

Class Snake

	Private
	Field _direction:Int
	Field _body:= new List<Coord>
	Field _head:= new Coord(0,0)
	
	Public
	Method New(size:Int, x:Int, y:Int, horizontal:Bool)	
		if(Not horizontal) Then
			For Local i:= 1 to size - 1
				Self._body.AddLast(new Coord(x, y - i))					
			Next
			
			Self._head.x = x
			Self._head.y = y
		Else
			For Local i:= 1 to size - 1
				Self._body.AddLast(new Coord(x - i, y))					
			Next
			
			Self._head.x = x
			Self._head.y = y			
		End If		
	End Method
	
	Method Update:Void()
		local lastCoord:Coord = new Coord(Self._head.x, Self._head.y)
		
		Select(Self._direction)
			Case Direction.UP
				Self._head.y-=1
			Case Direction.DOWN
				Self._head.y+=1
			Case Direction.RIGHT
				Self._head.x+=1
			Case Direction.LEFT
				Self._head.x-=1
		End Select
		
		if(Self._direction)			
			For Local c:=EachIn Self._body
				Local oldX:=lastCoord.x
				Local oldY:=lastCoord.y				
				lastCoord.x = c.x	
				lastCoord.y = c.y
				
				if(c.x = oldX And c.y = oldY) Then
					c.x = oldX	
					c.y = oldY
					Exit
				Else
					c.x = oldX	
					c.y = oldY
				End If					
			Next
		End If
	End Method
	
	Method Move:Void(direction:int)
		Self._direction = direction
	End Method
	
	Method GetDirection:Int()
		Return Self._direction
	End Method
	
	Method Body:List<Coord>()
		return Self._body
	End Method
	
	Method HeadX:Int()
		return Self._head.x
	End Method
	
	Method HeadY:Int()
		return Self._head.y
	End Method
	
	Method Eat:Void()
		local lastCoord:Coord = new Coord(Self._head.x, Self._head.y)		
		Self._body.AddFirst(lastCoord)	 
	End Method		
End Class