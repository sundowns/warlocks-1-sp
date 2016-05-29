effects = {}
textLog = {}

function addEffect(type, inX, inY, size, fade_out)
	if fade_out == nil then
		fade_out = false
	end
	local trueSize = size * effects[type].size
	local newEffect = {
		name = effects[type].name,
		key = effects[type].name,
		x = inX - ((effects[type].animation[1]:getWidth()/4) ),
		y = inY - ((effects[type].animation[1]:getHeight()/4) ),
		size = trueSize,
		animation = effects[type].animation,
		currentFrame = 1,
		timeBetweenFrames = effects[type].timeBetweenFrames,
		frameTimer = effects[type].frameTimer,
		loop = false, 
		mode = "STATIC",
		fade_out = fade_out
	}

	table.insert(effects, newEffect)
end

function addDurationEffect(spell, inX, inY, duration, owner, loop, fade_out)
	if fade_out == nil then
		fade_out = false
	end
	local newEffect = {
		name = spell.name,
		key = spell.name .. '-' .. owner,
		x = inX - spell.animation[1]:getWidth()/2*spell.size,
		y = inY - spell.animation[1]:getHeight()/2*spell.size,
		size = spell.size,
		animation = spell.animation,
		currentFrame = 1,
		timeBetweenFrames = spell.timeBetweenFrames,
		frameTimer = spell.frameTimer,
		loop = loop,
		duration = duration, 
		mode = spell.archetype,
		fade_out = fade_out
	}

	table.insert(effects, newEffect)
end

function drawEffect(effect)
	if effect ~= nil then
		if effect.fade_out then
			local alpha = 255
			alpha = 255 * (effect.duration)
			love.graphics.setColor(255, 255, 255, alpha)
		end
		love.graphics.draw(effect.animation[effect.currentFrame], effect.x, effect.y, nil, effect.size, effect.size)

		resetColour()
	end
end

function addTextData(inText, inX, inY, inDuration, dataType)
	local red, green, blue = 255, 255, 255
	local fontSize = defaultFontSize
	if dataType == "DAMAGE_ENEMY" then
		red, green, blue = 255, 0, 0
		fontSize = 32
	elseif dataType == "DAMAGE_SELF" then
		red, green, blue = 102, 0, 204
		fontSize = 26
	elseif dataType == "LAVA" then
		red, green, blue = 0, 0, 0
		fontSize = 26
	end

	local data = {
		text = inText,
		x = inX + love.math.random(-10,10),
		y = inY + love.math.random(-10,10),
		r = red,
		g = green,
		b = blue,
		timer = inDuration, 
		fontSize = fontSize
	}
	table.insert(textLog, data)
end

function drawTextData(data, i)
	if data ~= nil then
			if data.timer <= 0 then
				table.remove(textLog, i) --do this in update?
			else 
				local alpha = 255
				if data.timer < 3 then 
					alpha = 255*(data.timer/3)
				end
				setFontSize(data.fontSize)
				love.graphics.setColor(data.r, data.g, data.b, alpha)
				love.graphics.print(data.text, data.x, data.y)
				resetColour()
				resetFont()
			end
	end
end