# indicator.nvim

### What is Indicator.nvim ?
indicator.nvim is a lightweight plugin for indicating window numbers on the screen, 
allowing easy navigation through windows in a tab. 
It also includes a window highlight feature that activates while jumping between windows in a tab.

### Required

-   `neovim >= 0.10`
-   `plenary.nvim`

## ⇁ Installation
* neovim 0.10 + required
* make sure a nerdfont is added in your terminal emulator, if not download from : https://www.nerdfonts.com/
* install using your favorite plugin manager (lazy.nvim in this example)
* keymap examples are also provided, Feel free to change the keymaps to suit your own comfort.

```lua
{
   "Antony-AXS/indicator.nvim",
   event = "VeryLazy",
   dependencies = { "nvim-lua/plenary.nvim" },
   config = function()
     local Indicator = require("indicator")
     
     Indicator.setup({
       inindicator_event = true,
       wiwindow_highlight_event = true,
     })
   end
}
```
### Indicator Functions

| Functions                                     | Description                                                                           |
|-----------------------------------------------|---------------------------------------------------------------------------------------|
| `Indicator.indicator_event_activate`          | Triggers an event listener to inidcate the window number of the window you jump into  |
| `Indicator.indicator_event_deactivate`        | Disables the event listener to inidcate the window number of the window you jump into |
| `Indicator.window_highlight_event_activate`   | Triggers an event to Highlight the window you jump into everytime                     |
| `Indicator.window_highlight_event_deactivate` | Disables the event to Highlight the window you jump into everytime                    |
| `Indicator.indicateCurrent`                   | To Indicate the Current Window number in which the cursor is at that moment Located   |
| `Indicator.indicateAll`                       | To Indicate All the Opened Windows in a tab once with their perspective number        |

### KeyMaps for Indicator Functions

```lua
  vim.keymap.set("n", "<leader>bx", function()
  	Indicator.indicateCurrent(nil, nil, true)
  end, { silent = true })

  vim.keymap.set("n", "<leader>bv", function()
  	Indicator.indicateAll(true)
  end, { silent = true })

  vim.keymap.set("n", "<leader>bc", function()
  	Indicator.indicateAll(false)
  end, { silent = true })
  
  vim.keymap.set("n", "<leader>it", Indicator.indicator_event_activate, {})
  vim.keymap.set("n", "<leader>ir", Indicator.indicator_event_deactivate, {})
  
  vim.keymap.set("n", "<leader>iq", Indicator.window_highlight_event_activate, {})
  vim.keymap.set("n", "<leader>iw", Indicator.window_highlight_event_deactivate, {})
```
