-----------------------------------------------
-- PetList.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

local GameTooltip = GameTooltip
local ipairs = ipairs
local UNKNOWN = UNKNOWN
local PetJournal_ShowPetCardByID = PetJournal_ShowPetCardByID
local C_PetJournal = C_PetJournal
local ChatEdit_InsertLink = ChatEdit_InsertLink
local IsAltKeyDown = IsAltKeyDown
local IsShiftKeyDown = IsShiftKeyDown
local PetJournal = PetJournal
local TogglePetJournal = TogglePetJournal

local _, addon = ...
local L = addon.L

local selectedKey

local frame = UICreateVirtualScrollList(addon.frame:GetName().."List", addon.tabFrame, 10, 1)
addon.listFrame = frame
addon:RegisterForDrag(frame)
frame:SetPoint("TOPLEFT", 8, -8)
frame:SetPoint("BOTTOMRIGHT", -8, 8)
frame:EnableDrag(1)

addon.frame:CreateOperateButtons(frame, TRACKER_SORT_MANUAL_UP, TRACKER_SORT_MANUAL_DOWN, DELETE)

local promptTexts = {}
local function CreatePromptText(key)
	local fontString = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	fontString:Hide()
	fontString:SetPoint("TOPLEFT", 12, -40)
	fontString:SetPoint("BOTTOMRIGHT", -12, 12)
	fontString:SetJustifyV("TOP")
	fontString:SetJustifyH("LEFT")

	local text
	if key == "youngling" then
		text = L["list prompt youngling"]
	else
		text = L["list prompt fighter"]
		local names = addon:GetFighterSpeciesNames(key)
		local _, name
		for _, name in ipairs(names) do
			text = text.."\n"..name
		end
	end

	fontString:SetText(text)
	promptTexts[key] = fontString
end

local function UpdateDragPrompt()
	local key, text
	for key, text in pairs(promptTexts) do
		if key == selectedKey and frame:GetDataCount() == 0 then
			text:Show()
		else
			text:Hide()
		end
	end
end

do
	local _, key
	for _, key in ipairs(addon.DBKEYS) do
		CreatePromptText(key)
	end
end

function frame:OnUp(shiftDown)
	self:MoveData(nil, shiftDown and "TOP" or "UP")
end

function frame:OnTooltipUp(tooltip)
	tooltip:AddLine(L["tooltip list up"], 1, 1, 1, 1)
	tooltip:AddLine(L["tooltip list up shift"], 1, 1, 1, 1)
end

function frame:OnDown(shiftDown)
	self:MoveData(nil, shiftDown and "BOTTOM" or "DOWN")
end

function frame:OnTooltipDown(tooltip)
	tooltip:AddLine(L["tooltip list down"], 1, 1, 1, 1)
	tooltip:AddLine(L["tooltip list down shift"], 1, 1, 1, 1)
end

function frame:OnDelete()
	if self:RemoveData() then
		UpdateDragPrompt()
		addon:BroadcastEvent("PETLIST_CHANGED", selectedKey)
	end
end

function frame:OnTooltipDelete(tooltip)
	tooltip:AddLine(L["tooltip list delete"], 1, 1, 1, 1)
end

function frame:OnButtonCreated(button)
	button:SetHeight(40)

	button.bkgnd = button:CreateTexture(nil, "BACKGROUND")
	button.bkgnd:SetPoint("TOPLEFT")
	button.bkgnd:SetPoint("BOTTOMRIGHT", -2, 0)
	button.bkgnd:SetTexture("Interface\\PetBattles\\PetJournal")
	button.bkgnd:SetTexCoord(0.49804688, 0.90625, 0.12792969, 0.17285156)

	button.typeIcon = button:CreateTexture(nil, "BORDER")
	button.typeIcon:SetSize(90 * 40 / 44, 40)
	button.typeIcon:SetPoint("RIGHT", -2, 0)
	button.typeIcon:SetTexCoord(0.0078125, 0.7109375, 0.74609375, 0.91796875)

	button.loadOutIcon = button:CreateTexture(nil, "ARTWORK")
	button.loadOutIcon:Hide()
	button.loadOutIcon:SetSize(20, 20)
	button.loadOutIcon:SetPoint("RIGHT", -6, 0)
	button.loadOutIcon:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")

	button.name = button:CreateFontString(nil, "ARTWORK", "GameFontNormalLeft")
	button.name:SetPoint("LEFT", 44, 0)
	button.name:SetPoint("RIGHT", -6, 0)

	local child = CreateFrame("Frame", nil, button)
	child:SetSize(32, 32)
	child:SetPoint("LEFT", 4, 0)

	button.icon = child:CreateTexture(nil, "BACKGROUND")
	button.icon:SetAllPoints(child)

	button.dead = child:CreateTexture(nil, "BORDER")
	button.dead:SetAllPoints(button.icon)
	button.dead:SetTexture("Interface\\PetBattles\\DeadPetIcon")

	button.levelBg = child:CreateTexture(nil, "ARTWORK")
	button.levelBg:SetSize(17, 17)
	button.levelBg:SetPoint("BOTTOMRIGHT", button.icon, "BOTTOMRIGHT", 3, -3)
	button.levelBg:SetTexture("Interface\\PetBattles\\PetJournal")
	button.levelBg:SetTexCoord(0.06835938, 0.10937500, 0.02246094, 0.04296875)

	button.level = child:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	button.level:SetPoint("CENTER", button.levelBg, "CENTER", 1, -1)
	button.level:SetFont(STANDARD_TEXT_FONT, 11)

	addon:RegisterForDrag(button)
end

function frame:OnButtonUpdate(button, petId)
	local name, link, icon, speciesId, petType, level, rarity, health, r, g, b, sourceText, description, tradable = addon:GetPetInfo(petId)
	if name then
		button.icon:SetTexture(icon)
		button.typeIcon:SetTexture(GetPetTypeTexture(petType))
		button.typeIcon:Show()
		button.name:SetText(name)
		button.name:SetTextColor(r, g, b)
		button.level:SetFormattedText("%d", level)
		if health > 0 then
			button.dead:Hide()
		else
			button.dead:Show()
		end

		if addon:IsPetInLoadOut(petId) then
			button.loadOutIcon:Show()
		else
			button.loadOutIcon:Hide()
		end
	else
		button.icon:SetTexture("Interface\\Icons\\INV_Misc_QuestionMark")
		button.typeIcon:Hide()
		button.name:SetText(UNKNOWN)
		button.name:SetTextColor(1, 0.1, 0.1)
		button.level:SetText()
		button.dead:Hide()
		button.loadOutIcon:Hide()
	end
end

function frame:OnSelectionChanged(selection, petId)
	self.deleteButton:Disable()
	self.upButton:Disable()
	self.downButton:Disable()

	if selection then
		self.deleteButton:Enable()
		if selection > 1 then
			self.upButton:Enable()
		end

		if selection < self:GetDataCount() then
			self.downButton:Enable()
		end

		PetJournal_ShowPetCardByID(petId)
	end
end

function frame:OnButtonTooltip(button, petId)
	local name, link, icon, speciesId, petType, level, rarity, health, r, g, b, sourceText, description, tradable = addon:GetPetInfo(petId)
	if not name then
		return
	end

	GameTooltip:AddLine(name, r, g, b)

	if sourceText and sourceText ~= "" then
		GameTooltip:AddLine(sourceText, 1, 1, 1, 1)
	end

	if not tradable then
		GameTooltip:AddLine(BATTLE_PET_NOT_TRADABLE, 1, 0.1, 0.1, 1)
	end

	if description and description ~= "" then
		GameTooltip:AddLine(" ")
		GameTooltip:AddLine(description, nil, nil, nil, 1)
	end

	GameTooltip:AddLine(" ")
	GameTooltip:AddLine(L["add to team"], 0.5, 0.75, 1, 1)
end

function frame:OnButtonClick(button, petId, flag)
	if flag ~= "LeftButton" then
		return
	end

	if IsShiftKeyDown() then
		local link = C_PetJournal.GetBattlePetLink(petId)
		if link then
			ChatEdit_InsertLink(link)
		end
	elseif IsAltKeyDown() then
		addon:ChooseTeamPet(1, petId)
	end
end

function frame:OnButtonDoubleClick(button, petId)
	PetJournal_ShowPetCardByID(petId)
	if PetJournalParent:IsShown() then
		PetJournalParentTab2:Click()
	else
		TogglePetJournal(2)
	end
end

function frame:OnReceiveDrag(info, petId)
	if info == "battlepet" and addon:VerifyPetForQueue(selectedKey, petId) then
		self:InsertData(petId)
		UpdateDragPrompt()
		addon:BroadcastEvent("PETLIST_CHANGED", selectedKey, 1)
	end
end

addon:RegisterEventCallback("YOUNGLING_PROMOTE", function()
	if frame:IsVisible() then
		frame:RefreshContents()
	end
end)

addon:RegisterEventCallback("TAB_SELECTION", function(index, key)
	selectedKey = key
	local queue = addon.db[key]
	if queue then
		frame:BindDataList(queue)
		if key == "youngling" then
			addon:PromoteYounglings()
		end
		frame:Show()
	else
		frame:Hide()
	end

	UpdateDragPrompt()
end)

frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PET_JOURNAL_LIST_UPDATE")
frame:RegisterEvent("PET_JOURNAL_PET_DELETED")
frame:RegisterEvent("PET_JOURNAL_PETS_HEALED")
frame:RegisterEvent("COMPANION_UPDATE")
frame:RegisterEvent("PET_BATTLE_LEVEL_CHANGED")

frame:SetScript("OnEvent", function(self, event)
	self:RefreshContents()
	if event == "PET_JOURNAL_PET_DELETED" or event == "PET_JOURNAL_PETS_HEALED" then
		addon:BroadcastEvent("PETLIST_CHANGED", selectedKey)
	end
end)