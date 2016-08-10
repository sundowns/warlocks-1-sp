function initialise()
	love.mouse.setCursor(love.mouse.newCursor("assets/misc/cursor.png", 0, 0))
	love.graphics.setNewFont("assets/misc/IndieFlower.ttf", defaultFontSize)
	initSpells() 
	initEffects() 
	initEntities()
	initStage()
	for key, player in pairs(players) do
		initPlayer(player)
	end
	initPlayerControls() 
	initGame()

	camera = Camera(players['PLAYER_1'].x, players['PLAYER_1'].y)
	camera:zoom(1.25)
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

	players['PLAYER_3'].controls['RIGHT'] = 'right'
	players['PLAYER_3'].controls['LEFT'] = 'left'
	players['PLAYER_3'].controls['UP'] = 'up'
	players['PLAYER_3'].controls['DOWN'] = 'down'
	players['PLAYER_3'].controls['SPELL1'] = 'kp1'
	players['PLAYER_3'].controls['SPELL2'] = 'kp2'
	players['PLAYER_3'].controls['SPELL3'] = 'kp3'
	players['PLAYER_3'].controls['SPELL4'] = 'kp4'
	players['PLAYER_3'].controls['SPELL5'] = 'kp5'
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
		-- TODO: add other half of sprite
		leftImg_outline = love.graphics.newImage('assets/player/stand-left-outline.png'),
		leftImg_robe = love.graphics.newImage('assets/player/stand-left-robe.png'),
		rightImg_outline = love.graphics.newImage('assets/player/stand-right-outline.png'),
		rightImg_robe = love.graphics.newImage('assets/player/stand-right-robe.png')
	}

	--RUN
	player.States["RUN"] = { 
		animation = {},
		currentFrame = 1,
		timeBetweenFrames = 0.15,
		frameTimer = 0.15
	}
	player.States["RUN"].animation[1] = {
		leftImg_outline = love.graphics.newImage('assets/player/run-left-outline-1.png'),
		leftImg_robe = love.graphics.newImage('assets/player/run-left-robe-1.png'),
		rightImg_outline = love.graphics.newImage('assets/player/run-right-outline-1.png'),
		rightImg_robe = love.graphics.newImage('assets/player/run-right-robe-1.png')
	}
	player.States["RUN"].animation[2] = {
		leftImg_outline = love.graphics.newImage('assets/player/run-left-outline-2.png'),
		leftImg_robe = love.graphics.newImage('assets/player/run-left-robe-2.png'),
		rightImg_outline = love.graphics.newImage('assets/player/run-right-outline-2.png'),
		rightImg_robe = love.graphics.newImage('assets/player/run-right-robe-2.png')
	}
	player.States["RUN"].animation[3] = {
		leftImg_outline = love.graphics.newImage('assets/player/run-left-outline-3.png'),
		leftImg_robe = love.graphics.newImage('assets/player/run-left-robe-3.png'),
		rightImg_outline = love.graphics.newImage('assets/player/run-right-outline-3.png'),
		rightImg_robe = love.graphics.newImage('assets/player/run-right-robe-3.png')
	}
	player.States["RUN"].animation[4] = {
		leftImg_outline = love.graphics.newImage('assets/player/run-left-outline-4.png'),
		leftImg_robe = love.graphics.newImage('assets/player/run-left-robe-4.png'),
		rightImg_outline = love.graphics.newImage('assets/player/run-right-outline-4.png'),
		rightImg_robe = love.graphics.newImage('assets/player/run-right-robe-4.png')
	}
	player.States["RUN"].animation[5] = {
		leftImg_outline = love.graphics.newImage('assets/player/run-left-outline-5.png'),
		leftImg_robe = love.graphics.newImage('assets/player/run-left-robe-5.png'),
		rightImg_outline = love.graphics.newImage('assets/player/run-right-outline-5.png'),
		rightImg_robe = love.graphics.newImage('assets/player/run-right-robe-5.png')
	}
	player.States["RUN"].animation[6] = {
		leftImg_outline = love.graphics.newImage('assets/player/run-left-outline-6.png'),
		leftImg_robe = love.graphics.newImage('assets/player/run-left-robe-6.png'),
		rightImg_outline = love.graphics.newImage('assets/player/run-right-outline-6.png'),
		rightImg_robe = love.graphics.newImage('assets/player/run-right-robe-6.png')
	}

	--CASTING
	player.States["CASTING"] = { 
		animation = {},
		currentFrame = 1,
		timeBetweenFrames = 1000,
		frameTimer = 1000
	}
	player.States["CASTING"].animation[1] = {
		leftImg_outline = love.graphics.newImage('assets/player/cast-left-outline.png'),
		leftImg_robe = love.graphics.newImage('assets/player/cast-left-robe.png'),
		rightImg_outline = love.graphics.newImage('assets/player/cast-right-outline.png'),
		rightImg_robe = love.graphics.newImage('assets/player/cast-right-robe.png')
	}

	--DEAD
	player.States["DEAD"] = { 
		animation = {},
		currentFrame = 1,
		timeBetweenFrames = 1000,
		frameTimer = 1000
	}
	player.States["DEAD"].animation[1] = {
		leftImg_outline = love.graphics.newImage('assets/player/dead-left-outline.png'),
		leftImg_robe = love.graphics.newImage('assets/player/dead-left-robe.png'),
		rightImg_outline = love.graphics.newImage('assets/player/dead-right-outline.png'),
		rightImg_robe = love.graphics.newImage('assets/player/dead-right-robe.png')
	}

	player.height = player.States["STAND"].animation[1].leftImg_outline:getHeight()
	player.width = player.States["STAND"].animation[1].leftImg_outline:getWidth()

	player.hitbox = HC.circle(player.x + player.width*1.2, player.y + player.height*1.2, player.height*1.05)
	player.hitbox.owner = player.name
	player.hitbox.type = "PLAYER"
end

function initSpells()
	--FIREBALL--
	spells["FIREBALL"] = {
		name = "Fireball",
		level = 1,
		archetype = "PROJECTILE",
		cooldown = 1, --make this 8?
		timer = 0,
		ready = true,
		lifespan = 2, --make this 2?
		speed = 180,
		currentFrame = 1,
		animation = {},
		max_impulse = 120,
		damage = 8, --make this 8?
		timeBetweenFrames = 0.1,
		frameTimer = 0.1,
		size = 0.15,
		radius = 30,
	}

	spells["FIREBALL"].animation[1] = love.graphics.newImage('assets/spells/fireball/1.png')
	spells["FIREBALL"].animation[2] = love.graphics.newImage('assets/spells/fireball/2.png')
	spells["FIREBALL"].animation[3] = love.graphics.newImage('assets/spells/fireball/3.png')
	spells["FIREBALL"].animation[4] = love.graphics.newImage('assets/spells/fireball/4.png')
	spells["FIREBALL"].animation[5] = love.graphics.newImage('assets/spells/fireball/5.png')
	spells["FIREBALL"].animation[6] = love.graphics.newImage('assets/spells/fireball/6.png')		

	--SPRINT

	spells["SPRINT"] = {
		name = "Sprint",
		level = 1,
		archetype = "ENCHANTMENT",
		cooldown = 10, 
		ready = true,
		lifespan = 3, 
		buff_acceleration = 35,
		buff_max_velocity = 130,
		currentFrame = 1,
		animation = {},
		timeBetweenFrames = 0.015,
		frameTimer = 0.015,
		size = 1
	}

	spells["SPRINT"].animation[1]= love.graphics.newImage('assets/spells/sprint/1.png')
	spells["SPRINT"].animation[2]= love.graphics.newImage('assets/spells/sprint/2.png')
	spells["SPRINT"].animation[3]= love.graphics.newImage('assets/spells/sprint/3.png')
	spells["SPRINT"].animation[4]= love.graphics.newImage('assets/spells/sprint/4.png')
	spells["SPRINT"].animation[5]= love.graphics.newImage('assets/spells/sprint/5.png')
	spells["SPRINT"].animation[6]= love.graphics.newImage('assets/spells/sprint/6.png')
	spells["SPRINT"].animation[7]= love.graphics.newImage('assets/spells/sprint/7.png')
	spells["SPRINT"].animation[8]= love.graphics.newImage('assets/spells/sprint/8.png')
	spells["SPRINT"].animation[9]= love.graphics.newImage('assets/spells/sprint/9.png')
	spells["SPRINT"].animation[10]= love.graphics.newImage('assets/spells/sprint/10.png')
	spells["SPRINT"].animation[11]= love.graphics.newImage('assets/spells/sprint/11.png')
	spells["SPRINT"].animation[12]= love.graphics.newImage('assets/spells/sprint/12.png')
	spells["SPRINT"].animation[13]= love.graphics.newImage('assets/spells/sprint/13.png')
	spells["SPRINT"].animation[14]= love.graphics.newImage('assets/spells/sprint/14.png')
	spells["SPRINT"].animation[15]= love.graphics.newImage('assets/spells/sprint/15.png')
	spells["SPRINT"].animation[16]= love.graphics.newImage('assets/spells/sprint/16.png')

	--FISSURE

	spells["FISSURE"] = {
		name = "Fissure",
		level = 1,
		archetype = "ENTITYSPAWN",
		cooldown = 0.1,
		timer = 0,
		ready = true,
		speed = 180,
		currentFrame = 1,
		animation = {
			charging = {},
			attack = {}
		},
		max_impulse = 200,
		damage = 16, 
		timeBetweenFramesCharging = 0.155,
		timeBetweenFramesActive = 0.12,
		frameTimer = 0.18,
		size = 0.15,
		radius = 30,
		active = false,
		chargingTime = 3,
		activeTimer = 1,
		attackAnimationLength = 11,
		attackAnimationTimer = 0.11*11,
		chargingAnimationLength = 21
	}

	spells["FISSURE"].animation[1] = { charging = love.graphics.newImage('assets/spells/fissure/1.png'), attack = love.graphics.newImage('assets/spells/fissure/1-attack.png')  } 
	spells["FISSURE"].animation[2] = { charging = love.graphics.newImage('assets/spells/fissure/2.png'), attack = love.graphics.newImage('assets/spells/fissure/2-attack.png') } 
	spells["FISSURE"].animation[3] = { charging = love.graphics.newImage('assets/spells/fissure/3.png'), attack = love.graphics.newImage('assets/spells/fissure/3-attack.png') } 
	spells["FISSURE"].animation[4] = { charging = love.graphics.newImage('assets/spells/fissure/4.png'), attack = love.graphics.newImage('assets/spells/fissure/4-attack.png') } 
	spells["FISSURE"].animation[5] = { charging = love.graphics.newImage('assets/spells/fissure/5.png'), attack = love.graphics.newImage('assets/spells/fissure/5-attack.png') } 
	spells["FISSURE"].animation[6] = { charging = love.graphics.newImage('assets/spells/fissure/6.png'), attack = love.graphics.newImage('assets/spells/fissure/6-attack.png') } 
	spells["FISSURE"].animation[7] = { charging = love.graphics.newImage('assets/spells/fissure/7.png'), attack = love.graphics.newImage('assets/spells/fissure/7-attack.png') } 
	spells["FISSURE"].animation[8] = { charging = love.graphics.newImage('assets/spells/fissure/8.png'), attack = love.graphics.newImage('assets/spells/fissure/8-attack.png') } 
	spells["FISSURE"].animation[9] = { charging = love.graphics.newImage('assets/spells/fissure/9.png'), attack = love.graphics.newImage('assets/spells/fissure/9-attack.png') } 
	spells["FISSURE"].animation[10] = { charging = love.graphics.newImage('assets/spells/fissure/10.png'), attack = love.graphics.newImage('assets/spells/fissure/10-attack.png') } 
	spells["FISSURE"].animation[11] = { charging = love.graphics.newImage('assets/spells/fissure/11.png'), attack = love.graphics.newImage('assets/spells/fissure/11-attack.png') } 
	spells["FISSURE"].animation[12] = { charging = love.graphics.newImage('assets/spells/fissure/12.png') } 
	spells["FISSURE"].animation[13] = { charging = love.graphics.newImage('assets/spells/fissure/13.png') } 
	spells["FISSURE"].animation[14] = { charging = love.graphics.newImage('assets/spells/fissure/14.png') } 
	spells["FISSURE"].animation[15] = { charging = love.graphics.newImage('assets/spells/fissure/15.png') } 
	spells["FISSURE"].animation[16] = { charging = love.graphics.newImage('assets/spells/fissure/16.png') } 
	spells["FISSURE"].animation[17] = { charging = love.graphics.newImage('assets/spells/fissure/17.png') } 
	spells["FISSURE"].animation[18] = { charging = love.graphics.newImage('assets/spells/fissure/18.png') } 
	spells["FISSURE"].animation[19] = { charging = love.graphics.newImage('assets/spells/fissure/19.png') } 
	spells["FISSURE"].animation[20] = { charging = love.graphics.newImage('assets/spells/fissure/20.png') } 
	spells["FISSURE"].animation[21] = { charging = love.graphics.newImage('assets/spells/fissure/21.png') } 

	--TELEPORT

	spells["TELEPORT"] = {
		name = "Teleport",
		level = 1,
		archetype = "ESCAPE",
		cooldown = 1, 
		ready = true,
		lifespan = 0.7, 
		currentFrame = 1,
		size = 0.4,
		animation = {},
		timeBetweenFrames = 0.021,
		frameTimer = 0.021,
		time_to_live = 2
	}

	spells["TELEPORT"].animation[1]= love.graphics.newImage('assets/spells/teleport/1.png')
	spells["TELEPORT"].animation[2]= love.graphics.newImage('assets/spells/teleport/2.png')
	spells["TELEPORT"].animation[3]= love.graphics.newImage('assets/spells/teleport/3.png')
	spells["TELEPORT"].animation[4]= love.graphics.newImage('assets/spells/teleport/4.png')
	spells["TELEPORT"].animation[5]= love.graphics.newImage('assets/spells/teleport/5.png')
	spells["TELEPORT"].animation[6]= love.graphics.newImage('assets/spells/teleport/6.png')
	spells["TELEPORT"].animation[7]= love.graphics.newImage('assets/spells/teleport/7.png')
	spells["TELEPORT"].animation[8]= love.graphics.newImage('assets/spells/teleport/8.png')
	spells["TELEPORT"].animation[9]= love.graphics.newImage('assets/spells/teleport/9.png')
	spells["TELEPORT"].animation[10]= love.graphics.newImage('assets/spells/teleport/10.png')
	spells["TELEPORT"].animation[11]= love.graphics.newImage('assets/spells/teleport/11.png')
	spells["TELEPORT"].animation[12]= love.graphics.newImage('assets/spells/teleport/12.png')
	spells["TELEPORT"].animation[13]= love.graphics.newImage('assets/spells/teleport/13.png')
	spells["TELEPORT"].animation[14]= love.graphics.newImage('assets/spells/teleport/14.png')
	spells["TELEPORT"].animation[15]= love.graphics.newImage('assets/spells/teleport/15.png')
	spells["TELEPORT"].animation[16]= love.graphics.newImage('assets/spells/teleport/16.png')
	spells["TELEPORT"].animation[17]= love.graphics.newImage('assets/spells/teleport/17.png')
	spells["TELEPORT"].animation[18]= love.graphics.newImage('assets/spells/teleport/18.png')
	spells["TELEPORT"].animation[19]= love.graphics.newImage('assets/spells/teleport/19.png')
	spells["TELEPORT"].animation[20]= love.graphics.newImage('assets/spells/teleport/20.png')
	spells["TELEPORT"].animation[21]= love.graphics.newImage('assets/spells/teleport/21.png')
	spells["TELEPORT"].animation[22]= love.graphics.newImage('assets/spells/teleport/22.png')
	spells["TELEPORT"].animation[23]= love.graphics.newImage('assets/spells/teleport/23.png')
	spells["TELEPORT"].animation[24]= love.graphics.newImage('assets/spells/teleport/24.png')
	spells["TELEPORT"].animation[25]= love.graphics.newImage('assets/spells/teleport/25.png')
	spells["TELEPORT"].animation[26]= love.graphics.newImage('assets/spells/teleport/26.png')
	spells["TELEPORT"].animation[27]= love.graphics.newImage('assets/spells/teleport/27.png')
	spells["TELEPORT"].animation[28]= love.graphics.newImage('assets/spells/teleport/28.png')
	spells["TELEPORT"].animation[29]= love.graphics.newImage('assets/spells/teleport/29.png')
	spells["TELEPORT"].animation[30]= love.graphics.newImage('assets/spells/teleport/30.png')
	spells["TELEPORT"].animation[31]= love.graphics.newImage('assets/spells/teleport/31.png')
	spells["TELEPORT"].animation[32]= love.graphics.newImage('assets/spells/teleport/32.png')
	spells["TELEPORT"].animation[33]= love.graphics.newImage('assets/spells/teleport/33.png')


end

function initEffects()
	effects["EXPLOSION"] = {
		name = "Explosion",
		size = 0.5,
		animation = {},
		timeBetweenFrames = 0.05,
		frameTimer = 0.05,
	}

	effects["EXPLOSION"].animation[1] = love.graphics.newImage('assets/effects/explosion/1.png')
	effects["EXPLOSION"].animation[2] = love.graphics.newImage('assets/effects/explosion/2.png')
	effects["EXPLOSION"].animation[3] = love.graphics.newImage('assets/effects/explosion/3.png')
	effects["EXPLOSION"].animation[4] = love.graphics.newImage('assets/effects/explosion/4.png')
	effects["EXPLOSION"].animation[5] = love.graphics.newImage('assets/effects/explosion/5.png')
	effects["EXPLOSION"].animation[6] = love.graphics.newImage('assets/effects/explosion/6.png')
	effects["EXPLOSION"].animation[7] = love.graphics.newImage('assets/effects/explosion/7.png')
	effects["EXPLOSION"].animation[8] = love.graphics.newImage('assets/effects/explosion/8.png')
	effects["EXPLOSION"].animation[9] = love.graphics.newImage('assets/effects/explosion/9.png')
	effects["EXPLOSION"].animation[10] = love.graphics.newImage('assets/effects/explosion/10.png')
end

function initEntities() 
	entities['FIREBALL_BLAST'] = {
		name = "Fireball Blast",
		x = nil,
		y = nil,
		radius = nil,
		damage = nil,
		spell = nil,
		duration = nil,
		timetolive = nil,
		animation = {},
		timeBetweenFrames = 0.05,
		frameTimer = 0.05,
		owner = nil
	}
end

function initGame()
	for i = 1, totalPlayers do --if something fucks up, make sure this is initialising correct for all players (namely the last player)
		print("wtf ayy")
		stats['PLAYER_'..i] = { 
			roundDamageGiven = 0, --Done for now, needs to reset on new round
			totalDamageGiven = 0,
			roundDamageTaken = 0, --Done for now, needs to reset on new round
			totalDamageTaken = 0,
			roundKills = 0,
			totalKills = 0,
			roundSuicides = 0,
			totalSuicides = 0
		}
	end
end