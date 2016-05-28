effects = {}
textLog = {}

function addEffect(type, inX, inY, size)
	size = size * effects[type].size
	local newEffect = {
		name = effects[type].name,
		key = effects[type].name,
		x = inX - ((effects[type].animation[1]:getWidth()/2) *size),
		y = inY - ((effects[type].animation[1]:getHeight()/2) *size),
		size = size,
		animation = effects[type].animation,
		currentFrame = 1,
		timeBetweenFrames = effects[type].timeBetweenFrames,
		frameTimer = effects[type].frameTimer,
		loop = false, 
		mode = "STATIC"
	}

	table.insert(effects, newEffect)
end

function addSpellEffect(spell, inX, inY, duration, owner)
	local newEffect = {
		name = spell.name,
		key = spell.name .. '-' .. owner,
		x = inX - spell.animation[1]:getWidth()/2,
		y = inY - spell.animation[1]:getHeight()/2,
		size = spell.size,
		animation = spell.animation,
		currentFrame = 1,
		timeBetweenFrames = spell.timeBetweenFrames,
		frameTimer = spell.frameTimer,
		loop = true,
		duration = duration, 
		mode = spell.archetype
	}

	table.insert(effects, newEffect)
end

function drawEffect(effect)
	if effect ~= nil then
		love.graphics.draw(effect.animation[effect.currentFrame], effect.x, effect.y, nil, effect.size, effect.size)
	end
end

function addTextData(inText, inX, inY, inDuration, dataType)
	local red, green, blue = 255, 255, 255
	local fontSize = defaultFontSize
	if dataType == "DAMAGE" then
		red, green, blue = 255, 0, 0
		fontSize = 32
	end

	math.randomseed( os.time() )

	local data = {
		text = inText,
		x = inX + math.random(-2,2),
		y = inY + math.random(-2,2),
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