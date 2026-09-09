;;; eglot_custom.el -*- lexical-binding: t; -*-

;; Windows 优化
(when (eq system-type 'windows-nt)
  (setq process-connection-type nil
        w32-pipe-buffer-size 65536))

;; 项目根目录
(defun my-eglot-project-root (_dir)
  (or (and (fboundp 'projectile-project-root) (projectile-project-root))
      (and (fboundp 'project-current) (project-current)
           (ignore-errors (project-root (project-current))))))

;; Eglot 基础设置
(setq eglot-autoshutdown t
      eglot-sync-connect nil
      eglot-connect-timeout 60
      eglot-send-changes-idle-time 0.5
      eglot--project-fn #'my-eglot-project-root
      jsonrpc-default-request-timeout 20)

(use-package eglot
  :defer t
  :hook (prog-mode . eglot-ensure)
  :bind ("C-c i" . eglot-code-actions)
  :config
  (setq eglot-stay-out-of '(flymake)))

;; Emmet
(use-package emmet-mode
  :ensure t
  :hook ((html-mode css-mode) . emmet-mode))

;; JS
(use-package js2-mode
  :ensure t
  :mode ("\\.js\\'" . js2-mode))

;; DAP
(use-package dap-mode
  :ensure t
  :commands (dap-mode dap-ui-mode)
  :config
  (dap-mode 1)
  (dap-ui-mode 1)
  (require 'dap-gdb-lldb))

(provide 'eglot_custom)
