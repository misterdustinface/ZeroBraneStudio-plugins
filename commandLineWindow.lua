local runCommand
local addCommandLinePageToBottomNotebook

local PROMPT_MARKER = StylesGetMarker("prompt")
local PROMPT_MARKER_VALUE = 2^PROMPT_MARKER

local function getPromptLine()
  local commandLineBox = ide.frame.bottomnotebook.commandLineBox
  local totalLines = commandLineBox:GetLineCount()
  return commandLineBox:MarkerPrevious(totalLines+1, PROMPT_MARKER_VALUE)
end

local function getPromptText()
  local commandLineBox = ide.frame.bottomnotebook.commandLineBox
  local prompt = getPromptLine()
  return commandLineBox:GetTextRange(commandLineBox:PositionFromLine(prompt), commandLineBox:GetLength())
end

function addCommandLinePageToBottomNotebook()
  local bottomnotebook = ide.frame.bottomnotebook
  
  local commandLineBox = ide:CreateStyledTextCtrl(bottomnotebook, wx.wxID_ANY,
    wx.wxDefaultPosition, wx.wxDefaultSize, wx.wxBORDER_NONE)

  bottomnotebook:AddPage(commandLineBox, TR("Command Line"), false)

  commandLineBox:Connect(wx.wxEVT_KEY_DOWN,
    function (event)
      local key = event:GetKeyCode()
      if key == wx.WXK_RETURN or key == wx.WXK_NUMPAD_ENTER then
        local promptText = getPromptText()
        if #promptText == 0 then return end
        runCommand(promptText)
      end
      event:Skip()
    end)

  bottomnotebook.commandLineBox = commandLineBox
end

function runCommand(xCommand)
    xCommand = xCommand
    DisplayOutputLn(xCommand)
    CommandLineRun(xCommand, ide:GetProject(), true)
end

return {
  name = "Command Line",
  description = "Performs command line operations on the designated project directory.",
  author = "Dustin Shaffer",

  onRegister = function(self)
    addCommandLinePageToBottomNotebook()
  end,
}