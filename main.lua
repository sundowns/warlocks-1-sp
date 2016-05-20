debug = false

--Global
paused = false
projectiles = {}
players = {}

-- Load callback. Called ONCE initially
function love.load(arg)
	require("player")
	require("spells")
	loadPlayerStates()
	loadSpells()
	loadPlayerControls()

	player1.spellbook['SPELL1'] = spells['FIREBALL']
end
-- End Load

-- Update callback. Called every frame
function love.update(dt)
	if not paused then 
		calculatePlayerMovement(player1, dt)
		processInput(player1)
		
		--Iterate over players spell calculating new cooldown timer
		for spell, data in pairs(player1.spellbook) do
			if not data.ready then 
				data.timer = math.max(0, data.timer - dt) 
				if data.timer == 0 then
					data.ready = true
				end
			end
		end

		--Iterate over projectiles to update TTL
		for i, projectile in ipairs(projectiles) do
			projectile.time_to_live = math.max(0, projectile.time_to_live - dt)
			if projectile.time_to_live == 0 then 
				table.remove(projectiles, i)
			end

			projectile.x = projectile.x + (projectile.dx * dt)
			projectile.y = projectile.y + (projectile.dy * dt)
		end

		if debug then
			print("state: " .. player1.state .. " currentSpell: " .. player1.selected_spell)
		end
	end
end
-- End update

-- Draw callback. Called every frame
function love.draw(dt)

	love.graphics.setColor(245, 245, 220, 180)
	love.graphics.circle("fill", love.graphics.getWidth()/2, love.graphics.getHeight()/2, love.graphics.getHeight()/3, 100)
	love.graphics.setColor(255, 255, 255, 255)

	love.graphics.draw(getPlayerImg(player1), player1.x, player1.y, 0, 1.5, 1.5)

	for i, projectile in ipairs(projectiles) do
  		love.graphics.draw(projectile.images[projectile.anim_current], projectile.x, projectile.y, projectile.angle, projectile.size, projectile.size)
  		projectile.anim_current = projectile.anim_current + 1
  		if projectile.anim_current > projectile.anim_frames then
  			projectile.anim_current = 1
  		end
	end

	--Leave this at the end so its on top
	if (paused) then
		love.graphics.print("Paused", love.graphics.getWidth()/2 - 20, love.graphics.getHeight()/2 - 15)
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
		player1.modifier_aoe = 3
		player1.modifier_range = 1.5
	end
end

function love.mousepressed(x, y, button)
	if button == 1 then
		if player1.state == "CASTING" then
			castProjectileSpell(player1, player1.selected_spell, x, y)
			player1.state = "STAND"
		end
	elseif button == 2 then
		if player1.state == "CASTING" then
			player1.state = "STAND"
		end
 	end
end 
