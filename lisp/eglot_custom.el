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
(add-hook 'java-mode-hook #'eglot-ensure)
(add-hook 'python-mode-hook #'eglot-ensure)
(add-hook 'csharp-mode-hook #'eglot-ensure)
(add-hook 'c-mode-hook #'eglot-ensure)
(add-hook 'c++-mode-hook #'eglot-ensure)
(global-set-key (kbd "C-c i") 'eglot-code-actions)
(global-set-key (kbd "C-c f") 'eglot-format)
(setq eglot-ignored-server-capabilities '(:documentOnTypeFormattingProvider))

(with-eval-after-load 'eglot
  (push '((c-mode c++-mode c-ts-mode c++-ts-mode) . ("clangd" "--limit-results=0"))
        eglot-server-programs)

  (setq-default eglot-workspace-configuration
                '(:java          (:completion (:maxResults 0))
                  :gopls         (:completionBudget "0s")
                  :rust-analyzer (:workspace (:symbol (:search (:limit 0))))
                  :pylsp         (:plugins (:jedi_completion (:fuzzy t))))))


;; Eldoc
(use-package eldoc
  :hook (prog-mode . eldoc-mode)
  :config
  (setq eldoc-idle-delay 0.5
        eldoc-echo-area-use-multiline-p t 
        eldoc-echo-area-display-truncation-message nil)
  (setq max-mini-window-height 0.25))

(use-package eldoc-box
  :ensure t
  :config
  (setq eldoc-box-max-pixel-width 800
        eldoc-box-max-pixel-height 600
        eldoc-box-offset '(10 10 10 0))
  (global-set-key (kbd "<f2>") 'eldoc-box-help-at-point))

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
