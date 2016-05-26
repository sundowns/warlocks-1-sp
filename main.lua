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
	love.mouse.setCursor(love.mouse.newCursor("assets/misc/cursor.png", 0, 0))

	initSpells() -- Load spell data & images
	initEffects() -- Load effect data & images
	initPlayer(player1)
	initPlayer(player2)
	initPlayerControls() -- load player1 controlscheme
	table.insert(players, player1)
	table.insert(players, player2)
	camera = Camera(player1.x, player1.y)

	player1.spellbook['SPELL1'] = spells['FIREBALL']
	player1.spellbook['SPELL2'] = spells['SPRINT']
end
-- End Load

-- Update callback. Called every frame
function love.update(dt)
	if not paused then 
		for i, player in ipairs(players) do
			calculatePlayerMovement(player, dt)
			processInput(player)
			updateEnchantments(player, dt)
		end
		
		updateTimers(dt)

    camera:lookAt(player1.x + player1.width, player1.y + player1.height)
		
		--Iterate over projectiles to update TTL
		for i, projectile in ipairs(projectiles) do
			--print(#projectiles	)
			local kill = false
			for shape, delta in pairs(HC.collisions(projectile.hitbox)) do
				if projectile.hitbox.owner ~= shape.owner then
					if shape.type == "PLAYER" then
						addEffect("EXPLOSION", shape:center())
						projectileHit(shape, projectile, delta.x, delta.y)
						kill = true
					end
				end  	
  		end
			updateProjectile(projectile, dt, kill, i)
		end



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
		
	for i, player in ipairs(players) do  -- Draw players
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

		love.graphics.circle('fill', camX, camY, 2, 16)
	end
	camera:detach()

	--Leave this at the end so its on top
	if (paused) then
		love.graphics.setColor(255, 0, 0, 255)
		love.graphics.print("Paused", love.graphics.getWidth()/2 - 20, love.graphics.getHeight()/3)
		resetColour()
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
		updatePlayerState(player1, "STAND")
		updatePlayerState(player2, "STAND")
		player1.health = player1.max_health
		player2.health = player2.max_health
		updatePlayerPosition(player1, 600, 500)
		updatePlayerPosition(player2, 600, 600)
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
			if player1.state == "CASTING" then
				drawthatX = projectileTargetX
				drawthatY = projectileTargetY
				castSpell(player1, player1.spellbook[player1.selected_spell], projectileTargetX, projectileTargetY)
			end
		elseif button == 2 then
			if player1.state == "CASTING" then
				updatePlayerState(player1, "STAND")
			end
	 	end
	end
end 

function updateTimers(dt)
	--Iterate over players spell calculating new cooldown timer
	for spell, data in pairs(player1.spellbook) do
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

	for i, player in ipairs(players) do  -- player animation timer
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