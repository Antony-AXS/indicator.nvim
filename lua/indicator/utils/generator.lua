local ascii = require("indicator.ascii.digits")
local const = require("indicator/constants")
local win_fn = require("indicator.utils.window_fn")

local M = {}

---@param timer number|nil
---@param win_id number|nil
---@param bloat boolean
---@param disp_win_cls boolean
M.generate = function(timer, win_id, bloat, disp_win_cls, win_num)
	local curr_win_id = win_id or vim.api.nvim_get_current_win()

	if not vim.api.nvim_win_is_valid(curr_win_id) then
		return 1
	end

	local row, col = unpack(vim.api.nvim_win_get_position(curr_win_id))
	local number = tostring(win_num or vim.api.nvim_win_get_number(win_id or 0))
	local curr_win_config = vim.api.nvim_win_get_config(curr_win_id)
	local _width = vim.api.nvim_win_get_width(curr_win_id)
	local num = tostring(number)

	local highlight_color
	local hor_constant
	local num_ascii
	local content
	local height
	local width

	if rawget(curr_win_config, "zindex") then
		return 1
	end

	if const.cache[num] == nil then
		const.cache[num] = {}
	elseif vim.api.nvim_win_is_valid(const.cache[num].win_id) then
		vim.api.nvim_win_close(const.cache[num].win_id, true)
		const.open_win_count = const.open_win_count - 1
	end

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

	local win_res = win_fn.create_float_window_V2(content, {
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

	if win_res ~= nil and win_res.win_id ~= nil then
		const.open_win_count = const.open_win_count + 1
		const.cache[num].win_id = win_res.win_id
		const.cache[num].par_id = curr_win_id
		const.cache[num].status = 1
	end

	if disp_win_cls then
		table.insert(const.disp_ind_win_meta, { num = num, win_id = win_res.win_id })
		return
	else
		vim.defer_fn(function()
			if vim.api.nvim_win_is_valid(win_res.win_id) then
				vim.api.nvim_win_close(win_res.win_id, true) -- (window, force)
				const.open_win_count = const.open_win_count - 1
				const.cache[num].status = 0
			end
		end, (timer or const.indicator_timer))
	end
end

return M
