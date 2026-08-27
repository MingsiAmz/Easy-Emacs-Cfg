(setq gc-cons-threshold 100000000        
      gc-cons-percentage 0.6)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 800000
                  gc-cons-percentage 0.1)))

(when (boundp 'native-comp-available-p)
  (when (native-comp-available-p)
    (setq native-comp-deferred-compilation t
          native-comp-async-report-warnings-errors nil)))

;; ---- 文件句柄限制提升 ----
(setq max-lisp-eval-depth 5000)
(setq max-specpdl-size 5000)

;; ---- 吞掉不必要的冗长消息 ----
(setq inhibit-startup-message t
      inhibit-startup-echo-area-message user-login-name)

;; ---- 消息缓冲调大，减少日志操作 ----
(setq message-log-max 200)

(add-to-list 'load-path
             (expand-file-name (concat user-emacs-directory "lisp")))

;; ---- 允许重新定义交互命令，避免启动警告刷屏 ----
(setq ad-redefinition-action 'accept)

(require 'base)
(require 'eglot_custom)

(put 'upcase-region 'disabled nil)
(put 'set-goal-column 'disabled nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(company-fuzzy company-prescient doom-themes drag-stuff eglot-java
		   emmet-mode flx-rs flycheck flycheck-posframe
		   js2-mode lsp-java magit multiple-cursors orderless
		   projectile swiper yasnippet-snippets)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'dired-find-alternate-file 'disabled nil)
