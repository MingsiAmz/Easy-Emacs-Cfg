;;; eglot_custom.el -*- lexical-binding: t; -*-

(require 'eglot)

(when (eq system-type 'windows-nt)
  (setq process-connection-type nil
        w32-pipe-buffer-size 65536
        w32-pipe-read-delay 0))

(use-package eglot
  :ensure t
  :config
  (add-hook 'c-mode-hook      #'eglot-ensure)
  (add-hook 'c++-mode-hook    #'eglot-ensure)
  (add-hook 'python-mode-hook #'eglot-ensure)
  (add-hook 'java-mode-hook   #'eglot-ensure)
  (add-hook 'java-ts-mode-hook #'eglot-ensure)
  (add-to-list 'eglot-server-programs
	       `(java-mode . ("jdtls",(concat "-data" (expand-file-name "~/.cache/jdtls/workspace"))))))

(setq eglot-autoshutdown t
      eglot-sync-connect nil
      eglot-report-progress nil
      eglot-connect-timeout 60
      eglot-send-changes-idle-time 0.5
      flymake-no-changes-timeout 1.5
      eglot-events-buffer-size 0)

;; ---- DAP ----
(use-package dap-mode
  :ensure t
  :defer t
  :after eglot
  :config
  (dap-mode 1)
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (require 'dap-gdb-lldb)
  (setq dap-auto-configure-mode t))

(provide 'eglot_custom)
