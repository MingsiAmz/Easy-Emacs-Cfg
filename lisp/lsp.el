;; lsp mode
(setenv "PATH" (shell-command-to-string "echo %PATH%"))
(setq python-shell-interpreter "C:/Custom/Lib/Python/python-3.14/bin/python.exe")

;; (setq lib-path "C:/Custom/Lib/")
;; (add-to-list 'exec-path (format "%sPython/python-3.14/bin" lib-path))
;; (add-to-list 'exec-path (format "%smsys2/mingw64/bin" lib-path))
;; (add-to-list 'exec-path (format "%smsys2/usr/bin" lib-path))
;; (add-to-list 'exec-path (format "%sJava/jdk-21/bin" lib-path))

(use-package lsp-mode
  :ensure t
  :hook ((c-mode c++-mode java-mode python-mode) . lsp-deferred)
  :config
  (setq lsp-completion-provider :capf
        lsp-diagnostics-provider :none
        lsp-enable-symbol-highlighting nil
        lsp-enable-on-type-formatting nil
        lsp-idle-delay 0.5))

(use-package dap-mode
  :ensure t
  :after lsp-mode
  :config
  (dap-mode 1)
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (require 'dap-gdb-lldb)
  (setq dap-auto-configure-mode t))

(use-package emmet-mode
  :hook (web-mode . emmet-mode))

(let* ((msys2-base "C:/Custom/Lib/msys2")
       (mingw64-bin (concat msys2-base "/mingw64/bin"))
       (msys2-usr-bin (concat msys2-base "/usr/bin")))
  (setenv "PATH" (concat mingw64-bin ";" msys2-usr-bin ";" (getenv "PATH")))
)

(provide 'lsp)
