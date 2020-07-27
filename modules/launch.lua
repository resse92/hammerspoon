local hotkey = require "hs.hotkey"

function getWinList( name )
    local app = hs.window.filter.new(false):setAppFilter(name, {currentSpace=true}) 
    return app:getWindows()
end

function launchOrNextWindow( name, showName )
    local findName = showName or name
    local appName = hs.application.frontmostApplication():name()
    -- PrintTable(hs.window:allWindows())
    if findName ~= appName then
        hs.application.launchOrFocus(name)
    else
        local windowList = getWinList(findName)
        local windowCount = #windowList
        if windowCount > 1 then
            hs.eventtap.keyStroke({'cmd'}, '`')
        else
            local window = windowList[1]
            if window:isMinimized() then window:unminimize() else window:minimize() end
        end
    end
end

function mapLaunch( key, name, showName )
    hotkey.bind(option, key, function ( )
        launchOrNextWindow(name, showName)
    end)
end

mapLaunch("1", "Xcode")
mapLaunch("2", "Google Chrome")
mapLaunch("3", "Visual Studio Code")
mapLaunch("4", "iTerm")