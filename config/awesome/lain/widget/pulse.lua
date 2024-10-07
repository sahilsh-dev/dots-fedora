--[[

     Licensed under GNU General Public License v2
      * (c) 2016, Luca CPZ

--]]

local helpers = require("lain.helpers")
local shell   = require("awful.util").shell
local wibox   = require("wibox")
local naughty  = require("naughty")

-- Pipewire volume
-- lain.widget.pulse

local function factory(args)
    args           = args or {}

    local pulse    = { widget = args.widget or wibox.widget.textbox(), device = "N/A" }
    local timeout  = args.timeout or 5
    local settings = args.settings or function() end

    pulse.devicetype = args.devicetype or "sink"
    pulse.cmd = args.cmd or "pamixer --get-volume-human"

    function pulse.update(params)
        helpers.async({ shell, "-c", pulse.cmd },
        function(s)
            -- weird bug cant compare full string
            if s:sub(1,1) == "m" then
                volume_now = "M"
            else
                volume_now = s
            end

            if params.do_notify then
               naughty.notify({
                  title = "Volume",
                  text = "Current Volume: " .. s,
                  timeout = 2
              })
            end

            widget = pulse.widget
            settings()
        end)
    end

    helpers.newtimer("pulse", timeout, pulse.update)

    return pulse
end

return factory
