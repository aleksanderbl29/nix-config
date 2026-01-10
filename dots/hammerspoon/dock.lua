local M = {}

function M.updateDockVisibility()
  local externalDisplayCount = 0
  local primaryScreenId = hs.screen.primaryScreen():id()

  for _, screen in ipairs(hs.screen.allScreens()) do
    if screen:id() ~= primaryScreenId then
      externalDisplayCount = externalDisplayCount + 1
    end
  end

  local shouldHide = externalDisplayCount == 0
  hs.execute("defaults write com.apple.dock autohide -bool " ..
             tostring(shouldHide):lower())
  hs.execute("killall Dock")
end

return M
