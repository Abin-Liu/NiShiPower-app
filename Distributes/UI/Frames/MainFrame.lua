-----------------------------------------------
-- MainFrame.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

local GameTooltip = GameTooltip
local ipairs = ipairs
local IsShiftKeyDown = IsShiftKeyDown
local C_PetJournal = C_PetJournal
local type = type
local PetJournal = PetJournal
local GetItemQualityColor = GetItemQualityColor
local TogglePetJournal = TogglePetJournal

local addonName, addon = ...
local L = addon.L

BINDING_HEADER_NISHIPOWER_TITLE = L["title"]
BINDING_NAME_NISHIPOWER_ACTION = L["control action"]

-----------------------------------------------
-- Header button
-----------------------------------------------

local header = CreateFrame("Button", "NiShiPowerHeader", UIParent)
addon.header = header
header:SetSize(26, 26)
header:SetPoint("BOTTOMRIGHT", UIParent, "CENTER", -50, 100)
header:SetMovable(true)
header:SetUserPlaced(true)
header:SetClampedToScreen(true)
header:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight", "ADD")
header:RegisterForDrag("LeftButton")
header:SetScript("OnDragStart", header.StartMoving)
header:SetScript("OnDragStop", header.StopMovingOrSizing)

header:SetScript("OnClick", function(self)
	GameTooltip:Hide()
	addon.frame:Toggle()
end)

header:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:ClearLines()
	GameTooltip:AddLine(L["title"])
	GameTooltip:AddLine(L["toggle frame"], 1, 1, 1, 1)
	GameTooltip:Show()
end)

header:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

header.bkgnd = header:CreateTexture(nil, "BORDER")
header.bkgnd:SetAllPoints(header)
header.bkgnd:SetTexture("Interface\\PetBattles\\PetJournal")
header.bkgnd:SetTexCoord(0.06835938, 0.10937500, 0.02246094, 0.04296875)

header.icon = header:CreateTexture(nil, "ARTWORK")
header.icon:SetPoint("TOPLEFT", 4, -4)
header.icon:SetPoint("BOTTOMRIGHT", -4, 4)
header.icon:SetTexture("InterFace\\Icons\\Tracking_WildPet")

-----------------------------------------------
-- Main frame
-----------------------------------------------

local frame = UICreateInterfaceOptionPage("NiShiPowerFrame", L["title"], nil, nil, UIParent)
addon.frame = frame
frame:SetDialogStyle("DIALOG", 1)
frame:SetSize(310, 532)
frame:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -2)
frame:SetClampedToScreen(true)
frame:SetBackdrop({ bgFile = "Interface\\FrameGeneral\\UI-Background-Marble", edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", edgeSize = 16, insets = { left = 5, right = 5, top = 5, bottom = 5 } })
frame:SetUserPlaced(true)
frame:SetDontSavePosition(false)

frame:SetScript("OnShow", function(self)
	header:LockHighlight()
end)

------------------------------------------------------
-- I want my frame to be Esc-closable, but I don't want it to be annoyingly
-- closed by Blizzard default UI framework every time a pet battle starts,
-- so here's the solution: check the time duration between frame's "OnHide"
-- script and the "PLAYER_CONTROL_LOST" event, if it's shorter than 1 second
-- we re-open it. Am I a genius or what?
------------------------------------------------------

local hideTime
frame:SetScript("OnHide", function(self)
	header:UnlockHighlight()
	hideTime = GetTime()
end)

frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("PLAYER_CONTROL_LOST")

frame:SetScript("OnEvent", function(self, event, arg1)
	if event == "ADDON_LOADED" and arg1 == addonName then
		if type(NiShiPowerDB) ~= "table" then
			NiShiPowerDB = {}
		end

		addon.db = NiShiPowerDB
		local _, key
		for _, key in ipairs(addon.DBKEYS) do
			if type(addon.db[key]) ~= "table" then
				addon.db[key] = {}
			end
		end

		addon:BroadcastEvent("INITIALIZE", addon.db)

		local i
		for i = 1, addon.tabFrame:NumTabs() do
			addon:RegisterForDrag(addon.tabFrame:GetTabButton(i))
		end

		addon.tabFrame:SelectTab(1)

	elseif event == "PLAYER_CONTROL_LOST" and not InCombatLockdown() then
		if hideTime and GetTime() - hideTime < 1 and not self:IsShown() then
			self:Show()
		end
	end
end)

function Target_OnDragStart(self)
	frame:StartMoving()
end

function Target_OnDragStop(self)
	frame:StopMovingOrSizing()
end

function addon:RegisterForDrag(target)
	target:EnableMouse(true)
	target:RegisterForDrag("LeftButton")
	target:SetScript("OnDragStart", Target_OnDragStart)
	target:SetScript("OnDragStop", Target_OnDragStop)
end

addon:RegisterForDrag(frame.topClose)

-----------------------------------------------
-- Pet_Journal toggle button
-----------------------------------------------

local toggleButton = CreateFrame("Button", frame:GetName().."Toggle", frame, "UIMenuButtonStretchTemplate")
addon:RegisterForDrag(toggleButton)

toggleButton:SetSize(24, 20)
toggleButton:SetPoint("TOPLEFT", 8, -8)
toggleButton.leftArrow:Show()

toggleButton:SetScript("OnClick", function(self)
	GameTooltip:Hide()
	TogglePetJournal(2)
end)

toggleButton:SetScript("OnEnter", function(self)
	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:ClearLines()
	GameTooltip:AddLine(PET_JOURNAL)
	GameTooltip:AddLine(BINDING_NAME_TOGGLEPETJOURNAL, 1, 1, 1, 1)
	GameTooltip:Show()
end)

toggleButton:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

-----------------------------------------------
-- Tab frame
-----------------------------------------------

local tabFrame = UICreateTabFrame(frame:GetName().."TabFrame", frame)
addon.tabFrame = tabFrame
tabFrame:SetPoint("TOPLEFT", 12, -58)
tabFrame:SetPoint("TOPRIGHT", -12, -58)
tabFrame:SetHeight(418)

function tabFrame:OnTabSelected(index, key)
	addon:BroadcastEvent("TAB_SELECTION", index, key)
end

do
	local _, key
	for _, key in ipairs(addon.DBKEYS) do
		tabFrame:AddTab(L[key], key, L["tooltip "..key])
	end
	tabFrame:AddTab(L["log"], "log", L["tooltip log"])
end

-----------------------------------------------
-- Author info
-----------------------------------------------

local abin = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
abin:SetText("Abin Studio - 2012")
abin:SetFont(STANDARD_TEXT_FONT, 10)
abin:SetTextColor(0.5, 0.5, 0.5)
abin:SetPoint("BOTTOMRIGHT", -16, 12)

-----------------------------------------------
-- Utilities
-----------------------------------------------

local function PressButton_OnClick(self)
	local func = self:GetParent()["On"..self.key]
	if func then
		func(self:GetParent(), IsShiftKeyDown())
	end
end

local function PressButton_OnEnter(self)
	local func = self:GetParent()["OnTooltip"..self.key]
	if not func then
		return
	end

	GameTooltip:SetOwner(self, "ANCHOR_LEFT")
	GameTooltip:ClearLines()
	GameTooltip:AddLine(self:GetText())
	func(self:GetParent(), GameTooltip)
	GameTooltip:Show()
end

local function PressButton_OnLeave(self)
	GameTooltip:Hide()
end

local function CreatePressButton(parent, text, key)
	local button = frame:CreatePressButton(text)
	button:SetParent(parent)
	button:Disable()
	button:SetSize(90, 22)
	addon:RegisterForDrag(button)
	button.key = key

	if key == "Down" then
		button:SetPoint("TOP", tabFrame, "BOTTOM", 0, -6)
	elseif key == "Up" then
		button:SetPoint("RIGHT", parent.downButton, "LEFT")
	elseif key == "Delete" then
		button:SetPoint("LEFT", parent.downButton, "RIGHT")
	end

	button:SetScript("OnClick", PressButton_OnClick)
	button:SetScript("OnEnter", PressButton_OnEnter)
	button:SetScript("OnLeave", PressButton_OnLeave)

	return button
end

function frame:CreateOperateButtons(parent, textUp, textDown, textDelete)
	parent.downButton = CreatePressButton(parent, textDown, "Down")
	parent.upButton = CreatePressButton(parent, textUp, "Up")
	parent.deleteButton = CreatePressButton(parent, textDelete, "Delete")
	return parent.upButton, parent.downButton, parent.deleteButton
end

------------------------------------------------------------
-- Hook Pet_Journal list buttons
------------------------------------------------------------

local function FindPetInQueue(petId)
	if not petId then
		return
	end

	local _, key
	for _, key in ipairs(addon.DBKEYS) do
		if addon:IsPetInQueue(key, petId) then
			return key
		end
	end
end

hooksecurefunc("HybridScrollFrame_Update", function(scrollFrame)
	if scrollFrame ~= PetJournal.listScroll then
		return
	end

	local i
	for i = 1, 100 do
		local button = _G["PetJournalListScrollFrameButton"..i]
		if not button then
			return
		end

		local petId = button.petID
		local _, _, _, _, rarity = C_PetJournal.GetPetStats(petId or "")
		local r, g, b = GetItemQualityColor((rarity or 2) - 1)
		button.name:SetTextColor(r, g, b)

		local queued = FindPetInQueue(button.petID)
		local flag = button.__NiShiPowerFlag
		if not flag then
			flag = button:CreateTexture(nil, "OVERLAY")
			button.__NiShiPowerFlag = flag
			flag:SetSize(24, 24)
			flag:SetPoint("RIGHT", -6, 0)
			flag:SetTexture("Interface\\RaidFrame\\ReadyCheck-Ready")
		end

		if queued then
			flag:Show()
		else
			flag:Hide()
		end
	end
end)

------------------------------------------------------------
-- Slash command: /halfhill
------------------------------------------------------------

SLASH_NISHIPOWER1 = "/nishi"
SLASH_NISHIPOWER2 = "/nishipower"

SlashCmdList["NISHIPOWER"] = function()
	frame:Toggle()
end