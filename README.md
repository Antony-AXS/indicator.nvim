# indicator.nvim

### What is Indicator.nvim ?
indicator.nvim is a lightweight plugin for indicating window numbers on the screen, 
allowing easy navigation through windows in a tab. 
It also includes a window highlight feature that activates while jumping between windows in a tab.

### Preview

[Screencast from 21-08-24 08:50:17 PM IST.webm](https://github.com/user-attachments/assets/072ebf80-9028-4d80-93c7-03c0a566ac38)

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
       indicator_event = true, -- turns ON the Indicator feature by default
       window_highlight_event = false,
     })
   end
}
```
### Indicator Functions

| Functions                                     | Description                                                                           |
|-----------------------------------------------|---------------------------------------------------------------------------------------|
| `Indicator.indicateAll`                       | To Indicate All the Opened Windows in a tab once with their perspective number        |
| `Indicator.indicateCurrent`                   | To Indicate the Current Window number in which the cursor is at that moment Located   |
| `Indicator.indicator_event_activate`          | Triggers an event listener to inidcate the window number of the window you jump into  |
| `Indicator.indicator_event_deactivate`        | Disables the event listener to inidcate the window number of the window you jump into |
| `Indicator.window_highlight_event_activate`   | Triggers an event to Highlight the window you jump into everytime                     |
| `Indicator.window_highlight_event_deactivate` | Disables the event to Highlight the window you jump into everytime                    |


### KeyMaps for Indicator Functions

```lua
  vim.keymap.set("n", "<leader>bx", function()
  	Indicator.indicateCurrent() -- takes in an integer arugment to extend the indicator display time
  end, { silent = true })

  vim.keymap.set("n", "<leader>bv", function()
  	Indicator.indicateAll()
  end, { silent = true })
  
  vim.keymap.set("n", "<leader>it", Indicator.indicator_event_activate, {})
  vim.keymap.set("n", "<leader>ir", Indicator.indicator_event_deactivate, {})
```


## About Window Highlight Feature
* Setting 'window_highlight_event = true' in setup function sets the hightlight feature ON by default.
* You can use 'Indicator.window_highlight_event_deactivate' to turn it OFF.
* You can use 'Indicator.window_highlight_event_activate' to turn it ON.

### Preview
![wind](https://github.com/user-attachments/assets/f6a1a127-69a9-486e-8e2e-4e8f412c8c7a)


### Setup
```lua
 config = function()
   local Indicator = require("indicator")
   Indicator.setup({
    window_highlight_event = true, -- turns ON the window highlight feature by default
   })
 end
```

### Keymaps
```lua
 vim.keymap.set("n", "<leader>iq", Indicator.window_highlight_event_activate, {})
 vim.keymap.set("n", "<leader>iw", Indicator.window_highlight_event_deactivate, {})
```

## Welcome Your Ideas
If you have any ideas or suggestions to improve this plugin, I’d love to hear from you! Your feedback is always welcome.
