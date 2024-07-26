-- https://github.com/folke/noice.nvim/blob/main/lua/noice/util/spinners.lua
local _spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

local ProgressCounter = {}
ProgressCounter.__index = ProgressCounter

---@param total number | nil
---@param desc string | nil
function ProgressCounter:init(total, desc)
    local bar = {}
    setmetatable(bar, ProgressCounter)
    bar._total = total
    bar._desc = desc

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
    message = message .. (" %d"):format(self._progress)
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

local M = {}

M.ProgressCounter = ProgressCounter

return M
