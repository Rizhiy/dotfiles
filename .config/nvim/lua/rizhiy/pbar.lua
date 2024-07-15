-- https://github.com/folke/noice.nvim/blob/main/lua/noice/util/spinners.lua
local _spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }

local ProgressBar = {}
ProgressBar.__index = ProgressBar

---@param len number
---@param desc string
function ProgressBar:init(len, desc)
    local bar = {}
    setmetatable(bar, ProgressBar)
    bar._len = len
    bar._desc = desc

    bar._progress = 0
    bar._done = false
    bar._spinner_idx = 1
    bar._notif = nil
    bar:_update()
    return bar
end

function ProgressBar:_update()
    local message = self._done and "Done" or _spinner[self._spinner_idx]
    if self._desc then message = message .. " " .. self._desc end
    message = message .. (" %d"):format(self._progress)
    if self._len then message = message .. ("/%d"):format(self._len) end

    self._notif = vim.notify(message, vim.log.levels.INFO, {
        replace = self._notif,
    })

    if self._done then return end

    self._spinner_idx = self._spinner_idx + 1
    if _spinner[self._spinner_idx] == nil then self._spinner_idx = 1 end
    vim.defer_fn(function() self:_update() end, 100)
end

---@param step number
function ProgressBar:update(step)
    step = step or 1
    self._progress = self._progress + step
    if self._progress == self._len then self._done = true end
end

function ProgressBar:close() self._done = true end

local M = {}

M.ProgressBar = ProgressBar

return M
