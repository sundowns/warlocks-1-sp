spells = {}

function loadSpells()
	spells["FIREBALL"] = {
		name = "Fireball",
		level = 1,
		cooldown = 2, --make this 8?
		timer = 0,
		ready = true,
		lifespan = 2,
		speed = 160,
		anim_current = 1,
		images = {}
	}

	spells["FIREBALL"].images[1] = love.graphics.newImage('assets/spells/fireball/1.png')
	spells["FIREBALL"].images[2] = love.graphics.newImage('assets/spells/fireball/2.png')
	spells["FIREBALL"].images[3] = love.graphics.newImage('assets/spells/fireball/3.png')
	spells["FIREBALL"].images[4] = love.graphics.newImage('assets/spells/fireball/4.png')
	spells["FIREBALL"].images[5] = love.graphics.newImage('assets/spells/fireball/5.png')
	spells["FIREBALL"].images[6] = love.graphics.newImage('assets/spells/fireball/6.png')		
end

function castProjectileSpell(player, key, x, y)
	if player.spellbook[key].ready then
		local startX = player.x + player.width/2
		local startY = player.y + player.height/2
		local p_angle = math.atan2((y - startY), (x - startX))
		local p_Dx = player.spellbook[key].speed * math.cos(p_angle)
		local p_Dy = player.spellbook[key].speed * math.sin(p_angle)
		newProjectile = {
			x = startX,
			y = startY,
			dx = p_Dx,
			dy = p_Dy,
			angle = p_angle,
			img = player.spellbook[key].img,
			time_to_live = player.spellbook[key].lifespan * player.modifier_range,
			size = 0.15 * player.modifier_aoe,
			anim_current = 1,
			images = player.spellbook[key].images,
			owner = player.name,
			hitbox = nil,
			width = 0.15 * player.modifier_aoe * player.spellbook[key].images[1]:getWidth(),
			height = 0.15 * player.modifier_aoe * player.spellbook[key].images[1]:getHeight()
		}

		--This is the error, maybe the coordinates need to be rearranged or rounded so they dont 'intersect'
		--newProjectile.hitbox = HC.polygon(calculateProjectileHitbox(
		--	newProjectile.x, newProjectile.y, newProjectile.angle,
		--	newProjectile.width, newProjectile.height))

		table.insert(projectiles, newProjectile)
		player.spellbook[key].ready = false
		player.spellbook[key].timer = player.spellbook[key].cooldown
	end	
end

function updateProjectile(projectile, dt)
	projectile.time_to_live = math.max(0, projectile.time_to_live - dt)
	if projectile.time_to_live == 0 then 
		table.remove(projectiles, i)
	end
	projectile.x = projectile.x + (projectile.dx * dt)
	projectile.y = projectile.y + (projectile.dy * dt)
end

function drawProjectile(projectile)
	love.graphics.draw(projectile.images[projectile.anim_current], projectile.x, projectile.y, projectile.angle, projectile.size, projectile.size)
	projectile.anim_current = projectile.anim_current + 1
	if projectile.anim_current > #projectile.images then
		projectile.anim_current = 1
	end

	if debug then
		love.graphics.setColor(0, 0, 255, 255) 
		local x1, y1, x2, y2, x3, y3, x4, y4 = calculateProjectileHitbox(projectile.x, projectile.y, projectile.angle, projectile.width, projectile.height)
		love.graphics.line(x1, y1, x2, y2)
		love.graphics.line(x1, y1, x3, y3)
		love.graphics.line(x3, y3, x4, y4)
		love.graphics.line(x2, y2, x4, y4)
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

	return x1, y1, x2, y2, x3, y3, x4, y4
end