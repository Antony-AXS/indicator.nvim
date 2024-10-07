local popup = require("plenary.popup")
local M = {}

M.create_float_window = function(content)
	-- Create a new buffer
	local buf = vim.api.nvim_create_buf(false, true) -- {listed: false, scratch: true}

	-- Determine the width and height of the window
	local width = vim.api.nvim_get_option_value("columns", {})
	local height = vim.api.nvim_get_option_value("lines", {})

	-- Set the dimensions and position of the floating window
	local win_width = math.ceil(width * 0.8)
	local win_height = math.ceil(height * 0.5)
	local row = math.ceil((height - win_height) / 2) - 1
	local col = math.ceil((width - win_width) / 2)

	-- Set the window options
	local opts = {
		style = "minimal",
		relative = "editor",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
		focusable = false,
		border = { { "╭" }, { "─" }, { "╮" }, { "│" }, { "╯" }, { "─" }, { "╰" }, { "│" } },
	}

	-- Create the floating window
	vim.api.nvim_open_win(buf, true, opts)

	-- Optionally, you can set some buffer options
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, content)
end

M.create_float_window_V2 = function(content, options)
	local bufnr = vim.api.nvim_create_buf(false, true)

	local width = (options and options.size and options.size.width) or 90
	local height = (options and options.size and options.size.height) or 12

	local row = math.floor(((vim.o.lines - height) / 1.8) - 1)
	local col = math.floor((vim.o.columns - width) / 2)

	local function positions(type, axis)
		local static = {
			middle = {
				vertical = row,
				horizontal = col,
			},
			top_right_corner = {
				vertical = 15,
				horizontal = 0.5,
			},
		}
		local dynamic = function(axis)
			return {
				vertical = axis.vertical,
				horizontal = axis.horizontal,
			}
		end

		local response
		if type == "static" then
			response = static[axis]
		elseif type == "dynamic" then
			response = dynamic(axis)
		end
		return response
	end

	local type = (options.position and options.position.type) or "static"
	local axis = (options.position and options.position.axis) or "middle"

	local x_pos = positions(type, axis)["horizontal"]
	local y_pos = positions(type, axis)["vertical"]

	local win_id
	local border_val
	local highlight_name

	if options.highlight then
		vim.api.nvim_set_hl(
			0,
			options.highlight.name,
			{ bg = options.highlight.bg_color, fg = options.highlight.fg_color }
		)

		highlight_name = options.highlight.name
	else
		highlight_name = "NormalFloat"
	end

	if options and options.border == "default" and options.title then
		border_val = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
	elseif options and options.border == "default" and options.title == nil then
		border_val = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" }
	elseif options and options.border then
		border_val = options.border
	else
		border_val = nil
	end
	-- different border types : single, double, rounded, solid, shadow

	if options and options.title then
		vim.api.nvim_set_hl(0, "TitleWinBorder", { bg = nil, fg = "#3cb9fc" })
		local popup_win_id, win = popup.create(bufnr, {
			title = options.title,
			line = y_pos,
			col = x_pos,
			minwidth = width,
			minheight = height,
			highlight = highlight_name,
			borderhighlight = "TitleWinBorder",
			borderchars = border_val,
		})
		win_id = popup_win_id
	else
		local opts = {
			style = "minimal",
			relative = "editor",
			row = y_pos,
			col = x_pos,
			width = width,
			height = height,
			anchor = "NW",
			focusable = false,
			border = border_val,
		}

		win_id = vim.api.nvim_open_win(bufnr, options.foucs, opts)
		vim.api.nvim_set_option_value("winhighlight", "Normal:" .. highlight_name, { win = win_id })
	end
	-- vim.api.nvim_win_set_option(win.border.win_id, "winhl", "Normal:HarpoonBorder")

	local if_modifiable = (options and options.modifiable) or false
	local if_cursorline = (options and options.cursorline) or false

	local next_line
	if options.header then
		local line
		if options.header.align == "Center" then
			local line_length = #options.header.line
			local win_width = vim.api.nvim_win_get_width(win_id)
			local padding = math.floor((win_width - line_length) / 2)
			local centered_line = string.rep(" ", padding) .. options.header.line
			line = centered_line
		end
		local font = options.header.font
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { line })
		vim.api.nvim_buf_add_highlight(bufnr, -1, font or "Normal", 0, 0, -1)
		next_line = 1
	else
		next_line = 0
	end

	vim.api.nvim_buf_set_lines(bufnr, next_line, -1, false, content)
	vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = bufnr })
	vim.api.nvim_set_option_value("modifiable", if_modifiable, { buf = bufnr })
	vim.api.nvim_set_option_value("cursorline", if_cursorline, { win = win_id })

	return { bufnr = bufnr, win_id = win_id }
end

return M
