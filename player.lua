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
	 	colour = "PURPLE",
	 	States = {},
	 	hitbox = nil,
	 	impact_acceleration = 2000,
	 	x_impact_velocity = 0,
	 	y_impact_velocity = 0,
	 	terminal_velocity = 350,
	 	impact_friction = 80,
	 	active_enchantments = {},
	 	alias = "sundowns" -- shouldnt be over ~20 chars
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
	 	colour = "GREEN",
	 	States = {},
	 	hitbox = nil,
	 	impact_acceleration = 2000,
	 	x_impact_velocity = 0,
	 	y_impact_velocity = 0,
	 	terminal_velocity = 350,
	 	impact_friction = 80,
	 	active_enchantments = {},
	 	alias = "Swiggy McLongNames" -- shouldnt be over ~20 chars
	}

skillslots = {'SPELL1', 'SPELL2', 'SPELL3', 'SPELL4', 'SPELL5'}

--check id dX,dY or right, some reason it aint moving haha idk
function projectileHit(playerShape, projectile, dX, dY)
	local player = players[playerShape.owner]	
	player.x_impact_velocity = math.clamp(player.x_impact_velocity + math.clamp((-dX*player.impact_acceleration), -projectile.max_impulse, projectile.max_impulse), -player.terminal_velocity, player.terminal_velocity)
	player.y_impact_velocity = math.clamp(player.y_impact_velocity + math.clamp((-dY*player.impact_acceleration), -projectile.max_impulse, projectile.max_impulse), -player.terminal_velocity, player.terminal_velocity)
	applyDamage(player, projectile.damage)
	
end

function applyDamage(player, damage)
	addTextData(damage, player.x, player.y, 4, "DAMAGE")
	player.health = math.max(0, player.health - damage)
	if debug then
		print(player.name .. "'s HP: " .. player.health)
	end
	if player.health <= 0 then
		player.state = "DEAD"
	end
end

function initPlayer(player)
	--STAND
	player.States["STAND"] = {
		animation={},
		currentFrame = 1,
		timeBetweenFrames = 1000,
		frameTimer = 1000
	}

	player.States["STAND"].animation[1] = {
		leftImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/stand-left.png'),
		rightImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/stand-right.png'),
	}

	--RUN
	player.States["RUN"] = { 
		animation = {},
		currentFrame = 1,
		timeBetweenFrames = 0.15,
		frameTimer = 0.15
	}
	player.States["RUN"].animation[1] = {
		leftImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/run-left-1.png'),
		rightImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/run-right-1.png')
	}
	player.States["RUN"].animation[2] = {
		leftImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/run-left-2.png'),
		rightImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/run-right-2.png')
	}
	player.States["RUN"].animation[3] = {
		leftImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/run-left-3.png'),
		rightImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/run-right-3.png')
	}
	player.States["RUN"].animation[4] = {
		leftImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/run-left-4.png'),
		rightImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/run-right-4.png')
	}
	player.States["RUN"].animation[5] = {
		leftImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/run-left-5.png'),
		rightImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/run-right-5.png')
	}
	player.States["RUN"].animation[6] = {
		leftImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/run-left-6.png'),
		rightImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/run-right-6.png')
	}

	--CASTING
	player.States["CASTING"] = { 
		animation = {},
		currentFrame = 1,
		timeBetweenFrames = 1000,
		frameTimer = 1000
	}
	player.States["CASTING"].animation[1] = {
		leftImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/cast-left.png'),
		rightImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/cast-right.png'),
	}

	--DEAD
	player.States["DEAD"] = { 
		animation = {},
		currentFrame = 1,
		timeBetweenFrames = 1000,
		frameTimer = 1000
	}
	player.States["DEAD"].animation[1] = {
		leftImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/dead-left.png'),
		rightImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/dead-right.png'),
	}

	player.height = player.States["STAND"].animation[1].leftImg:getHeight()
	player.width = player.States["STAND"].animation[1].leftImg:getWidth()

	player.hitbox = HC.circle(player.x + player.width*1.2, player.y + player.height*1.2, player.height*1.05)
	player.hitbox.owner = player.name
	player.hitbox.type = "PLAYER"
end

function initPlayerControls()
	players['PLAYER_1'].controls['RIGHT'] = 'd'
	players['PLAYER_1'].controls['LEFT'] = 'a'
	players['PLAYER_1'].controls['UP'] = 'w'
	players['PLAYER_1'].controls['DOWN'] = 's'
	players['PLAYER_1'].controls['SPELL1'] = '1'
	players['PLAYER_1'].controls['SPELL2'] = '2'
	players['PLAYER_1'].controls['SPELL3'] = '3'
	players['PLAYER_1'].controls['SPELL4'] = '4'
	players['PLAYER_1'].controls['SPELL5'] = '5'

	players['PLAYER_2'].controls['RIGHT'] = 'right'
	players['PLAYER_2'].controls['LEFT'] = 'left'
	players['PLAYER_2'].controls['UP'] = 'up'
	players['PLAYER_2'].controls['DOWN'] = 'down'
	players['PLAYER_2'].controls['SPELL1'] = 'kp1'
	players['PLAYER_2'].controls['SPELL2'] = 'kp2'
	players['PLAYER_2'].controls['SPELL3'] = 'kp3'
	players['PLAYER_2'].controls['SPELL4'] = 'kp4'
	players['PLAYER_2'].controls['SPELL5'] = 'kp5'
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
					if player.spellbook[skillslots[i]].archetype == "PROJECTILE" then
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
end

function updatePlayerState(player, state)
	if state ~= player.state then
		if state == 'CASTING' then 
			player.x = player.x - 1
		end
	end

	player.States[player.state].currentFrame = 1
	player.state = state
	player.height = player.States[state].animation[1].leftImg:getHeight()
	player.width = player.States[state].animation[1].leftImg:getWidth()
end

function updatePlayerHitbox(player)
	player.hitbox:moveTo(player.x + player.width, player.y + player.height)
end

function updatePlayerPosition(player, x, y)
	player.x = x
	player.y = y
	updatePlayerHitbox(player)
end

function getCenter(player)
	return player.x + player.width/2, player.y + player.height/2
end

function drawPlayer(player)
	love.graphics.draw(getPlayerImg(player), player.x, player.y, 0, 2, 2)

	if player.state ~= 'DEAD' then 
		if settings.showPlayerNames then
			local width = player.States['STAND'].animation[1].leftImg:getWidth()*2
			love.graphics.setColor(255, 255, 0, 255)
			love.graphics.printf(player.alias, player.x - 60 , player.y - width*1.1, 150, 'center')
			resetColour()
		end

		if settings.showHealthBars then 
			local width = player.States['STAND'].animation[1].leftImg:getWidth()*2 + 10
			local currHealth = player.health/player.max_health
			love.graphics.setColor(255*(1-currHealth), 255*currHealth, 0, 255)
			love.graphics.rectangle('fill', player.x-5, player.y-7, width*currHealth, 6)
			love.graphics.setColor(0, 0, 0, 255)
			love.graphics.rectangle('line', player.x-5, player.y-7, width , 6)
			resetColour()
		end
	end
	
	if debug then
		love.graphics.circle("line", player.hitbox:outcircle())
	end
end