(add-to-list 'load-path
	     (expand-file-name (concat user-emacs-directory "lisp"))
)
(require 'base)
(require 'lsp)
(put 'upcase-region 'disabled nil)
(put 'set-goal-column 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(## company composite consult counsel doom-themes dracula-theme
	emmet-mode flycheck general go-mode gradle-mode js2-mode
	json-mode lsp-java lsp-pyright lsp-ui markdown-preview-mode
	multiple-cursors nodejs-repl npm-mode orderless pandoc
	projectile projectile-ripgrep python-mode restart-emacs
	ripgrep rust-mode theme-buffet toml-mode typescript-mode
	web-mode yaml-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'dired-find-alternate-file 'disabled nil)
