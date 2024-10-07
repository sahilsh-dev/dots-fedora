--[[

     Licensed under GNU General Public License v2
      * (c) 2016, Luca CPZ

--]]

local helpers = require("lain.helpers")
local shell   = require("awful.util").shell
local wibox   = require("wibox")
local naughty  = require("naughty")

local function factory(args)
    args           = args or {}

    local brt    = { widget = args.widget or wibox.widget.textbox(), device = "N/A" }
    local timeout  = args.timeout or 5
    local settings = args.settings or function() end

    brt.devicetype = args.devicetype or "sink"
    brt.cmd = args.cmd or "brightnessctl"

    function brt.update(params)
        helpers.async({ shell, "-c", brt.cmd },
        function(s)
            brightness_now = s:match("%((%d+)%%%)")

            if params.do_notify then
               naughty.notify({
                  text = "Brightness: " .. brightness_now,
                  timeout = 2
              })
            end

            widget = brt.widget
            settings()
        end)
    end

    helpers.newtimer("brt", timeout, brt.update)

    return brt
end

return factory
