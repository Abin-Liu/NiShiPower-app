-----------------------------------------------
-- Core.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

local type = type
local pairs = pairs
local format = format
local DEFAULT_CHAT_FRAME = DEFAULT_CHAT_FRAME
local wipe = wipe
local ipairs = ipairs
local C_PetBattles = C_PetBattles
local LE_BATTLE_PET_ENEMY = LE_BATTLE_PET_ENEMY
local LE_BATTLE_PET_ALLY = LE_BATTLE_PET_ALLY
local tinsert = tinsert
local C_PetJournal = C_PetJournal
local tremove = tremove
local GetItemQualityColor = GetItemQualityColor
local PetJournal = PetJournal
local PetJournal_UpdatePetLoadOut = PetJournal_UpdatePetLoadOut
local PetBattleUtil_PetHasAura = PetBattleUtil_PetHasAura
local ITEM_QUALITY_COLORS = ITEM_QUALITY_COLORS
local format = format
local GetQuestLogIndexByID = GetQuestLogIndexByID
local GetQuestLogTitle = GetQuestLogTitle
local SelectQuestLogEntry = SelectQuestLogEntry
local SetAbandonQuest = SetAbandonQuest
local AbandonQuest = AbandonQuest
local GetPlayerMapPosition = GetPlayerMapPosition
local sqrt = sqrt
local QuestFrame = QuestFrame
local GetQuestID = GetQuestID
local QuestFrameAcceptButton = QuestFrameAcceptButton
local DEAD = DEAD

local addonName, addon = ...
_G["NiShiPower"] = addon

local L = addon.L

EmbedEventObject(addon)
addon.version = GetAddOnMetadata(addonName, "Version") or "1.0"
addon.db = {}
addon.DBKEYS = { "youngling", "fighter1", "fighter2" }
addon.TEAM_POS = { fighter1 = 1, fighter2 = 2, youngling = 3 }

local MAX_PET_LEVEL = 25 -- Maximum battle pet level, 25 as of 50100
local NISHI_QUEST_ID = 31955 -- Quest id
local NISHI_POS_X = 0.4607 -- Npc map position x
local NISHI_POS_Y = 0.4368 -- Npc map position y
local NISHI_PETS = { [995] = 1, [996] = 1, [997] = 0 } -- worm, radish, sunflower

-- Species those can be formed up as fighters
local FIGHTER_SPECIES = {
	-- fighter 1
	[328] = { index = 1, ability1 = 118, ability2 = 123, ability3 = 297 },
	[383] = { index = 1, ability1 = 118, ability2 = 123, ability3 = 297 },
	[566] = { index = 1, ability1 = 118, ability2 = 123, ability3 = 297 },
	[751] = { index = 1, ability1 = 118, ability2 = 123, ability3 = 297 },
	[836] = { index = 1, ability1 = 118, ability2 = 123, ability3 = 297 },

	-- fighter 2
	[85] =	{ index = 2, ability1 = 116, ability2 = 640, ability3 = 282 },
	[339] = { index = 2, ability1 = 777, ability2 = 334, ability3 = 282 },
	[500] = { index = 2, ability1 = 406, ability2 = 392, ability3 = 282 },
	[844] = { index = 2, ability1 = 115, ability2 = 334, ability3 = 282 },
}

do
	local id, data
	for id, data in pairs(FIGHTER_SPECIES) do
		data.name = C_PetJournal.GetPetInfoBySpeciesID(id)
	end
end

function addon:Print(msg, arg1, ...)
	if not addon.silent and type(msg) == "string" then
		if arg1 then
			msg = format(msg, arg1, ...)
		end

		DEFAULT_CHAT_FRAME:AddMessage("|cffffff78"..L["title"]..":|r "..msg, 0.5, 0.75, 1)
	end
end

function addon:GetNpcDistance()
	local x, y = GetPlayerMapPosition("player")
	return sqrt((x - NISHI_POS_X) * (x - NISHI_POS_X) + (y - NISHI_POS_Y) * (y - NISHI_POS_Y)) * 10000
end

function addon:IsNiShiBattle()
	local i
	for i = 1, 3 do
		local speciesId = C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ENEMY, i)
		if not NISHI_PETS[speciesId] then
			return
		end
	end

	return 1
end

function addon:FindQuest()
	local index = GetQuestLogIndexByID(NISHI_QUEST_ID)
	if not index or index < 1 then
		return
	end

	local title, _, questTag, _, _, _, isComplete, isDaily = GetQuestLogTitle(index)
	if title and questTag and isDaily then
		return isComplete and -1 or index
	end
end

function addon:AbandonQuest()
	local index = self:FindQuest()
	if index and index > 0 then
		SelectQuestLogEntry(index)
		SetAbandonQuest()
		AbandonQuest()
	end
end

function addon:CanAcceptQuest()
	return QuestFrame:IsShown() and GetQuestID() == NISHI_QUEST_ID and not self:FindQuest() and QuestFrameAcceptButton:IsVisible() and QuestFrameAcceptButton:IsEnabled()
end

function addon:IsPetInLoadOut(petId)
	if type(petId) == "string" then
		local i
		for i = 1, 3 do
			if C_PetJournal.GetPetLoadOutInfo(i) == petId then
				return i
			end
		end
	end
end

function addon:GetBattlePetLink(petId)
	if type(petId) == "number" then
		petId = C_PetJournal.GetPetLoadOutInfo(petId)
	end

	if type(petId) == "string" then
		return C_PetJournal.GetBattlePetLink(petId)
	end
end

function addon:GetQueueCount(key)
	local queue = addon.db[key]
	return queue and #queue or 0
end

function addon:GetQueuePet(key, index)
	local queue = addon.db[key]
	return queue and queue[index]
end

function addon:ClearAllPets(key)
	local queue = addon.db[key]
	if queue then
		wipe(queue)
	end
end

function addon:IsPetInQueue(key, petId)
	local queue = addon.db[key]
	if petId and queue then
		local index, id
		for index, id in ipairs(queue) do
			if id == petId then
				return index
			end
		end
	end
end

function addon:IsAllyFaster()
	local enemyActive = C_PetBattles.GetActivePet(LE_BATTLE_PET_ENEMY)
	local allyActive = C_PetBattles.GetActivePet(LE_BATTLE_PET_ALLY)
	if (enemyActive or 0) > 0 and (allyActive or 0) > 0 then
		return C_PetBattles.GetSpeed(LE_BATTLE_PET_ALLY, allyActive) > C_PetBattles.GetSpeed(LE_BATTLE_PET_ENEMY, enemyActive)
	end
end

function addon:CanPetDropBox(index)
	local data = FIGHTER_SPECIES[C_PetBattles.GetPetSpeciesID(LE_BATTLE_PET_ALLY, index)]
	return data and data.ability2 == 334
end

function addon:IsFighterSpecies(key, speciesId)
	local data = FIGHTER_SPECIES[speciesId]
	if data then
		return key == "fighter"..data.index
	end
end

function addon:GetFighterSpeciesNames(key)
	local names = {}
	local id, data
	for id, data in pairs(FIGHTER_SPECIES) do
		if key == "fighter"..data.index then
			tinsert(names, data.name)
		end
	end
	return names
end

function addon:VerifyPetForQueue(key, petId)
	if not petId then
		return -- Invalid pet id
	end

	local link = C_PetJournal.GetBattlePetLink(petId)
	if not link then
		return -- Invalid pet id
	end

	if self:IsPetInQueue(key, petId) then
		self:Print(L["error already exists"], link, L[key])
		return
	end

	local queue = addon.db[key]
	if not queue then
		return -- Invalid key
	end

	local speciesId, _, level, _, _, _, _, _, _, _, _, _, _, _, canBattle = C_PetJournal.GetPetInfoByPetID(petId)
	if not speciesId or not level then
		return -- Shouldn't happen but who knows
	end

	if not canBattle then
		self:Print(L["error cannot battle"], link)
		return
	end

	if key == "youngling" then
		if level >= MAX_PET_LEVEL then
			self:Print(L["error level maxed"], link)
			return
		end
	else
		if level < MAX_PET_LEVEL then
			self:Print(L["error level not maxed"], link)
			return
		end

		if not self:IsFighterSpecies(key, speciesId) then
			self:Print(L["error not fighter species"], link, L[key])
			return
		end
	end

	return 1
end

function addon:GetPetInfo(petId)
	if type(petId) == "number" then
		petId = C_PetJournal.GetPetLoadOutInfo(petId)
	end

	if type(petId) ~= "string" then
		return
	end

	local speciesId, customName, level, _, _, _, _, name, icon, petType, _, sourceText, description, _, canBattle, tradable = C_PetJournal.GetPetInfoByPetID(petId)
	if not canBattle then
		return
	end

	if customName and customName ~= "" then
		name = customName
	end

	local health, _, _, _, rarity = C_PetJournal.GetPetStats(petId)
	rarity = rarity - 1
	local link = C_PetJournal.GetBattlePetLink(petId)
	local r, g, b = GetItemQualityColor(rarity)

	return name, link, icon, speciesId, petType, level, rarity, health, r, g, b, sourceText, description, tradable
end

function addon:GetBattlePetAbilityInfo(petIndex, abilityIndex, enemy)
	local owner = enemy and LE_BATTLE_PET_ENEMY or LE_BATTLE_PET_ALLY
	local id, name, icon = C_PetBattles.GetAbilityInfo(owner, petIndex, abilityIndex)
	if id and name then
		return name, GetBattlePetAbilityHyperlink(id, C_PetBattles.GetMaxHealth(owner, petIndex), C_PetBattles.GetPower(owner, petIndex), C_PetBattles.GetSpeed(owner, petIndex)), icon
	end
end

function addon:PromoteYounglings()
	addon.silent = 1
	local queue = addon.db.youngling
	local i
	for i = #queue, 1, -1 do
		local petId = queue[i]
		local _, _, level = C_PetJournal.GetPetInfoByPetID(petId)
		if level and level >= MAX_PET_LEVEL then
			tremove(queue, i)
			if self:VerifyPetForQueue("fighter1", petId) then
				tinsert(addon.db.fighter1, petId)
			elseif self:VerifyPetForQueue("fighter2", petId) then
				tinsert(addon.db.fighter2, petId)
			end
			addon:BroadcastEvent("YOUNGLING_PROMOTE", petId)
		end
	end
	addon.silent = nil
end

local HEALTH_MIN_YOUNGLING = 200
local HEALTH_MIN_FIGHTER = 300

function addon:FindYoungling()
	local key = "youngling"
	local reason = L["log team fail error not configured"]
	local i
	for i = 1, self:GetQueueCount(key) do
		local petId = self:GetQueuePet(key, i)
		local name, link, icon, speciesId, petType, level, rarity, health, r, g, b, sourceText, description, tradable = addon:GetPetInfo(petId)
		if level and health then
			if health == 0 then
				reason = DEAD
			elseif health < HEALTH_MIN_YOUNGLING then
				reason = format(L["log team fail error health low"], HEALTH_MIN_YOUNGLING)
			elseif level >= MAX_PET_LEVEL then
				reason = L["log team fail error level maxed"]
			else
				return petId, icon, link
			end
		end
	end

	return nil, reason
end

function addon:FindFighter(index)
	local key = "fighter"..index
	local healthReq = index * HEALTH_MIN_FIGHTER
	local reason = L["log team fail error not configured"]
	local i
	for i = 1, self:GetQueueCount(key) do
		local petId = self:GetQueuePet(key, i)
		local name, link, icon, speciesId, petType, level, rarity, health, r, g, b, sourceText, description, tradable = addon:GetPetInfo(petId)
		if level and health then
			if health == 0 then
				reason = DEAD
			elseif health < healthReq then
				reason = format(L["log team fail error health low"], healthReq)
			elseif level < MAX_PET_LEVEL then
				reason = L["log team fail error level not maxed"]
			else
				local data = FIGHTER_SPECIES[speciesId]
				if not data or data.index ~= index then
					reason = L["log team fail error type mismatch"]
				else
					return petId, icon, link, data.ability1, data.ability2, data.ability3
				end
			end

		end
	end

	return nil, reason
end

function addon:PetHasAbility(petId, abilityId)
	if not petId then
		return
	end

	local speciesId = C_PetJournal.GetPetInfoByPetID(petId)
	if not speciesId then
		return
	end

	local list = C_PetJournal.GetPetAbilityList(speciesId)
	if not list then
		return
	end

	local index, id
	for index, id in ipairs(list) do
		if id == abilityId then
			return index
		end
	end
end

local PET_TEAMS = { [1] = 1, [2] = 1, [3] = 1 }

function addon:ChooseTeamPet(teamIndex, petId)
	if not petId or not PET_TEAMS[teamIndex] then
		return
	end

	if C_PetJournal.GetPetLoadOutInfo(teamIndex) == petId then
		return 1
	end

	C_PetJournal.SetPetLoadOutInfo(teamIndex, petId)
	if PetJournal:IsVisible() then
		PetJournal_UpdatePetLoadOut()
	end

	return 0 -- Need to check later if returns 0
end

function addon:VerifyTeamPet(teamIndex, petId)
	return petId and PET_TEAMS[teamIndex] and petId == C_PetJournal.GetPetLoadOutInfo(teamIndex) and C_PetJournal.GetPetStats(petId) >= HEALTH_MIN_YOUNGLING
end

function addon:ChooseTeamPetAbilities(teamIndex, ability1, ability2, ability3)
	if not PET_TEAMS[teamIndex] then
		return
	end

	local petId, a1, a2, a3 = C_PetJournal.GetPetLoadOutInfo(teamIndex)
	if not petId then
		return
	end

	local result = 1
	if ability1 and ability1 ~= a1 then
		result = 0
		C_PetJournal.SetAbility(teamIndex, 1, ability1)
	end

	if ability2 and ability2 ~= a2 then
		result = 0
		C_PetJournal.SetAbility(teamIndex, 2, ability2)
	end

	if ability3 and ability3 ~= a3 then
		result = 0
		C_PetJournal.SetAbility(teamIndex, 3, ability3)
	end

	if result ~= 1 and PetJournal:IsVisible() then
		PetJournal_UpdatePetLoadOut()
	end

	return result -- Need to check later if returns 0
end

function addon:VerifyTeamPetAbilities(teamIndex, ability1, ability2, ability3)
	if not PET_TEAMS[teamIndex] then
		return
	end

	local _, a1, a2, a3 = C_PetJournal.GetPetLoadOutInfo(teamIndex)
	return (ability1 or a1) == a1 and (ability2 or a2) == a2 and (ability3 or a3) == a3
end

function addon:PetHasAura(index, auraId, enemy)
	if not auraId then
		return
	end

	local owner = enemy and LE_BATTLE_PET_ENEMY or LE_BATTLE_PET_ALLY
	local i
	for i = 1, C_PetBattles.GetNumAuras(owner, index) do
		local id, _, remain, helpful = C_PetBattles.GetAuraInfo(owner, index, i)
		if id == auraId then
			return remain, helpful
		end
	end
end

function addon:IsAbilityUsable(petIndex, abilityIndex, enemy)
	local owner = enemy and LE_BATTLE_PET_ENEMY or LE_BATTLE_PET_ALLY
	local usable, cooldown = C_PetBattles.GetAbilityState(owner, petIndex, abilityIndex)
	return usable, cooldown
end