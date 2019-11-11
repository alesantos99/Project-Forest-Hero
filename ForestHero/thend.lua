-----------------------------------------------------------------------------------------
--
-- gameover.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"

local backgroundMusic 

audio.reserveChannels( 1 )
audio.reserveChannels( 2 )
audio.setVolume( 0.8, { channel=1, channel = 2 } )

local playMusic 
--------------------------------------------

-- forward declarations and other locals
--local playBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to level1.lua scene
	audio.play( playMusic, { channel=2} )
	audio.setVolume( 0.8, { channel = 2 } )
    composer.removeScene("Scenes.level1",false)

	composer.gotoScene( "menu", "fade", 500 )

	return true	-- indicates successful touch

end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "Images/thend.png", display.actualContentWidth, display.actualContentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x = 0 + display.screenOriginX 
	background.y = 0 + display.screenOriginY
	
	backgroundMusic = audio.loadStream( "Music/GameOver.wav" )

	playMusic  = audio.loadStream( "Music/collect.ogg" )
	-- create/position logo/title image on upper-half of the screen
	--local titleLogo = display.newImageRect( "logo.png", 264, 42 )
	--titleLogo.x = display.contentCenterX
	--titleLogo.y = 100
	
	
	-- create a widget button (which will loads level1.lua on release)

	local play = display.newImageRect("Images/backtomenu.png", 800,300)

	play.x = display.contentCenterX
	play.y = 1800

	play:addEventListener("touch",onPlayBtnRelease)

	
	--playBtn = widget.newButton{
		--label="Play Now",
		--labelColor = { default={255}, over={128} },
		--default="button.png",
		--over="button-over.png",
		--width=500, height=1000,
		--onRelease = onPlayBtnRelease	-- event listener function
	--}
	
	--play.x = display.contentCenterX
	
	--play.y = display.actualContentHeight-100
	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	--sceneGroup:insert( titleLogo )
	sceneGroup:insert( play)

	--sceneGroup:insert( selectbtn)
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
	elseif phase == "did" then
		-- Called when the scene is now off screen
		audio.stop( 1 )

	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end

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