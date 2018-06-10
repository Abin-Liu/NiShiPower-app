-----------------------------------------------
-- zhCN.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

if GetLocale() ~= "zhCN" then return end

local _, addon = ...

addon.L = {
	["title"] = "倪石之力",
	["control action"] = "主动作控制",
	["Farmer Nishi"] = "农夫倪石",
	["scroll bottom"] = "最后",
	["youngling"] = "幼宠",
	["fighter1"] = "战宠1",
	["fighter2"] = "战宠2",
	["tooltip youngling"] = "你希望升级的幼宠，升级顺序为从上至下。",
	["tooltip fighter1"] = "1号战宠，它将杀死敌方1-2号宠物，然后故意死于敌方3号宠物之手。",
	["tooltip fighter2"] = "2号战宠，它将使用|cffff0000自爆|r技能与敌方3号宠物同归于尽。",
	["error already exists"] = "%s已经在队列%s之中。",
	["error cannot battle"] = "%s不是一只战斗宠物。",
	["error level maxed"] = "%s已经达到最大等级。",
	["error level not maxed"] = "%s尚未达到最大等级。",
	["error not fighter species"] = "%s宠物类型不符合%s的要求。",
	["list prompt youngling"] = "将你希望升级的幼宠拖动到这里。",
	["list prompt fighter"] = "将你希望使用的战宠拖动到这里。战宠类型必须符合下列范围：\n",
	["log"] = "日志",
	["tooltip log"] = "查看最近的动作日志。",
	["toggle frame"] = "显示/隐藏倪石之力窗口。",
	["add to team"] = "Alt-点击：将这只宠物放入战队。",
	["error quest completed"] = "任务已完成，运行终止。",

	["tooltip list up"] = "点击：将选中的宠物上移。",
	["tooltip list up shift"] = "Shift-点击：将选中的宠物移到顶部。",
	["tooltip list down"] = "点击：将选中的宠物下移。",
	["tooltip list down shift"] = "Shift-点击：将选中的宠物移到底部。",
	["tooltip list delete"] = "点击：将选定的宠物从队列中移除。",

	["tooltip log up"] = "点击：将日志内容向上滚动。",
	["tooltip log up shift"] = "Shift-点击：将日志内容滚动到顶部。",
	["tooltip log down"] = "点击：将日志内容向下滚动。",
	["tooltip log down shift"] = "Shift-点击：将日志内容滚动到底部。",
	["tooltip log clear"] = "点击：清空日志内容。",

	["log manager activate"] = "Npc接近中，组件已激活。",
	["log manager deactivate"] = "Npc远离视野，组件已休眠。\n",
	["log all states"] = "清除所有状态。",
	["log battle started"] = "战斗开始。",
	["log battle round"] = "战斗回合 %d。",
	["log battle over"] = "战斗结束。",
	["log wait StartModuleTeam"] = "等待组队模块启动...",
	["log team module started"] = "组队模块已启动。",
	["log team choosing pets"] = "遴选战队宠物。",
	["log team heal"] = "无法组成战队，尝试复活宠物。",
	["log team form"] = "正在组队。",
	["log team choose abilities"] = "为战队宠物设置技能。",
	["log team ready"] = "战队组建成功。",

	["log team pet choosing ok"] = "已选择%s \124T%s:0:0:0:0\124t%s。",
	["log team pet choosing fail"] = "无法选择%s（%s）。",
	["log team fail error not configured"] = "未设置",
	["log team fail error health low"] = "血量低于%d",
	["log team fail error level maxed"] = "已满级",
	["log team fail error level not maxed"] = "未满级",
	["log team fail error type mismatch"] = "类型不符",
	["log team heal cooldown"] = "\124T%s:0:0:0:0\124t%s冷却剩余%d秒。",
	["log team cast heal"] = "施放 \124T%s:0:0:0:0\124t%s。",
	["log team pet list changed"] = "宠物列表更改，重启组队模块...",

	["log wait StartModuleInteract"] = "等待互动模块启动...",
	["log interact module started"] = "互动模块已启动。",
	["log interact abandoning quest"] = "放弃任务。",
	["log interact targeting npc"] = "选中Npc为目标。",
	["log interact moving"] = "向Npc移动（%d码）。",
	["log interact distance ok"] = "已到达互动距离（%d码）。",
	["log interact interacting"] = "与Npc互动。",
	["log interact accept quest"] = "接受任务。",
	["log interact starting battle"] = "尝试启动战斗。",
	["log interact distance error"] = "与Npc距离过远，有错误发生，模块停止。",

	["log battle using ability"] = "使用技能 \124T%s:0:0:0:0\124t%s。",
	["log battle change pet"] = "切换宠物 \124T%s:0:0:0:0\124t%s。",
	["log battle skip turn"] = "等待一回合。",
	["log battle forfeit"] = "战斗失败，认输。",
	["log battle health low"] = "血线过低，治疗。",
	["log battle explode"] = "准备自爆！(预估伤害 %d)",
	["log battle won"] = "战斗胜利。",
	["log battle enormous damage coming"] = "巨大伤害即将到来！",
	["log battle enemy invincible"] = "对方无敌一回合。",
	["log battle quest abandon failed"] = "任务放弃未成功，退出战斗。",
}