-- Version : 0.1
--First Release--

Callback.Bind('Load', function()

  Callback.Bind('GameStart', function() OnStart() end)

end)

function OnStart()
	if player.charName ~= 'Katarina' then return end

		TheMenu = MenuConfig("Katarina")
		TheMenu:Icon("fa-user")

		TheMenu:Menu("Combo", "Combo Settings")
		TheMenu.Combo:Icon("fa-folder-o")
		TheMenu.Combo:Section("Combo Settings", "Combo Settings")
		TheMenu.Combo:Boolean("useq", "Use Q", true)
		TheMenu.Combo:Boolean("usew", "Use W", true)
		TheMenu.Combo:Boolean("usee", "Use E", true)
		TheMenu.Combo:Boolean("user", "Use R", true)

		TheMenu:Menu("Harass", "Harass Settings")
		TheMenu.Harass:Icon("fa-folder-o")
		TheMenu.Harass:Section("Harass Settings", "Harass Settings")  
		TheMenu.Harass:Boolean("usee", "Use W", true)

--		TheMenu:Menu("LaneClear", "Lane Clear Settings")
--		TheMenu.LaneClear:Icon("fa-folder-o")
--		TheMenu.LaneClear:Section("LaneClear Settings", "Lane Clear Settings")  
--		TheMenu.LaneClear:Boolean("useq", "Use Q", false)
--		TheMenu.LaneClear:Boolean("usew", "Use W", false)

		TheMenu:Menu("KS", "KS Settings")
		TheMenu.KS:Icon("fa-folder-o")
		TheMenu.KS:Section("KS Settings", "KS Settings")
		TheMenu.KS:Boolean("useq", "Use Q", false)
		TheMenu.KS:Boolean("usew", "Use W", false)
		TheMenu.KS:Boolean("usee", "Use E", false)
		TheMenu.KS.usee:Note("For Sneaky KS :D")
		TheMenu.KS:Boolean("user", "Use R", true)
		TheMenu:DropDown("is_safe_or_risky", 'Safe or Risk', 1, {"Safe", "Risk"})

		TheMenu:Menu("draw", "Draw")
		TheMenu.draw:Boolean("drawrange", "Draw Range ?", true)
		TheMenu.draw:Boolean("drawq", "Draw Q Range ?", true)
		TheMenu.draw:Boolean("draww", "Draw W Range ?", true)
		TheMenu.draw:Boolean("drawe", "Draw E Range ?", true)
		TheMenu.draw:Boolean("drawr", "Draw R Range ?", true)

--		TheMenu:Menu("Items", "Item Settings")
--		TheMenu.Items:Icon("fa-folder-o")
--		TheMenu.Items:Section("Item Settings", "Item Settings")
--		TheMenu.Items:Boolean("usedfg", "Use Deathfire Grasp", true) ]]
--		TheMenu.Items:Boolean("use", "Use ", true) ]]
--      TheMenu.Items:Boolean("use", "Use", true) ]]

		TheMenu:Section('Keys', 'Keys Selection')
		TheMenu:KeyBinding('combokey', 'Combo', 'SPACE')
		TheMenu:KeyBinding('harasskey', 'Harass', 'A')
		TheMenu.harasskey:Toggle('Toggle-Mode')
		TheMenu:Boolean('kskey', 'KS', true)
		TheMenu:KeyBinding('laneclearkey', 'Lane Clear', 'X')


	Callback.Bind('Tick', function() OnTick() end)
	Callback.Bind('Draw', function() OnDraw() end)

	Game.Chat.Print("<font color=\"FF0000\">[Katarina] by Fallen Angel loaded! </font>")

	Color = { Red = Graphics.ARGB(0xFF,0xFF,0,0),
			  Green = Graphics.ARGB(0xFF,0,0xFF,0),
			  Blue = Graphics.ARGB(0xFF,0,0,0xFF),
			  White = Graphics.ARGB(0xFF,0xFF,0xFF,0xFF),
			  Yellow = Graphics.ARGB(0xFF,0xFF,0xFF,0)
			}

end

function GetTarget(range)
	local T = {Unit = nil, THP = 100000}
	for i = 1, Game.HeroCount() do
		local h = Game.Hero(i)
		if h and h.valid and h.visible and not h.dead and h.isTargetable and h.team ~= myHero.team and h.pos:DistanceTo(myHero.pos) < player.range then
			local THP = (h.health * (1 + ((h.magicArmor or h.armor) / 100)))
			if THP < T.THP then	T.Unit, T.THP = h, THP end
		end	
	end
	return T.Unit
end


function OnTick()

	Checks()
	Combo()
	Harass()
--	LaneClear()
	KS()
end

function ValidTarget(Target)
	return Target ~= nil and Target.type == player.type and Target.team == TEAM_ENEMY and not Target.dead and Target.visible and Target.health > 0 and Target.isTargetable
end

function Checks()

	Target = GetTarget(player.range)

	Qready = player:CanUseSpell(0) == Game.SpellState.READY
	Wready = player:CanUseSpell(1) == Game.SpellState.READY
	Eready = player:CanUseSpell(2) == Game.SpellState.READY
	Rready = player:CanUseSpell(3) == Game.SpellState.READY


function Combo()

	if TheMenu.combokey:IsPressed() then
		if ValidTarget(Target) then
			
			local target_distance = Allclass.GetDistance(Target)

			if target_distance < player.range and Qready then
				player:CastSpell(0, Target)
				Qready = false
			end
			
			if target_distance < player.range and Wready
				player:CastSpell(1, Target)
				Wready = false
			end

			if target_distance < player.range and Eready then 
				player:CastSpell(2, Target)
				Eready = false
			
			if target_distance < player.range and Rready then
				player:CastSpell(3, Target)
				Rready = false
			end
			
			if target_distance < player.range and dfgready then
		end
	end
end

function Harass()

	if TheMenu.harasskey:IsPressed() then
			 		Game.Chat.Print("<font color=\"#F5F5F5\">Harass on</font>")

	 	if ValidTarget(Target) then

			local target_distance = Allclass.GetDistance(Target)

			if target_distance < player.range and Qready then
				player:CastSpell(0, Target)
				Qready = false
			
			if target_distance < player.range and Wready then
				player:CastSpell(1, Target)
				Wready = false
			end
		end
	end
end

function KS()
	if TheMenu.harasskey:IsPressed() then
			 		Game.Chat.Print("<font color=\"#F5F5F5\">Pentakill inc.</font>")
	
	if TheMenu.kskey:Value() then

		for i = 1, Game.HeroCount() do

			ennemi = Game.Hero(i)

			local ennemi_distance = Allclass.GetDistance(ennemi)

			if ValidTarget(ennemi) and ennemi_distance < player.range then
				local qdmg = player:CalcMagicDamage(ennemi, 60 + 25 * player:GetSpellData(0).level + 0.45 * player.ap)
				local wdmg = player:CalcMagicDamage(ennemi, 40 + 35 * player:GetSpellData(1).level + 0.25 * player.ap + 0.6 * player.ad)
				local edmg = player:CalcMagicDamage(ennemi, 60 + 25 * player:GetSpellData(2).level + 0.4 * player.ap)
--				local rdmg = player:CalcMagicDamage(ennemi, 350 + 200 * player:GetSpellData(3).level + 2.5 * player.ap + 3.75 * player.ad)

				if Qready and ennemi.health < qdmg - 25 and TheMenu.KS.useq:Value() then
					player:CastSpell(0, ennemi)
					Qready = false

				elseif Wready and ennemi.health < wdmg - 25 and TheMenu.KS.usew:Value() then
					player:CastSpell(1, ennemi)
					Rready = false

				elseif Qready and Eready and Wready and ennemi.health < qdmg + edmg + wdmg - 25 and TheMenu.KS.useq:Value() and TheMenu.KS.usee:Value() and TheMenu.KS.usew:Value() then
					player:CastSpell(0, ennemi)
					player:CastSpell(1, ennemi)
					player:CastSpell(2, ennemi)
					Qready = false
					Eready = false
					Wready = false
				end
			end
		end
	end
end

function CanCastSpell(spell, target)
	if player:CanUseSpell(spell) == Game.SpellState.READY and player:DistanceTo(target) < player:GetSpellData(spell).range then
		return true
	else 
		return false
	end
end

function OnDraw()
	
	if TheMenu.combokey:IsPressed() then
		CircleColor = Color.Red
	elseif TheMenu.harasskey:IsPressed() then
		CircleColor = Color.Yellow
	elseif TheMenu.laneclearkey:IsPressed() then
		CircleColor = Color.Green
	else
		CircleColor = Color.White
	end

	if TheMenu.draw.drawq:Value() then
		Graphics.DrawCircle(player, myHero:GetSpellData(0).range, CircleColor)
	end
	
	if TheMenu.draw.draww:Value() then
		Graphics.DrawCircle(player, myHero:GetSpellData(1).range, CircleColor)
	end
	
	if TheMenu.draw.drawe:Value() then
		Graphics.DrawCircle(player, myHero:GetSpellData(2).range, CircleColor)
	end
	
	if TheMenu.draw.drawr:Value() then
		Graphics.DrawCircle(player, myHero:GetSpellData(3).range, CircleColor)
	end

	if TheMenu.draw.drawrange:Value() then
		Graphics.DrawCircle(player, player.range, CircleColor)
	end
end 
