player1 = { 
	x = 100,
 	y = 200,
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
 	name = "PLAYER_1",
 	colour = "PURPLE",
 	States = {},
 	hibox = nil
}

function initialisePlayer(player)
	player.States["STAND"] = { 
		leftImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/stand-left.png'),
		rightImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/stand-right.png') 
	}
	player.States["CASTING"] = {
		leftImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/cast-left.png'),
		rightImg = love.graphics.newImage('assets/player/' .. player.colour ..  '/cast-right.png')
	}

	player.height = player.States["STAND"].leftImg:getHeight()
	player.width = player.States["STAND"].leftImg:getWidth()

	player.hitbox = HC.circle(player.x + player.width*0.75, player.y + player.height*0.75, player.height*0.8)
	player.hitbox.owner = player.name
	player.hitbox.type = "PLAYER"
end

function loadPlayerControls()
	player1.controls['RIGHT'] = 'd'
	player1.controls['LEFT'] = 'a'
	player1.controls['UP'] = 'w'
	player1.controls['DOWN'] = 's'
	player1.controls['SPELL1'] = '1'
	player1.controls['SPELL2'] = '2'
	player1.controls['SPELL3'] = '3'
	player1.controls['SPELL4'] = '4'
	player1.controls['SPELL5'] = '5'
end

function getPlayerImg(player)
	if player.orientation == "RIGHT" then
		return player.States[player.state].rightImg
	elseif player.orientation == "LEFT" then
		return player.States[player.state].leftImg
	end
end

function processInput(player)
	if player.state == "STAND" then 
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
	
	if love.keyboard.isDown(player.controls['SPELL1']) then
		if player.spellbook['SPELL1'] ~= nil then 
			if player.spellbook['SPELL1'].ready then
				updatePlayerState(player, "CASTING")
				player.selected_spell = 'SPELL1' 
			end
		end		
	end
end

function calculatePlayerMovement(player, dt)
	player.x = player.x + (player.x_velocity * dt)
	player.y = player.y + (player.y_velocity * dt)
	if player.x_velocity > 0 then 
		player.orientation = "RIGHT"
		player.x_velocity = math.max(0, player.x_velocity - (player.movement_friction * dt)) 
	elseif player.x_velocity < 0 then
		player.orientation = "LEFT"
		player.x_velocity = math.min(0, player.x_velocity + (player.movement_friction * dt)) 
	end

	if player.y_velocity > 0 then 
		player.y_velocity = math.max(0, player.y_velocity - (player.movement_friction * dt)) 
	elseif player.y_velocity < 0 then
		player.y_velocity = math.min(0, player.y_velocity + (player.movement_friction * dt)) 
	end
end

function drawPlayer(player)
	love.graphics.draw(getPlayerImg(player), player.x, player.y, 0, 1.5, 1.5)
	if displayNames then
		love.graphics.print(player.name, player.x - player.width, player.y - player.height)
	end
	if debug then
		love.graphics.circle("line", player.hitbox:outcircle())
	end
end

function updatePlayerState(player, state)
	player.state = state
	player.height = player.States[state].leftImg:getHeight()
	player.width = player.States[state].leftImg:getWidth()
end

function updatePlayerHitbox(player)
	player.hitbox:moveTo(player.x + player.width*0.75, player.y + player.height*0.75)
end