-----------------------------------------------
-- Battle.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

local _, addon = ...
local L = addon.L

addon:RegisterEventCallback("BATTLE_ROUND", function(round, myIndex, myHealth, myHealthMax, mySpecies, enemyIndex, enemyHealth, enemySpecies, invincible, dangerous)

	local hasBump = myIndex == addon.TEAM_POS.fighter1 and addon:PetHasAura(myIndex, 296)
	local ability2Usable = addon:IsAbilityUsable(myIndex, 2)

	if enemyIndex < 3 then
		if myIndex == addon.TEAM_POS.fighter1 then
			if ability2Usable and myHealth < 500 then
				addon:AddSpecialLog("WARNING", L["log battle health low"])
				addon:UsePetAbility(2)
			elseif hasBump then
				if invincible or enemyHealth < 420 then
					addon:UsePetAbility(1)
				else
					addon:UsePetAbility(3)
				end
			else
				addon:UsePetAbility(3)
			end
		else
			addon:UsePetAbility(1)
		end
		return
	end


	-- Fights the damn worm!
	if myIndex == addon.TEAM_POS.fighter1 then
		if invincible then
			if hasBump then
				addon:UsePetAbility(1)
			else
				addon:UsePetAbility(3)
			end
		elseif enemyHealth > 1000 then
			addon:UsePetAbility(3)
		elseif enemyHealth > 500 then
			addon:UsePetAbility(1)
		else
			addon:SkipTurn() -- Wait to die
		end
	else
		local explodeDamage = myHealthMax * 0.59
		if ability2Usable and (dangerous or enemyHealth < explodeDamage * 1.3) and addon:CanPetDropBox(myIndex) then
			addon:UsePetAbility(2)
		elseif ability2Usable and dangerous and mySpecies == 500 then
			addon:UsePetAbility(2)
		elseif not invincible and enemyHealth < explodeDamage then
			addon:AddSpecialLog("CRITICAL", L["log battle explode"], explodeDamage)
			addon:UsePetAbility(3) -- explode
		elseif invincible and enemyHealth < 600 and myHealth > 600 then
			addon:SkipTurn()
		else
			addon:UsePetAbility(1)
		end
	end
end)