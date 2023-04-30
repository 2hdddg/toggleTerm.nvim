local M = {}
-- Shared between windows and buffers, only one terminal instance
local terminalBufs = {}

local function is_terminal_buf(buf)
    for i, b in ipairs(terminalBufs) do
        if b == buf then
            return true
        end
    end
    return false
end

M.to_terminal = function(index)
    local terminalBuf = terminalBufs[index]
    local init = false
    if terminalBuf == nil or (not vim.api.nvim_buf_is_valid(terminalBuf)) then
        -- Need to initialize the terminal in a real windows
        -- This case implies switching to terminal.
        terminalBuf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_option(terminalBuf, "buftype", "nofile")
        vim.api.nvim_buf_set_option(terminalBuf, "filetype", "myterm")
        init = true
        terminalBufs[index] = terminalBuf
    end
    local buf = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()
    if not is_terminal_buf(buf) then
        vim.api.nvim_win_set_var(win, "TT:buf", buf)
    end
    vim.api.nvim_win_set_buf(win, terminalBuf)
    if init then
        vim.fn.termopen("/bin/bash")
    end
    vim.cmd("startinsert")
end

M.from_terminal = function()
    local buf = vim.api.nvim_get_current_buf()
    if not is_terminal_buf(buf) then
        return
    end
    -- Switch back to the buffer that was previously active
    -- in the current window.
    local win = vim.api.nvim_get_current_win()
    local previousBuf = vim.w["TT:buf"]
    if previousBuf == nil then
        return
    end
    if not vim.api.nvim_buf_is_valid(previousBuf) then
        return
    end
    vim.api.nvim_win_set_buf(win, previousBuf)
end

M.setup = function()
end

return M

