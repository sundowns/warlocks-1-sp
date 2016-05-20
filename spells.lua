spells = {}

function loadSpells()
	spells["FIREBALL"] = {
		name = "Fireball",
		level = 1,
		cooldown = 8,
		timer = 0,
		ready = true,
		lifespan = 2,
		speed = 160,
		anim_frames = 6,
		anim_current = 1,
		images = {}
	}

	spells["FIREBALL"].images[1] = love.graphics.newImage('assets/spells/fireball/1.png')
	spells["FIREBALL"].images[2] = love.graphics.newImage('assets/spells/fireball/2.png')
	spells["FIREBALL"].images[3] = love.graphics.newImage('assets/spells/fireball/3.png')
	spells["FIREBALL"].images[4] = love.graphics.newImage('assets/spells/fireball/4.png')
	spells["FIREBALL"].images[5] = love.graphics.newImage('assets/spells/fireball/5.png')
	spells["FIREBALL"].images[6] = love.graphics.newImage('assets/spells/fireball/6.png')		
end

function castProjectileSpell(player, key, x, y)
	if player.spellbook[key].ready then
		local startX = player.x + player.width/2
		local startY = player.y + player.height/2
		local p_angle = math.atan2((y - startY), (x - startX))
		local p_Dx = player.spellbook[key].speed * math.cos(p_angle)
		local p_Dy = player.spellbook[key].speed * math.sin(p_angle)
		table.insert(projectiles, {
			x = startX,
			y = startY,
			dx = p_Dx,
			dy = p_Dy,
			angle = p_angle,
			img = player.spellbook[key].img,
			time_to_live = player.spellbook[key].lifespan * player.modifier_range,
			size = 0.15 * player.modifier_aoe,
			anim_current = 1,
			anim_frames = player.spellbook[key].anim_frames,
			images = player.spellbook[key].images,
			owner = player.name
		})
		player.spellbook[key].ready = false
		player.spellbook[key].timer = player.spellbook[key].cooldown
		if debug then
			print("player used " .. key .. " " .. player.spellbook[key].name)
		end
	end	
end