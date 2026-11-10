;;; base.el -*- lexical-binding: t; -*-

;; 环境变量
(when (eq system-type 'windows-nt)
  (let ((p (getenv "PATH")))
    (when p (setenv "PATH" p)))
  (setq w32-get-true-file-attributes nil
        w32-pipe-read-delay 0))

(setq split-height-threshold nil)
(setq split-width-threshold 9999)

;; 垃圾回收性能优化
(defvar my-gc-small-threshold (* 64 1024 1024))
(defun my-gc-set (threshold)
  (setq gc-cons-threshold threshold
        gc-cons-percentage 0.6))
(my-gc-set (* 64 1024 1024))

;; 界面 & 基础行为
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)
(setq inhibit-startup-screen t
      ring-bell-function 'ignore)
(set-face-attribute 'default nil :font "Sarasa Term SC" :height 160)
(fset 'yes-or-no-p 'y-or-n-p)
(add-hook 'window-setup-hook 'toggle-frame-maximized)
(electric-pair-mode 1)
(setq-default tab-width 8 indent-tabs-mode nil)
(setq-default c-basic-offset 8)

;; 主题
(use-package doom-themes
  :ensure t
  :config
  (load-theme 'doom-one-light t)
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
(setq auto-revert-interval 5
      auto-revert-use-notify t
      auto-revert-remote-files nil
      auto-revert-stop-on-user-input t
      revert-without-query nil)
(add-hook 'dired-mode-hook #'auto-revert-mode)

;; long file sync read
(require 'so-long)
(global-so-long-mode 1)
(setq so-long-threshold 2500
      so-long-max-lines 200
      large-file-warning-threshold (* 50 1024 1024))

;; 平滑滚动
(setq scroll-margin 2
      scroll-conservatively 101
      scroll-step 1
      mouse-wheel-scroll-amount '(1)
      mouse-wheel-progressive-speed nil)
(pixel-scroll-precision-mode t)

;; 包管理
(setq package-archives '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
                         ("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(setq package-check-signature nil)

;; sesston state
(use-package savehist
  :ensure nil
  :hook (after-init . savehist-mode)
  :config
  (setq savehist-additional-variables '(search-ring regexp-search-ring kill-ring)
        savehist-file (locate-user-emacs-file "history")))
(save-place-mode 1)
(setq recentf-max-saved-items 500
      recentf-max-menu-items 30)
(recentf-mode 1)

;; use-package
(setq use-package-always-ensure t
      use-package-verbose nil
      use-package-expand-minimally t)

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

;; 主动空闲 GC
(run-with-idle-timer 20 t (lambda ()
                            (when (> gc-cons-threshold (* 96 1024 1024))
                              (garbage-collect))))

;; 保存后恢复常规阈值
(defun my-gc-restore () (my-gc-set my-gc-small-threshold))
(add-hook 'after-save-hook #'my-gc-restore)

;; Projectile
(use-package projectile
  :ensure t
  :init
  (setq projectile-keymap-prefix (kbd "C-c p"))
  (projectile-mode +1)
  :config
  (projectile-mode +1)
  (setq projectile-completion-system 'helm)
  (setq projectile-enable-caching t)
  (setq projectile-auto-discover t)
  (setq projectile-project-search-path
        '("~/Documents/Code" "~/Documents" "~/Desktop" "~/Custom"))
  (setq projectile-indexing-method (if (executable-find "fd") 'alien 'native))
  (when (executable-find "fd")
    (setq projectile-generic-command "fd . -0 --type f --color=never")))

(setq project-vc-extra-root-markers
      '("build.gradle" "build.gradle.kts" "settings.gradle" "settings.gradle.kts"
        "pom.xml" "gradlew" "mvnw" "package.json" "pnpm-workspace.yaml"
        "CMakeLists.txt" "pyproject.toml" "setup.py" "go.mod" ".project"))

(use-package helm
  :ensure t
  :defer t
  :config
  (setq helm-split-window-inside-p t
        helm-move-to-line-cycle-in-source t
        helm-scroll-amount 8
        helm-echo-input-in-header-line t))

(use-package helm-projectile
  :ensure t
  :defer t
  :config
  (helm-projectile-mode 1))

(run-with-idle-timer 1 nil
                     (lambda ()
                       (with-demoted-errors "helm-projectile: %S"
                         (require 'helm-projectile))))

;; Ivy
(use-package ivy
  :ensure t
  :defer 0.5
  :config (ivy-mode 1))

;; Company
(use-package company
  :hook (prog-mode . company-mode)
  :custom
  (company-idle-delay 0.1)
  (company-minimum-prefix-length 0)
  (company-tooltip-limit 12)
  (company-tooltip-align-annotations t)
  (company-tooltip-flip-when-above t)
  (company-selection-wrap-around t)
  (company-require-match nil)
  (company-show-numbers t)
  (company-backends '((company-capf :with company-yasnippet)
                      company-files
                      (company-dabbrev-code company-dabbrev)
                      company-keywords))
  (company-dabbrev-downcase nil))

;; Prescient
(use-package prescient
  :ensure t
  :after company
  :config
  (setq prescient-filter-method '(literal prefix flex)
        prescient-save-file (locate-user-emacs-file "prescient-save.el")
        prescient-history-length 1000
        prescient-use-case-folding t
        completion-ignore-case t))

(use-package company-prescient
  :ensure t
  :after (company prescient)
  :config
  (company-prescient-mode 1)
  (prescient-persist-mode 1)
  (setq company-prescient-sort-length-enable nil))

(require 'ai_minuet)

;; Orderless
(use-package orderless
  :ensure t
  :defer t
  :init
  (setq completion-styles '(orderless basic)
	completion-category-overrides '((eglot (styles orderless)))
	orderless-matching-styles '(orderless-literal
                                    orderless-prefixes
                                    orderless-flex)))

(global-set-key (kbd "C-M-i") 'company-complete)

;; flymake
(setq flymake-show-diagnostics-at-end-of-line nil)
;; (setq flymake-show-diagnostics-at-end-of-line 'short)

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
  :init (setq mc/always-run-for-all t))

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

;; Dired
(setq find-file-run-dired t
      dired-recursive-deletes 'always)

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

(dolist (c (number-sequence ?a ?z))
  (let ((up (upcase c)))
    (define-key key-translation-map (vector (logior #x4000000 up)) (vector up))))

(defun my-restore-shifted-letter (&rest _)
  (let* ((keys (this-command-keys-vector))
         (n (length keys)))
    (when (= n 1)
      (let* ((last (aref keys 0))
             (base (and (integerp last) (event-basic-type last))))
        (when (and (integerp base) (<= ?A base) (<= base ?Z)
                   (memq 'control (event-modifiers last)))
          (insert (char-to-string base)))))))
(advice-add 'undefined :before #'my-restore-shifted-letter)

(provide 'base)
