-- translate sth to chinese
hs.hotkey.bind(option, "T", function()
    hs.application.open("Hammerspoon")
    translate();
end)

  -- decode url
  -- return url that decoded
function decodeURI(s)
    s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
    return s
end
  
  -- econde url
  -- return url that encoded 
function encodeURI(s)
    s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
    return string.gsub(s, " ", "+")
end
  
  -- translate
  -- param: to the language code that you want translate to
  -- return void, will show the result in the dialog
function translate()
    local s = hs.pasteboard.getContents()
    if s == nil then
        return
    end
    local url = "http://fanyi.youdao.com/translate?&doctype=json&type=EN2ZH_CN&i="..encodeURI(s)

    hs.http.asyncGet(url, nil, function(status, body, headers)
      local result = hs.json.decode(body)
      print(body) -- 打印结果  出错时便于排查
      if result.errorCode == 0 then
        local translateResult = result.translateResult
        print(translateResult)
        local message = "~翻译成功~"
        local information = s.."->"
        for i=1, #translateResult do
            local temp = translateResult[i]
            for j=1, #temp do
                information = information..temp[i].tgt..","
            end
        end
        
        print(information)

        hs.dialog.alert(message, information, "OK", "", "informational")
      else
        hs.dialog.alert("!翻译失败!", "~~~失败啦~~~", "OK", "", "informational")
      end
    end)
end

mouseCircle = nil
mouseCircleTimer = nil

function mouseHighlight()
    -- Delete an existing highlight if it exists
    if mouseCircle then
        mouseCircle:delete()
        if mouseCircleTimer then
            mouseCircleTimer:stop()
        end
    end
    -- Get the current co-ordinates of the mouse pointer
    mousepoint = hs.mouse.getAbsolutePosition()
    -- Prepare a big red circle around the mouse pointer
    hs.window:focusedWindow():center
    mouseCircle = hs.drawing.circle(hs.geometry.rect(mousepoint.x-40, mousepoint.y-40, 80, 80))
    mouseCircle:setStrokeColor({["red"]=1,["blue"]=0,["green"]=0,["alpha"]=1})
    mouseCircle:setFill(false)
    mouseCircle:setStrokeWidth(5)
    mouseCircle:show()

    -- Set a timer to delete the circle after 3 seconds
    mouseCircleTimer = hs.timer.doAfter(3, function() mouseCircle:delete() end)
end
hs.hotkey.bind({"cmd","alt","shift"}, "D", mouseHighlight)