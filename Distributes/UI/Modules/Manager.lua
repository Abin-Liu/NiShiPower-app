-----------------------------------------------
-- Manager.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

local CreateFrame = CreateFrame
local tinsert = tinsert
local ipairs = ipairs
local InCombatLockdown = InCombatLockdown
local ClearOverrideBindings = ClearOverrideBindings
local GetBindingKey = GetBindingKey
local SetOverrideBindingClick = SetOverrideBindingClick
local format = format
local type = type
local strfind = strfind
local GetRealZoneText = GetRealZoneText
local C_PetBattles = C_PetBattles
local LE_BATTLE_PET_ALLY = LE_BATTLE_PET_ALLY
local LE_BATTLE_PET_ENEMY = LE_BATTLE_PET_ENEMY
local UIErrorsFrame = UIErrorsFrame

local _, addon = ...
local L = addon.L

local MAP_NAME = GetMapNameByID(807) -- check by GetCurrentMapAreaID()

local modules = {}
local manager = EmbedEventObject()

local function Module_SetState(self, state)
	if self.__state ~= state then
		self.__state = state
	end
end

local function Module_GetState(self)
	return self.__state
end

local function Module_StartTick(self, state, interval)
	Module_SetState(self, state)
	self:RegisterTick(interval)
end

local function Module_StopTick(self)
	self:UnregisterTick()
	Module_SetState(self)
end

function addon:CreateModule()
	local module = EmbedEventObject()
	module.StartTick = Module_StartTick
	module.StopTick = Module_StopTick
	module.SetState = Module_SetState
	module.GetState = Module_GetState
	module.CreateUtilityFrame = Module_CreateUtilityFrame
	tinsert(modules, module)
	return module
end

function addon:StopAllModules()
	local _, module
	for _, module in ipairs(modules) do
		Module_StopTick(module)
	end
end

local wasAcivated
function manager:Activate()
	if wasAcivated then
		return
	end

	wasAcivated = 1
	addon:StopAllModules()

	addon:AddSpecialLog("STARTUP", L["log manager activate"])
	addon:AddSpecialLog("SYSTEM", L["log all states"])
	if C_PetBattles.IsInBattle() then
		addon:NotifyClick("C_PetBattles.ForfeitGame()")
	else
		addon:BroadcastEvent("BATTLE_OVER")
	end
end

function manager:Deactivate()
	if not wasAcivated then
		return
	end

	wasAcivated = nil
	addon:AddSpecialLog("STARTUP", L["log manager deactivate"])
	addon:StopAllModules()
end

local frame = CreateFrame("Frame", "NiShiPowerPixelFrame", UIParent)
frame:SetSize(2, 2)
frame:SetPoint("TOP")
frame:SetFrameStrata("TOOLTIP")

local function Frame_CheckDistance(self)
	if addon:GetNpcDistance() < 100 then
		self:SetAlpha(1)
		manager:Activate()
	else
		self:SetAlpha(0)
		manager:Deactivate()
	end
end

frame:SetScript("OnShow", Frame_CheckDistance)

frame:SetScript("OnHide", function(self)
	self:SetAlpha(0)
end)

frame:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > 1 then
		self.elapsed = 0
		Frame_CheckDistance(self)
	end
end)

local pixel = frame:CreateTexture(nil, "OVERLAY")
pixel:SetAllPoints(frame)
pixel:Hide()

local actionButton = CreateFrame("Button", "NiShiPowerActionButton", UIParent, "SecureActionButtonTemplate")
actionButton:SetAttribute("type", "macro")
actionButton:RegisterEvent("PLAYER_LOGIN")
actionButton:RegisterEvent("UPDATE_BINDINGS")
actionButton:RegisterEvent("PLAYER_REGEN_ENABLED")

actionButton:SetScript("OnEvent", function(self, event, ...)
	if not InCombatLockdown() then
		ClearOverrideBindings(frame)
		local key1, key2 = GetBindingKey("NISHIPOWER_ACTION")
		if key1 or key2 then
			SetOverrideBindingClick(frame, false, key1 or key2, self:GetName())
		end
	end
end)

actionButton:SetScript("PostClick", function(self)
	pixel:Hide()
end)

function addon:ClearPixel()
	pixel:Hide()
end

function addon:NotifySpecialClick(r, g, b)
	pixel:SetTexture(r, g, b)
	pixel:Show()
end

function addon:NotifyClick(snippet, arg1, ...)
	if InCombatLockdown() then
		return
	end

	actionButton:SetAttribute("macrotext", nil)
	pixel:Hide()

	local macro
	if snippet == 1 or snippet == 2 or snippet == 3 then
		macro = format("C_PetBattles.UseAbility(%d)", snippet)

	elseif type(snippet) == "string" then
		if arg1 then
			macro = format(snippet, arg1, ...)
		else
			macro = snippet
		end
	end

	if macro then
		if strfind(macro, "/") ~= 1 then
			macro = "/script "..macro
		end

		actionButton:SetAttribute("macrotext", macro)
		pixel:SetTexture(0, 0, 1)
		pixel:Show()
	end
end

function addon:UsePetAbility(index)
	local name, link, icon = addon:GetBattlePetAbilityInfo(C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY), index)
	addon:AddLog(L["log battle using ability"], icon, link)
	addon:NotifyClick(index)
end

function addon:ChangePet(index)
	local _, link, icon = addon:GetPetInfo(index)
	addon:AddLog(L["log battle change pet"], icon, link)
	addon:NotifyClick("C_PetBattles.ChangePet(%d)", index)
end

function addon:SkipTurn()
	addon:AddLog(L["log battle skip turn"])
	addon:NotifyClick("C_PetBattles.SkipTurn()")
end

local function GetHealthFlag(index, enemy)
	local health = C_PetBattles.GetHealth(enemy and LE_BATTLE_PET_ENEMY or LE_BATTLE_PET_ALLY, index) or 0
	if health > 0 then
		return health
	end
end

local questExists, nishiBattle, prevEnemyIndex

manager:RegisterEvent("PLAYER_ENTERING_WORLD", "ZONE_CHANGED")
manager:RegisterEvent("ZONE_CHANGED_NEW_AREA", "ZONE_CHANGED")
manager:RegisterEvent("ZONE_CHANGED")
manager:RegisterEvent("PET_BATTLE_OPENING_START")
manager:RegisterEvent("PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE")
manager:RegisterEvent("PET_BATTLE_CLOSE")

function manager:ZONE_CHANGED()
	if GetRealZoneText() == MAP_NAME then
		frame:Show()
	else
		frame:Hide()
	end
end

function manager:PET_BATTLE_OPENING_START()
	questExists, prevEnemyIndex = nil
	nishiBattle = addon:IsNiShiBattle()

	if not nishiBattle then
		return
	end

	addon:StopAllModules()
	UIErrorsFrame:Clear()
	addon:AddSpecialLog("SYSTEM", L["log battle started"])
	addon:BroadcastEvent("BATTLE_START")
end

function manager:PET_BATTLE_CLOSE()
	if not nishiBattle then
		return
	end

	addon:StopAllModules()
	addon:AddSpecialLog("SYSTEM", L["log battle over"])
	addon:BroadcastEvent(questExists and "TEAM_READY" or "BATTLE_OVER")
end

local INVINCIBLE_ENEMIES = { [996] = 829, [995] = 340 }

function manager:PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE(arg1)
	pixel:Hide()
	if not nishiBattle then
		return
	end

	questExists = addon:FindQuest()
	if questExists then
		addon:NotifyClick("NiShiPower:AddSpecialLog('CRITICAL', '%s') C_PetBattles.ForfeitGame()", L["log battle quest abandon failed"])
		return
	end

	local round = (arg1 or 0) + 1
	addon:AddSpecialLog("SYSTEM", L["log battle round"], round)

	if round > 40 then
		-- Something went wrong
		addon:AddLog(L["log battle forfeit"])
		addon:NotifyClick("C_PetBattles.ForfeitGame()")
		return
	end

	local myIndex = C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY)
	local myHealth = GetHealthFlag(myIndex)
	if not myHealth then
		if myIndex == 1 then
			addon:ChangePet(2)
		end
		return
	end

	local enemyIndex = C_PetBattles.GetActivePet(LE_BATTLE_PET_ENEMY)
	local enemyHealth = GetHealthFlag(enemyIndex, 1)
	if not enemyHealth then
		return -- Wait the npc to switch pets
	end

	local newEnemy = prevEnemyIndex ~= enemyIndex
	prevEnemyIndex = enemyIndex

	local youngling = GetHealthFlag(addon.TEAM_POS.youngling)
	if not youngling then
		addon:AddLog(L["log battle forfeit"])
		addon:NotifyClick("C_PetBattles.ForfeitGame()")
		return -- Youngling died, no points to continue
	end

	local mySpecies = C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ALLY, myIndex)
	local enemySpecies = C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ENEMY, enemyIndex)
	local auraId = INVINCIBLE_ENEMIES[enemySpecies]
	local invincible, dangerous

	if auraId then
		local allyFaster = addon:IsAllyFaster()
		local remain = addon:PetHasAura(enemyIndex, auraId, 1) or 0
		local usable, cooldown = addon:IsAbilityUsable(enemyIndex, 3, 1)
		if newEnemy and enemySpecies == 995 then
			usable, cooldown = nil, 1
		end

		if remain > 1 or (remain == 1 and enemySpecies == 996) then
			invincible = 1
		elseif usable and not allyFaster then
			invincible = 1
		end

		if enemyIndex == 3 then
			if allyFaster then
				dangerous = remain > 0
			else
				dangerous = usable
			end
		end
	end

	if invincible then
		addon:AddSpecialLog("WARNING", L["log battle enemy invincible"])
	end

	if dangerous then
		addon:AddSpecialLog("CRITICAL", L["log battle enormous damage coming"])
	end

	local fighter1 = GetHealthFlag(addon.TEAM_POS.fighter1)
	local fighter2 = GetHealthFlag(addon.TEAM_POS.fighter2)

	if fighter1 or fighter2 then
		-- At least one fight alives
		local healthMax = C_PetBattles.GetMaxHealth(LE_BATTLE_PET_ALLY, myIndex)
		addon:BroadcastEvent("BATTLE_ROUND", round, myIndex, myHealth, healthMax, mySpecies, enemyIndex, enemyHealth, enemySpecies, invincible, dangerous)
	else
		-- Both fighters died, now let the youngling fight or die!
		addon:UsePetAbility(1)
	end
end