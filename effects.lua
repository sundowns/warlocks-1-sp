effects = {}
textLog = {}

function initEffects()
	effects["EXPLOSION"] = {
		name = "Explosion",
		size = 0.5,
		animation = {},
		timeBetweenFrames = 0.05,
		frameTimer = 0.05,
	}

	effects["EXPLOSION"].animation[1] = love.graphics.newImage('assets/effects/explosion/1.png')
	effects["EXPLOSION"].animation[2] = love.graphics.newImage('assets/effects/explosion/2.png')
	effects["EXPLOSION"].animation[3] = love.graphics.newImage('assets/effects/explosion/3.png')
	effects["EXPLOSION"].animation[4] = love.graphics.newImage('assets/effects/explosion/4.png')
	effects["EXPLOSION"].animation[5] = love.graphics.newImage('assets/effects/explosion/5.png')
	effects["EXPLOSION"].animation[6] = love.graphics.newImage('assets/effects/explosion/6.png')
	effects["EXPLOSION"].animation[7] = love.graphics.newImage('assets/effects/explosion/7.png')
	effects["EXPLOSION"].animation[8] = love.graphics.newImage('assets/effects/explosion/8.png')
	effects["EXPLOSION"].animation[9] = love.graphics.newImage('assets/effects/explosion/9.png')
	effects["EXPLOSION"].animation[10] = love.graphics.newImage('assets/effects/explosion/10.png')
end

function addEffect(type, inX, inY)
	local newEffect = {
		name = effects[type].name,
		key = effects[type].name,
		x = inX - ((effects[type].animation[1]:getWidth()/2) *effects[type].size),
		y = inY - ((effects[type].animation[1]:getHeight()/2) *effects[type].size),
		size = effects[type].size,
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
	if dataType == "DAMAGE" then
		red, green, blue = 255, 0, 0
	end

	local data = {
		text = inText,
		x = inX,
		y = inY,
		r = red,
		g = green,
		b = blue,
		timer = inDuration
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
				love.graphics.setColor(data.r, data.g, data.b, alpha)
				love.graphics.print(data.text, data.x, data.y)
				resetColour()
			end
	end
end