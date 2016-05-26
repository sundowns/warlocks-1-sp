stageSegments = 120

function drawStage()
	love.graphics.setColor(245, 245, 220, 180)
	love.graphics.circle("fill", love.graphics.getWidth()/2, love.graphics.getHeight()/2, love.graphics.getHeight()/2, stageSegments)
	resetColour()
end

