local x, _ = pcall(require, "lualine")

local M = {}

M.window_count = function(activate, position)
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
		local x_line = require("lualine").get_config().sections.lualine_x
		table.insert(x_line, position or 1, component)
		require("lualine").setup({ sections = { lualine_x = x_line } })
	elseif activate and x == false then
		vim.notify("Lualine is not installed")
	end
end

return M
