-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------
local ground, ground1, ground2, ground3, ground4, background,background1,walkLeft,walkRight,band

local scores = 0

local scoresLabel 
scoresLabel = display.newText( "Scores", -1300,370, 300,300, "Fonts/ANASTAS.TTF",  150)
scoresLabel:setFillColor( 1, 1, 0 )


local scoresText 
scoresText = display.newText( scores, -1000,370, 300,300, "Fonts/ANASTAS.TTF", 150 )
scoresText:setFillColor( 1, 1, 1 )

local lives = 3
local livesLabel =  display.newText( "Lives", -1300,180, 300,300, "Fonts/ANASTAS.TTF", 150 )
livesLabel:setFillColor( 1, 1, 0 )
local livesText =  display.newText( lives, -1020,180, 300,300, "Fonts/ANASTAS.TTF", 150 )
livesText:setFillColor( 1, 1, 1 )



local arrows = 5

local arrowsLabel =  display.newText( "Arrows", 2100,250, 400,400, "Fonts/ANASTAS.TTF", 150 )
arrowsLabel:setFillColor( 1, 1, 0 )


local arrowsText =  display.newText( arrows, 2450,190, 300,300, "Fonts/ANASTAS.TTF", 150 )
livesText:setFillColor( 1, 1, 1 )


local backgroundMusic

local composer = require( "composer" )

local scene = composer.newScene()


-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------

-- forward declarations and other locals

local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX


-- Button's

local  buttonLeft


local buttonRight


local buttonJump

local  buttonShoot 

local perspective = require("perspective")


local camera 
camera = perspective.createView()

--local camera
local bullet



--Hero sprisheet

local sheetOptions =
{
    width = 174,
    height = 224,
    numFrames = 22
}

local moveHero =  graphics.newImageSheet( "Images/spritesherofn.png", sheetOptions )



local sequences_hero = {
    -- first sequence (consecutive frames)
	{
        name = "idleLeft",
        frames = { 20},
        loopCount = 0
    },
    {
        name = "idleRight",
        frames = { 21},
        loopCount = 0
    },
    
	{
        name = "walkLeft",
        --start = 1,
        --count = 6,
        frames = { 1,2,3,4,5,6},
        time = 800,
        loopCount = 0,
    	loopDirection = "forward"

    },
    {
        name = "walkRight",
        start = 7,
        time = 	800,
        count = 6,
        loopCount = 0,
    	loopDirection = "forward"
    	

    },
    {
        name = "jumpLeft",
        frames = { 20},
        loopCount = 0,
        time = 1500
    },
    {
        name = "jumpRight",
        frames = { 17,21},
        time =  200,
        loopCount = 0
    },

    {
    	name = "shootLeft",
    	frames = { 15,16},
      	time =  700,
        loopCount = 0  
   	},
    {
    	name = "shootRight",
    	frames = { 22,19},
      	time =  700,
        loopCount = 0  
   	}
}

local hero = {} 

hero = display.newSprite( moveHero, sequences_hero )

hero:setSequence("idleRight")

hero:play()

local lumberjackOption = {
	width = 243,
	height = 282,
	numFrames = 10
}


local moveLumberJack =  graphics.newImageSheet( "Images/spritesenemy1fn.png", lumberjackOption )

local sequences_lumberjack = {
    -- first sequence (consecutive frames)
	{
        name = "walkEnemy2",
        start = 6,
        time = 	500,
        count = 5,
        loopCount = 0,
    	loopDirection = "forward"
    	
	}
}

local hunterOptions = {
	width = 136,
	height = 184,
	numFrames = 6
}


local moveHunter =  graphics.newImageSheet( "Images/enemy1.png", hunterOptions)

local sequences_hunter = {
    -- first sequence (consecutive frames)
	{
        name = "walkEnemy1",
        start = 4,
        time = 	500,
        count = 1,
        loopCount = 0,
    	loopDirection = "forward"
    	
	}
}

local originHero
local arrow = {}
local enemy = {}
enemy = display.newSprite( moveLumberJack, sequences_lumberjack )

enemy:setSequence("walkEnemy2")

enemy:play()

local enemy1 = {}

enemy1 = display.newSprite( moveLumberJack, sequences_lumberjack )

enemy1:setSequence("walkEnemy2")

enemy1:play()

local enemy2 = {}

enemy2 = display.newSprite( moveLumberJack, sequences_lumberjack )

enemy2:setSequence("walkEnemy2")

enemy2:play()


local enemy3 = {}

enemy3 = display.newSprite( moveLumberJack, sequences_lumberjack )

enemy3:setSequence("walkEnemy2")

enemy3:play()

local enemy4 = {}

local enemy4 = {}

enemy4 = display.newSprite( moveLumberJack, sequences_lumberjack )

enemy4:setSequence("walkEnemy2")

enemy4:play()

local heart

local arrowCounter

audio.reserveChannels( 1 )
audio.setVolume( 0.5, { channel=1} )


function scene:create( event )

	local sceneGroup = self.view
	
	--physics.setDrawMode("hybrid")
	physics.start()

	physics.pause()

	backgroundMusic = audio.loadStream( "Music/TheForest.wav" )

	
	background = display.newImageRect( "Images/bg.png", screenW, screenH)
	
	background.x = 0 
	background.y = display.screenOriginY

	background.anchorX = 0 
	background.anchorY = 0
	background.alpha = 0.95
	background1 = display.newImageRect( "Images/bg0.png", screenW, screenH)
	background1.x = screenW-10 
	background1.y = display.screenOriginY
	background1.alpha = 0.95
	

	background1.anchorX = 0 
	background1.anchorY = 0
	--background:setFillColor( .5 )
	--background.alpha = 0.7
	--background1.alpha = 0.7
	

	ground = display.newImageRect("Images/teste.png", screenW*6,200)

	ground.x = display.screenOriginX
	
	ground.y = display.contentHeight-30

	ground.id = "ground"

	ground.objType = "ground"

	physics.addBody( ground, "static",{ bounce=0.0, friction=0.3 } )
	
	wallLeft = display.newRect(10, display.contentHeight, 10, display.contentHeight)

	wallLeft.x = 0
	wallLeft.y = display.contentCenterY
	wallLeft.alpha = 0
	physics.addBody(wallLeft, "static",{ bounce=0.0, friction=0.3 } )
	
	
	wallRight = display.newRect(10, display.contentHeight, 10, display.contentHeight)

	wallRight.x = 10800
	wallRight.y = display.contentCenterY
	wallRight.alpha = 0
	physics.addBody(wallRight, "static",{ bounce=0.0, friction=0.3 } )
	


	ground1 = display.newImageRect("Images/plataforma1.png", 1000,200)

	ground1.x = 1800
	
	ground1.y = display.contentHeight - 225

	ground1.id = "ground"

	ground1.objType = "ground"

	physics.addBody( ground1, "static",{ bounce=0.0, friction=0.3 } )
	
	
	ground2 = display.newImageRect("Images/plataforma2.png", 1000,430)

	ground2.x = 2800
	
	ground2.y = display.contentHeight - 320

	ground2.id = "ground"

	ground2.objType = "ground"

	physics.addBody( ground2, "static",{ bounce=0.0, friction=0.3 } )
	
	ground3 = display.newImageRect("Images/plataforma3.png",3000,640)
	
	ground3.x = 4800

	ground3.y = display.contentHeight - 420

	ground3.id = "ground"

	ground3.objType = "ground"

	physics.addBody( ground3, "static",{ bounce=0.0, friction=0.3 } )
	


	ground4 = display.newImageRect("Images/plataforma3.png", 2000,400)

	ground4.x = 7300

	ground4.y = display.contentHeight - 320

	ground4.id = "ground"

	ground4.objType = "ground"

	physics.addBody( ground4, "static",{ bounce=0.0, friction=0.3 } )
	

	hero.x = 180

	hero.id = "hero"
	hero.y = display.contentHeight-172

	
	
	hero.speed = 1
	
    hero.sensorOverlaps = 0
    

	physics.addBody( hero,"dynamic", { density=3, friction=0.5, bounce= 0.0 } )

	
	hero.isFixedRotation = true

	--enemy = display.newRect(100,200,100,200)

	enemy.x = 2100

	enemy.y = display.contentHeight-225
	enemy.id = "enemy"
	enemy.objType = "enemy"
	
	physics.addBody(enemy,"dynamic", { density=3, friction=0.5, bounce= 0.0 })

	enemy.isFixedRotation = true

	--enemy1 = display.newRect(100,200,100,200)

	enemy1.x = 2800
	
	enemy1.y = display.contentHeight -320
	physics.addBody(enemy1,"dynamic", { density=3, friction=0.5, bounce= 0.0 })

	enemy1.isFixedRotation = true

	enemy1.id = "enemy1"
	enemy1.objType = "enemy"

	--enemy2 = display.newRect(100,200,100,200)

	enemy2.x = 4800
	enemy2.y = display.contentHeight -520
	enemy2.objType = "enemy"
	physics.addBody(enemy2,"dynamic", { density=3, friction=0.5, bounce= 0.0 })

	enemy2.isFixedRotation = true

	enemy2.id = "enemy2"

	enemy3.x = 5600
	enemy3.y = display.contentHeight -520
	enemy3.objType = "enemy"
	physics.addBody(enemy3,"dynamic", { density=3, friction=0.5, bounce= 0.0 })

	enemy3.isFixedRotation = true

	enemy3.id = "enemy3"

	enemy4.x = 8000
	enemy4.y = display.contentHeight - 480
	enemy4.objType = "enemy"
	physics.addBody(enemy4,"dynamic", { density=3, friction=0.5, bounce= 0.0 })

	enemy4.isFixedRotation = true

	enemy4.id = "enemy4"

	band = display.newImageRect("Images/band.png", 180,180)
	
	band.x = 9800

	band.y = display.contentHeight-190
	physics.addBody( band, "static",{ bounce=0.0, friction=0.3 } )
	
	band.id = "band"

	
	
	buttonLeft = display.newImageRect("Images/btnleft.png", 300,300)

	buttonLeft.id = "left"

	buttonLeft.x= -1000

	buttonLeft.y = display.contentHeight-200
	
	buttonLeft.alpha = 0.6

	buttonLeft:addEventListener("touch",doControls)


	 
	


	-- Move to right


	buttonRight = display.newImageRect("Images/btright.png", 300,300)

	buttonRight.id = "right"

	buttonRight.x = -600

	buttonRight.alpha = 0.6

 	buttonRight.y = display.contentHeight-200
	buttonRight:addEventListener("touch", doControls)


	-- jumpRight

	buttonJump = display.newImageRect("Images/btnjump.png", 300,300)
	buttonJump.id = "jump"

	buttonJump.x = 1650

	buttonJump.alpha = 0.6

 	buttonJump.y = display.contentHeight-200
	buttonJump:addEventListener("touch", doControls)

	-- shoot
	buttonShoot = display.newImageRect("Images/btnarrow.png", 300,300)
	

	buttonShoot.x = 2000

	buttonShoot.y = display.contentHeight-200

	buttonShoot.alpha = 0.6
	buttonShoot:addEventListener("touch", shootArrows)

	buttonShoot.id = "shoot"

	heart = display.newImageRect("Images/heart.png",120,120)
	heart.x = -1000
	heart.y = 120
	--scoresText.text = scores

	
	arrowCounter = display.newImageRect("Images/arrowCounter.png",200,200)
	arrowCounter.x = 2520
	arrowCounter.y = 140
	arrowCounter:rotate(90)

	Runtime:addEventListener("collision", arrowCollide)	
	
	Runtime:addEventListener("collision",jumpCollide)	
	
	Runtime:addEventListener("collision",heroHit)	
	
	Runtime:addEventListener("enterFrame",callGameOver)	
	
	Runtime:addEventListener("collision", movieEnemies)	

	Runtime:addEventListener("collision", collisionHeroBand)	


	camera:add(hero,1,true)	
	camera:add(enemy,2,false)

	camera:add(enemy1,2,false)
	camera:add(enemy2,2,false)
	camera:add(enemy3,2,false)
	camera:add(enemy4,2,false)

	camera:add(band,2,false)


	camera:add(ground,3,false)	
	camera:add(ground1,3,false)
	camera:add(ground2,3,false)
	camera:add(ground3,3,false)
	
		
	camera:add(ground4,3,false)	
	
	camera:add(wallLeft,4,false)
	camera:add(wallRight,4,false)
	
	camera:add(heart,4,false)
	
	camera:add(background,5,false)	
	camera:add(background1,5,false)	

	camera:layer(2).paralaxRatio= 0.5
		local levelWidth = display.actualContentWidth*4-1100
		camera:setBounds(display.actualContentWidth/2,levelWidth-display.actualContentWidth*2-1800, display.contentHeight-1200, display.contentHeight-1200)	
		
		if(hero.x > 1260)then
			camera:remove(ground1)
		end	
	
		
		sceneGroup:insert(camera)


		sceneGroup:insert( buttonLeft )
		sceneGroup:insert( buttonRight)
		sceneGroup:insert( buttonJump)
		sceneGroup:insert( buttonShoot)
		sceneGroup:insert(scoresLabel)
		sceneGroup:insert(scoresText)
		sceneGroup:insert(livesLabel)
		sceneGroup:insert(livesText)
		sceneGroup:insert(heart)
		sceneGroup:insert(arrowsLabel)
		sceneGroup:insert(arrowsText)
		sceneGroup:insert(arrowCounter)

	
end

function movieEnemies(event)
	
	local object1 = event.object1

 	local object2 = event.object2
	
	 
	 
 	
	 if ( object1.id == "ground" and object2.id == "enemy"  or
	 		object1.id == "enemy" and object2.id == "ground") then
 		
        -- Foot sensor has entered (overlapped) a ground object
        if ( event.phase == "began" ) then
			Runtime:addEventListener("enterFrame",enemyEnterFrame)

        elseif ( event.phase == "ended" ) then
			Runtime:removeEventListener("enterFrame",enemyEnterFrame)

        end
	
	
	elseif ( object1.id == "ground" and object2.id == "enemy1" ) then
		-- Foot sensor has entered (overlapped) a ground object
		if ( event.phase == "began" ) then

			Runtime:addEventListener("enterFrame",enemy1EnterFrame)
				

		elseif ( event.phase == "ended" ) then
			Runtime:removeEventListener("enterFrame",enemy1EnterFrame)
				
		end
	
		
	elseif ( object1.id == "ground" and object2.id == "enemy2" ) then
	
		-- Foot sensor has entered (overlapped) a ground object
		if ( event.phase == "began" ) then
			Runtime:addEventListener("enterFrame",enemy2EnterFrame)
				
		elseif ( event.phase == "ended" ) then
			Runtime:removeEventListener("enterFrame",enemy2EnterFrame)
				
		end
	
	elseif ( object1.id == "ground" and object2.id == "enemy3" ) then
	
		-- Foot sensor has entered (overlapped) a ground object
		if ( event.phase == "began" ) then
			Runtime:addEventListener("enterFrame",enemy3EnterFrame)
				
		elseif ( event.phase == "ended" ) then
			Runtime:removeEventListener("enterFrame",enemy3EnterFrame)
				
		end
	elseif ( object1.id == "ground" and object2.id == "enemy4" ) then
	
		-- Foot sensor has entered (overlapped) a ground object
		if ( event.phase == "began" ) then
			Runtime:addEventListener("enterFrame",enemy4EnterFrame)
				
		elseif ( event.phase == "ended" ) then
			Runtime:removeEventListener("enterFrame",enemy4EnterFrame)
				
		end
	
	
			
	end
end

function enemyEnterFrame()
	
	enemy:setLinearVelocity(-300,0)
	
end


function enemy1EnterFrame()
	
	enemy1:setLinearVelocity(-320,150)
	
end



function enemy2EnterFrame()
	
	enemy2:setLinearVelocity(-300,80)
	
end

function enemy3EnterFrame()
	
	enemy3:setLinearVelocity(-300,150)
	
end


function enemy4EnterFrame()
	
	enemy4:setLinearVelocity(-200,150)
	
end


local hX , hY
local  isLeft, isRight

local  shootLeft  = false

local shootRight = true

function doControls(event)
	local pressed = event.target

	
	if event.phase == "began" then
		
		if pressed.id == "left" then
			
			shootLeft = true
			
			shootRight = false
			
			if(hero.x > 170) then
				if lives> 0 then
					display.currentStage:setFocus(buttonLeft)
					
				
					local  x = hero.x + hero.speed

					hero:applyLinearImpulse(-200,0, x, hero.y)
					hero:setSequence( "walkLeft")
					-- switch to "fastRun" sequence
					hero:play()
					
					hX = -hero.x
					hY = hero.y
					isLeft = true
					--hero.velocity = -hero.speed
					Runtime:addEventListener("enterFrame", moveHeroEnterFrame)
				end	
			end
		elseif pressed.id == "right" then
			if lives > 0 then
				shootRight = true	
				shootLeft = false
				display.currentStage:setFocus(buttonRight)

				hero:applyLinearImpulse(200,0, hero.x, hero.y)
				hero:setSequence( "walkRight" )  -- switch to "fastRun" sequence
				hero:play()
				
				hX = hero.x
				hY = hero.y

				isRight = true

				Runtime:addEventListener("enterFrame", moveHeroEnterFrame)
			end	

		elseif pressed.id == "jump" and hero.sensorOverlaps > 0 then
			
			
				
				display.currentStage:setFocus(buttonJump)
				local vx, vy = hero:getLinearVelocity()
				
					

				hero:applyLinearImpulse(0,-1700, hero.x, hero.y)
				
				hero.count = 1
				event.target.isFocus = true
				if  isLeft == true then
					
					hero:play()
	    		else 
	    			hero:play()
	    		end
		
			end

	elseif event.phase == "ended" or event.phase == "cancelled" then 	
		isLeft = false	
		isRight = false
		if pressed.id == "left" then

			display.currentStage:setFocus(nil)
			Runtime:removeEventListener("enterFrame",moveHeroEnterFrame)
			--buttonLeft:removeEventListener("touch", moveHeroEnterFrame)
			hero:setSequence( "idleLeft" )
		
		elseif pressed.id == "right" then
			--buttonRight:removeEventListener("touch", moveHeroEnterFrame)
			Runtime:removeEventListener("enterFrame",moveHeroEnterFrame)

			display.currentStage:setFocus(nil)
			
			hero:setSequence( "idleRight" )  -- switch to "fastRun" sequence
			
		
		elseif pressed.id == "jump" then
			display.currentStage:setFocus(nil)
			
			--hero:setSequence( "idleRight")  -- switch to "fastRun" sequence
			hero:play()
		end
		
			
	end 

end

local function updateText()
	--scores = scores+10
	scoresText.text = scores
	livesText.text = lives
	arrowsText.text = arrows
end

function heroHit(event)

	local object1 = event.object1

 	local object2 = event.object2

	 if (event.phase == "began") then
		if ( object1.objType == "enemy" and object2.id == "hero" ) or
			( object1.id == "hero" and object2.objType == "enemy" ) 
		then
				lives = lives -1
				Runtime:addEventListener("enterFrame", updateText)
				Runtime:removeEventListener("enterFrame",enemyEnterFrame)
				Runtime:removeEventListener("enterFrame",enemy1EnterFrame)
				Runtime:removeEventListener("enterFrame",enemy2EnterFrame)
				Runtime:removeEventListener("enterFrame",enemy3EnterFrame)
				Runtime:removeEventListener("enterFrame",enemy4EnterFrame)
				
			
				object1.alpha = 0.8
				camera:remove(object2)
				display.remove(object2)

			
		end
	elseif (event.phase == "ended") then
		Runtime:removeEventListener("enterFrame",updateText)
		
		object1.alpha = 1.0
	end
end

function shootArrows(event)
	local l = false
	if event.phase == "began" then
		
		if event.target.id == "shoot" then
			display.currentStage:setFocus(buttonShoot)
		
			if shootRight == true then
				if arrows > 0 then
					arrows = arrows - 1
					Runtime:addEventListener("enterFrame", updateText)
				
					l = true
					hero:setSequence("shootRight")
					
					hero:play()
								
					
								
					local arrow = display.newImageRect("Images/arrow1.png",100,100)
					
					camera:add(arrow,2,false)
					
					physics.addBody( arrow, "dynamic",{isSensor = true})

					arrow.gravityScale = 0

					arrow.isBullet = true
					arrow.x = hero.x+90
					
					
					
					arrow.y = hero.y-20
					
					arrow.id = "arrow"

					transition.to( arrow, { x=hero.x+1800, time=1000,
					onComplete = function() display.remove( arrow ) end
				} )
				end
			elseif shootLeft == true then 
				if arrows > 0 then
					
					arrows = arrows - 1
					Runtime:addEventListener("enterFrame", updateText)
				

					hero:setSequence("shootLeft")
					
					hero:play()
				
					local arrow = display.newImageRect("Images/arrow1.png",100,100)
					
					camera:add(arrow,2,false)
					
					physics.addBody( arrow, "dynamic",{isSensor = true})

					arrow.gravityScale = 0

					arrow.isBullet = true
					arrow.x = hero.x-90
					
					arrow.y = hero.y-20
					arrow.id = "arrow"
					arrow:rotate(180)
					--transition.to( arrow, { x= 1400, time=800, } )


					arrow:setLinearVelocity( -800, 0 )
					
					transition.to( arrow, { x=hero.x-1800, time=1000,
					onComplete = function() display.remove( arrow ) end
				} )
				end
			end	
		end
	elseif event.phase == "ended" then
		if event.target.id == "shoot" then
			
			Runtime:removeEventListener("enterFrame", updateText)

			display.currentStage:setFocus(nil)

			transition:cancel(arrow)

			if shootRight == true then
				hero:setSequence("idleRight")
				
			elseif isLeft == true then
				hero:setSequence("idleLeft")
				hero:play()
			end	
		end
	end
end



function moveHeroEnterFrame()
	if isLeft == true then
		if lives > 0 then
		hero:setLinearVelocity(-350,190)

		hero:applyLinearImpulse(-250,0, hero.x, hero.y)
		end	
	elseif isRight == true then
		if lives > 0 then
		
		hero:setLinearVelocity(350,190)

		hero:applyLinearImpulse(250,0, hero.x, hero.y)
		end
	end 

	
end


function arrowCollide(event)
	local object1 = event.object1

 	local object2 = event.object2
	 
 	
	 if ( object1.id == "ground" and object2.id == "arrow" )or
	 ( object1.id == "arrow" and object2.id == "ground" )
	 then
 		
        -- Foot sensor has entered (overlapped) a ground object
        if ( event.phase == "began" ) then
        	display.remove(arrow)
			camera:remove(object2)
        elseif ( event.phase == "ended" ) then
        
        end
	
	elseif (( object1.objType == "enemy" and object2.id == "arrow" )or
	( object1.id == "arrow" and object2.objType == "enemy" ) )then
		if event.phase == "began" then
		
				Runtime:addEventListener("enterFrame", updateText)
				Runtime:removeEventListener("enterFrame",enemyEnterFrame)
				Runtime:removeEventListener("enterFrame",enemy1EnterFrame)
				Runtime:removeEventListener("enterFrame",enemy2EnterFrame)
				Runtime:removeEventListener("enterFrame",enemy3EnterFrame)
				Runtime:removeEventListener("enterFrame",enemy4EnterFrame)
			
				display.remove(object1)
				
				display.remove(object2)
				camera:remove(object1)
				camera:remove(object2)
				
				scores= scores+10
				
				if(scores % 20 == 0) then
					if(lives <3) then
						lives = lives +1
					end
				end

				if(scores % 30 == 0) then
					if(arrows < 5) then
						arrows = arrows +1
					end
				end
		
			elseif event.phase == "ended" then
				Runtime:removeEventListener("enterFrame", updateText)
			end			
	end
	
end

function jumpCollide( event)


 	local object1 = event.object1

 	local object2 = event.object2
	
	if ( object1.id == "ground" and object2.id == "hero" ) then
 		
        -- Foot sensor has entered (overlapped) a ground object
        if ( event.phase == "began" ) then
            object2.sensorOverlaps = object2.sensorOverlaps + 1
        -- Foot sensor has exited a ground object
        elseif ( event.phase == "ended" ) then
            object2.sensorOverlaps = object2.sensorOverlaps - 1
        end
    end 	
 	

end

function goGameOver()

	if(lives <= 0) then
	
		composer.gotoScene("Scenes.gameover", "fade", 500 )

		
	end
	
end
function callGameOver() 
	if(lives <= 0) then
	
		composer.gotoScene("Scenes.gameover", "fade", 500 )

		
	end
	
	
end

function  goNextLevel()

	composer.gotoScene("Scenes.blank", "fade", 500 )
			


end

function collisionHeroBand(event) 
	

	local object1 = event.object1

	local object2 = event.object2
   
	if ( object1.id == "band" and object2.id == "hero"
		or object1.id == "hero" and object2.id == "band" ) then
			timer.performWithDelay(	1000, goNextLevel)
    end 	
 	
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
		

	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		audio.play( backgroundMusic, { channel=1, loops=-1 } )
		camera:track()
		physics.start()
	end
end



function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		
		Runtime:removeEventListener("collision",heroHit)	
		
		
		Runtime:removeEventListener("collision",arrowCollide)	
		Runtime:removeEventListener("collision",jumpCollide)	
		
			
		
		Runtime:removeEventListener("collision",movieEnemies)	
		Runtime:removeEventListener("collision", collisionHeroBand)	

		Runtime:removeEventListener("enterFrame",callGameOver)	
		

		display.remove(sceneGroup)
		
		physics.stop()
		--composer.removeScene("Scenes.level1",false)
		--composer.gotoScene("Scenes.level1")
	elseif phase == "did" then
		-- Called when the scene is now off screen
		audio.stop( 1 )
		
		
		
	end	
	
end




function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
	camera:destroy()
	audio.dispose( backgroundMusic)

	

	
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


-----------------------------------------------------------------------------------------

return scene