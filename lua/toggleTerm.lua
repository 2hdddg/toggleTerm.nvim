local M = {}
-- Shared between windows and buffers, only one terminal instance
local terminalBuf = nil

M.toggle = function()
    local init = false
    if terminalBuf == nil or (not vim.api.nvim_buf_is_valid(terminalBuf)) then
        -- Need to initialize the terminal in a real windows
        -- This case implies switching to terminal.
        terminalBuf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_option(terminalBuf, "buftype", "nofile")
        vim.api.nvim_buf_set_option(terminalBuf, "filetype", "myterm")
        init = true
    end
    local buf = vim.api.nvim_get_current_buf()
    local win = vim.api.nvim_get_current_win()
    if buf == terminalBuf then
        -- Switch back to the buffer that was previously active
        -- in the current window.
        vim.api.nvim_win_set_buf(win, vim.api.nvim_win_get_var(win, "TT:buf"))
    else
        -- Switch to terminal, stash away the buffer that was active
        -- in this window.
        vim.api.nvim_win_set_var(win, "TT:buf", buf)
        vim.api.nvim_win_set_buf(win, terminalBuf)
        if init then
            vim.fn.termopen("/bin/bash")
            vim.cmd("startinsert")
        end
    end
end

M.setup = function()
end

return M

