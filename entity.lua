entities = {}

function handleEntityCollision(entity) 
	for shape, delta in pairs(HC.collisions(entity.hitbox)) do
		if entity.owner ~= shape.owner then --if it doesnt belong to the owner
			if shape.type == "PLAYER" then --it is another player
				entityHit(shape.owner, entity, delta.x, delta.y, false)
			end
		else -- it belongs to the owner 
			if shape.type == "PLAYER" then
				if entity.spell.name == "Fireball" then
			 		entityHit(shape.owner, entity, delta.x, delta.y, true)
			 	end
		 	end
		end  
	end
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
			chargingTime= 0,
			originalChargingTime = 0,
			multiHit = false,
			activates = false,
			hasHit = {},
			fade_in = false,
			state = "ATTACK"
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
			time_to_live = spell.attackAnimationTimer + spell.chargingTime	, --make sure it explodes
			active = false,
			visible = true,
			animation	= spell.animation,
			currentFrame = spell.currentFrame,
			frameTimer = spell.frameTimer,
			timeBetweenFramesActive = spell.timeBetweenFramesActive,
			timeBetweenFramesCharging =spell.timeBetweenFramesCharging,
			activeTimer = spell.activeTimer,
			attackAnimationTimer = spell.attackAnimationTimer,
			attackAnimationLength = spell.attackAnimationLength,
			chargingAnimationLength = spell.chargingAnimationLength,
			chargingTime = spell.chargingTime,
			originalChargingTime = spell.chargingTime,
			dX = dX,
			dY = dY,
			multiHit = false,
			hasHit = {},
			activates = true,
			fade_in = true,
			lifespan = spell.attackAnimationTimer + spell.chargingTime,
			state = "CHARGE",
			hasBeenActive = false,
			scale = players[ownerName].modifier_aoe
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
		
		if entity.active then
			handleEntityCollision(entity) 
	 	end
		entity.time_to_live = math.max(0, entity.time_to_live - dt)
		if entity.time_to_live == 0   then --
			destroyEntity(entity, i)
		end
		entity.chargingTime = math.max(0, entity.chargingTime - dt)

		if entity.chargingTime == 0 then 
			if entity.active then
				entity.activeTimer = math.max(0, entity.activeTimer - dt)
				if entity.activeTimer == 0  then 
					entity.active = false
				end
			end
		end
		if not entity.hasBeenActive and entity.chargingTime == 0  then 
			entity.state = "ATTACK"
			entity.active = true
			entity.hasBeenActive = true
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
		local entity_alpha = 255
		if entity.fade_in then
			entity_alpha = 255 *(1 - (entity.chargingTime/entity.originalChargingTime))
			love.graphics.setColor(255, 255, 255, entity_alpha)
		end
		if entity.state == "ATTACK" then 
			love.graphics.draw(img.attack, entity.cX - img.attack:getWidth()/2*entity.scale, entity.cY - img.attack:getHeight()/2*entity.scale + extraY*entity.scale, 0, entity.scale, entity.scale)	
		elseif entity.state == "CHARGE" then
			love.graphics.draw(img.charging, entity.cX - img.charging:getWidth()/2*entity.scale, entity.cY - img.charging:getHeight()/2*entity.scale + extraY*entity.scale, 0, entity.scale, entity.scale)
		end
		resetColour()
	end

	if debug then
		love.graphics.setColor(140, 60, 208, 255)
		love.graphics.circle('line', entity.cX, entity.cY, entity.radius, 20)
		
		if entity.active then
			love.graphics.setColor(140, 60, 208, 100)
			love.graphics.circle('fill', entity.cX, entity.cY, entity.radius, 20)
		end

		resetColour()
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

function destroyEntity(entity, i)
	HC.remove(entity.hitbox) 
	table.remove(entities, i)
end