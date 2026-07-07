(setenv "CTAGS" "C:/Custom/Lib/msys2/ucrt64/bin/ctags.exe")

;; LSP MODE
(use-package lsp-mode
  :ensure t
  :hook ((csharp-mode java-mode python-mode) . lsp-deferred)
  :config
  (setq lsp-completion-provider :capf
        lsp-diagnostics-provider :none
        lsp-enable-symbol-highlighting nil
        lsp-enable-on-type-formatting nil
        lsp-enable-snippet nil
        lsp-idle-delay 0.124
        lsp-response-timeout 5))

;; DAP MODE
(use-package dap-mode
  :ensure t
  :defer t
  :after lsp-mode
  :config
  (dap-mode 1)
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (require 'dap-gdb-lldb)
  (setq dap-auto-configure-mode t))

;; FLYCHECK MODE
(use-package flycheck
  :ensure t
  :hook ((csharp-mode java-mode python-mode) . flycheck-mode)
  :config
  (setq truncate-lines nil))

;; CITRE MODE
(use-package citre
  :ensure t
  :config
  (require 'citre-config)
  (setq citre-ctags-program (getenv "CTAGS"))
  (setq citre-default-create-tags-function 'citre-ctags-create-tags))

(add-hook 'c-mode-hook 'citre-mode)
(add-hook 'c++-mode-hook 'citre-mode)

;; Emmet
(use-package emmet-mode
  :defer t
  :hook (web-mode . emmet-mode))

(provide 'lsp)
