-----------------------------------------------
-- zhTW.lua
--
-- Abin
-- 2012-12-08
-----------------------------------------------

if GetLocale() ~= "zhTW" then return end

local _, addon = ...

addon.L = {
	["title"] = "妮希之力",
	["control action"] = "主動作控制",
	["Farmer Nishi"] = "農夫妮希",
	["scroll bottom"] = "最後",
	["youngling"] = "幼寵",
	["fighter1"] = "戰寵1",
	["fighter2"] = "戰寵2",
	["tooltip youngling"] = "你希望升級的幼寵，升級順序為從上至下。",
	["tooltip fighter1"] = "1號戰寵，牠將殺死敵方1-2號寵物，然後故意死於敵方3號寵物之手。",
	["tooltip fighter2"] = "2號戰寵，牠將使用|cffff0000自爆|r技能與敵方3號寵物同歸於盡。",
	["error already exists"] = "%s已經在隊列%s之中。",
	["error cannot battle"] = "%s不是一隻戰鬥寵物。",
	["error level maxed"] = "%s已經達到最大等級。",
	["error level not maxed"] = "%s尚未達到最大等級。",
	["error not fighter species"] = "%s寵物類型不符合%s的要求。",
	["list prompt youngling"] = "將你希望升級的幼寵拖動到這裡。",
	["list prompt fighter"] = "將你希望使用的戰寵拖動到這裡。戰寵類型必須符合下列範圍：\n",
	["log"] = "日誌",
	["tooltip log"] = "查看最近的動作日誌。",
	["toggle frame"] = "顯示/隱藏妮希之力窗口。",
	["add to team"] = "Alt-點擊：將這隻寵物放入戰隊。",
	["error quest completed"] = "任務已完成，運行終止。",

	["tooltip list up"] = "點擊：將選中的寵物上移。",
	["tooltip list up shift"] = "Shift-點擊：將選中的寵物移到頂部。",
	["tooltip list down"] = "點擊：將選中的寵物下移。",
	["tooltip list down shift"] = "Shift-點擊：將選中的寵物移到底部。",
	["tooltip list delete"] = "點擊：將選中的寵物從隊列中移除。",

	["tooltip log up"] = "點擊：將日誌內容向上滾動。",
	["tooltip log up shift"] = "Shift-點擊：將日誌內容滾動到頂部。",
	["tooltip log down"] = "點擊：將日誌內容向下滾動。",
	["tooltip log down shift"] = "Shift-點擊：將日誌內容滾動到底部。",
	["tooltip log clear"] = "點擊：清空日誌內容。",

	["log manager activate"] = "Npc接近中，組件已激活。",
	["log manager deactivate"] = "Npc遠離視野，組件已休眠。\n",
	["log all states"] = "清除所有狀態。",
	["log battle started"] = "戰鬥開始。",
	["log battle round"] = "戰鬥回合 %d。",
	["log battle over"] = "戰鬥結束。",
	["log wait StartModuleTeam"] = "等待組隊模塊啟動...",
	["log team module started"] = "組隊模塊已啟動。",
	["log team choosing pets"] = "遴選戰隊寵物。",
	["log team heal"] = "無法組成戰隊，嘗試復活寵物。",
	["log team form"] = "正在組隊。",
	["log team choose abilities"] = "為戰隊寵物設置技能。",
	["log team ready"] = "戰隊組建成功。",

	["log team pet choosing ok"] = "已選擇%s \124T%s:0:0:0:0\124t%s。",
	["log team pet choosing fail"] = "無法選擇%s（%s）。",
	["log team fail error not configured"] = "未設置",
	["log team fail error health low"] = "血量低於%d",
	["log team fail error level maxed"] = "已滿級",
	["log team fail error level not maxed"] = "未滿級",
	["log team fail error type mismatch"] = "類型不符h",
	["log team heal cooldown"] = "\124T%s:0:0:0:0\124t%s冷卻剩餘%d秒。",
	["log team cast heal"] = "施放 \124T%s:0:0:0:0\124t%s。",
	["log team pet list changed"] = "寵物列表更改，重啟組隊模塊...",

	["log wait StartModuleInteract"] = "等待互動模塊啟動...",
	["log interact module started"] = "互動模塊已啟動。",
	["log interact abandoning quest"] = "放棄任務。",
	["log interact targeting npc"] = "選中Npc為目標。",
	["log interact moving"] = "向Npc移動（%d碼）。",
	["log interact distance ok"] = "已到達互動距離（%d码）。",
	["log interact interacting"] = "與Npc互動。",
	["log interact accept quest"] = "接受任務。",
	["log interact starting battle"] = "嘗試啟動戰鬥。",
	["log interact distance error"] = "與Npc距離過遠，有錯誤發生，模塊停止。",

	["log battle using ability"] = "使用技能 \124T%s:0:0:0:0\124t%s。",
	["log battle change pet"] = "切換寵物 \124T%s:0:0:0:0\124t%s。",
	["log battle skip turn"] = "等待一回合。",
	["log battle forfeit"] = "戰鬥失敗，認輸。",
	["log battle health low"] = "血線過低，治療。",
	["log battle explode"] = "準備自爆！(預估傷害 %d)",
	["log battle won"] = "戰鬥勝利。",
	["log battle enormous damage coming"] = "巨大傷害即將到來！",
	["log battle enemy invincible"] = "對方無敵一回合。",
	["log battle quest abandon failed"] = "任務放棄未成功，退出戰鬥。",
}