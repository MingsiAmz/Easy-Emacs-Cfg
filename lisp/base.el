;; 环境变量
(when (eq system-type 'windows-nt)
  (setenv "PATH" (string-trim-right (shell-command-to-string "echo %PATH%"))))

;; 界面 & 基础行为
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode t)
(global-auto-revert-mode 1)
(set-face-attribute 'default nil :font "等距更纱黑体 SC" :height 160)
(setq inhibit-startup-screen t
      ring-bell-function 'ignore
      auto-revert-interval 1)
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
(setq auto-revert-remote-files nil
      auto-revert-stop-on-user-input t
      revert-without-query nil)
(add-hook 'dired-mode-hook #'auto-revert-mode)
(global-auto-revert-mode -1)

;; 平滑滚动
(setq scroll-margin 2
      scroll-conservatively 101
      scroll-step 1
      pixel-scroll-precision-mode t
      mouse-wheel-scroll-amount '(1)
      mouse-wheel-progressive-speed nil)

;; 包管理
;; (setq package-archives '(("gnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
;;                          ("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
;;                          ("melpa" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/"))
;;       package-check-signature nil
;;       package-enable-at-startup nil
;;       package-quickstart nil)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(package-initialize)

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
;; (electric-indent-mode -1)

;; Projectile
(use-package projectile
  :ensure t
  :diminish projectile-mode
  :config
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
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
  :config (ivy-mode 1))

;; Company
(use-package company
  :ensure t
  :hook ((prog-mode        . company-mode)  
         (java-mode       . company-mode)
         (java-ts-mode    . company-mode)
         (c-mode          . company-mode)
         (c++-mode        . company-mode)
         (python-mode     . company-mode)
         (js-mode         . company-mode)
         (typescript-mode . company-mode)
	 (html-mode . company-mode))
  :config
  (setq company-idle-delay 0                
        company-minimum-prefix-length 1     
        company-tooltip-limit 8
        company-tooltip-max-width 50
        company-tooltip-flip-when-above t
        company-require-match nil           
        company-frontends '(company-pseudo-tooltip-frontend
                            company-echo-metadata-frontend)
        company-backends '((company-capf :with company-dabbrev))
        company-dabbrev-other-buffers 'code
        company-dabbrev-ignore-case t
        company-dabbrev-minimum-prefix-length 3
        completion-ignore-case t)
  (setq company-auto-complete nil)
  (setq company-auto-complete-chars nil))

;; Orderless
(use-package orderless
  :ensure t
  :config (setq completion-styles '(orderless basic)))

;; Drag stuff
(use-package drag-stuff
  :ensure t
  :bind (("M-p" . drag-stuff-up)
         ("M-n" . drag-stuff-down)))

;; Multiple cursors
(use-package multiple-cursors
  :ensure t
  :config (setq mc/always-run-for-all t))

;; Swiper
(use-package swiper
  :ensure t
  :bind (("C-s" . swiper)))

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

;; Magit
(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status)
  :config
  (setq magit-commit-arguments '("--encoding=UTF-8"))
  (global-set-key (kbd "C-x v c") 'magit-commit))

;; YASnippet
(use-package yasnippet
  :ensure t
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets
  :ensure t
  :after yasnippet)



(provide 'base)
