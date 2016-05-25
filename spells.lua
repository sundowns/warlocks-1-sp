spells = {}
projectiles = {}

function initSpells()
	--FIREBALL--
	spells["FIREBALL"] = {
		name = "Fireball",
		level = 1,
		archetype = "PROJECTILE",
		cooldown = 1, --make this 8?
		timer = 0,
		ready = true,
		lifespan = 3, --make this 2?
		speed = 160,
		currentFrame = 1,
		animation = {},
		max_impulse = 120,
		damage = 8,
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
		cooldown = 4, 
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

function castSpell(player, spell, x, y)
	if spell.ready then 
		if spell.archetype == "PROJECTILE" then 
			if spell.name == "Fireball" then 
				castLinearProjectile(player, spell, x, y)
			end
			updatePlayerState(player, "STAND")
		elseif spell.archetype == "ENCHANTMENT" then
			if spell.name == "Sprint" then 
				castSprint(player, spell)
			end
		end
	end
end

function castSprint(player, spell) 
	print("X: " ..player.x .. " Y: " .. player.y .. " w: " .. player.width .. ' h: ' .. player.height)
	local startX = player.x + player.width
	local startY = player.y + player.height
	addSpellEffect(spell, startX, startY, spell.lifespan, player.name)
	local sprintEnchant = {
		duration = spell.lifespan,
		name = spell.name,
		mode = spell.archetype,
		buff_max_velocity = spell.buff_max_velocity,
		buff_acceleration = spell.buff_acceleration
	}
	player.active_enchantments['SPRINT'] = sprintEnchant
	player.max_movement_velocity = player.max_movement_velocity + spell.buff_max_velocity
	player.acceleration = player.acceleration + spell.buff_acceleration
	spell.ready = false
	spell.timer = spell.cooldown
end

function updateEnchantments(player, dt) 
	for key, enchantment in pairs(player.active_enchantments) do 
		print(enchantment.duration)
		enchantment.duration = math.max(0, enchantment.duration - dt)
		if enchantment.mode == "ENCHANTMENT" then
			for i, effect in ipairs(effects) do
				if effect.key == enchantment.name..'-'..player.name then
					effect.x = player.x - effect.animation[1]:getWidth()/2 + player.width
					effect.y = player.y - effect.animation[1]:getHeight()/2 + player.height
				end
			end
		end

		if enchantment.duration == 0 then
			print('never happens ' .. enchantment.name)
			if enchantment.name == 'Sprint' then
				print('death to sprint')
				player.max_movement_velocity = player.max_movement_velocity - enchantment.buff_max_velocity
				player.acceleration = player.acceleration - enchantment.buff_acceleration
			end
			player.active_enchantments[key] = nil
		end
	end
end

function castLinearProjectile(player, spell, x, y)
	local startX = player.x + player.width/2
	local startY = player.y + player.height/2
	local p_angle = math.atan2((y - startY), (x - startX))
	local p_Dx = spell.speed * math.cos(p_angle)
	local p_Dy = spell.speed * math.sin(p_angle)

	newProjectile = {
		x = startX,
		y = startY,
		dx = p_Dx,
		dy = p_Dy,
		angle = p_angle,
		img = spell.img,
		time_to_live = spell.lifespan * player.modifier_range,
		size = spell.size * player.modifier_aoe,
		currentFrame = 1,
		animation = spell.animation,
		owner = player.name,
		hitbox = nil,
		width = spell.size * player.modifier_aoe * spell.animation[1]:getWidth(),
		height = spell.size * player.modifier_aoe * spell.animation[1]:getHeight(),
		max_impulse = spell.max_impulse,
		damage = spell.damage,
		frameTimer = spell.frameTimer,
		timeBetweenFrames = spell.timeBetweenFrames
	}

	newProjectile.hitbox = HC.polygon(calculateProjectileHitbox(
		newProjectile.x, newProjectile.y, newProjectile.angle,
		newProjectile.width, newProjectile.height))
	newProjectile.hitbox.owner = newProjectile.owner 
	newProjectile.hitbox.type = "SPELL"
	newProjectile.hitbox.spell = "FIREBALL"

	table.insert(projectiles, newProjectile)
	spell.ready = false
	spell.timer = spell.cooldown
end

function updateProjectile(projectile, dt, kill, i)
	projectile.time_to_live = math.max(0, projectile.time_to_live - dt)
	if projectile.time_to_live == 0 or kill then
		destroy(projectile, i)
	else 
		projectile.x = projectile.x + (projectile.dx * dt)
		projectile.y = projectile.y + (projectile.dy * dt)

		projectile.hitbox:moveTo(calculateProjectileCenter(projectile.x, projectile.y, projectile.angle, projectile.width, projectile.height))
	end
end

function drawProjectile(projectile)
	love.graphics.draw(projectile.animation[projectile.currentFrame], projectile.x, projectile.y, projectile.angle, projectile.size, projectile.size)

	if debug then
		love.graphics.setColor(0, 255, 0, 255)
		projectile.hitbox:draw('line') -- hitbox polygon = green
		love.graphics.points(calculateProjectileCenter(projectile.x, projectile.y, projectile.angle, projectile.width, projectile.height)) -- blue center
		resetColour()
	end
end

function calculateProjectileHitbox(x1, y1, angle, width, height)
	local x2 = x1 + (width * math.cos(angle))
	local y2 = y1 + (width * math.sin(angle))
	local x3 = x1 + (height * math.cos(angle+1.5)) --idk why +1.5 radians is the perpendicular but hey, it works
	local y3 = y1 + (height * math.sin(angle+1.5))
	local x4 = x3 + (x2 - x1) -- x3 + the difference between x1 and x2
	local y4 = y3 + (y2 - y1)

	return x1, y1, x2, y2, x4, y4, x3, y3 -- vertices in clockwise order
end

function calculateProjectileCenter(x, y, angle, width, height)
	local x1, y1, x2, y2, x3, y3, x4, y4 = calculateProjectileHitbox(x, y, angle, width, height)

	local centroidX = (x1 + x2 + x3 + x4)/4
	local centroidY = (y1 + y2 + y3 + y4)/4

	return centroidX, centroidY
end

function destroy(projectile, i)
	HC.remove(projectile.hitbox) 
	table.remove(projectiles, i)
end