debug = false

--Global
paused = false
displayNames = false

otherPlayers = {}

--Hardon Collider
HC = require 'libs/HC'


-- Load callback. Called ONCE initially
function love.load(arg)
	require("player")
	require("spells")
	require("stage")
	require("effects")

	loadSpells()
	loadEffects()
	initialisePlayer(player1)
	loadPlayerControls()

	player2 = { 
		x = love.graphics.getWidth()/2,
	 	y = love.graphics.getWidth()/2,
	 	width = nil,
	 	height = nil,
	 	x_velocity = 0,
	 	y_velocity = 0,
	 	max_movement_velocity = 130,
	 	movement_friction = 200,
	 	acceleration = 35,
	 	health = 100,
	 	state="STAND",
	 	orientation="RIGHT",
	 	selected_spell = "",
	 	controls = {},
	 	spellbook = {},
	 	modifier_aoe = 1,
	 	modifier_range = 1,
	 	name = "PLAYER_2",
	 	colour = "GREEN",
	 	States = {},
	 	hitbox = nil,
	 	projectileHit = nil,
 		projectile_slippa = 100
	}
	initialisePlayer(player2)
	table.insert(otherPlayers, player2)

	player1.spellbook['SPELL1'] = spells['FIREBALL']
end
-- End Load

-- Update callback. Called every frame
function love.update(dt)
	if not paused then 
		calculatePlayerMovement(player1, dt)
		processInput(player1)
		updatePlayerHitbox(player1)

		for i, player in ipairs(otherPlayers) do
			updatePlayerHitbox(player)
		end

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
			local kill = false
			for shape, delta in pairs(HC.collisions(projectile.hitbox)) do
				if projectile.hitbox.owner ~= shape.owner then
					if debug then
						print("projectile collision! Proj owner: " .. projectile.hitbox.owner .. " shape owner: " .. shape.owner .. " type: ".. shape.type)
					end
					if shape.type == "PLAYER" then
						addEffect("EXPLOSION", shape:center())
						projectileHit(shape, projectile, delta.x, delta.y, dt)
					end

					kill = true
				else kill = false
				end
	       
	        	
	    	end
			updateProjectile(projectile, dt, kill)
		end
	end
end
-- End update

-- Draw callback. Called every frame
function love.draw(dt)
	drawStage() -- Draw our stage
	drawPlayer(player1) -- Draw player1 
	for i, player in ipairs(otherPlayers) do  -- Draw other players
		drawPlayer(player)
	end

	for i, projectile in ipairs(projectiles) do
  		drawProjectile(projectile)
	end

	for i, effect in ipairs(effects) do
		drawEffect(effect)
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
		displayNames = not displayNames
	elseif key == "f5" then
		os.execute("cls")	
	end
end

function love.mousepressed(x, y, button)
	if not paused then 
		if button == 1 then
			if player1.state == "CASTING" then
				castLinearProjectile(player1, player1.selected_spell, x, y)
				updatePlayerState(player1, "STAND")
			end
		elseif button == 2 then
			if player1.state == "CASTING" then
				updatePlayerState(player1, "STAND")
			end
	 	end
	end

end 
