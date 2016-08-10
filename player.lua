players = {}

players["PLAYER_1"] = { 
	x = 600,
 	y = 490,
 	width = nil,
 	height = nil,
 	x_velocity = 0,
 	y_velocity = 0,
 	base_max_movement_velocity = 140,
 	max_movement_velocity = 140,
 	movement_friction = 200,
 	base_acceleration = 35,
 	acceleration = 35,
 	max_health = 100,
 	health = 100,
 	state="STAND",
 	orientation="RIGHT",
 	selected_spell = "",
 	controls = {},
 	spellbook = {},
 	modifier_aoe = 1,
 	modifier_range = 1,
 	name = "PLAYER_1",
 	colour = {r = 255, g = 255, b = 255},
 	States = {},
 	hitbox = nil,
 	impact_acceleration = 2000,
 	x_impact_velocity = 0,
 	y_impact_velocity = 0,
 	terminal_velocity = 350,
 	impact_friction = 80,
 	active_enchantments = {},
 	alias = "sundowns", -- shouldnt be over ~20 chars
 	userControlled = true
}

players["PLAYER_2"] = { 
	x = love.graphics.getWidth()/2,
 	y = love.graphics.getWidth()/2,
 	width = nil,
 	height = nil,
 	x_velocity = 0,
 	y_velocity = 0,
 	base_max_movement_velocity = 140,
 	max_movement_velocity = 140,
 	movement_friction = 200,
 	acceleration = 35,
 	max_health = 100,
 	health = 100,
 	state="STAND",
 	orientation="RIGHT",
 	selected_spell = "",
 	controls = {},
 	spellbook = {},
 	modifier_aoe = 1,
 	modifier_range = 1,
 	name = "PLAYER_2",
 	colour = {r = 0, g = 0, b = 255},
 	States = {},
 	hitbox = nil,
 	impact_acceleration = 2000,
 	x_impact_velocity = 0,
 	y_impact_velocity = 0,
 	terminal_velocity = 350,
 	impact_friction = 80,
 	active_enchantments = {},
 	alias = "Swiggy McLongNames", -- shouldnt be over ~20 chars
 	userControlled = false
}

players["PLAYER_3"] = { 
	x = love.graphics.getWidth()/2 + 30,
 	y = love.graphics.getWidth()/2,
 	width = nil,
 	height = nil,
 	x_velocity = 0,
 	y_velocity = 0,
 	base_max_movement_velocity = 140,
 	max_movement_velocity = 140,
 	movement_friction = 200,
 	acceleration = 35,
 	max_health = 100,
 	health = 100,
 	state="STAND",
 	orientation="RIGHT",
 	selected_spell = "",
 	controls = {},
 	spellbook = {},
 	modifier_aoe = 1,
 	modifier_range = 1,
 	name = "PLAYER_3",
 	colour = {r = 0, g = 255, b = 0},
 	States = {},
 	hitbox = nil,
 	impact_acceleration = 2000,
 	x_impact_velocity = 0,
 	y_impact_velocity = 0,
 	terminal_velocity = 350,
 	impact_friction = 80,
 	active_enchantments = {},
 	alias = "New Red Guy", -- shouldnt be over ~20 chars
 	userControlled = false
}

skillslots = {'SPELL1', 'SPELL2', 'SPELL3', 'SPELL4', 'SPELL5'}

function entityHit(owner, entity, dX, dY, self)
	local dmg = entity.damage
	if self then
		dmg = dmg/2
		dX = dX/2
		dY = dY/2
	end
	local player = players[owner]	
	if entity.hasHit[player.name] == nil or entity.multiHit then
		if entity.spell.name == "Fireball" or entity.spell.name == "Fissure" then
			local xAccel = math.clamp(-dX*player.impact_acceleration, -entity.max_impulse, entity.max_impulse)
			local xAbsAccel = math.abs(xAccel)
			if player.x_impact_velocity > 0 then
				player.x_impact_velocity = math.clamp(player.x_impact_velocity + xAbsAccel, -player.terminal_velocity, player.terminal_velocity)
			elseif player.x_impact_velocity < 0 then
				player.x_impact_velocity = math.clamp(player.x_impact_velocity - xAbsAccel, -player.terminal_velocity, player.terminal_velocity)
			elseif player.x_impact_velocity == 0 then
				player.x_impact_velocity = math.clamp(player.x_impact_velocity + xAccel, -player.terminal_velocity, player.terminal_velocity)
			end

			local yAccel = math.clamp(-dY*player.impact_acceleration, -entity.max_impulse, entity.max_impulse)
			local yAbsAccel = math.abs(yAccel)
			if player.y_impact_velocity > 0 then
				player.y_impact_velocity = math.clamp(player.y_impact_velocity + yAbsAccel, -player.terminal_velocity, player.terminal_velocity)
			elseif player.y_impact_velocity < 0 then
				player.y_impact_velocity = math.clamp(player.y_impact_velocity - yAbsAccel, -player.terminal_velocity, player.terminal_velocity)
			elseif player.y_impact_velocity == 0 then
				player.y_impact_velocity = math.clamp(player.y_impact_velocity + yAccel, -player.terminal_velocity, player.terminal_velocity)
			end
		end
		
		if player.state ~= 'DEAD' then
			if self then	
				applyDamage(player, dmg, "SELF", entity.owner)
			else
				applyDamage(player, dmg, "ENEMY", entity.owner)
			end
		end
		entity.hasHit[player.name] = 1
	end
end

function applyDamage(player, damage, sourceType, from)
	if player.state ~= "DEAD" then
		addTextData(damage, player.x, player.y, 4, sourceType)
		player.health = math.max(0, player.health - damage)
		stats[player.name].roundDamageTaken = stats[player.name].roundDamageTaken + damage
		if sourceType == "ENEMY" then
			stats[from].roundDamageGiven = stats[from].roundDamageGiven + damage
		end

		if player.health <= 0 then
			player.state = "DEAD"
			if sourceType == "ENEMY" then
				stats[from].roundKills = stats[from].roundKills + 1
			elseif sourceType == "SELF" then
				stats[from].roundSuicides = stats[from].roundSuicides + 1
			elseif sourceType == "LAVA" then
				--figure something out for attributing lava kills correctly
			end
		end
	end
end

function getPlayerImg(player)
	local img = nil
	if player.orientation == "RIGHT" then
		img = player.States[player.state].animation[player.States[player.state].currentFrame].rightImg
	elseif player.orientation == "LEFT" then
		img = player.States[player.state].animation[player.States[player.state].currentFrame].leftImg
	end
	return img
end

function getPlayerRobe(player)
	local img = nil
	if player.orientation == "RIGHT" then
		img = player.States[player.state].animation[player.States[player.state].currentFrame].rightImg_robe
	elseif player.orientation == "LEFT" then
		img = player.States[player.state].animation[player.States[player.state].currentFrame].leftImg_robe
	end
	return img
end

function getPlayerOutline(player)
	local img = nil
	if player.orientation == "RIGHT" then
		img = player.States[player.state].animation[player.States[player.state].currentFrame].rightImg_outline
	elseif player.orientation == "LEFT" then
		img = player.States[player.state].animation[player.States[player.state].currentFrame].leftImg_outline
	end
	return img
end

function processInput(player)
	if player.state == "STAND" or player.state == "RUN" then 
		if love.keyboard.isDown(player.controls['RIGHT'])  then
			player.x_velocity = math.min(player.x_velocity + player.acceleration, player.max_movement_velocity)
		end 
		if love.keyboard.isDown(player.controls['LEFT']) then
			player.x_velocity = math.max(player.x_velocity - player.acceleration, -1*player.max_movement_velocity) 
		end
		if love.keyboard.isDown(player.controls['UP']) then
			player.y_velocity = math.max(player.y_velocity - player.acceleration, -1*player.max_movement_velocity)
		end
		if love.keyboard.isDown(player.controls['DOWN']) then
			player.y_velocity = math.min(player.y_velocity + player.acceleration, player.max_movement_velocity)
		end
	end

	for i=1, #skillslots do
		if love.keyboard.isDown(player.controls[skillslots[i]]) then
			if player.spellbook[skillslots[i]] ~= nil then 
				if player.spellbook[skillslots[i]].ready then
					player.selected_spell = skillslots[i] 
					if player.spellbook[skillslots[i]].archetype == "PROJECTILE" or player.spellbook[skillslots[i]].archetype == "ENTITYSPAWN" or player.spellbook[skillslots[i]].archetype == "ESCAPE" then
						updatePlayerState(player, "CASTING")
					elseif player.spellbook[skillslots[i]].archetype == "ENCHANTMENT" then
						if player.state == "STAND" or player.state == "RUN" then
							castSpell(player, player.spellbook[skillslots[i]])
						end
					end
				end
			end		
		end
	end

end

function calculatePlayerMovement(player, dt)
	updatePlayerPosition(player, (player.x + ((player.x_velocity * dt) + (player.x_impact_velocity*dt))), (player.y + ((player.y_velocity * dt) + (player.y_impact_velocity * dt))))
	--Movement velocity - movement friction	
	if player.x_velocity > 1 then 
		player.orientation = "RIGHT"
		if player.state == "STAND" then 
			updatePlayerState(player, "RUN")
		end
		player.x_velocity = math.max(0, player.x_velocity - (player.movement_friction * dt))
	elseif player.x_velocity < -1 then
		player.orientation = "LEFT"
		if player.state == "STAND" then 
			updatePlayerState(player, "RUN")
		end
		player.x_velocity = math.min(0, player.x_velocity + (player.movement_friction * dt)) 
	end

	if player.y_velocity > 1 then 
		if player.state == "STAND" then 
			updatePlayerState(player, "RUN")
		end
		player.y_velocity = math.max(0, player.y_velocity - (player.movement_friction * dt)) 
	elseif player.y_velocity < -1 then
		if player.state == "STAND" then 
			updatePlayerState(player, "RUN")
		end
		player.y_velocity = math.min(0, player.y_velocity + (player.movement_friction * dt)) 
	end

	if player.x_velocity < 1 and player.x_velocity > -1 and player.y_velocity < 1 and player.y_velocity > -1 then
		if player.state == "RUN" then 
			updatePlayerState(player, "STAND")
		end
		player.x_velocity = 0
		player.y_velocity = 0
	end

	--Impact velocity - impact friction
	if player.x_impact_velocity > 0 then 	
		player.x_impact_velocity = math.max(0, player.x_impact_velocity - (player.impact_friction * dt))
	elseif player.x_impact_velocity < 0 then
		player.x_impact_velocity = math.min(0, player.x_impact_velocity + (player.impact_friction * dt)) 
	end

	if player.y_impact_velocity > 0 then 
		player.y_impact_velocity = math.max(0, player.y_impact_velocity - (player.impact_friction * dt)) 
	elseif player.y_impact_velocity < 0 then
		player.y_impact_velocity = math.min(0, player.y_impact_velocity + (player.impact_friction * dt)) 
	end

	local playerX, playerY = player.hitbox:center()
	if playerX < playerX/stage.tilewidth then end
end

function updatePlayerState(player, state)
	if state ~= player.state then
		if state == 'CASTING' then 
			player.x = player.x - 1
		end
	end

	player.States[player.state].currentFrame = 1
	player.state = state
	player.height = player.States[state].animation[1].leftImg_outline:getHeight()
	player.width = player.States[state].animation[1].leftImg_outline:getWidth()
end

function updatePlayerHitbox(player)
	player.hitbox:moveTo(player.x + player.width, player.y + player.height)
end

function updatePlayerPosition(player, x, y)
	player.x = x
	player.y = y
	updatePlayerHitbox(player)
end

function drawPlayer(player)
	love.graphics.setColor(player.colour.r, player.colour.g, player.colour.b, 255)
	love.graphics.draw(getPlayerRobe(player), player.x, player.y, 0, 2, 2)	
	resetColour()
	love.graphics.draw(getPlayerOutline(player), player.x, player.y, 0, 2, 2)
	
	if player.state ~= 'DEAD' then 
		if settings.showPlayerNames then
			local width = player.States['STAND'].animation[1].leftImg_outline:getWidth()*2
			love.graphics.setColor(255, 255, 0, 255)
			love.graphics.printf(player.alias, player.x - 60 , player.y - width*1.1, 150, 'center')
			resetColour()
		end

		if settings.showHealthBars then 
			local width = player.States['STAND'].animation[1].leftImg_outline:getWidth()*2 + 10
			local currHealth = player.health/player.max_health
			love.graphics.setColor(255*(1-currHealth), 255*currHealth, 0, 255)
			love.graphics.rectangle('fill', player.x-5, player.y-7, width*currHealth, 6)
			love.graphics.setColor(0, 0, 0, 255)
			love.graphics.rectangle('line', player.x-5, player.y-7, width , 6)
			resetColour()
		end
	end
	
	if debug then
		love.graphics.setColor(255, 102, 0, 255)
		love.graphics.circle("line", player.hitbox:outcircle())
		local cx, cy = player.hitbox:center()
		love.graphics.circle("fill", cx, cy, 2, 16)
		resetColour()
	end
end