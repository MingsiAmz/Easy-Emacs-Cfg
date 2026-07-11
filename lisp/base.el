;; 环境变量
(setenv "PATH" (shell-command-to-string "echo %PATH%"))
(setq python-shell-interpreter "C:/Custom/Lib/Python/python-3.14/bin/python.exe")

;; 界面 & 基础行为
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode t)
(setq inhibit-startup-screen t
      ring-bell-function 'ignore
      dired-auto-revert-buffer t)
(set-face-attribute 'default nil :font "等距更纱黑体 SC" :height 160)
(fset 'yes-or-no-p 'y-or-n-p)
(add-hook 'window-setup-hook 'toggle-frame-maximized)

;; 平滑滚动
(setq scroll-margin 2
      scroll-conservatively 101
      scroll-step 1)
(setq pixel-scroll-precision-mode t)
(setq mouse-wheel-scroll-amount '(1))
(setq mouse-wheel-progressive-speed nil)

;; 编码设置
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-language-environment "UTF-8")
(setq compilation-environment '("LANG=zh_CN.UTF-8" "LC_ALL=zh_CN.UTF-8")
      buffer-file-coding-system 'utf-8
      save-buffer-coding-system 'utf-8)
(global-auto-revert-mode 1)
(setq revert-without-query '(".*"))

;; 包管理
(setq package-archives '(("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/"))
      package-check-signature nil
      package-enable-at-startup nil
      package-quickstart t)

(package-initialize)
(unless package-archive-contents (package-refresh-contents))

(use-package use-package
  :ensure t
  :config
  (setq use-package-always-ensure t
        use-package-verbose nil
        use-package-expand-minimally t))

;; 禁用备份文件
(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil
      delete-by-moving-to-trash t)

;; 编程模式通用设置
(electric-indent-mode -1)
(use-package projectile
  :ensure t
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map))

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1))

;; Company
(use-package company
  :ensure t
  :hook (after-init . global-company-mode)
  :config
  (setq company-tooltip-limit 4
        company-tooltip-max-width 50
        company-tooltip-flip-when-above t
        company-idle-delay 0.2
        company-minimum-prefix-length 1
        company-backends '(company-capf)))

(use-package orderless
  :config
  (setq completion-styles '(orderless basic)))

(use-package drag-stuff
  :ensure t
  :bind (("M-p" . drag-stuff-up)
         ("M-n" . drag-stuff-down)))

;; multiple-cursors
(use-package multiple-cursors
  :ensure t
  :config
  (setq mc/always-run-for-all t))

;; swiper
(use-package swiper
  :ensure t
  :bind
  (("C-s" . swiper)))

;; 快捷键
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-2") 'split-window-below)
(global-set-key (kbd "M-3") 'split-window-right)
(global-set-key (kbd "M-0") 'kill-buffer-and-window)
(global-set-key (kbd "C-=") 'text-scale-adjust)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<f5>") 'compile)
(global-set-key (kbd "C-M-s") 'grep)
(global-set-key (kbd "M-g") 'goto-line)

;; 主题
(use-package doom-themes
  :demand
  :config (load-theme 'doom-one t))

;; Dired
(setq find-file-run-dired t
      dired-recursive-deletes 'always
      dired-auto-revert-buffer t)

;; 自定义函数
(defun jump-project-dir ()
  (interactive)
  (let ((code-dir (expand-file-name "~/Documents/Code/")))
    (unless (file-exists-p code-dir)
      (make-directory code-dir t))
    (dired code-dir)))
(global-set-key (kbd "C-x x j") 'jump-project-dir)

(defun back-to-buffer ()
  (interactive)
  (switch-to-buffer nil))
(global-set-key (kbd "C-c b") 'back-to-buffer)

(defun search-all-str (item ffix)
  (interactive "ssearch for: \nsFile extension:")
  (grep (format "findstr /ns \"%s\" *.%s" item ffix)))
(global-set-key (kbd "C-`") 'search-all-str)

(defun org-quick-preview ()
  (interactive)
  (org-html-export-to-html)
  (browse-url (concat (file-name-sans-extension buffer-file-name) ".html")))

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "C-c C-p") 'org-quick-preview))

(provide 'base)
