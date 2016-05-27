spells = {}
projectiles = {}

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
		elseif spell.archetype == "ENTITYSPAWN" then
			if spell.name == "Fissure" then
				castFissure(player, spell, x, y)		
			end
			updatePlayerState(player, "STAND")
		end
	end
end

function castSprint(player, spell) 
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

function castFissure(player, spell, x, y)
	--calculate a point along the line between the player & xy that is the spell's range away from the player
	spawnEntity(spell, player.name, x, y)
end

function updateEnchantments(player, dt) 
	for key, enchantment in pairs(player.active_enchantments) do 
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
			if enchantment.name == 'Sprint' then
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
	local p_angle = math.atan2((y  - startY), (x  - startX))
	local perpendicular = p_angle -1.6 
	if perpendicular < -3.2 then
		perpendicular = 3.2
	end
	--LEFT QUADRANT SEEMS TO BE OFF, IDK WHY LMAO HAHA
	local adjustedX = player.x + player.width*0.4 +math.cos(perpendicular) * spell.size * player.modifier_aoe * spell.animation[1]:getWidth()/2
	local adjustedY = player.y + player.width*0.4 +math.sin(perpendicular) * spell.size * player.modifier_aoe * spell.animation[1]:getWidth()/2

	local p_Dx = spell.speed * math.cos(p_angle)
	local p_Dy = spell.speed * math.sin(p_angle)
	
	newProjectile = {
		x = adjustedX,
		y = adjustedY,
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
		frameTimer = spell.frameTimer,
		timeBetweenFrames = spell.timeBetweenFrames,
		originX = adjustedX,
		originY = adjustedY,
		spell = spell 
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
		destroyProjectile(projectile, i)
	else 
		projectile.x = projectile.x + (projectile.dx * dt)
		projectile.y = projectile.y + (projectile.dy * dt)

		projectile.hitbox:moveTo(calculateProjectileCenter(projectile.x, projectile.y, projectile.angle, projectile.width, projectile.height))
	end
end

function drawProjectile(projectile)

	love.graphics.draw(projectile.animation[projectile.currentFrame], projectile.x, projectile.y, projectile.angle, projectile.size, projectile.size)

	if debug then
		love.graphics.setColor(0, 0, 255, 255)
		love.graphics.circle("fill", projectile.originX, projectile.originY, 3, 20)
		love.graphics.setColor(0, 255, 0, 255)
		projectile.hitbox:draw('line') -- hitbox polygon = green
		love.graphics.points(calculateProjectileCenter(projectile.x, projectile.y, projectile.angle, projectile.width, projectile.height)) -- blue center
		resetColour()
	end
end

function calculateProjectileHitbox(x1, y1, angle, width, height)
	local x2 = x1 + (width * math.cos(angle))
	local y2 = y1 + (width * math.sin(angle))
	local x3 = x1 + (height * math.cos(angle+1.6)) --idk why +1.5 radians is the perpendicular but hey, it works
	local y3 = y1 + (height * math.sin(angle+1.6))
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

function destroyProjectile(projectile, i)
	HC.remove(projectile.hitbox) 
	table.remove(projectiles, i)
end

function updateProjectiles(dt)
	for i, projectile in ipairs(projectiles) do
		local kill = handleProjectileCollision(projectile)
		updateProjectile(projectile, dt, kill, i)
	end
end

--Projectiles colliding with enemies or enemy projectiles should deal damage/knockback all players within a radius
function handleProjectileCollision(projectile)
	local kill = false
	for shape, delta in pairs(HC.collisions(projectile.hitbox)) do
		if projectile.owner ~= shape.owner then
			addEffect("EXPLOSION", shape:center())
			local x, y = shape:center()
			spawnEntity(projectile.spell, projectile.owner, x, y, delta.x, delta.y) 	
			kill = true
		end
	end
	return kill
end

