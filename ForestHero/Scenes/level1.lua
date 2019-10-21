-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------
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


local camera = perspective.createView()

--local camera
local bullet



--Hero sprisheet

local sheetOptions =
{
    width = 147,
    height = 216,
    numFrames = 22
}

local moveHero=  graphics.newImageSheet( "Images/spriteshero.png", sheetOptions )



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
      	time =  800,
        loopCount = 0  
   	},
    {
    	name = "shootRight",
    	frames = { 22,19},
      	time =  200,
        loopCount = 0  
   	}
}

local hero = {} 

hero = display.newSprite( moveHero, sequences_hero )

hero:setSequence("idleRight")

hero:play()

local originHero
local arrow = {}
local enemy

local enemy1
local enemy2

local enemy3

local enemy4

local heart

local arrowCounter

audio.reserveChannels( 1 )
audio.setVolume( 0.5, { channel=1} )

function scene:create( event )

	local sceneGroup = self.view
	
	physics.setDrawMode("hybrid")
	physics.start()

	physics.pause()

	backgroundMusic = audio.loadStream( "Music/TheForest.wav" )

	
	local background = display.newImageRect( "Images/bg.png", screenW, screenH)
	print("screen origin",screenW/2)
	background.x = 0 
	background.y = display.screenOriginY

	background.anchorX = 0 
	background.anchorY = 0
	background.alpha = 0.95
	local background1 = display.newImageRect( "Images/bg0.png", screenW, screenH)
	background1.x = screenW-10 
	background1.y = display.screenOriginY

	background1.anchorX = 0 
	background1.anchorY = 0
	--background:setFillColor( .5 )
	--background.alpha = 0.7
	--background1.alpha = 0.7
	print("SW",screenW*4)

	local ground = display.newImageRect("Images/teste.png", screenW*6,200)

	ground.x = display.screenOriginX
	
	ground.y = display.contentHeight-30

	ground.id = "ground"

	ground.objType = "ground"

	physics.addBody( ground, "static",{ bounce=0.0, friction=0.3 } )
	
	local wallLeft = display.newRect(10, display.contentHeight, 10, display.contentHeight)

	wallLeft.x = 0
	wallLeft.y = display.contentCenterY
	wallLeft.alpha = 0
	physics.addBody(wallLeft, "static",{ bounce=0.0, friction=0.3 } )
	
	

	local ground1 = display.newImageRect("Images/plataforma1.png", 1000,200)

	ground1.x = 1800
	
	ground1.y = display.contentHeight - 225

	ground1.id = "ground"

	ground1.objType = "ground"

	physics.addBody( ground1, "static",{ bounce=0.0, friction=0.3 } )
	
	
	local ground2 = display.newImageRect("Images/plataforma2.png", 1000,430)

	ground2.x = 2800
	
	ground2.y = display.contentHeight - 320

	ground2.id = "ground"

	ground2.objType = "ground"

	physics.addBody( ground2, "static",{ bounce=0.0, friction=0.3 } )
	
	local ground3 = display.newImageRect("Images/plataforma1.png",3000,640)
	
	ground3.x = 4800

	ground3.y = display.contentHeight - 420

	ground3.id = "ground"

	ground3.objType = "ground"

	physics.addBody( ground3, "static",{ bounce=0.0, friction=0.3 } )
	


	local ground4 = display.newImageRect("Images/plataforma3.png", 2000,400)

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

	enemy = display.newRect(100,200,100,200)

	enemy.x = 2100

	enemy.y = display.contentHeight-225
	enemy.id = "enemy"
	enemy.objType = "enemy"
	physics.addBody(enemy,"dynamic", { density=3, friction=0.5, bounce= 0.0 })

	enemy.isFixedRotation = true

	enemy1 = display.newRect(100,200,100,200)

	enemy1.x = 2800
	
	enemy1.y = display.contentHeight -320
	physics.addBody(enemy1,"dynamic", { density=3, friction=0.5, bounce= 0.0 })

	enemy1.isFixedRotation = true

	enemy1.id = "enemy1"
	enemy1.objType = "enemy"

	enemy2 = display.newRect(100,200,100,200)

	enemy2.x = 4700
	enemy2.y = display.contentHeight -520
	enemy2.objType = "enemy"
	physics.addBody(enemy2,"dynamic", { density=3, friction=0.5, bounce= 0.0 })

	enemy2.isFixedRotation = true

	enemy2.id = "enemy2"


	
	Runtime:addEventListener("collision", movieEnemies)	
	buttonLeft = display.newImageRect("Images/btnleft.png", 200,200)

	buttonLeft.id = "left"

	buttonLeft.x= -1000

	buttonLeft.y = display.contentHeight-200
	
	buttonLeft.alpha = 0.6

	buttonLeft:addEventListener("touch",doControls)

	 
	


	-- Move to right


	buttonRight = display.newImageRect("Images/btright.png", 200,200)

	buttonRight.id = "right"

	buttonRight.x = -700

	buttonRight.alpha = 0.6

 	buttonRight.y = display.contentHeight-200
	buttonRight:addEventListener("touch", doControls)


	-- jumpRight

	buttonJump = display.newImageRect("Images/btnjump.png", 200,200)
	buttonJump.id = "jump"

	buttonJump.x = 1650

	buttonJump.alpha = 0.6

 	buttonJump.y = display.contentHeight-200
	buttonJump:addEventListener("touch", doControls)

	-- shoot
	buttonShoot = display.newImageRect("Images/btnarrow.png", 200,200)
	

	buttonShoot.x = 1900

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
	
	camera:add(hero,1,true)	
	camera:add(enemy,2)
	camera:add(enemy1,2,false)
	camera:add(enemy2,2,false)
	
	camera:add(ground,2,false)	
	camera:add(ground1,2,false)
	camera:add(ground2,2,false)
	camera:add(ground3,2,false)
	
	camera:add(ground4,2,false)	
	
	camera:add(wallLeft,3,false)
	camera:add(heart,3,false)
	
	camera:add(background,4,false)	
	camera:add(background1,5,false)	

	camera:layer(2).paralaxRatio= 0.5
	local levelWidth = display.actualContentWidth*4-1100
	camera:setBounds(display.actualContentWidth/2,levelWidth-display.actualContentWidth*2-1200, -1000, display.contentHeight-1200)	
	
	if(hero.x > 1260)then
		camera:remove(ground1)
	end	
	
	sceneGroup:insert(camera)


	sceneGroup:insert( buttonLeft )
	sceneGroup:insert( buttonRight)
	sceneGroup:insert( buttonJump)
	sceneGroup:insert( buttonShoot)
	sceneGroup:insert(scoresText)
	sceneGroup:insert(heart)

end

function movieEnemies(event)
	
	local object1 = event.object1

 	local object2 = event.object2
	
	 
	local object1 = event.object1

 	local object2 = event.object2
	 
	 print(object2.x)
 	
 	if ( object1.id == "ground" and object2.id == "enemy" ) then
 		
        -- Foot sensor has entered (overlapped) a ground object
        if ( event.phase == "began" ) then
			Runtime:addEventListener("enterFrame",enemyEnterFrame)

        elseif ( event.phase == "ended" ) then
			Runtime:removeEventListener("enterFrame",enemyEnterFrame)

        end
    end
end

function enemyEnterFrame()
	enemy:setLinearVelocity(-150,0)
	

end

local function enemiesShoot()
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

				display.currentStage:setFocus(buttonLeft)
				
			
				local  x = hero.x + hero.speed

				hero:applyLinearImpulse(-200,0, x, hero.y)
				hero:setSequence( "walkLeft")
				  -- switch to "fastRun" sequence
	    		hero:play()
				print("Hero x",hero.x)
				print("Hero y",hero.y)
				hX = -hero.x
				hY = hero.y
				isLeft = true
				--hero.velocity = -hero.speed
				Runtime:addEventListener("enterFrame", moveHeroEnterFrame)

			end
		elseif pressed.id == "right" then
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


		elseif pressed.id == "jump" and hero.sensorOverlaps > 0 then
			
			
				
				display.currentStage:setFocus(buttonJump)
				local vx, vy = hero:getLinearVelocity()
				hero:setLinearVelocity( vx, 0 )	
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
			hero:setSequence( "idleLeft" )
		
		elseif pressed.id == "right" then
			
			display.currentStage:setFocus(nil)
			Runtime:removeEventListener("enterFrame",moveHeroEnterFrame)
			
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
		
		end
	end
end

function shootArrows(event)
	local l = false
	if event.phase == "began" then
		print("oi")
		if event.target.id == "shoot" then
			display.currentStage:setFocus(buttonShoot)

			if arrows > 0 then
				arrows = arrows - 1
				Runtime:addEventListener("enterFrame", updateText)
				if shootRight == true then
					l = true
					hero:setSequence("shootRight")
					
					hero:play()
								
					
								
					local arrow = display.newImageRect("Images/arrow1.png",100,100)
					
					camera:add(arrow,2,false)
					
					physics.addBody( arrow, "dynamic",{isSensor = true})

					arrow.gravityScale = 0

					arrow.isBullet = true
					arrow.x = hero.x+90
					
					print("Arrow x",arrow.x)
					
					arrow.y = hero.y-20
					
					arrow.id = "arrow"

					
					--transition.to( arrow, { x= screenW+100, time=800, } )

					--arrow:setLinearVelocity( 800, 0 )

					--if(arrow.x >hero.x+100) then
					---	arrow:removeSelf()
					--end
					transition.to( arrow, { x=hero.x+1800, time=1000,
					onComplete = function() display.remove( arrow ) end
				} )
				end
			else 
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
					print("Arrow x",arrow.x)
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
		
			display.currentStage:setFocus(nil)

			if shootRight == true then
				hero:setSequence("idleRight")
				
			else
				hero:setSequence("idleLeft")
				hero:play()
			end	
		end
	end
end



function moveHeroEnterFrame(event)
	if isLeft == true then
		hero:setLinearVelocity(-170,70)

		hero:applyLinearImpulse(-200,0, hero.x, hero.y)

	elseif isRight == true then
		hero:setLinearVelocity(170,70)

		hero:applyLinearImpulse(200,0, hero.x, hero.y)
		
	end 

	
end


function arrowCollide(event)
	local object1 = event.object1

 	local object2 = event.object2
	 
	print("scoresanTES", scores)
 	
	 if ( object1.id == "ground" and object2.id == "arrow" )or
	 ( object1.id == "arrow" and object2.id == "ground" )
	 then
 		print("passei")
        -- Foot sensor has entered (overlapped) a ground object
        if ( event.phase == "began" ) then
        	display.remove(arrow)

        elseif ( event.phase == "ended" ) then
        
        end
	
	elseif (( object1.id == "enemy" and object2.id == "arrow" )or
	( object1.id == "arrow" and object2.id == "enemy" ) )then
			Runtime:addEventListener("enterFrame", updateText)
			print("scoresandepois", scores)
			Runtime:removeEventListener("enterFrame",enemyEnterFrame)
		
			display.remove(object1)
			
			display.remove(object2)
			
			scores= scores+10		
		
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

		physics.stop()
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

	audio.dispose( backgroundMusic)

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

scene:addEventListener( "doConrtrols", scene )

-----------------------------------------------------------------------------------------

return scene