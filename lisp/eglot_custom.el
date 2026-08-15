;;; eglot_custom.el -*- lexical-binding: t; -*-

;; Windows 管道优化
(when (eq system-type 'windows-nt)
  (setq process-connection-type nil
        w32-pipe-buffer-size 65536
        w32-pipe-read-delay 0))

;; eglot 全局策略
(setq eglot-autoshutdown t          
      eglot-sync-connect nil        
      eglot-report-progress nil     
      eglot-connect-timeout 60
      eglot-send-changes-idle-time 0.5
      flymake-no-changes-timeout 1.5
      eglot-events-buffer-size 0)   

(global-set-key (kbd "C-c i") 'eglot-code-actions)

;; 项目根目录解析
(defun my-eglot-project-root (dir)
  (or (projectile-project-root)
      (project-root (project-current))))

(use-package eglot
  :ensure t
  :defer t
  :hook ((c-mode . eglot-ensure)
         (c++-mode . eglot-ensure)
         (python-mode . eglot-ensure)
         (java-mode . eglot-ensure)
         (html-mode . eglot-ensure))
  :config
  (setq jsonrpc-default-request-timeout 20))
(setq eglot--project-fn #'my-eglot-project-root)

(use-package emmet-mode
  :ensure t
  :defer t
  :hook ((html-mode css-mode web-mode) . emmet-mode)
  :config
  (setq emmet-indentation 2
        emmet-move-cursor-between-quotes t))

;; JS 模式
(use-package js2-mode
  :ensure t
  :defer t
  :mode ("\\.js\\'" . js2-mode)
  :config
  (setq js2-basic-offset tab-width
        js2-show-parse-errors nil
        js2-show-strict-warnings nil
        js2-strict-missing-semi-warning nil))

;; DAP（调试，延迟加载）
(use-package dap-mode
  :ensure t
  :defer t
  :commands (dap-mode dap-ui-mode dap-tooltip-mode)
  :config
  (dap-mode 1)
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (require 'dap-gdb-lldb)
  (setq dap-auto-configure-mode t))

(provide 'eglot_custom)
