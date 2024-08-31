# indicator.nvim

### What is Indicator.nvim ?
Indicator.nvim is a lightweight plugin that displays window numbers on the screen, 
making it easy to navigate through windows in a tab. 
It also highlights the window you jump into, enhancing your navigation experience.

### Preview

![r_inidcaotr](https://github.com/user-attachments/assets/cff899b1-3650-452f-85f6-c1d14d569e6c)

### Required

-   `neovim >= 0.10`
-   `plenary.nvim`

### Optional

-   [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - (for window and tab count indication on statusbar)


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


### Keymaps for Indicator Functions

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
## Status Line Indication
If you have [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) window and tab count stats can be inidcated on the statusbar.

window count has three parameters:
  * 1st is the window number you cursor is in.
  * 2nd is the total number of windows that are open in the current tab.
  * 3rd is the total window count in all the opened tabs in your neovim instance.

tab count has two parameters:
  * 1st one indicates the current tab you are in.
  * 2nd is indicates the total number of tabs open in neovim instance.

### Preview
![status_bar_3](https://github.com/user-attachments/assets/7caf6268-9e3b-48cf-bf27-28f3d485e88f)
![status_bar_2](https://github.com/user-attachments/assets/af12c04f-e6f4-4313-bd7e-f5be55d05d18)

### Setup
```lua
 Indicator.setup({
   window_count_status = {
 	 tab = {
 	   activate = true,
 	   position = { section = "x", index = 1 },
 	 },
 	 window = {
 	   activate = true,
 	   position = { section = "x", index = 1 },
 	 },
   },
 })
```

## Help Doc
The indicator.nvim help doc explains the features and functionality of the plugin in detail.<br>
Use the commands below to jump to each specific sections of the document.
| Doc Commands                   | Description                                            |
|--------------------------------|--------------------------------------------------------|
|`:help indicator.nvim`          | to jump to the start of the document                   | 
|`:help indicator_commands`      | to jump to the commands section of the document        |
|`:help indicator_functions`     | to jump to the functions section of the document       |
|`:help indicator_configuration` | to jump to the configuration section of the document   |

## Welcome Your Ideas
If you have any ideas or suggestions to improve this plugin, I’d love to hear from you! Your feedback is always welcome.
