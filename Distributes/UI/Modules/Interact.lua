-----------------------------------------------
-- Interact.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

local UnitName = UnitName
local QuestFrame = QuestFrame
local GossipFrame = GossipFrame

local _, addon = ...
local L = addon.L


local MAX_INTERACT_DISTANCE = 10 -- Distance threshold where interaction disabled

local prevDistance, movedAlready

local module = addon:CreateModule()

function module:OnTick()
	local state = self:GetState()
	if state == "start" then
		if addon:FindQuest() == -1 then
			addon:StopAllModules()
			addon:AddSpecialLog("CRITICAL", L["error quest completed"])
		else
			self:SetState("target")
		end

	elseif state == "target" then
		addon:AddLog(L["log interact targeting npc"])
		if UnitName("target") == L["Farmer Nishi"] then
			self:SetState("move")
		else
			addon:NotifyClick("/targetexact "..L["Farmer Nishi"])
		end

	elseif state == "move" then
		local distance = addon:GetNpcDistance()
		if distance > MAX_INTERACT_DISTANCE then
			if not prevDistance or prevDistance > distance then
				addon:AddLog(L["log interact moving"], distance)
				if movedAlready then
					addon:NotifySpecialClick(1, 0, 1)
				else
					addon:NotifySpecialClick(1, 0, 0)
				end
				movedAlready = 1
			end
			prevDistance = distance
		else
			addon:AddLog(L["log interact distance ok"], distance)
			self:SetState("interact")
		end

	elseif state == "interact" then
		addon:AddLog(L["log interact interacting"])
		if UnitName("target") ~= L["Farmer Nishi"] then
			addon:NotifyClick("/targetexact "..L["Farmer Nishi"])

		elseif QuestFrame:IsShown() then
			if addon:CanAcceptQuest() then
				addon:AddLog(L["log interact accept quest"])
				addon:NotifyClick("/click QuestFrameAcceptButton")
			else
				QuestFrame:Hide()
			end

		elseif GossipFrame:IsShown() then
			if UnitName("npc") == L["Farmer Nishi"] and addon:FindQuest() then
				self:SetState("option")
			else
				GossipFrame:Hide()
			end
		else
			addon:NotifySpecialClick(1, 1, 0) -- interact
		end

	elseif state == "option" then
		addon:AddLog(L["log interact starting battle"])
		local index = addon:FindQuest()
		if index == -1 then
			addon:StopAllModules()
			addon:AddSpecialLog("CRITICAL", L["error quest completed"])
		else
			addon:NotifyClick("NiShiPower:AbandonQuest() SelectGossipOption(1, nil, 1)")
			self:SetState("interact")
		end
	end
end

function addon:StartModuleInteract()
	module:StopTick()
	addon:AddSpecialLog("READY", L["log interact module started"])
	movedAlready = nil
	prevDistance = nil
	module:StartTick("start", 0.5)
end

addon:RegisterEventCallback("TEAM_READY", function()
	module:StopTick()
	addon:AddLog(L["log wait StartModuleInteract"])
	addon:NotifyClick("NiShiPower:StartModuleInteract()")
end)

addon:RegisterEventCallback("BATTLE_START", function()
	module:StopTick()
end)