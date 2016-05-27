--Global
debug = false
paused = false
displayNames = false

--Test
drawthatX = 1
drawthatY = 1
drawthatR = 1

--Hardon Collider
HC = require 'libs/HC'
Camera = require 'libs/camera'

-- Load callback. Called ONCE initially
function love.load(arg)
	require("settings")
	require("util")
	require("timers")
	require("player")
	require("spells")
	require("stage")
	require("effects")
	require("entity")
	require("init")

	initialise()
	
	players['PLAYER_1'].spellbook['SPELL1'] = spells['FIREBALL']
	players['PLAYER_1'].spellbook['SPELL2'] = spells['SPRINT']
	players['PLAYER_1'].spellbook['SPELL3'] = spells['FISSURE']
end
-- End Load

-- Update callback. Called every frame
function love.update(dt)
	if not paused then 
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
	camera:attach()

	drawStage() -- Draw our stage
	
	

	for i, effect in ipairs(effects) do
		drawEffect(effect, i)
	end
		
	for key, player in pairs(players) do  -- Draw players
		drawPlayer(player)
	end

	for i, entity in ipairs(entities) do
		drawEntity(entity, i)
	end

	for i, projectile in ipairs(projectiles) do
  		drawProjectile(projectile)
	end

	for i, data in ipairs(textLog) do
		drawTextData(data, i)
	end

	if debug then 
		local camX, camY = camera:position()
		love.graphics.setColor(255, 0, 0, 255)
		love.graphics.circle('fill', camX, camY, 2, 16)
		love.graphics.rectangle('line', camX - love.graphics.getWidth()*0.15, camY - love.graphics.getHeight()*0.1, 0.3*love.graphics.getWidth(), 0.2*love.graphics.getHeight())
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
	elseif key == "f5" then
		os.execute("cls")	
	elseif key == "esc"then
		love.quit()
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
	local playerX, playerY = getCenter(players['PLAYER_1'])
	if (playerX > camX + love.graphics.getWidth()*0.15) then
		newX = playerX - love.graphics.getWidth()*0.15
	end
	if (playerX < camX - love.graphics.getWidth()*0.15) then
		newX = playerX + love.graphics.getWidth()*0.15
	end
	if (playerY > camY + love.graphics.getHeight()*0.1) then
		newY = playerY - love.graphics.getHeight()*0.1
	end
	if (playerY < camY - love.graphics.getHeight()*0.1) then
		newY = playerY + love.graphics.getHeight()*0.1
	end

	camera:lookAt(newX, newY)
end