-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------



local composer = require( "composer" )

local scene = composer.newScene()


-- include Corona's "physics" library
local physics = require "physics"

--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.actualContentWidth, display.actualContentHeight, display.contentCenterX

local wallLeft

local  wallRight

local  wallTop

local   wallBottom

-- Button's

local  buttonLeft


local buttonRight


local buttonJump

local  buttonShoot 

local perspective = require("perspective")

local camera = perspective.createView()

--local camera
local bullet

local arrow

--Hero sprisheet

local sheetOptions =
{
    width = 209,
    height = 257,
    numFrames = 6
}

local moveHero=  graphics.newImageSheet( "Images/spritesmovendo.png", sheetOptions )



local sequences_hero = {
    -- first sequence (consecutive frames)
	{
        name = "idleLeft",
        frames = { 1},
        loopCount = 0
    },
    {
        name = "idleRight",
        frames = { 3},
        loopCount = 0
    },
    
	{
        name = "walkLeft",
        --start = 1,
        --count = 2,
        frames = { 1,2,1},
        time = 400,
        loopCount = 0,
    	loopDirection = "forward"

    },
    {
        name = "walkRight",
        start = 3,
        time = 	300,
        count = 2,
        loopCount = 0,
    	loopDirection = "forward"

    },
    {
        name = "jumpLeft",
        frames = { 6},
        loopCount = 0
    },
    {
        name = "jumpRight",
        frames = { 5},
        loopCount = 0
    },
    -- next sequence (non-consecutive frames)
    
}

local hero = {} 

hero = display.newSprite( moveHero, sequences_hero )

hero:setSequence("idleRight")

hero:play()


local  sheetOptions1 = {

	width = 239,
	height = 260,
	frames = 6
}

local atackHero=  graphics.newImageSheet( "Images/spritesatacando.png", sheetOptions1 )


local sequenceAtack ={

	{
        name = "shootArrowLeft",
        
        frames = { 1,5},
        time = 400,
        loopCount = 0,
    	loopDirection = "forward"

    },

    {
        name = "shootArrowRight",
        
        frames = { 2,6},
        time = 400,
        loopCount = 0,
    	loopDirection = "forward"

    }
    
}
 


function scene:create( event )

	local sceneGroup = self.view
	
	--physics.setDrawMode("hybrid")
	physics.start()

	physics.pause()


	local background = display.newImageRect( "Images/bg.png", screenW, screenH)
	background.x = display.screenOriginX
	background.y = display.screenOriginY

	background.anchorX = 0 
	background.anchorY = 0

	local background1 = display.newImageRect( "Images/bg0.png", screenW, screenH)
	background1.x = screenW-50
	background1.y = display.screenOriginY

	background1.anchorX = 0 
	background1.anchorY = 0
	--background:setFillColor( .5 )
	--background.alpha = 0.7
	--background1.alpha = 0.7


	local ground = display.newImageRect("Images/ground.png", screenW*4,200)

	ground.x = display.screenOriginX
	
	ground.y = display.contentHeight-30

	ground.id = "ground"

	ground.objType = "ground"

	physics.addBody( ground, "static",{ bounce=0.0, friction=0.3 } )
	

	local ground1 = display.newImageRect("Images/asset3.png", 500,400)

	ground1.x = display.contentCenterX
	
	ground1.y = display.contentHeight-200

	ground1.id = "ground"

	ground1.objType = "ground"

	physics.addBody( ground1, "static",{ bounce=0.0, friction=0.3 } )
	
	


	local ground2 = display.newImageRect("Images/asset3.png",800,200)

	ground2.x = 1500
	
	ground2.y = display.contentHeight-200

	ground2.id = "ground"

	ground2.objType = "ground"


	physics.addBody( ground2, "static",{ bounce=0.0, friction=0.3 } )
	

	local ground3 = display.newImageRect("Images/asset3.png",1200,400)

	ground3.x = 2490
	
	ground3.y = display.contentHeight-300

	ground3.id = "ground"

	ground3.objType = "ground"


	physics.addBody( ground3, "static",{ bounce=0.0, friction=0.3 } )
	

	local ground4 = display.newImageRect("Images/asset3.png",600,200)

	ground4.x = 3300
	
	ground4.y = display.contentHeight-200

	ground4.id = "ground"

	ground4.objType = "ground"


	physics.addBody( ground4, "static",{ bounce=0.0, friction=0.3 } )
	

	




	hero.x = 180

	hero.id = "hero"
	hero.y = display.contentHeight-172

	
	hero.speed = 1
	
    hero.sensorOverlaps = 0
    

	physics.addBody( hero,"dynamic", { density=2, friction=0.3, bounce= 0.0 } )

	
	hero.isFixedRotation = true


	buttonLeft = display.newImageRect("Images/btnleft.png", 200,200)

	buttonLeft.id = "left"

	buttonLeft.x= 200

	buttonLeft.y = display.contentHeight-200
	
	buttonLeft.alpha = 0.6

	buttonLeft:addEventListener("touch",doControls)

	 
	


	-- Move to right


	buttonRight = display.newImageRect("Images/btright.png", 200,200)

	buttonRight.id = "right"

	buttonRight.x = 450

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
	buttonShoot:addEventListener("touch", shootArrow)

	buttonShoot.id = "shoot"



	Runtime:addEventListener("collision",jumpCollide)	
	camera:add(hero,1,true)	
	
	camera:add(ground,2,false)	
	camera:add(ground1,3,false)
	camera:add(ground2,4,false)

	camera:add(ground3,5,false)
	camera:add(ground4,6,false)
			
	camera:add(background,7,false)	
	camera:add(background1,8,false)	

	camera:layer(2).paralaxRatio= 0.5
	local levelWidth = display.actualContentWidth*4
	--camera:setFocus(hero)
	print("acw", display.actualContentWidth/2)
	camera:setBounds(display.actualContentWidth/2,levelWidth-display.actualContentWidth*2-1200, -1000, display.contentHeight-1200)	
	
	if(hero.x > 1260)then
		camera:remove(ground1)
	end	

	--camera:insert(background)

	--camera:insert( ground)
		
	--camera:insert( hero)
	
	--sceneGroup:insert( background )
	--sceneGroup:insert( ground) 
	--sceneGroup:insert( hero)

	sceneGroup:insert(camera)
	

	
	sceneGroup:insert( buttonLeft )
	sceneGroup:insert( buttonRight)
	sceneGroup:insert( buttonJump)
	

end



local hX , hY

function doControls(event)
	local pressed = event.target

	
	if event.phase == "began" then

		if pressed.id == "left" then
			if(hero.x > 170) then
				display.currentStage:setFocus(buttonLeft)
				
				
				local  x = hero.x + hero.speed

				hero:applyLinearImpulse(-200,0, x, hero.y)
				hero:setSequence( "walkLeft" )  -- switch to "fastRun" sequence
	    		hero:play()
				print("Hero x",hero.x)
				print("Hero y",hero.y)
				hX = -hero.x
				hY = hero.y

				--hero.velocity = -hero.speed
			end
		elseif pressed.id == "right" then

			display.currentStage:setFocus(buttonRight)

			hero:applyLinearImpulse(200,0, hero.x, hero.y)
			hero:setSequence( "walkRight" )  -- switch to "fastRun" sequence
    		hero:play()
		
			--hero.velocity = hero.speed
			hX = hero.x
			hY = hero.y

		elseif pressed.id == "jump" and hero.sensorOverlaps > 0 then
			
			
				
				display.currentStage:setFocus(buttonJump)
				local vx, vy = hero:getLinearVelocity()
				hero:setLinearVelocity( vx, 0 )	
				hero:applyLinearImpulse(50,-1700, hero.x, hero.y)
				hero.count = 1
				hero:setSequence( "jumpRight" )  -- switch to "fastRun" sequence
	    		hero:play()
				--heroJumps = false
				
				--heroJumps = heroJumps+1
				
		
			end

	elseif event.phase == "ended" then 	
		if pressed.id == "left" then

			display.currentStage:setFocus(nil)
			
		elseif pressed.id == "right" then
			
			display.currentStage:setFocus(nil)
		
		elseif pressed.id == "jump" then
			
			display.currentStage:setFocus(nil)
		
			
		
		end
		
			
	end 

end
function shootArrow(event)
	


	local  pressed = event.target

	print(event.target.id)
	if event.phase == "began" then

		if pressed.id == "shoot" then
				
				display.currentStage:setFocus(buttonShoot)
				
				--local bullet = display.newCircle( 100, 100, 10 )

				--bullet.x = hX

				---bullet.y = hY


				--physics.addBody( bullet, "dynamic", { radius=10 } )
				--bullet.gravityScale = 0
				 
				-- Make the object a "bullet" type object
				--bullet.isBullet = true
				 
				--bullet:setLinearVelocity( 800, 0 )
				--arrow = display.newImageRect("arrow.png",100,100)

				--arrow.x = hX

				---arrow.y = 500

				--physics.addBody( arrow, "dynamic")

				--arrow.isBullet = true

				--arrow.gravityScale = 0
				---arrow:setLinearVelocity( 800, 0 ) 

				local arrow = display.newImageRect("Images/arrow.png",100,100)
			
				physics.addBody( arrow, "dynamic")

				arrow.gravityScale = 0

				arrow.isBullet = true
				arrow.x = hero.x
				arrow.y = hero.y
				--transition.to ( arrow, { time = 1000, x = hero.X, y =-100} )
				arrow:setLinearVelocity( 800, 0 )
				--physics.addBody(arrow, "static", {density = 1, friction = 0, bounce = 0})

				--transition.to ( arrow, { time = 1000, x = hX, y =-100} )

	    end
	elseif event.phase == "ended" then

			display.currentStage:setFocus(nil)
		
		

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