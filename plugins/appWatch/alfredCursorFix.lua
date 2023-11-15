-- Alfred redesigned_text_cursor fix
--
-- Save this in a file named something like `alfredCursorFix.lua` in the Hammerspoon config folder (`~/.hammerspoon`),
-- then import it from your Hammerspoon `init.lua` file:
--
-- ```lua
-- alfredCursorFix = requier 'alfredCursorFix'
-- ```

local obj = {}

obj.canvas = hs.canvas.new({ x = 10, y = 10, w = 10, h = 10 })
obj.canvas:appendElements({
    {
        type = "rectangle",
        action = "fill",
        frame = { x = 0, y = 0, w = 10000, h = 10000 },

        -- text cursor color definition
        fillColor = { red = 1, green = 1, blue = 1, alpha = 1 },
    }
})
obj.caret_blink_timer = hs.timer.doEvery(1 / 2, function()
    local rect = obj.canvas[1]
    if rect.fillColor.alpha == 0 then
        rect.fillColor.alpha = 1
    else
        rect.fillColor.alpha = 0
    end
end)

obj.timer = hs.timer.new(1 / 120, function()
    local el = hs.axuielement.systemWideElement().AXFocusedUIElement
    if el == nil then
        obj.canvas:hide()
        return
    end

    local range = el.AXSelectedTextRange
    if range == nil or range.length > 0 then
        obj.canvas:hide()
        return
    end

    local loc = el:parameterizedAttributeValue('AXBoundsForRange',
        { length = 1, location = math.max(0, range.location - 1) })
    if loc == nil then
        obj.canvas:hide()
        return
    end

    local x = loc.x
    if range.location > 0 then
        x = x + loc.w
    end
    local old_frame = obj.canvas:frame()
    local new_frame = { x = x, y = loc.y, h = loc.h, w = 2 }
    for k, _ in pairs(new_frame) do
        if math.floor(old_frame[k]) ~= math.floor(new_frame[k]) then
            obj.canvas:frame(new_frame)
            obj.canvas:show()

            -- text cursors don't seem to blink while typing
            obj.canvas[1].fillColor.alpha = 1
            break
        end
    end
end)

function obj:hide()
    obj.timer:stop()
    obj.canvas:hide()
end

function obj:show()
    obj.timer:start()
end

-- window filter didn't seem to pick up the alfred search window so polling here instead
obj.window_timer = hs.timer.doEvery(1 / 10, function()
    local el = hs.axuielement.systemWideElement().AXFocusedUIElement
    if el == nil then
        obj:hide()
        return
    end

    local app = hs.application.applicationForPID(el:pid())
    if app == nil then
        obj:hide()
        return
    end

    local app_name = app:name()
    if app_name == "Alfred" or app_name == "Alfred Preferences" then
        obj:show()
    else
        obj:hide()
    end
end)
