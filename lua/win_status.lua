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
		table.insert(tbl, position or 2, component)
	end
end

local window_count = function(activate, position, tbl)
	local component
	if activate and x == true then
		component = {
			function()
				local Icon = "󱇿 "
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
		table.insert(tbl, position or 1, component)
	end
end

M.setTabAndWindowStatus = function(opts)
	local tab_config
	local window_config

	if next(opts.tab) and opts.tab.position and opts.tab.position.section then
		tab_config = lualineTbl[opts.tab.position.section]
	else
		tab_config = "lualine_x"
	end

	if next(opts.window) and opts.window.position and opts.window.position.section then
		window_config = lualineTbl[opts.window.position.section]
	else
		window_config = "lualine_x"
	end

	local for_tab = sections[tab_config]
	local for_window = sections[window_config]

	local tab_position = opts.tab.position and opts.tab.position.index or nil
	local window_position = opts.window.position and opts.window.position.index or nil

	tab_count(opts.tab.activate, tab_position, for_tab)
	window_count(opts.tab.activate, window_position, for_window)

	require("lualine").setup({
		sections = {
			[tab_config] = for_tab,
			[window_config] = for_window,
		},
	})
	return 0
end

return M
