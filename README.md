# Indicator.nvim

### What is Indicator.nvim ?
Indicator.nvim is a lightweight plugin that displays window numbers on the screen, 
making it easy to navigate through windows in a tab. 
It also highlights the window you jump into, enhancing your navigation experience.

### Preview

![indicator](https://github.com/user-attachments/assets/cff899b1-3650-452f-85f6-c1d14d569e6c)

### Required

-   `neovim >= 0.10`
-   `plenary.nvim`

### Optional

-   [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - (for window and tab stats indication on status bar)


## ⇁ Installation

* Neovim 0.10 + required
* Ensure that a [Nerd Font](https://www.nerdfonts.com/font-downloads) is installed and configured in your terminal emulator.
* Install using your preferred plugin manager (e.g., `lazy.nvim` and `packer.nvim`).
* Keymap examples are also provided. Feel free to modify them to suit your preferences.

#### [lazy.nvim](https://github.com/folke/lazy.nvim)

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

#### [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "Antony-AXS/indicator.nvim",
  event = "VimEnter",
  requires = { "nvim-lua/plenary.nvim" },
  config = function()
    local Indicator = require("indicator")
    
    Indicator.setup({
      indicator_event = true, -- turns ON the Indicator feature by default
      window_highlight_event = false,
    })
  end
}
```

### Indicator API

| Functions                           | Description                                                                                   |
|-------------------------------------|-----------------------------------------------------------------------------------------------|
| `indicateAll`                       | To Indicate All the Opened Windows in a tab once with their perspective number.               |
| `indicateCurrent`                   | To Indicate the Current Window number in which the cursor is at that moment Located.          |
| `triggerWindowManager`              | Mimics inbuilt neovim window management system, only 'jump' and 'close' feature is avaliable. |
| `indicator_event_activate`          | Triggers an event listener to inidcate the window number of the window you jump into.         |
| `indicator_event_deactivate`        | Disables the event listener to inidcate the window number of the window you jump into.        |
| `window_highlight_event_activate`   | Triggers an event to Highlight the window you jump into everytime.                            |
| `window_highlight_event_deactivate` | Disables the event to Highlight the window you jump into everytime.                           |

### Keymaps for Indicator API

```lua
  vim.keymap.set("n", "<leader>bx", function()
  	Indicator.indicateCurrent() -- takes in an integer arugment to extend the indicator display time
  end, { silent = true })

  vim.keymap.set("n", "<leader>bv", function()
  	Indicator.indicateAll()
  end, { silent = true })
  
  vim.keymap.set("n", "<leader>im", Indicator.triggerWindowManager, {})
  vim.keymap.set("n", "<leader>it", Indicator.indicator_event_activate, {})
  vim.keymap.set("n", "<leader>ir", Indicator.indicator_event_deactivate, {})
```

## Window Management with Visual Indication
Neovim's in-built window management system is replicated here with added visual indicators, focusing on only the window *'jumping'*, *'shifting'*, *'rotating'* and *'closing'* features.<br>
Set a keymap to trigger the function *triggerWindowManager*, and then use key commands to perform the following actions:

<table>
	<tr>
		<th colspan="1">Action</th>
		<th>Keys</th>
		<th>Description</th>
	</tr>
	<tr>
		<td rowspan="4"><b>Shift</b></td>
		<td><i>number</i> + <b>H</b></td>
		<td>to shift the window to the left.</td>
	</tr>
	<tr>
		<td><i>number</i> + <b>J</b></td>
		<td>to shift the window to the bottom.</td>
	</tr>
	<tr>
		<td><i>number</i> + <b>K</b></td>
		<td>to shift the window to the top.</td>
	</tr>
	<tr>
		<td><i>number</i> + <b>L</b></td>
		<td>to shift the window to the right.</td>
	</tr>
	<tr>
		<td rowspan="3"><b>Close</b></td>
		<td><i>number</i> + <b>c</b></td>
		<td>to close the desired window only.</td>
	</tr>
	<tr>
		<td><i>number</i> + <b>o</b></td>
		<td>to keep the desired window and close the rest.</td>
	</tr>
	<tr>
		<td><i>number</i> + <b>q</b></td>
		<td>to quit the desired window only.</td>
	</tr>
	<tr>
		<td rowspan="2"><b>Rotate</b></td>
		<td><i>number</i> + <b>r</b></td>
		<td>To continuously rotate all windows in the current tab <i>'clockwise'</i><br>until the rotation instance expires.<br><i>(expiration only happens only after the indicators disappear)</i></td>
	</tr>
		<tr>
		<td><i>number</i> + <b>R</b></td>
		<td>To continuously rotate all windows in the current tab <i>'anticlockwise'</i><br>until the rotation instance expires.</td>
	</tr>
	<tr>
		<td rowspan="1"><b>Jump</b></td>
		<td><i>number</i> + <b>w</b></td>
		<td>to jump to the desired window.</td>
	</tr>
</table>

*Here, "number" in the table refers to the window number displayed on the screen.*

**Note:** If a window number is not provided before pressing the valid keys, the following actions will be executed in the current window where the cursor is located.

### Preview
![window_management](https://github.com/user-attachments/assets/74346f23-b05f-4bc0-9312-88f58e1f08f8)

## About Window Highlight Feature
* Setting 'window_highlight_event = true' in setup function sets the hightlight feature ON by default.
* You can use 'Indicator.window_highlight_event_deactivate' to turn it OFF.
* You can use 'Indicator.window_highlight_event_activate' to turn it ON.

### Preview
![window_highlight](https://github.com/user-attachments/assets/f6a1a127-69a9-486e-8e2e-4e8f412c8c7a)

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
If you have [lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) installed, window and tab count stats can be displayed on the status bar.

#### Tab count has two variables:
  * **1**st one indicates the current tab you are in.
  * **2**nd indicates the total number of tabs open in the neovim instance.

#### Window count has three variables:
  * **1**st is the window number you cursor is in.
  * **2**nd is the total number of windows that are open in the current tab.
  * **3**rd is the total window count across all the open tabs in the neovim instance.

### Preview
![status_bar_1](https://github.com/user-attachments/assets/7caf6268-9e3b-48cf-bf27-28f3d485e88f)
![status_bar_2](https://github.com/user-attachments/assets/af12c04f-e6f4-4313-bd7e-f5be55d05d18) <br><br>
If only one tab is open, the tab stats won't appear, and the 3rd parameter for window stats will also be hidden.<br>
They will only be displayed if more than one tab is open.<br>

### Setup
```lua
 Indicator.setup({
  window_count_status = {
   tab = {
     activate = true, -- Displays the tab stats on the status bar.
     position = { section = "x", index = 1 }, -- To configure the position of the tab stats.
     color = "" -- Sets the color of tab stats. If not set, the default color will be yellow.
   },
   window = {
     activate = true, -- Displays the window stats on the status bar.
     position = { section = "x", index = 1 }, -- To configure the position of the window stats.
     color = "" -- Sets the color of window stats. If not set, the default color will be yellow.
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
