;; 环境变量
(setenv "PATH" (shell-command-to-string "echo %PATH%"))
(setq python-shell-interpreter "C:/Custom/Lib/Python/python-3.14/bin/python.exe")

;; LSP Mode
(use-package lsp-mode
  :ensure t
  :defer t 
  :hook ((c-mode c++-mode csharp-mode java-mode python-mode) . lsp-deferred)
  :config
  (setq lsp-completion-provider :capf
        lsp-diagnostics-provider :none
        lsp-enable-symbol-highlighting nil
        lsp-enable-on-type-formatting nil
        lsp-enable-snippet nil
        lsp-idle-delay 0.124
        lsp-response-timeout 5))

;; DAP Mode
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

;; Emmet
(use-package emmet-mode
  :defer t
  :hook (web-mode . emmet-mode))

(provide 'lsp)
