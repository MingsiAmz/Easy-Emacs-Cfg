;; lsp mode
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l"
		lsp-file-watch-threshold 500)
  :hook
  (lsp-mode . lsp-enable-which-key-integration)
  :commands (lsp lsp-deferred)
  :config
  (setq lsp-completion-provider :none)
  (setq lsp-headerline-breadcrumb-enable -t)
  :bind
  ("C-c l s" . lsp-ivy-workspace-symbol)
)

(use-package emmet-mode
  :hook (web-mode . emmet-mode))

(let* ((msys2-base "C:/Custom/Lib/msys2")
       (mingw64-bin (concat msys2-base "/mingw64/bin"))
       (msys2-usr-bin (concat msys2-base "/usr/bin")))
  (setenv "PATH" (concat mingw64-bin ";" msys2-usr-bin ";" (getenv "PATH")))
)

(provide 'lsp)
