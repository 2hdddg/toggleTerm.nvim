Simple plugin to toggle any window into the same instance of a single terminal.

Example setup to toggle a window into terminal:
```
nnoremap <silent> <C-z> <cmd>lua require("toggleTerm").toggle()<cr>
```
And back again from the terminal back to the buffer that the window previously showed:
```
tnoremap <silent> <C-z> <cmd>lua require("toggleTerm").toggle()<cr>
```
