local GUI = require("GUI")
local system = require("System")
local filesystem = require("Filesystem")
local component = require("component")
local localization = system.getCurrentScriptLocalization()
title = "Lol"
documentString = "Lol"
flag = false
if not component.isAvailable("openprinter") then
  GUI.alert(localization.notAvailablePrinter)
  return
end

openprinter = component.openprinter

-- Add a new window to MineOS workspace
local workspace, window, menu = system.addWindow(GUI.filledWindow(1, 1, 60, 20, 0xE1E1E1))

-- Get localization table dependent of current system language
local localization = system.getCurrentScriptLocalization()

-- Add single cell layout to window
local layout = window:addChild(GUI.layout(1, 1, window.width, window.height, 1, 1))

-- Add nice gray text object to layout
--layout:addChild(GUI.text(1, 1, 0x4B4B4B, localization.greeting .. system.getUser()))

local titleD = window:addChild(GUI.input(2, 4, 25, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "", localization.documentTitle))
titleD.onInputFinished = function()
  --GUI.alert("Input finished!")
  title = titleD.text
end

local stringD = window:addChild(GUI.input(2, 8, 25, 3, 0xEEEEEE, 0x555555, 0x999999, 0xFFFFFF, 0x2D2D2D, "", localization.documentString))
stringD.onInputFinished = function()
  --GUI.alert("Input finished!")
  documentString = stringD.text
end

local printB = window:addChild(GUI.button(2, 12, 25, 3, 0xFFFFFF, 0x555555, 0x3C3C3C, 0xFFFFFF, localization.printButton))
printB.onTouch = function()
  --openprinter.printTag("String")
  openprinter.setTitle(title)
  if flag == false then
    openprinter.writeln(documentString)
  end
  openprinter.print()
  flag = false
end

window:addChild(GUI.text(29, 4, 0x000000, localization.inkBlack))
window:addChild(GUI.text(29, 5, 0x000000, localization.inkColor))
window:addChild(GUI.text(46, 4, 0x000000, openprinter.getBlackInkLevel()))
window:addChild(GUI.text(46, 5, 0x000000, openprinter.getColorInkLevel()))

local filesystemChooser = window:addChild(GUI.filesystemChooser(27, 8, 33, 3, 0xE1E1E1, 0x888888, 0x3C3C3C, 0x888888, nil, localization.open, localization.cancel, localization.choose, "/"))
filesystemChooser:setMode(GUI.IO_MODE_OPEN, GUI.IO_MODE_FILE)
filesystemChooser.onSubmit = function(path)
  --GUI.alert("File \"" .. path .. "\" was selected")
  --GUI.alert(system.call(sugoma, path))
    --local handle = filesystem.open(pathArg, "r")
  local s1 = filesystem.readLines(path)
   for i = 1, #s1, 1 do
      pidor = s1[i]
      openprinter.writeln(pidor)
   end
  --handle:close()
  --openprinter.writeln(s1)
  
  flag = true
end


window.onResize = function(newWidth, newHeight)
  window.backgroundPanel.width, window.backgroundPanel.height = newWidth, newHeight
  layout.width, layout.height = newWidth, newHeight
end

workspace:draw()
