# indicator.nvim
indicator.nvim is a light-weight plugin for inidicating the window numbers on the screen,
so that one can use it to navigate throught windows in a tab easily.
there is so a window highlight feature when jumping through windows 

## Required

-   `neovim >= 0.10`
-   `plenary.nvim`

## ⇁ Installation
* neovim 0.10 + required
* install using your favorite plugin manager (lazy.nvim in this example)
* keymap examples are also added in config, feel free to change the keymaps according to your own comfort
```lua
{
	"Antony-AXS/indicator.nvim",
	event = "VeryLazy",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local Indicator = require("indicator")

		Indicator.setup({
			indicator_event = true,
			window_highlight_event = true,
		})

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
		vim.keymap.set("n", "<leader>ir", Indicator.indicator_event_diactivate, {})

		vim.keymap.set("n", "<leader>iq", Indicator.window_highlight_event_activate, {})
		vim.keymap.set("n", "<leader>iw", Indicator.window_highlight_event_diactivate, {})
	end,
}
```

