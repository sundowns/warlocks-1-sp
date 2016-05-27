entities = {}

function handleEntityCollision(entity) 
	local kill = false
	for shape, delta in pairs(HC.collisions(entity.hitbox)) do
		if entity.owner ~= shape.owner then
			if shape.type == "PLAYER" then 
				kill = true
				entityHit(shape.owner, entity, entity.dX, entity.dY)
			end
		elseif shape.type == "PLAYER" then 
				kill = true
				entityHit(shape.owner, entity, -entity.dX, -entity.dY)		
		end  
	end
	return kill
end

function spawnEntity(spell, ownerName, inX, inY, dX, dY)
	local newEntity = {}
	if spell.name == "Fireball" then 
		 newEntity = {
			owner = ownerName,
			spell = spell,
			radius = spell.radius * players[ownerName].modifier_aoe,
			cX = inX,
			cY = inY,
			hitbox = nil,
			max_impulse = spell.max_impulse,
			damage = spell.damage,
			time_to_live = 0.1,
			dX = dX,
			dY = dY,
			active = true,
			visible = false,
			activeTimer = 0,
			chargingTime= 0
		}
	elseif spell.name == "Fissure" then 
		newEntity = {
			owner = ownerName,
			spell = spell,
			radius = spell.radius * players[ownerName].modifier_aoe,
			cX = inX,
			cY = inY,
			hitbox = nil,
			max_impulse = spell.max_impulse,
			damage = spell.damage,
			time_to_live = spell.activeTimer + spell.chargingTime	, --make sure it explodes
			active = false,
			visible = true,
			animation	= spell.animation,
			currentFrame = spell.currentFrame,
			frameTimer = spell.frameTimer,
			timeBetweenFrames = spell.timeBetweenFrames,
			activeTimer = spell.activeTimer,
			attackAnimationLength = spell.attackAnimationLength,
			chargingAnimationLength = spell.chargingAnimationLength,
			chargingTime= spell.chargingTime	
		}
	end
	newEntity.hitbox = HC.circle(newEntity.cX, newEntity.cY, newEntity.radius)
	newEntity.hitbox.owner = newEntity.owner 
	newEntity.hitbox.type = "SPELL"
	newEntity.hitbox.spell = "FISSURE"

	table.insert(entities, newEntity)
end

function updateEntities(dt)
	for i, entity in ipairs(entities) do 
		
		--print("houston we are " .. entity.active)
		local kill = false
		if entity.active then
			kill = handleEntityCollision(entity) 
	 	end
		entity.time_to_live = math.max(0, entity.time_to_live - dt)
		if entity.time_to_live == 0 or kill  then --
			destroyEntity(entity, i)
		end
		entity.chargingTime = math.max(0, entity.chargingTime - dt)
		if not entity.active and entity.chargingTime == 0  then 
			entity.active = true
			entity.currentFrame	= 1
		end
	end
end

function drawEntity(entity, i)
	if entity.visible	then
		local img = entity.animation[entity.currentFrame]
		local extraY = 0
		if entity.spell.name == "Fissure" then
				extraY = -10
		end
		if entity.active then 
			love.graphics.draw(img.attack, entity.cX - img.attack:getWidth()/2, entity.cY - img.attack:getHeight()/2 + extraY, 0, 1, 1)
		else
			love.graphics.draw(img.charging, entity.cX - img.charging:getWidth()/2, entity.cY - img.charging:getHeight()/2, 0, 1, 1)
		end
	end

	if debug then
		love.graphics.setColor(140, 60, 208, 255)
		love.graphics.circle('line', entity.cX, entity.cY, entity.radius, 20)
		resetColour()
		love.graphics.circle('fill', drawthatX, drawthatY, drawthatR, 16)
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

function destroyEntity(entitiy, i)
	HC.remove(entitiy.hitbox) 
	table.remove(entities, i)
end