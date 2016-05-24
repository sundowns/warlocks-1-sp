function math.clamp(val, min, max)
    if min - val > 0 then
        return min
    end
    if max - val < 0 then
        return max
    end
    return val
end

function resetColour()
	love.graphics.setColor(255, 255, 255, 255)
end