effects = {}

function loadEffects()
	effects["EXPLOSION"] = {
		name = "Explosion",
		size = 1,
		images = {}
	}

	effects["EXPLOSION"].images[1] = love.graphics.newImage('assets/effects/explosion/1.png')
	effects["EXPLOSION"].images[2] = love.graphics.newImage('assets/effects/explosion/2.png')
	effects["EXPLOSION"].images[3] = love.graphics.newImage('assets/effects/explosion/3.png')
	effects["EXPLOSION"].images[4] = love.graphics.newImage('assets/effects/explosion/4.png')
	effects["EXPLOSION"].images[5] = love.graphics.newImage('assets/effects/explosion/5.png')
	effects["EXPLOSION"].images[6] = love.graphics.newImage('assets/effects/explosion/6.png')
	effects["EXPLOSION"].images[7] = love.graphics.newImage('assets/effects/explosion/7.png')
	effects["EXPLOSION"].images[8] = love.graphics.newImage('assets/effects/explosion/8.png')
	effects["EXPLOSION"].images[9] = love.graphics.newImage('assets/effects/explosion/9.png')
	effects["EXPLOSION"].images[10] = love.graphics.newImage('assets/effects/explosion/10.png')
end


function addEffect(type, inX, inY)
	local newEffect = {
		name = effects[type].name,
		x = inX - effects[type].images[1]:getWidth()/2,
		y = inY - effects[type].images[1]:getHeight()/2,
		size = effects[type].size,
		images = effects[type].images,
		anim_current = 1
	}

	table.insert(effects, newEffect)
end

function drawEffect(effect)
	if effect ~= nil then
		if effect.anim_current > #effect.images then
			table.remove(effects, i)
			else 
			love.graphics.draw(effect.images[effect.anim_current], effect.x, effect.y, nil, effect.size, effect.size)
			effect.anim_current = effect.anim_current + 1
		end
	end
end