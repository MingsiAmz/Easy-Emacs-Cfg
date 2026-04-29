(defconst *is_mac* (eq system-type 'darwin))
(defconst *is_linux* (eq system-type 'gnu/linux))
(defconst *is_window* (or (eq system-type 'ms-dos)
			  (eq system-type 'windows-nt)))

(provide 'base_const)
