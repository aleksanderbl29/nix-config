local M = {}

function M.updateDockVisibility()
  local externalDisplayCount = 0

  -- Helper function to check if a screen is built-in
  -- Checks for built-in display patterns in English and Danish
  -- Uses case-insensitive matching for robustness
  local function isBuiltInDisplay(screenName)
    local screenNameLower = screenName:lower()
    local builtInPatterns = {
      "built%-in",      -- English
      "indbygget",      -- Danish
    }
    
    for _, pattern in ipairs(builtInPatterns) do
      if screenNameLower:match(pattern) then
        return true
      end
    end
    return false
  end

  for _, screen in ipairs(hs.screen.allScreens()) do
    local screenName = screen:name()
    -- Skip built-in displays by checking for localized patterns
    -- This works even when an external monitor is set as primary
    if not isBuiltInDisplay(screenName) then
      externalDisplayCount = externalDisplayCount + 1
    end
  end

  local shouldHide = externalDisplayCount == 0
  hs.execute("defaults write com.apple.dock autohide -bool " ..
             tostring(shouldHide):lower())
  hs.execute("killall Dock")
end

return M
