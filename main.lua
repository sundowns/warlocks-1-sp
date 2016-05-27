--Global
debug = false
paused = false
displayNames = false

--Test
drawthatX = 1
drawthatY = 1

--Hardon Collider
HC = require 'libs/HC'
Camera = require 'libs/camera'

-- Load callback. Called ONCE initially
function love.load(arg)
	require("settings")
	require("util")
	require("player")
	require("spells")
	require("stage")
	require("effects")
	require("init")

	initialise()
	
	players['PLAYER_1'].spellbook['SPELL1'] = spells['FIREBALL']
	players['PLAYER_1'].spellbook['SPELL2'] = spells['SPRINT']
end
-- End Load

-- Update callback. Called every frame
function love.update(dt)
	if not paused then 
		for key, player in pairs(players) do
			calculatePlayerMovement(player, dt)
			processInput(player)
			updateEnchantments(player, dt)
		end
			
		updateTimers(dt)

		updateCamera()
			
		updateProjectiles(dt)
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

	for i, projectile in ipairs(projectiles) do
  		drawProjectile(projectile)
	end

	for i, data in ipairs(textLog) do
		drawTextData(data, i)
	end

	if debug then 
		love.graphics.circle('fill', drawthatX, drawthatY, 3, 16)
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
		updatePlayerState(players['PLAYER_1'], "STAND")
		updatePlayerState(players['PLAYER_2'], "STAND")
		players['PLAYER_1'].health = players['PLAYER_1'].max_health
		players['PLAYER_2'].health = players['PLAYER_2'].max_health
		updatePlayerPosition(players['PLAYER_1'], 600, 500)
		updatePlayerPosition(players['PLAYER_2'], 600, 600)
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
				drawthatX = projectileTargetX
				drawthatY = projectileTargetY
				castSpell(players['PLAYER_1'], players['PLAYER_1'].spellbook[players['PLAYER_1'].selected_spell], projectileTargetX, projectileTargetY)
			end
		elseif button == 2 then
			if players['PLAYER_1'].state == "CASTING" then
				updatePlayerState(players['PLAYER_1'], "STAND")
			end
	 	end
	end
end 

function updateTimers(dt)
	--Iterate over players spell calculating new cooldown timer
	for spell, data in pairs(players['PLAYER_1'].spellbook) do
		if not data.ready then 
			data.timer = math.max(0, data.timer - dt) 
			if data.timer == 0 then
				data.ready = true
			end
		end
	end

	for i, data in ipairs(textLog) do --combat text timers
		data.timer = math.max(0, data.timer - dt) 		
	end

	for key, player in pairs(players) do  -- player animation timer
		player.States[player.state].frameTimer = math.max(0, player.States[player.state].frameTimer - dt)
		
		if player.States[player.state].frameTimer <= 0 then 
			if #player.States[player.state].animation > 1 then
				player.States[player.state].currentFrame = player.States[player.state].currentFrame + 1 
			end
			if player.States[player.state].currentFrame > #player.States[player.state].animation then
				player.States[player.state].currentFrame = 1
			end
			player.States[player.state].frameTimer = player.States[player.state].timeBetweenFrames
		end
	end

	for i, projectile in ipairs(projectiles) do  -- projectile animation timers
		projectile.frameTimer = math.max(0, projectile.frameTimer - dt)
		if projectile.frameTimer <= 0 then 
			if #projectile.animation > 1 then
				projectile.currentFrame = projectile.currentFrame + 1 
			end
			if projectile.currentFrame > #projectile.animation then
				projectile.currentFrame = 1
			end
			projectile.frameTimer = projectile.timeBetweenFrames
		end
	end

	for i, effect in ipairs(effects) do  -- effect animation timers
		effect.frameTimer = math.max(0, effect.frameTimer - dt)
		if effect.frameTimer <= 0 then 
			if #effect.animation > 1 then
				effect.currentFrame = effect.currentFrame + 1 
			end
			if effect.currentFrame > #effect.animation then
				if effect.loop then
					effect.currentFrame = 1
				else 
					table.remove(effects, i)
				end
			end
			effect.frameTimer = effect.timeBetweenFrames
		end
		if effect.loop then
			effect.duration = math.max(0, effect.duration - dt)
			if effect.duration == 0 then
				table.remove(effects, i)
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