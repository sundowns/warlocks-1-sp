stageSegments = 14

function drawStage()
	love.graphics.setColor(245, 245, 220, 180)
	love.graphics.circle("fill", love.graphics.getWidth()/2, love.graphics.getHeight()/2, love.graphics.getHeight()/3, stageSegments)
	resetColour()
end

function resetColour()
	love.graphics.setColor(255, 255, 255, 255)
end