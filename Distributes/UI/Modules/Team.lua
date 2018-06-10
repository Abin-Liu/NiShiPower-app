-----------------------------------------------
-- Team.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

local _, addon = ...
local L = addon.L

local SPELL_ID = 125439
local SPELL_NAME, _, SPELL_ICON = GetSpellInfo(SPELL_ID)
local SPELL_LINK = GetSpellLink(SPELL_ID)

local youngling, fighter1, fighter2, f1a1, f1a2, f1a3, f2a1, f2a2, f2a3

local module = addon:CreateModule()

local function AddPetChoosingLog(key, petId, icon, link)
	if petId then
		addon:AddLog(L["log team pet choosing ok"], L[key], icon, link)
	else
		addon:AddSpecialLog("WARNING", L["log team pet choosing fail"], L[key], icon)
	end
end

function module:OnTick()
	local state = self:GetState()
	if state == "start" then

		youngling, fighter1, fighter2, f1a1, f1a2, f1a3, f2a1, f2a2, f2a3 = nil

		addon:AddLog(L["log team choosing pets"])
		addon:PromoteYounglings()

		local icon, link

		youngling, icon, link = addon:FindYoungling()
		AddPetChoosingLog("youngling", youngling, icon, link)

		if youngling then
			fighter1, icon, link, f1a1, f1a2, f1a3 = addon:FindFighter(1)
			AddPetChoosingLog("fighter1", fighter1, icon, link)
		end

		if fighter1 then
			fighter2, icon, link, f2a1, f2a2, f2a3 = addon:FindFighter(2)
			AddPetChoosingLog("fighter2", fighter2, icon, link)
		end

		if fighter2 then
			self:StopTick()
			self:StartTick("form team")
		else
			addon:AddLog(L["log team heal"])
			self:SetState("heal")
		end

	elseif state == "heal" then
		local start, duration, enable = GetSpellCooldown(SPELL_ID)
		local cooldown = 0
		if start > 0 then
			cooldown = max(0, start + duration - GetTime())
		end

		addon:AddLog(L["log team heal cooldown"], SPELL_ICON, SPELL_LINK, cooldown)

		if start == 0 then
			addon:AddLog(L["log team cast heal"], SPELL_ICON, SPELL_LINK)
			addon:NotifyClick("/cast "..SPELL_NAME)
			self:SetState("start")
		end

	elseif state == "form team" then

		addon:AddLog(L["log team form"])

		if addon:ChooseTeamPet(addon.TEAM_POS.fighter1, fighter1) and addon:ChooseTeamPet(addon.TEAM_POS.fighter2, fighter2) and addon:ChooseTeamPet(addon.TEAM_POS.youngling, youngling) then
			self:SetState("check team")
		end

	elseif state == "check team" then

		if addon:VerifyTeamPet(addon.TEAM_POS.fighter1, fighter1) and addon:VerifyTeamPet(addon.TEAM_POS.fighter2, fighter2) and addon:VerifyTeamPet(addon.TEAM_POS.youngling, youngling) then
			self:SetState("form abilities")
		else
			self:SetState("form team")
		end

	elseif state == "form abilities" then

		addon:AddLog(L["log team choose abilities"])
		addon:ChooseTeamPetAbilities(addon.TEAM_POS.fighter1, f1a1, f1a2, f1a3)
		addon:ChooseTeamPetAbilities(addon.TEAM_POS.fighter2, f2a1, f2a2, f2a3)
		self:SetState("check abilities")

	elseif state == "check abilities" then

		if addon:VerifyTeamPetAbilities(addon.TEAM_POS.fighter1, f1a1, f1a2, f1a3) and addon:VerifyTeamPetAbilities(addon.TEAM_POS.fighter2, f2a1, f2a2, f2a3) then
			self:StopTick()
			addon:AddSpecialLog("READY", L["log team ready"])
			addon:BroadcastEvent("TEAM_READY")
		else
			self:SetState("form abilities")
		end
	end
end

function addon:StartModuleTeam()
	module:StopTick()
	addon:AddSpecialLog("READY", L["log team module started"])
	module:StartTick("start", 1.5)
end

addon:RegisterEventCallback("BATTLE_OVER", function()
	module:StopTick()
	addon:AddLog(L["log wait StartModuleTeam"])
	addon:NotifyClick("NiShiPower:StartModuleTeam()")
end)

addon:RegisterEventCallback("PETLIST_CHANGED", function()
	if module:GetState() then
		addon:AddLog(L["log team pet list changed"])
		addon:StartModuleTeam()
	end
end)