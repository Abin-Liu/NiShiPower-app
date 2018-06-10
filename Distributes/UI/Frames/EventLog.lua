-----------------------------------------------
-- EventLog.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

local format = format
local date = date
local strsub = strsub
local IsShiftKeyDown = IsShiftKeyDown

local _, addon = ...
local L = addon.L

local frame = CreateFrame("ScrollingMessageFrame", addon.frame:GetName().."LogFrame", addon.tabFrame, "ChatFrameTemplate")
addon.logFrame = frame
frame:Hide()
frame:SetPoint("TOPLEFT", 8, -6)
frame:SetPoint("BOTTOMRIGHT", -8, 8)
frame:SetFading(false)
frame:SetMaxLines(500)
frame:SetJustifyH("LEFT")
frame:SetJustifyV("TOP")
frame:SetIndentedWordWrap(false)
frame:SetFrameStrata("DIALOG")
frame:SetHyperlinksEnabled(true)
frame:EnableMouseWheel(true)

frame:SetScript("OnLoad", nil)
frame:SetScript("OnEvent", nil)
frame:SetScript("OnUpdate", nil)
frame:UnregisterAllEvents()

addon.frame:CreateOperateButtons(frame, COMBAT_TEXT_SCROLL_UP, COMBAT_TEXT_SCROLL_DOWN, CLEAR_ALL)

function frame:OnTooltipUp(tooltip)
	tooltip:AddLine(L["tooltip log up"])
	tooltip:AddLine(L["tooltip log up shift"])
end

function frame:OnUp(shiftDown)
	if shiftDown then
		self:ScrollToTop()
	else
		self:ScrollUp()
	end
end

function frame:OnTooltipDown(tooltip)
	tooltip:AddLine(L["tooltip log down"])
	tooltip:AddLine(L["tooltip log down shift"])
end

function frame:OnDown(shiftDown)
	if shiftDown then
		self:ScrollToBottom()
	else
		self:ScrollDown()
	end
end

function frame:OnTooltipDelete(tooltip)
	tooltip:AddLine(L["tooltip log clear"])
end

function frame:OnDelete()
	self.deleteButton:Disable()
	self:Clear()
end

frame:SetScript("OnMouseWheel", function(self, delta)
	if delta == 1 then
		if IsShiftKeyDown() then
			self:ScrollToTop()
		else
			self:ScrollUp()
		end
	elseif delta == -1 then
		if IsShiftKeyDown() then
			self:ScrollToBottom()
		else
			self:ScrollDown()
		end
	end
end)

local function Frame_UpdateButtonStates(self)
	local count = self:GetNumMessages()

	if count == 0 or self:AtTop() then
		self.upButton:Disable()
	else
		self.upButton:Enable()
	end

	if count == 0 or self:AtBottom() then
		self.downButton:Disable()
	else
		self.downButton:Enable()
	end
end

frame:SetScript("OnShow", Frame_UpdateButtonStates)
frame:SetScript("OnMessageScrollChanged", Frame_UpdateButtonStates)

frame:SetScript("OnUpdate", function(self, elapsed)
	self.elapsed = (self.elapsed or 0) + elapsed
	if self.elapsed > 0.2 then
		self.elapsed = 0
		Frame_UpdateButtonStates(self)
	end
end)

addon:RegisterEventCallback("TAB_SELECTION", function(index, key)
	if key == "log" then
		frame:Show()
	else
		frame:Hide()
	end
end)

local lastLogText
function addon:AddLog(text, arg1, ...)
	if not text then
		return
	end

	if arg1 then
		text = format(text, arg1, ...)
	end

	if lastLogText == text then
		return
	end

	lastLogText = text

	local timeStamp = "|cffffff78"..strsub(date(), 10, 17).."|r"
	text = timeStamp.." "..text
	frame:AddMessage(text)
	frame.deleteButton:Enable()
end

local SPECIAL_CODES = {
	STARTUP = "80c0ff",
	SYSTEM = "9d9d9d",
	READY = "009620",
	CRITICAL = "ff8000",
	WARNING = "cd4d39",
}

function addon:AddSpecialLog(code, text, arg1, ...)
	local color = SPECIAL_CODES[code]
	if color then
		addon:AddLog("|cff"..color..text.."|r", arg1, ...)
	else
		addon:AddLog(text, arg1, ...)
	end
end