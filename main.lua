--Global
debug = false
paused = false
displayNames = false
totalPlayers = 3

--Test

loadingTimer = 0.5 --remove this when u done circle jerkin

function loadlibs()
	HC = require 'libs/HC'
	Camera = require 'libs/camera'
	STI = require 'libs/sti'
end

loadingScreen = nil

-- Load callback. Called ONCE initially
function love.load(arg)
	loading = true
	loadingScreen = love.graphics.newImage('assets/misc/loading-screen.png')
	love.graphics.setBackgroundColor(0, 0, 0)
	loadlibs()
	require("settings")
	require("util")
	require("timers")
	require("player")
	require("spells")
	require("stage")
	require("effects")
	require("entity")
	require("meta")
	require("init")

	initialise()
	
	players['PLAYER_1'].spellbook['SPELL1'] = spells['FIREBALL']
	players['PLAYER_1'].spellbook['SPELL2'] = spells['SPRINT']
	players['PLAYER_1'].spellbook['SPELL3'] = spells['FISSURE']
	players['PLAYER_1'].spellbook['SPELL4'] = spells['TELEPORT']
end
-- End Load

-- Update callback. Called every frame
function love.update(dt)
	loadingTimer = loadingTimer - dt -- remove all this lmao
	if loadingTimer <= 0 then
		loading = false
	end

	if not paused and not loading then 
		updateStage(dt)
		for key, player in pairs(players) do
			calculatePlayerMovement(player, dt)
			if player.userControlled then
				processInput(player)
			end
			updateEnchantments(player, dt)
		end

		updateTimers(dt)
			
		updateProjectiles(dt)

		updateEntities(dt)

		updateCamera()
	end
end
-- End update

-- Draw callback. Called every frame
function love.draw()
	if loading then
		love.graphics.draw( loadingScreen, love.graphics.getWidth()/2-loadingScreen:getWidth()/2, love.graphics.getHeight()/2-loadingScreen:getHeight()/2 )
	else 
		camera:attach()

		drawStage() -- Draw our stage


		for i, effect in ipairs(effects) do
			drawEffect(effect, i)
		end
			
		for i, entity in ipairs(entities) do
			drawEntity(entity, i)
		end

		for key, player in pairs(players) do  -- Draw players
			drawPlayer(player)
		end

		for i, effect in ipairs(effects) do
			drawEffect(effect, i)
		end

		for i, projectile in ipairs(projectiles) do
	  		drawProjectile(projectile)
		end

		for i, data in ipairs(textLog) do
			drawTextData(data, i)
		end

		print("dmg: " .. stats["PLAYER_1"].roundDamageGiven)


		if debug then 
			local camX, camY = camera:position()
			love.graphics.setColor(255, 0, 0, 255)
			love.graphics.circle('fill', camX, camY, 2, 16)
			love.graphics.rectangle('line', camX - love.graphics.getWidth()*0.05, camY - love.graphics.getHeight()*0.035, 0.1*love.graphics.getWidth(), 0.07*love.graphics.getHeight())
			resetColour()
		end
		camera:detach()

		--Leave this at the end so its on top
		if (paused) then
			love.graphics.setColor(255, 0, 0, 255)
			setFontSize(32)
			love.graphics.print("Paused", love.graphics.getWidth()/2 - 45, love.graphics.getHeight()/3)
			resetColour()
			resetFont()
		end
	end
end
-- End Draw

-- Focus callback. Called everytime focus changes
function love.focus(b)
	if not b then
		paused = true;
	end
end
-- End Focus

function love.keypressed(key, scancode, isrepeat)
	if key == "return" then
		paused = not paused
	elseif key == "f1" then
		debug = not debug	
	elseif key == "f2" then
		for key, player in pairs(players) do 
			updatePlayerState(player, "STAND")
			player.health = player.max_health
			local x,y = nil, nil
			if key == "PLAYER_1" then 
				x, y = 450, 600
			elseif key == "PLAYER_2" then
				x, y = 500, 600
			elseif key == "PLAYER_3" then
				x, y = 550, 600	
			end
			updatePlayerPosition(player, x, y)
		end	
	elseif key == "f3" then
		players['PLAYER_1'].modifier_aoe	= 2
	elseif key == "f4" then
		castLinearProjectile(players['PLAYER_2'], players['PLAYER_1'].spellbook['SPELL1'], players['PLAYER_1'].x, players['PLAYER_1'].y)
	elseif key == "f5" then
		os.execute("cls")	
	elseif key == "escape" then
		love.event.quit()
	end
end

projectileTargetX = nil
projectileTargetY = nil

function love.mousepressed(x, y, button, istouch)
	projectileTargetX, projectileTargetY = camera:worldCoords(love.mouse.getPosition()) 
end

function love.mousereleased(x, y, button)
	if not paused then 
		if button == 1 then
			if players['PLAYER_1'].state == "CASTING" then
				castSpell(players['PLAYER_1'], players['PLAYER_1'].spellbook[players['PLAYER_1'].selected_spell], projectileTargetX, projectileTargetY)
			end
		elseif button == 2 then
			if players['PLAYER_1'].state == "CASTING" then
				updatePlayerState(players['PLAYER_1'], "STAND")
			end
	 	end
	end
end 

function updateCamera()
	local camX, camY = camera:position()
	local newX, newY = camX, camY
	local playerX, playerY = players['PLAYER_1'].hitbox:center()
	if (playerX > camX + love.graphics.getWidth()*0.05) then
		newX = playerX - love.graphics.getWidth()*0.05
	end
	if (playerX < camX - love.graphics.getWidth()*0.05) then
		newX = playerX + love.graphics.getWidth()*0.05
	end
	if (playerY > camY + love.graphics.getHeight()*0.035) then
		newY = playerY - love.graphics.getHeight()*0.035
	end
	if (playerY < camY - love.graphics.getHeight()*0.035) then
		newY = playerY + love.graphics.getHeight()*0.035
	end

	--camera:lookAt(newX, newY)
	camera:lockPosition(newX, newY, camera.smooth.damped(2))
end