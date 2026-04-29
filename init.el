(setq native-comp-async-report-warnings-errors nil)
(setq byte-compile-warnings '(not obsolete))
(setq warning-suppress-types '((bytecomp) (comp)))
(add-to-list 'load-path
	     (expand-file-name (concat user-emacs-directory "lisp"))
)
(require 'base_const)
(require 'init_package)
(require 'base_start)
(require 'base_ui)
(require 'init_theme)
(require 'use_other_package)
(require 'init_programing)
(put 'upcase-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(ace-window-display-mode ace-window-mode company counsel doom-themes
			     dracula-theme emmet-mode flycheck go-mode
			     js2-mode json-mode lsp-java
			     lsp-javascript lsp-pyright lsp-ui
			     nodejs-repl npm-mode projectile
			     python-mode restart-emacs rust-mode
			     theme-buffet toml-mode typescript-mode
			     web-mode yaml-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
