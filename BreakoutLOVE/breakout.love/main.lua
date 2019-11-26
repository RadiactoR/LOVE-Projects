function love.load()
  --keyboard blockers
  cPressed = false
  useMouse = false
  
  --game variables
  brickRows = 2
  gameOver = false
  
  red = 255
  green = 0
  blue = 255

  --brick variables
  numberOfBricks = 30
  brickWidth = 50
  brickHeight = 10
  xPos = 10
  yPos = 10
  bricks = {}
  createBrick = function()
    brick = {}
    brick.x = xPos
    brick.y = yPos
    brick.r = red
    brick.g = green
    brick.b = blue
    table.insert(bricks, brick)
  end
  
  --ball variables
  ballX = 100
  ballY = 200
  ballSpeedX = 5
  ballSpeedY = 5
  
  --player variables
  playerX = 10
  playerY = 580
  playerSpeed = 10
end

function love.update(dt)
  
  --create the bricks
  if (cPressed == false) then
    if (love.keyboard.isDown("c")) then
      for i= 1,numberOfBricks do
        createBrick()
        --check if it will fit
        if (brick.x + 60 >= (love.graphics.getWidth() - 10)) then
          xPos = 10
          yPos = yPos + 30
        else
          xPos = xPos + 60
        end
      end
      cPressed = true
    end
  end

  --player movement
  if (love.keyboard.isDown("d") and (playerX + 60) < love.graphics.getWidth()) then
    playerX = playerX + playerSpeed
  end
  if (love.keyboard.isDown("a") and playerX > 10) then
    playerX = playerX - playerSpeed
  end
  if (useMouse == true) then
    playerX = love.mouse.getX()
  end
  
  if love.keyboard.isDown("m") then
    if (useMouse == true) then
      useMouse = false
    else
      useMouse = true
    end
  end
  
  --ball collision with player
  if ((ballY + 10) >= playerY and ballY <= (playerY + 10)) then
    if ((ballX + 10) >= playerX and ballX <= (playerX + 60)) then
      if (ballSpeedY > 0) then
        ballSpeedY = ballSpeedY * -1
      end
    end
  end
  
  --ball collision with brick
  for _,v in pairs(bricks) do
    if (ballY <= (v.y + brickHeight) and (ballY + 10) >= v.y) then
      if ((ballX + 10) >= v.x and ballX < (v.x + brickWidth)) then
        ballSpeedY = ballSpeedY * -1
        table.remove(bricks, _)
      end
    end
  end
  
  --ball collision with walls
  if ((ballX + 10) >= love.graphics.getWidth() or ballX <= 0) then
    ballSpeedX = ballSpeedX * -1
  end
  if (ballY <= 0) then
    ballSpeedY = ballSpeedY * -1
  end
  
  --respawn ball (if bugged out)
  if love.keyboard.isDown("r") then
    ballX = 100
    ballY = 200
    ballSpeedX = 5
    ballSpeedY = 5
  end
end

function love.draw()
  
  --print the window resolution
  love.graphics.print("X: " .. love.graphics.getWidth() .. " Y: " .. love.graphics.getHeight() .. ". #bricks: " .. #bricks)
  
  --draw the ball
  love.graphics.ellipse("fill", ballX, ballY, 5, 5)
  
  --make the ball move
  ballX = ballX + ballSpeedX
  ballY = ballY + ballSpeedY
  
  --draw the bricks
  for _,v in pairs(bricks) do
    love.graphics.setColor(v.r, v.g, v.b)
    love.graphics.rectangle("fill", v.x, v.y, brickWidth, brickHeight)
  end
  
  --draw the player
  love.graphics.setColor(255, 255, 255)
  love.graphics.rectangle("fill", playerX, playerY, 50, 10)
end