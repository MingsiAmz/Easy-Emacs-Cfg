;; 界面 & 基础行为
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode t)
(setq inhibit-startup-screen t)
(setq ring-bell-function 'ignore)
(set-face-attribute 'default nil :font "Fira Code" :height 160)
(setq compilation-environment '("LANG=zh_CN.UTF-8" "LC_ALL=zh_CN.UTF-8"))

;; 平滑滚动
(setq scroll-margin 2
      scroll-conservatively 101
      scroll-step 1)

;; 包管理（清华镜像）
(setq package-archives '(("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/"))
      package-check-signature nil
      package-enable-at-startup nil)

(package-initialize)
(unless package-archive-contents (package-refresh-contents))

(use-package use-package
  :ensure t
  :config
  (setq use-package-always-ensure t
        use-package-verbose nil))

;; 禁用备份文件
(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil
      delete-by-moving-to-trash t)

;; prog
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-tooltip-limit 4)            
  (setq company-tooltip-max-width 50)       
  (setq company-tooltip-flip-when-above t)) 

(use-package orderless
  :config
  (setq completion-styles '(orderless basic)))

(use-package drag-stuff
  :ensure t
  :bind (("M-p" . drag-stuff-up)
         ("M-n" . drag-stuff-down)))

(require 'multiple-cursors)

;; key bording
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-2") 'split-window-below)
(global-set-key (kbd "M-3") 'split-window-right)
(global-set-key (kbd "C-=") 'text-scale-adjust)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<f5>") 'compile)

;; 主题 & Dired
(use-package doom-themes
  :demand
  :config (load-theme 'doom-one t))

(setq find-file-run-dired t
      dired-recursive-deletes 'always
      dired-auto-revert-buffer t)

;; def
(defun jump-project-dir ()
  (interactive)
  (dired "C:/Users/MingsiAmz/Documents/Code/"))

(global-set-key (kbd "C-x x j") 'jump-project-dir)

(defun back-to-buffer ()
  (interactive)
  (switch-to-buffer nil))

(global-set-key (kbd "C-c b") 'back-to-buffer)

(defun org-quick-preview ()
  (interactive)
  (org-html-export-to-html)
  (browse-url (concat (file-name-sans-extension buffer-file-name) ".html")))

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c C-p") 'org-quick-preview))



(provide 'base)
