local fn = require("utils.fn")
local const = require("constants")
local ascii = require("ascii.numbers")

local M = {}

local indicator = function(timer, win_id, bloat)
	local curr_win_id = win_id or vim.api.nvim_get_current_win()
	local row, col = unpack(vim.api.nvim_win_get_position(curr_win_id))
	local _width = vim.api.nvim_win_get_width(curr_win_id)

	local number = tostring(vim.api.nvim_win_get_number(win_id or 0))
	local highlight_color
	local hor_constant
	local num_ascii
	local content
	local height
	local width

	if #number > 1 then
		local digits = {}
		for digit in number:gmatch("%d") do
			table.insert(digits, digit)
		end
		local num_tbl = {}
		for _, d_str in ipairs(digits) do
			table.insert(num_tbl, ascii[tostring(d_str)])
		end
		local fin_tbl = {}
		for _, d_ascii in ipairs(num_tbl) do
			for i, line in ipairs(d_ascii) do
				if fin_tbl[i] then
					fin_tbl[i] = fin_tbl[i] .. line
				else
					table.insert(fin_tbl, line)
				end
			end
		end
		num_ascii = fin_tbl
	else
		num_ascii = ascii[number]
	end

	if bloat then
		content = num_ascii
		highlight_color = nil
		hor_constant = 10
		height = 6
		width = 10
	else
		content = { " " .. number }
		highlight_color = { name = "IndicatorWin", fg_color = "#000000", bg_color = "#ffff00" }
		hor_constant = 5
		height = 1
		width = 3
	end
	local win_res = fn.create_float_window_V2(content, {
		focus = false, -- mandatory field
		highlight = highlight_color,
		border = nil,
		position = {
			type = "dynamic",
			axis = {
				vertical = row,
				horizontal = (col + _width) - hor_constant,
			},
		},
		size = {
			height = height,
			width = width,
		},
	})

	vim.defer_fn(function()
		if vim.api.nvim_win_is_valid(win_res.win_id) then
			vim.api.nvim_win_close(win_res.win_id, true) -- (window, force)
		end
	end, (timer or 1500))
end

local window_highlight = function()
	local win_id = vim.api.nvim_get_current_win()
	vim.api.nvim_set_hl(0, "ThisWinHighLight", { bg = "#2c3135", fg = nil }) -- #36454F #2c3135 #29343b
	vim.api.nvim_set_option_value("winhighlight", "Normal:ThisWinHighLight", { win = win_id })

	vim.defer_fn(function()
		if vim.api.nvim_win_is_valid(win_id) then
			vim.api.nvim_set_hl(0, "thisWinHighLight", { bg = nil, fg = nil })
			vim.api.nvim_set_option_value("winhighlight", "Noarmal:thisWinHighLight", { win = win_id })
		end
	end, 300)
end

M.indicateCurrent = function(timer, win_id, bloat)
	indicator(timer, win_id, bloat)
end
M.indicateAll = function(bloat)
	local current_tabpage = vim.api.nvim_get_current_tabpage()
	local window_ids = vim.api.nvim_tabpage_list_wins(current_tabpage)

	for _, win_id in ipairs(window_ids) do
		indicator(1500, win_id, bloat)
	end
end

M.indicator_event_activate = function()
	if const.autocmd_id == nil then
		const.autocmd_id = vim.api.nvim_create_autocmd("WinEnter", {
			desc = "Trigger always when entering a new Buffer",
			group = vim.api.nvim_create_augroup("window-indicator-function", { clear = true }),
			callback = function()
				indicator(500, nil, true)
			end,
		})
		vim.notify("Indicator Event Triggered")
	else
		vim.notify("Indicator Event Already Triggered")
	end
end

M.indicator_event_diactivate = function()
	if const.autocmd_id then
		vim.api.nvim_del_autocmd(const.autocmd_id)
		const.autocmd_id = nil
		vim.notify("Indicator Event Disabled")
	else
		vim.notify("Indicator Event already Disabled")
	end
end

M.window_highlight_event_activate = function()
	if const.win_hilght_acmd_id == nil then
		const.win_hilght_acmd_id = vim.api.nvim_create_autocmd("WinEnter", { callback = window_highlight })
		vim.notify("Window HighLight Enabled")
	else
		vim.notify("Window HighLight Already Enabled")
	end
end

M.window_highlight_event_diactivate = function()
	if const.win_hilght_acmd_id ~= nil then
		vim.api.nvim_del_autocmd(const.win_hilght_acmd_id)
		const.win_hilght_acmd_id = nil
		vim.notify("Window HighLight Disabled")
	else
		vim.notify("Window HighLight Already Disabled")
	end
end

M.setup = function(config)
	if config.indicator_event then
		if const.autocmd_id == nil then
			const.autocmd_id = vim.api.nvim_create_autocmd("WinEnter", {
				desc = "Trigger always when entering a new Buffer",
				group = vim.api.nvim_create_augroup("window-indicator-function", { clear = true }),
				callback = function()
					indicator(500, nil, true)
				end,
			})
			vim.notify("Indicator Event Triggered")
		else
			vim.notify("Indicator Event Already Triggered")
		end
	end

	if config.window_highlight_event then
		M.window_highlight_event_activate()
	end
end

return M
