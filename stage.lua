stageSegments = 120

stage = nil

stageTickTimer = 0.8
stageTickLength = 0.8
stageTick = 0
stagePhase = 1
stagePhaseTimer = 2
stagePhaseTickTime = 2
stageDamageOverTime = 6
phaseCount = 3

function initStage()
	stage = STI.new("assets/maps/ffa01.lua")
	stage:resize(love.graphics.getWidth(), love.graphics.getHeight())
end

function drawStage()

	--local x, y = camera:position()
	--stage:setDrawRange(-x, -y, love.graphics.getWidth(), love.graphics.getHeight())
	
	
	stage:drawLayer(stage.layers["Ground_1"] )
	stage:drawLayer(stage.layers["Lava_" .. stagePhase])
end

function updateStage(dt)
	stageTickTimer = stageTickTimer - dt
	if stageTickTimer <= 0 then
		stage:update(dt)
		for key, layer in pairs(stage.layers) do
			if (type(key) == "string") then 

				if layer.properties['phase'] == stagePhase and layer.properties['damaging'] then
				print("key: " .. key .. " phase: " .. stagePhase)
					for playerKey, player in pairs(players) do
						if playerKey == "PLAYER_1" then 
							local playerX, playerY = player.hitbox:center()
							local tileX = math.max(0,  math.floor(playerX/stage.tilewidth))
							local tileY = math.max(0, math.floor(playerY/stage.tileheight))
							--print(player.name .. " at" .. tileX .. "," .. tileY .. " trueX,Y: " .. playerX .. "," .. playerY)
							print(layer.properties['phase'] .. " : " .. stagePhase)
							if tileY > 0 and tileY < #layer.data and layer.data[tileY][tileX] ~= nil and layer.properties['active'] then
								print(layer.data[tileY][tileX].id)
								applyDamage(player, stageDamageOverTime, "LAVA") --applyDamage(player, damage, sourceType)
							end
						end
						
					end

					--iterate over players checking what tile they're on and if they need ot get dam'd on
				end
			end

			
		end


		stageTickTimer = stageTickLength
		stageTick = stageTick + 1
		print("phase: " ..stagePhase)
		--print(stageTick)
	end

	
end

