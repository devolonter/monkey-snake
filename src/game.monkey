Import mojo

Import src.gamefield
Import src.angelfont

class Game extends App
	Private
	Field _gameField:GameField
	Field _time:Int
	Field _scores:AngelFont
	Field _text:AngelFont
	Field _turn:Bool
	
	Global _state:int
	
	Public
	Global Interval:Int
	Global Scores:Int
	
	Const CELL_SIZE:=20
	
	Const STATE_START:Int = 1
	Const STATE_PLAY:Int = 2
	Const STATE_GAMEOVER:Int = 3
	
	Method OnCreate()	
		SetUpdateRate(60)
		
		Self._scores = New AngelFont()
		Self._scores.LoadFont("digital")
		
		Self._text = New AngelFont()
		Self._text.LoadFont("text")
					
		Self.Reset()		
	End
	
	Method Reset()
		Self._gameField = null
		Self._gameField = new GameField(Game.CELL_SIZE, DeviceWidth() - Game.CELL_SIZE, DeviceHeight() - Game.CELL_SIZE*3)	
		Self._gameField.SetOriginY(Game.CELL_SIZE*2.5)
		Self._gameField.GetSnake().Move(Direction.NONE)
		Self._state = Game.STATE_START
		Self._gameField.Update()
		Self._turn = false
		Self._time = Millisecs()
		Self.Interval = 150
		Self.Scores = 0
	End Method
	
	Method OnUpdate()		
		#If TARGET <> "html5" And TARGET <> "flash"
			if(KeyHit(KEY_ESCAPE)) Then
				Error ""
			End if
		#End If
	
		Select(Self._state)
			Case Game.STATE_START
				#If TARGET="android" or TARGET="ios"
					if(TouchHit()) Then
						Self.SetState(Game.STATE_PLAY)
						Self._gameField.GetSnake().Move(Direction.RIGHT)
					End If	
				#Else
					if(KeyHit(KEY_SPACE)) Then
						Self.SetState(Game.STATE_PLAY)
						Self._gameField.GetSnake().Move(Direction.RIGHT)
					End If
				#Endif
			Case Game.STATE_PLAY
				if(Not Self._turn) Then
					#If TARGET="android" or TARGET="ios"
						If(TouchHit()) Then						
							local d = Direction.NONE
							local x:Int = Self._gameField.GetSnake().HeadX()*Game.CELL_SIZE
							local y:Int = Self._gameField.GetSnake().HeadY()*Game.CELL_SIZE
							local tx:Float = TouchX()
							local ty:Float = TouchY()
							
							if(Self._gameField.GetSnake().GetDirection() = Direction.UP Or 
								Self._gameField.GetSnake().GetDirection() = Direction.DOWN) Then
								if(tx > x) d = Direction.RIGHT
								if(tx < x) d = Direction.LEFT
							End If
							
							if(Self._gameField.GetSnake().GetDirection() = Direction.RIGHT Or 
								Self._gameField.GetSnake().GetDirection() = Direction.LEFT) Then
								if(ty > y) d = Direction.DOWN
								if(ty < y) d = Direction.UP
							End If						
							
							if(d = Direction.UP) Then 
								if(Self._gameField.GetSnake().GetDirection() <> Direction.DOWN) Then
									Self._gameField.GetSnake().Move(Direction.UP)
									Self._turn = True
								End If
							End if
							
							if(d = Direction.RIGHT) Then 
								if(Self._gameField.GetSnake().GetDirection() <> Direction.LEFT) Then 
									Self._gameField.GetSnake().Move(Direction.RIGHT)
									Self._turn = True
								End If						
							End If
							
							if(d = Direction.DOWN) Then
								if(Self._gameField.GetSnake().GetDirection() <> Direction.UP) Then 
									Self._gameField.GetSnake().Move(Direction.DOWN)
									Self._turn = True
								End If
							End If
							
							if(d = Direction.LEFT) Then 
								if(Self._gameField.GetSnake().GetDirection() <> Direction.RIGHT) Then
									Self._gameField.GetSnake().Move(Direction.LEFT)
									Self._turn = True
								End If
							End if
						End If
					#Else
						if(KeyHit(KEY_UP)) Then 
							if(Self._gameField.GetSnake().GetDirection() <> Direction.DOWN) Then
								Self._gameField.GetSnake().Move(Direction.UP)
								Self._turn = True
							End If
						End if
						
						if(KeyHit(KEY_RIGHT)) Then 
							if(Self._gameField.GetSnake().GetDirection() <> Direction.LEFT) Then 
								Self._gameField.GetSnake().Move(Direction.RIGHT)
								Self._turn = True
							End If						
						End If
						
						if(KeyHit(KEY_DOWN)) Then
							if(Self._gameField.GetSnake().GetDirection() <> Direction.UP) Then 
								Self._gameField.GetSnake().Move(Direction.DOWN)
								Self._turn = True
							End If
						End If
						
						if(KeyHit(KEY_LEFT)) Then 
							if(Self._gameField.GetSnake().GetDirection() <> Direction.RIGHT) Then
								Self._gameField.GetSnake().Move(Direction.LEFT)
								Self._turn = True
							End If
						End if
					#Endif
				End if
				if(Millisecs() - Self._time > Game.Interval) Then
					Self._gameField.Update()
					Self._time = Millisecs()
					Self._turn = False
				End If
			Case Game.STATE_GAMEOVER
				#If TARGET="android" or TARGET="ios"
					if(TouchHit()) Then
						Self.SetState(Game.STATE_START)
						Self.Reset()
					End If
				#Else
					if(KeyHit(KEY_SPACE)) Then
						Self.SetState(Game.STATE_START)
						Self.Reset()
					End If
				#Endif
		End Select
						
	End
	
	Method OnRender()
		Cls(120,138,126)
		
		SetColor(120,138,126)
		DrawRect(0, 0, DeviceWidth(), DeviceHeight())
		SetColor(255,255,255)
		
		Self._scores.DrawText(Game.Scores, Game.CELL_SIZE, 0)
		
		Self._gameField.Draw()	
		
		Select(Self._state)
			Case Game.STATE_START
				local text:String = "Press space to start"
				Self._text.DrawText(text, DeviceWidth()*.5, DeviceHeight()*.6, AngelFont.ALIGN_CENTER)
			Case Game.STATE_GAMEOVER
				Self._text.DrawText("Game Over", DeviceWidth()*.5, DeviceHeight()*.6, AngelFont.ALIGN_CENTER)
				Self._text.DrawText("Press space to reset", DeviceWidth()*.5, DeviceHeight()*.68, AngelFont.ALIGN_CENTER)
		End Select
	
	End Method
	
	Function SetState:Void(state:int)
		Game._state = state
	End Function
End Class