stageSegments = 120

stage = nil

stageTickTimer = 1
stageTickLength = 1
stageTick = 0
stagePhase = 1
stagePhaseTimer = 4
stagePhaseTickTime = 4
stageDamageOverTime = 6
phaseCount = 12

layerPhaseIsActive = {}

function initStage()
	stage = STI.new("assets/maps/ffa01.lua")
	stage:resize(love.graphics.getWidth(), love.graphics.getHeight())
	layerPhaseIsActive[1] = true
	for i = 1, phaseCount do 
		layerPhaseIsActive[i] = false
	end
end

function drawStage()
	local x, y = camera:position()
	stage:setDrawRange(-x, -y, love.graphics.getWidth()+x, love.graphics.getHeight()+y)
	
	stage:drawLayer(stage.layers["Ground_1"] )
	stage:drawLayer(stage.layers["Lava_" .. stagePhase])
end

function updateStage(dt)
	if stagePhase <= phaseCount then 
		stageTickTimer = stageTickTimer - dt
		if stageTickTimer <= 0 then
			stage:update(dt)
			local layer = stage.layers["Lava_" .. stagePhase]
			for playerKey, player in pairs(players) do
				if player.State ~= "DEAD" then 
					local playerX, playerY = player.hitbox:center() 
					playerY = playerY + player.height/2
					local tileX = math.max(0, math.floor(playerX/stage.tilewidth)) +1 --something wrong wid dese maybe idk
					local tileY = math.max(0, math.floor(playerY/stage.tileheight)) +1
					if tileY > 0 and tileY < #layer.data and layer.data[tileY][tileX] ~= nil then
						applyDamage(player, stageDamageOverTime, "LAVA")
					end		
				end							
			end

			stageTickTimer = stageTickLength
			stageTick = stageTick + 1
		end
	end
end

