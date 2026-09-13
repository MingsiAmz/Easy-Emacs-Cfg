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
(require 'eglot)
;; (setq eglot-report-progress t)
(add-hook 'java-mode-hook #'eglot-ensure)
(add-hook 'python-mode-hook #'eglot-ensure)
(add-hook 'csharp-mode-hook #'eglot-ensure)
(add-hook 'c-mode-hook #'eglot-ensure)
(add-hook 'c++-mode-hook #'eglot-ensure)
(global-set-key (kbd "C-c i") 'eglot-code-actions)

;; envrc
(use-package envrc
  :ensure t
  :init
  (envrc-global-mode))

;; Emmet
(use-package emmet-mode
  :ensure t
  :hook ((html-mode css-mode) . emmet-mode))

;; DAP
(use-package dap-mode
  :ensure t
  :commands (dap-mode dap-ui-mode)
  :config
  (dap-mode 1)
  (dap-ui-mode 1)
  (require 'dap-gdb-lldb))

(provide 'eglot_custom)
