--
-- A simple Slash command
-- This can be used to access the Addon functions in-game
-- by the use of a /<command> <parameters> format
--
SLASH_HELLO_WORLD_SHOW1 = "/hwshow"
SLASH_HELLO_WORLD_SHOW2 = "/helloworldshow" -- an alias to /hwshow

SlashCmdList["HELLO_WORLD_SHOW"] = function (msg)
	HelloWorld(msg)
end

--
-- References used for the current framework
-- Button Generator - http://wowprogramming.com/snippets/LOL_CLASS_31
-- Quantity Box - http://eu.battle.net/wow/en/forum/topic/1622897526
-- Dropdown Box - http://wowprogramming.com/snippets/Create_UI-styled_dropdown_menu_10
--
local scale = 1
local prevpos = false
local itemlist = {};

local quantityTypes = {
	"Individual", -- ID 1
	"Stacks", -- ID 2
}

--
-- Advertise the Item into Trade Chat (Channel 2), when the Icon is clicked
--
local function advertiseItem(itemID, quantity, quantityType)
	local index, name = GetChannelName(2) -- It finds Trade is a channel at index 2
	local quantityString = (quantityType == 2 and " Stack(s)." or ".")

	if (index ~= nil) then 
		local itemName, itemLink = GetItemInfo(itemID)
		SendChatMessage("WTS "..itemLink.." x "..quantity..quantityString, "CHANNEL", nil, index);
	end
end

--
-- Callback for whenever the drop down changes
--
local function dropdownBoxOnClick(self, frame)
  UIDropDownMenu_SetSelectedID(frame, self:GetID())
end

--
-- Initialization of the dropdown and filling up with values
--
local function initializeDropdownBox(self, level)
	local info = UIDropDownMenu_CreateInfo()
	for k,v in pairs(quantityTypes) do
		info = UIDropDownMenu_CreateInfo()
		info.text = v
		info.value = v
		info.func = function(this) dropdownBoxOnClick(this, self) end
		UIDropDownMenu_AddButton(info, level)
	end 
end

--
-- Generates a button containing the icon of the tooltip data captured
-- and also a Quantity Box to enter quantities
--
-- TODO:
-- 1. Better alignment of generated rows of Buttons and Boxes
-- 2. Table to store and retrieve Data after logging off
-- 3. Implement basic trading logic (yet to be split into micro tasks)
--
local function generateButton(itemIcon, itemID) 
	if itemlist[itemID] == true then
		return;
	end
	
	local button = CreateFrame("Button", itemID.."-button", HelloWorldForm, "ActionButtonTemplate")
	local editBox = CreateFrame("EditBox", itemID.."-editBox", HelloWorldForm, "InputBoxTemplate")
	local dropdownBox = CreateFrame("Button", itemID.."-dropdownBox", HelloWorldForm, "UIDropDownMenuTemplate")
	
	-- Initialize each of the UI elements
	button:SetScale(scale)
	
	editBox:SetWidth(35)
	editBox:SetHeight(50)
	editBox:SetAutoFocus(false)
	editBox:SetNumeric(true)
	editBox:SetNumber(1)
	
	dropdownBox:ClearAllPoints()
	dropdownBox:SetPoint("CENTER", 0, 0)
	dropdownBox:Show()

	UIDropDownMenu_Initialize(dropdownBox, initializeDropdownBox)
	UIDropDownMenu_SetWidth(dropdownBox, 100);
	UIDropDownMenu_SetButtonWidth(dropdownBox, 124)
	UIDropDownMenu_SetSelectedID(dropdownBox, 1)
	UIDropDownMenu_JustifyText(dropdownBox, "LEFT")

   if not prevpos then
   	button:SetPoint("TOPLEFT",HelloWorldForm,"TOPLEFT",13,-13)
   	editBox:SetPoint("TOPLEFT",HelloWorldForm,"TOPLEFT",65,-6.5)
   	dropdownBox:SetPoint("TOPLEFT",HelloWorldForm,"TOPLEFT",130,-6.5)
   else 
   	button:SetPoint("TOP",prevpos,"BOTTOM",0,-4)
   	editBox:SetPoint("TOP",prevposBox,"BOTTOM",0,2)
   	dropdownBox:SetPoint("TOP",prevposDropdownBox,"BOTTOM",0,2)
   end

   _G[button:GetName().."Icon"]:SetTexture(itemIcon)
   _G[button:GetName().."Icon"]:SetTexCoord(0, 1, 0, 1)   
	
  
	button:SetScript("OnClick", function() advertiseItem(itemID, editBox:GetNumber(), UIDropDownMenu_GetSelectedID(dropdownBox)) end)

	editBox:SetScript("OnEnterPressed", function (self) 
				editBox:ClearFocus(); -- clears focus from editbox, (unlocks key bindings, so pressing W makes your character go forward.
	end );
	editBox:Show()

	prevpos = itemID.."-button"
	prevposBox = itemID.."-editBox"
	prevposDropdownBox = itemID.."-dropdownBox"
	itemlist[itemID] = true
end

--
-- Stub code for the trade chat parser
--
local function tradeChatParser(self, event, ...)
	local message, author = ...
	local channelName = select(4, ...)
	local channelNo = select(8, ...)
	print(author.." "..message.." "..channelName.." "..channelNo)
end

--
-- Initializes the hooks and callbacks for watching tradechat, the callback
-- is a parser to extract potential trading information
--
local function tradeChatWatcher()
	local frame = CreateFrame("Frame");
	
	frame:RegisterEvent("CHAT_MSG_CHANNEL")
	frame:SetScript("OnEvent", tradeChatParser)
end

--
-- Captures the data from the tooltip
--
local function showTooltip(self, linkData)
	local linkType, itemID = string.split(":", linkData)
	if(linkType == 'item') then
		itemIcon = GetItemIcon(itemID);
		generateButton(itemIcon, itemID);
	end
end

--
-- Not used a stub function
--
local function hideTooltip(...)
--	print(...)
end

--
-- Initializes all the events and handlers for a given frame
--
local function setOrHookHandler(frame, event, handler)
	if frame:GetScript(event) then -- Checks if the event has a handler
		frame:HookScript(event, handler) -- if not we hook out handler
	else
		frame:SetScript(event, handler) -- else set our function has the handler
	end
end

-- 
-- Initializes the hooks and handlers for capturing information
-- from an Item Hyperlink
--
local function hoverToolTip()
	-- Creates copy of "General Chat Frame"
	local frame = getglobal("ChatFrame"..1);
	print(frame)
	if frame then
		setOrHookHandler(frame,"onHyperlinkClick", showTooltip)
		setOrHookHandler(frame,"OnHyperlinkLeave", hideTooltip)
	end
end	

--
-- A simple function
--
function HelloWorld(msg) 
	local str = str or msg;
  -- print("Hello, Universe!"); -- Simple Console Message
  -- message("Hello, Universe!"); -- Simple PopUp Box
  
  -- Controls the display of the frame based on the parameter passed to the
  -- slash command
  if(str == "show") then
  	HelloWorldForm:Show();
  else if(str == "hide") then
  		HelloWorldForm:Hide();
  	end
  end
  
  -- Display a message if the string passed is not empty
  if (str ~= "") then
  	print("You passed " .. msg);
  end
  
  -- Initialize the Tooltip Information Capture
  hoverToolTip()
  
  -- Sets the backdrop to be transparent
  HelloWorldForm:SetBackdrop(StaticPopup1:GetBackdrop())
  
  tradeChatWatcher()
end



