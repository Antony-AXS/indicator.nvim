return {
	cache = {},
	autocmd_id = nil,
	open_win_count = 0,
	window_timer = 300,
	indicator_timer = 1500,
	window_notify = false,
	indicator_notify = false,
	disp_ind_win_meta = {},
	win_hilght_acmd_id = nil,
	win_mngr_valid_chrs = {
		H = { false },
		h = { true },
		j = { true },
		J = { false },
		K = { false },
		k = { true },
		L = { false },
		l = { true },
		o = { false },
		q = { false },
		w = { false },
	},
}
