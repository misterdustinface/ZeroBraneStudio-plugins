
return {
  name = "Timestamp",
  description = "Displays Timestamp on Save",
  author = "Dustin Shaffer",

  onEditorSave = function(self, editor)  
    DisplayOutputLn("[SAVED]", os.date("%c")) 
  end,
}
