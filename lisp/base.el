;;; base.el -*- lexical-binding: t; -*-

;; 环境变量
(when (eq system-type 'windows-nt)
  (setenv "PATH" (string-trim-right (shell-command-to-string "echo %PATH%"))))

;; 垃圾回收性能优化（单线程 Emacs 卡顿治理）
(defvar my-gc-small-threshold (* 32 1024 1024))
(defun my-gc-set (threshold)
  (setq gc-cons-threshold threshold
        gc-cons-percentage 0.6))
(my-gc-set (* 64 1024 1024))

;; 界面 & 基础行为
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode t)
(setq inhibit-startup-screen t
      ring-bell-function 'ignore)
(set-face-attribute 'default nil :font "等距更纱黑体 SC" :height 160)
(fset 'yes-or-no-p 'y-or-n-p)
(add-hook 'window-setup-hook 'toggle-frame-maximized)

;; 主题
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one t)
  (set-face-attribute 'mode-line nil :height 100)
  (set-face-attribute 'mode-line-inactive nil :height 100))

;; 编码设置
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-language-environment "UTF-8")
(setq compilation-environment '("LANG=zh_CN.UTF-8" "LC_ALL=zh_CN.UTF-8")
      buffer-file-coding-system 'utf-8
      save-buffer-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8-unix)

;; revert
(global-auto-revert-mode 1)
(setq auto-revert-interval 1
      auto-revert-remote-files nil
      auto-revert-stop-on-user-input t
      revert-without-query nil)
(add-hook 'dired-mode-hook #'auto-revert-mode)

;; 平滑滚动
(setq scroll-margin 2
      scroll-conservatively 101
      scroll-step 1
      mouse-wheel-scroll-amount '(1)
      mouse-wheel-progressive-speed nil)
(pixel-scroll-precision-mode t)

;; 包管理
(setq package-archives
      '(("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/"))
      package-check-signature nil
      package-enable-at-startup nil)
(package-initialize)

;; use-package
(use-package use-package
  :config
  (setq use-package-always-ensure nil
        use-package-verbose nil
        use-package-expand-minimally t))

;; 禁用备份文件
(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil
      delete-by-moving-to-trash t)

;; 大文件 / 手动切缓冲时动态调整 GC 阈值
(defun my-buffer-size-based-gc ()
  (cond
   ((> (buffer-size) (* 4 1024 1024))
    (my-gc-set (max my-gc-small-threshold (* (buffer-size) 8))))
   ((and (called-interactively-p 'interactive)
         (> gc-cons-threshold (* 48 1024 1024)))
    (my-gc-set my-gc-small-threshold))))
(add-hook 'after-change-major-mode-hook #'my-buffer-size-based-gc)

;; 主动空闲 GC：摊到按键间隙
(run-with-idle-timer 20 t (lambda ()
                            (when (< gc-cons-threshold (* 96 1024 1024))
                              (garbage-collect))))

;; 保存后恢复常规阈值
(defun my-gc-restore () (my-gc-set my-gc-small-threshold))
(add-hook 'after-save-hook #'my-gc-restore)

;; Projectile
(use-package projectile
  :ensure t
  :defer t
  :diminish projectile-mode
  :bind-keymap ("C-c p" . projectile-command-map)
  :config
  (projectile-mode +1)
  (setq projectile-project-root-files
        '("build.gradle"
          "settings.gradle"
          "pom.xml"
          ".git"
          ".project"
          "build.sbt"
          "project.clj"))
  (setq projectile-enable-caching t)
  (setq projectile-auto-discover t)
  (when (executable-find "fd")
    (setq projectile-generic-command "fd . -0 --type f --color=never")))

;; Ivy
(use-package ivy
  :ensure t
  :defer 0.5
  :config (ivy-mode 1))

;; Orderless
(use-package orderless
  :ensure t
  :defer t
  :config (setq completion-styles '(orderless basic)))

;; Company
(use-package company
  :ensure t
  :defer t
  :hook (prog-mode . company-mode)
  :config
  (setq company-idle-delay 0.08
        company-minimum-prefix-length 2
        company-tooltip-limit 12
        company-backends '(company-capf)
        company-dabbrev-min-length 4
        company-dabbrev-ignore-case t
        company-dabbrev-code-everywhere t
        company-preserve-chart t
        company-transformers '(company-sort-prefix-first)))

(use-package company-prescient
  :ensure t
  :defer t
  :after company
  :config
  (company-prescient-mode 1))

;; 前缀优先排序
(defun company-sort-prefix-first (candidates)
  (let* ((prefix (company-prefix-or-completion))
         (pl (downcase prefix))
         (rx (regexp-quote pl))
         (idx-list (cl-loop for i from 0 for c in candidates
                            collect (cons c i))))
    (mapcar #'car
            (sort idx-list
                  (lambda (x y)
                    (let ((ta (company--match-tier pl rx (car x)))
                          (tb (company--match-tier pl rx (car y))))
                      (cond
                       ((/= ta tb) (> ta tb))
                       (t (< (cdr x) (cdr y))))))))))

(defun company--match-tier (pl rx cand)
  (let ((c (downcase cand)))
    (cond
     ((string-prefix-p pl c) 3)
     ((string-match rx c)
      (let ((beg (string-match rx c)))
        (if (and (> beg 0)
                 (member (aref c (1- beg)) '(?_ ?. ?- ?/ ? )))
            2
          1)))
     (t 0))))

(global-set-key (kbd "C-M-i") 'company-complete)

;; Drag stuff
(use-package drag-stuff
  :ensure t
  :defer t
  :bind (("M-p" . drag-stuff-up)
         ("M-n" . drag-stuff-down)))

;; Multiple cursors
(use-package multiple-cursors
  :ensure t
  :defer t
  :config (setq mc/always-run-for-all t))

;; Swiper
(use-package swiper
  :ensure t
  :defer t
  :bind (("C-s" . swiper)))

;; Magit
(use-package magit
  :ensure t
  :defer t
  :bind ("C-x g" . magit-status)
  :config
  (setq magit-commit-arguments '("--encoding=UTF-8"))
  (global-set-key (kbd "C-x v c") 'magit-commit))

;; YASnippet
(use-package yasnippet
  :ensure t
  :defer t
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t
  :defer t
  :after yasnippet)

;; 快捷键
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-M-o") 'other-window)
(global-set-key (kbd "M-1") 'delete-other-windows)
(global-set-key (kbd "M-2") 'split-window-below)
(global-set-key (kbd "M-3") 'split-window-right)
(global-set-key (kbd "M-0") 'kill-buffer-and-window)
(global-set-key (kbd "C-=") 'text-scale-adjust)
(global-set-key (kbd "C--") 'text-scale-decrease)
(global-set-key (kbd "<f5>") 'compile)
(global-set-key (kbd "C-M-s") 'grep)
(global-set-key (kbd "M-g") 'goto-line)
(global-set-key (kbd "C-c i") 'eglot-code-actions)

;; Dired
(setq find-file-run-dired t
      dired-recursive-deletes 'always)

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

;; 窗口分割
(setq split-window-preferred-function
      (lambda (&optional window)
        (split-window (or window (selected-window)) nil 'below)))

(defun my/display-buffer-smart (buffer alist)
  (if (one-window-p (selected-frame))
      (display-buffer-in-direction buffer (cons '(direction . below) alist))
    (display-buffer-in-direction buffer (cons '(direction . right) alist))))

(with-eval-after-load 'magit
  (add-to-list 'display-buffer-alist
               '("\\`\\*magit" my/display-buffer-smart)))

(defun my/trim-path (path)
  (if (string-prefix-p user-emacs-directory path)
      path
    (file-truename path)))

(provide 'base)
