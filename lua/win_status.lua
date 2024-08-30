local x, _ = pcall(require, "lualine")

local M = {}

if not x then
	return vim.notify("Lualine is not Installed")
end

local sections = require("lualine").get_config().sections

local lualineTbl = {
	x = "lualine_x",
	y = "lualine_y",
	z = "lualine_z",
}

local tab_count = function(activate, position, tbl)
	local component
	if activate and x == true then
		component = {
			function()
				local Icon = "󱓷 "
				if #vim.api.nvim_list_tabpages() > 1 then
					return (Icon .. vim.fn.tabpagenr() .. "|" .. (#vim.api.nvim_list_tabpages()))
				else
					return ""
				end
			end,
			color = function()
				if #vim.api.nvim_list_tabpages() > 1 then
					return { fg = "#FFA500", gui = "bold" }
				else
					return { fg = "grey", gui = "bold" }
				end
			end,

			padding = { left = 1, right = 1 },
		}
		table.insert(tbl, position or 1, component)
	end
end

local window_count = function(activate, position, tbl)
	local component
	if activate and x == true then
		component = {
			function()
				local Icon = " "
				if #vim.api.nvim_list_tabpages() == 1 then
					return (Icon .. vim.fn.winnr() .. "|" .. #vim.api.nvim_tabpage_list_wins(0))
				else
					return (
						Icon
						.. vim.fn.winnr()
						.. "|"
						.. (#vim.api.nvim_tabpage_list_wins(0))
						.. "|"
						.. (#vim.api.nvim_list_wins())
					)
				end
			end,
			color = {
				fg = "#a9ff0a",
				gui = "bold",
			},
			padding = { left = 1, right = 1 },
		}
		table.insert(tbl, position or 2, component)
	end
end

M.tabAndWindowStatus = function(opts)
	local for_tab = sections[lualineTbl[opts.tab.position.section] or "lualine_x"]
	local for_window = sections[lualineTbl[opts.window.position.section] or "lualine_x"]

	tab_count(opts.tab.activate, opts.tab.position.index, for_tab)
	window_count(opts.tab.activate, opts.tab.position.index, for_window)

	require("lualine").setup({
		sections = {
			[opts.tab.position.section] = for_tab,
			[opts.window.position.section] = for_window,
		},
	})
end

return M
