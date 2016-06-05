function updateTimers(dt)
	--Iterate over players spell calculating new cooldown timer
	for spell, data in pairs(players['PLAYER_1'].spellbook) do
		if not data.ready then 
			data.timer = math.max(0, data.timer - dt) 
			if data.timer == 0 then
				data.ready = true
			end
		end
	end

	for i, data in ipairs(textLog) do --combat text timers
		data.timer = math.max(0, data.timer - dt) 		
	end

	for key, player in pairs(players) do  -- player animation timer
		player.States[player.state].frameTimer = math.max(0, player.States[player.state].frameTimer - dt)
		
		if player.States[player.state].frameTimer <= 0 then 
			if #player.States[player.state].animation > 1 then
				player.States[player.state].currentFrame = player.States[player.state].currentFrame + 1 
			end
			if player.States[player.state].currentFrame > #player.States[player.state].animation then
				player.States[player.state].currentFrame = 1
			end
			player.States[player.state].frameTimer = player.States[player.state].timeBetweenFrames
		end
	end

	for i, projectile in ipairs(projectiles) do  -- projectile animation timers
		projectile.frameTimer = math.max(0, projectile.frameTimer - dt)
		if projectile.frameTimer <= 0 then 
			if #projectile.animation > 1 then
				projectile.currentFrame = projectile.currentFrame + 1 
			end
			if projectile.currentFrame > #projectile.animation then
				projectile.currentFrame = 1
			end
			projectile.frameTimer = projectile.timeBetweenFrames
		end
	end

	for i, entity in ipairs(entities) do  -- entities animation timers
		if entity.activates then
			entity.frameTimer = math.max(0, entity.frameTimer - dt)
			if entity.frameTimer <= 0 then 
				if entity.state == "ATTACK" then 
						if entity.attackAnimationLength > 1 then
							entity.currentFrame = entity.currentFrame + 1 
						end
						if entity.currentFrame > entity.attackAnimationLength then
							entity.currentFrame = 1
						end
						entity.frameTimer = entity.timeBetweenFramesActive
				elseif entity.state == "CHARGE" then
						if entity.chargingAnimationLength > 1 then
							entity.currentFrame = entity.currentFrame + 1 
						end
						if entity.currentFrame > entity.chargingAnimationLength then
							entity.currentFrame = 1
						end
						entity.frameTimer = entity.timeBetweenFramesCharging
				end
				
			end
 		end
	end

	for i, effect in ipairs(effects) do  -- effect animation timers
		effect.frameTimer = math.max(0, effect.frameTimer - dt)
		if effect.frameTimer <= 0 then 
			if #effect.animation > 1 then
				effect.currentFrame = effect.currentFrame + 1 
			end
			if effect.currentFrame > #effect.animation then
				if effect.loop then
					effect.currentFrame = 1
				else 
					if effect.duration == nil then
						table.remove(effects, i)
					end
				end
			end
			effect.frameTimer = effect.timeBetweenFrames
		end
		
		if effect.duration ~= nil then 
			effect.duration = math.max(0, effect.duration - dt)
			if effect.duration == 0 then
				table.remove(effects, i)
			end
		end
	end

	stagePhaseTimer = math.max(0, stagePhaseTimer - dt)
	if stagePhaseTimer <= 0 and stagePhase < phaseCount then 
		layerPhaseIsActive[stagePhase] = false
		stagePhase = stagePhase + 1
		stagePhaseTimer = stagePhaseTickTime
		layerPhaseIsActive[stagePhase] = true
		--print this table
	end
end