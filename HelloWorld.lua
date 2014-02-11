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
-- A simple function
--
function HelloWorld(msg) 
	local str = str or msg;
  -- print("Hello, Universe!"); -- Simple Console Message
  message("Hello, Universe!"); -- Simple PopUp Box
  
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
end