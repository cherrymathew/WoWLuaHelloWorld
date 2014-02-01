--
-- A simple Slash command
-- This can be used to access the Addon functions in-game
-- by the use of a /<command> <parameters> format
--
SLASH_HELLO_WORLD_SHOW1 = "/hwshow"
SLASH_HELLO_WORLD_SHOW2 = "/helloworldshow" -- an alias to /hwshow

SlashCmdList["HELLO_WORLD_SHOW"] = function ()
	HelloWorld()
end

--
-- A simple function
--
function HelloWorld() 
  -- print("Hello, Universe!"); -- Simple Console Message
  message("Hello, Universe!"); -- Simple PopUp Box
end