function initialise()
	love.mouse.setCursor(love.mouse.newCursor("assets/misc/cursor.png", 0, 0))
	love.graphics.setNewFont("assets/misc/IndieFlower.ttf", defaultFontSize)
	initSpells() 
	initEffects() 
	for key, player in pairs(players) do
		initPlayer(player)
	end
	initPlayerControls() 

	camera = Camera(players['PLAYER_1'].x, players['PLAYER_1'].y)
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
		damage = 25, --make this 8?
		timeBetweenFrames = 0.1,
		frameTimer = 0.1,
		size = 0.15
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