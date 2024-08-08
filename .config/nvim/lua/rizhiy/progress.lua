-- https://github.com/folke/noice.nvim/blob/main/lua/noice/util/spinners.lua
local _spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

local ProgressCounter = {}
ProgressCounter.__index = ProgressCounter

---@param total number | nil
---@param desc string | nil
---@param no_counter boolean | nil if true don't print count
function ProgressCounter:init(total, desc, no_counter)
    local bar = {}
    setmetatable(bar, ProgressCounter)
    bar._total = total
    bar._desc = desc
    bar._no_counter = no_counter

    bar._progress = 0
    bar._done = false
    bar._spinner_idx = 1
    bar._notif = nil
    bar:_update()
    return bar
end

function ProgressCounter:_update()
    local message = self._done and "Done" or _spinner[self._spinner_idx]
    if self._desc then message = message .. " " .. self._desc end
    if not self._no_counter then message = message .. (" %d"):format(self._progress) end
    if self._total then message = message .. ("/%d"):format(self._total) end

    self._notif = vim.notify(message, vim.log.levels.INFO, {
        replace = self._notif,
    })

    if self._done then return end

    self._spinner_idx = self._spinner_idx + 1
    if _spinner[self._spinner_idx] == nil then self._spinner_idx = 1 end
    vim.defer_fn(function() self:_update() end, 100)
end

---@param step number
function ProgressCounter:update(step)
    step = step or 1
    self._progress = self._progress + step
    if self._progress == self._total then self._done = true end
end

function ProgressCounter:close() self._done = true end

---@param command string[]
---@param desc string spinner text
function run_system_with_sinner(command, desc)
    local all_buffers = vim.api.nvim_list_bufs()
    local change_modifiable = require("rizhiy.utils").change_modifiable

    change_modifiable(all_buffers, false)
    local counter = ProgressCounter:init(nil, desc, true)
    vim.system(command, { text = true }, function(obj)
        if obj.code == 0 then
            vim.notify(obj.stdout)
        else
            vim.notify(obj.stderr, vim.log.levels.ERROR)
        end
        change_modifiable(all_buffers, true)
        counter:close()
    end)
end

return {
    ProgressCounter = ProgressCounter,
    run_system_with_sinner = run_system_with_sinner,
}
