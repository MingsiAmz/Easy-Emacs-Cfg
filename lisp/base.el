;; 界面 & 基础行为
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode t)
(setq inhibit-startup-screen t)
(set-face-attribute 'default nil :font "Fira Code" :height 160)

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
  :hook (after-init . global-company-mode)
  :config
  (setq company-minimum-prefix-length 1
        company-idle-delay 0.1
        company-tooltip-align-annotations t))

(use-package flycheck
  :hook (prog-mode . flycheck-mode))

(use-package orderless
  :config
  (setq completion-styles '(orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles basic partial-completion)))))

;; multiple
(global-set-key (kbd "C-c m") 'mc/mark-all-dwim)
(global-set-key (kbd "C-c o") 'mc/mark-all-like-this)
(global-set-key (kbd "C-c i") 'mc/edit-lines)

;; 主题 & Dired
(use-package doom-themes
  :demand
  :config (load-theme 'doom-one t))

(setq find-file-run-dired t
      dired-recursive-deletes 'always
      dired-auto-revert-buffer t)

(provide 'base)
