local const = require("indicator/constants")
local x, _ = pcall(require, "lualine")

local M = {}

local sections = _.get_config().sections

local lualineSectTbl = {
	a = "lualine_a",
	b = "lualine_b",
	c = "lualine_c",
	x = "lualine_x",
	y = "lualine_y",
	z = "lualine_z",
}

local tab_count = function(position, tbl)
	local component = {
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

local window_count = function(position, tbl)
	local component = {
		function()
			local Icon = "󱇿 "
			if #vim.api.nvim_list_tabpages() == 1 then
				if #vim.api.nvim_tabpage_list_wins(0) ~= 1 then
					return (
						Icon
						.. vim.fn.winnr()
						.. "|"
						.. (#vim.api.nvim_tabpage_list_wins(0) - const.open_win_count)
					)
				else
					const.open_win_count = 0
					return (Icon .. vim.fn.winnr() .. "|" .. (#vim.api.nvim_tabpage_list_wins(0)))
				end
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

local function validateLualineInstalled()
	if vim.fn.executable("git") == 0 then
		return {
			val = false,
			message = "Indicator.nvim [Warning]: GIT is not Installed in your System",
		}
	end
	local runtime_paths = vim.api.nvim_list_runtime_paths()
	for _, path in ipairs(runtime_paths) do
		if string.match(path, "lualine") then
			local command = "git --git-dir=" .. path .. "/.git config --get remote.origin.url"
			local url = vim.fn.system(command)
			if string.match(url, "nvim%-lualine/lualine.nvim") then
				return {
					val = true,
					message = "Indicator.nvim [INFO]: lualine detected",
				}
			end
		end
	end
	return {
		val = false,
		message = "Indicator.nvim [Warning]: Can't use Window Status Feature, Lualine not Installed",
	}
end

M.setTabAndWindowStatus = function(opts)
	local retVal = validateLualineInstalled()
	if not retVal.val then
		return vim.notify(retVal.message, vim.log.levels.WARN)
	end

	local tab_config
	local window_config

	if next(opts) and opts.tab and opts.tab.activate then
		if opts.tab.position and opts.tab.position.section then
			tab_config = lualineSectTbl[opts.tab.position.section]
		else
			tab_config = "lualine_x"
		end
		local for_tab = sections[tab_config]
		local tab_position = opts.tab.position and opts.tab.position.index or nil
		tab_count(tab_position, for_tab)
	end

	if next(opts) and opts.window and opts.window.activate then
		if opts.window.position and opts.window.position.section then
			window_config = lualineSectTbl[opts.window.position.section]
		else
			window_config = "lualine_x"
		end
		local for_window = sections[window_config]
		local window_position = opts.window.position and opts.window.position.index or nil
		window_count(window_position, for_window)
	end

	_.setup({ sections = sections })
	return 0
end

return M
