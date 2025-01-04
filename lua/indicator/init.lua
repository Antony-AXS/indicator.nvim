local const = require("indicator/constants")
local indicator = require("indicator.utils.generator")
local status = require("indicator/win_status")

local M = {}

local window_highlight = function()
	vim.api.nvim_set_hl(0, "IndCurrWinHiglt", { bg = "#2c3135", fg = nil }) -- #36454F #2c3135 #29343b
	vim.api.nvim_set_hl(0, "IndRestWinHiglt", { bg = nil, fg = nil })

	local curr_win_id = vim.api.nvim_get_current_win()
	local all_open_win = vim.api.nvim_list_wins()

	for _, id in ipairs(all_open_win) do
		if id == curr_win_id then
			vim.api.nvim_set_option_value("winhl", "Normal:IndCurrWinHiglt", { win = curr_win_id })
		else
			vim.api.nvim_set_option_value("winhl", "Normal:IndRestWinHiglt", { win = id })
		end
	end

	vim.defer_fn(function()
		if vim.api.nvim_win_is_valid(curr_win_id) then
			vim.api.nvim_set_hl(0, "IndCurrWinHiglt", { bg = nil, fg = nil })
			vim.api.nvim_set_option_value("winhl", "Normal:IndCurrWinHiglt", { win = curr_win_id })
		end
	end, const.window_timer)
end

-- text doc specific alterations
vim.api.nvim_create_autocmd({ "BufRead", "BufEnter" }, {
	pattern = vim.fn.getcwd() .. "/doc" .. "/indicator.nvim.txt",
	callback = function()
		vim.opt_local.list = true
		vim.opt_local.listchars = { tab = ">-", trail = "-" }

		-- vim.api.nvim_set_hl(0, "MyIndiCustomColor", { fg = "#45f963", bg = "#ff0000", bold = true })
		-- vim.fn.matchadd("MyIndiCustomColor", "License")

		-- vim.cmd([[syntax match MyIndiCustomColor "https://github.com/Antony-AXS/indicator.nvim"]])
		-- vim.cmd([[highlight link MyIndiCustomColor "License"]])
	end,
})

---@param timer number|nil
M.indicateCurrent = function(timer)
	indicator.generate(timer, nil, true, false)
end

---@param timer number|nil
M.indicateAll = function(timer)
	local current_tabpage = vim.api.nvim_get_current_tabpage()
	local window_ids = vim.api.nvim_tabpage_list_wins(current_tabpage)

	for _, win_id in ipairs(window_ids) do
		indicator.generate(timer, win_id, true, false)
	end
end

M.indicator_event_activate = function()
	if const.autocmd_id == nil then
		const.autocmd_id = vim.api.nvim_create_autocmd("WinEnter", {
			desc = "Trigger always when entering a new Buffer",
			group = vim.api.nvim_create_augroup("window-indicator-function", { clear = true }),
			callback = function()
				indicator.generate(500, nil, true, false)
			end,
		})
		if const.indicator_notify then
			vim.notify("Indicator Event Triggered", vim.log.levels.INFO)
		end
	else
		vim.notify("Indicator Event Already Triggered", vim.log.levels.INFO)
	end
	const.indicator_notify = true
end

M.indicator_event_deactivate = function()
	if const.autocmd_id then
		vim.api.nvim_del_autocmd(const.autocmd_id)
		const.autocmd_id = nil
		vim.notify("Indicator Event Disabled", vim.log.levels.INFO)
	else
		vim.notify("Indicator Event already Disabled", vim.log.levels.INFO)
	end
	const.indicator_notify = true
end

M.window_highlight_event_activate = function()
	if const.win_hilght_acmd_id == nil then
		const.win_hilght_acmd_id = vim.api.nvim_create_autocmd("WinEnter", { callback = window_highlight })
		if const.window_notify then
			vim.notify("Window HighLight Enabled", vim.log.levels.INFO)
		end
	else
		vim.notify("Window HighLight Already Enabled", vim.log.levels.INFO)
	end
	const.window_notify = true
end

M.window_highlight_event_deactivate = function()
	if const.win_hilght_acmd_id ~= nil then
		vim.api.nvim_del_autocmd(const.win_hilght_acmd_id)
		const.win_hilght_acmd_id = nil
		vim.notify("Window HighLight Disabled", vim.log.levels.INFO)
	else
		vim.notify("Window HighLight Already Disabled", vim.log.levels.INFO)
	end
	const.window_notify = true
end

M.triggerWindowManager = function()
	local current_tabpage = vim.api.nvim_get_current_tabpage()
	local window_ids = vim.api.nvim_tabpage_list_wins(current_tabpage)

	for _, win_id in ipairs(window_ids) do
		indicator.generate(nil, win_id, true, true)
	end

	vim.schedule(function()
		local key
		local tbl = {}
		local valid_set = const.win_mngr_valid_chrs
		local digit_count = 0
		while true do
			local char = vim.fn.nr2char(vim.fn.getchar())
			local is_digit = string.match(char, "%d")
			local valid_char = valid_set[char]

			if valid_char then
				key = char
				break
			elseif not is_digit and not valid_char then
				table.insert(tbl, "x")
				break
			elseif is_digit and digit_count < const.wmgr_nlmt then
				table.insert(tbl, char)
				digit_count = digit_count + 1
			else
				break
			end
		end
		local digit = table.concat(tbl)

		local command
		local cmd_str = "wincmd" .. " "

		if valid_set[key] and valid_set[key]["sft"] then
			command = cmd_str .. key
			vim.cmd(cmd_str .. digit .. "w")
		elseif valid_set[key] then
			command = cmd_str .. digit .. key
		elseif string.match(digit, "^%d%d$") then
			command = ""
			local msg = "Indicator.nvim [WARNING]: Digit limit exceeded."
			vim.notify(msg, vim.log.levels.WARN)
		elseif string.match(digit, "^x$") then
			command = ""
			local msg = "Indicator.nvim [WARNING]: Invalid Character Entered."
			vim.notify(msg, vim.log.levels.WARN)
		else
			command = ""
			local msg_1 = "Indicator.nvim [WARNING]: Invalid window management command,"
			local msg_2 = "Only 'h', 'j', 'k', 'l', 'w', 'o', 'q' are considered valid."
			vim.notify(msg_1 .. "\n" .. msg_2, vim.log.levels.WARN)
		end

		local _, errorMessage = pcall(function()
			vim.api.nvim_exec2(command, { output = true })
		end)

		local re_ind_flg = true

		if errorMessage then
			re_ind_flg = false
			local message = tostring(errorMessage)
			vim.notify(message, vim.log.levels.WARN)
		end

		for _, win_res in ipairs(const.disp_ind_win_meta) do
			if vim.api.nvim_win_is_valid(win_res.win_id) then
				vim.api.nvim_win_close(win_res.win_id, true)
				const.open_win_count = const.open_win_count - 1
				const.cache[win_res.num].status = 0
			end
		end

		if re_ind_flg and key and string.match(key, "[brtHJKLR]") then
			local all_win_meta = const.cache
			local win_limit = #vim.api.nvim_tabpage_list_wins(0)

			local function triggerReIndication()
				for i = 1, win_limit do
					local win_meta = all_win_meta[tostring(i)]
					if win_meta then
						local win_id = win_meta.par_id
						indicator.generate(1000, win_id, true, false, i)
					end
				end
			end

			triggerReIndication()

			local timer_id
			local function start_new_timer()
				if timer_id then
					vim.fn.timer_stop(timer_id)
				end

				timer_id = vim.fn.timer_start(1000, function()
					vim.api.nvim_input("<Esc>")
				end)
			end

			local function reInitate()
				vim.defer_fn(function()
					start_new_timer()
					local char = vim.fn.nr2char(vim.fn.getchar())
					if string.match(char, "[rR]") then
						vim.cmd("wincmd" .. " " .. char)
						triggerReIndication()
						reInitate()
					else
						for i = 1, win_limit do
							local win_meta = all_win_meta[tostring(i)]
							if win_meta then
								local win_id = win_meta.win_id
								if vim.api.nvim_win_is_valid(win_id) then
									vim.api.nvim_win_close(win_id, true)
									const.open_win_count = const.open_win_count - 1
									const.cache[tostring(i)].status = 0
								end
							end
						end
					end
				end, 10)

				return 0
			end

			reInitate()
		end
		const.disp_ind_win_meta = {}
	end)
end

---@alias ModeEnum "ON" | "OFF"
---@class Table
---@field args ModeEnum

---@param opts Table
vim.api.nvim_create_user_command("Indicator", function(opts)
	if opts.args == "ON" then
		M.indicator_event_activate()
	elseif opts.args == "OFF" then
		M.indicator_event_deactivate()
	else
		local message = "Please pass the right Indicator Argument, {ON | OFF}"
		vim.notify(message, vim.log.levels.WARN)
	end
end, { nargs = "?" })

---@param opts Table
vim.api.nvim_create_user_command("IndicatorWinHl", function(opts)
	if opts.args == "ON" then
		M.indicator_event_activate()
	elseif opts.args == "OFF" then
		M.indicator_event_deactivate()
	else
		local message = "Please pass the right Window Highlight Argument, {ON | OFF}"
		vim.notify(message, vim.log.levels.WARN)
	end
end, { nargs = "?" })

---@param config table
M.setup = function(config)
	if config.indicator_event then
		M.indicator_event_activate()
	end

	if config.window_highlight_event then
		M.window_highlight_event_activate()
	end

	if config.window_count_status then
		if status then
			status.setTabAndWindowStatus(config.window_count_status)
		end
	end
end

return M
