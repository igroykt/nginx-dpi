return {
	proxy_addr = "127.0.0.1",
	proxy_port = 1082,
	isp_block_banner = "fz139.ttk.ru",
	isp_common_name = "ttk.ru",
	exclude_domains = {
        "127.0.0.1/8",
        "::1",
        "localhost",
		".ru",
		"igro.tech",
	},
	force_domains = {
	},
	connection_timeout = 2000,
	read_timeout = 2000,
	write_timeout = 2000
}