player1 = { 
	x = 100,
 	y = 200,
 	width = nil,
 	height = nil,
 	x_velocity = 0,
 	y_velocity = 0,
 	max_movement_velocity = 150,
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
 	name = "PLAYER_1"
}

playerStates = {}

function loadPlayerStates()
	playerStates["STAND"] = { 
		leftImg = love.graphics.newImage('assets/player/stand-left.png'),
		rightImg = love.graphics.newImage('assets/player/stand-right.png') 
	}
	playerStates["CASTING"] = {
		leftImg = love.graphics.newImage('assets/player/cast-left.png'),
		rightImg = love.graphics.newImage('assets/player/cast-right.png')
	}

	player1.height = playerStates["STAND"].leftImg:getHeight()
	player1.width = playerStates["STAND"].leftImg:getWidth()
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
		return playerStates[player.state].rightImg
	elseif player.orientation == "LEFT" then
		return playerStates[player.state].leftImg
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
				player.state = "CASTING"
				player.selected_spell = 'SPELL1' -- They should enter 'casting' state where you pick where to cast
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