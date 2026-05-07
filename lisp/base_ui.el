;; 初始化窗口
(tool-bar-mode -1)
(scroll-bar-mode -1)
(menu-bar-mode -1)  
(setq inhibit-startup-screen t)
(set-face-attribute 'default nil :font "Menlo")

;; 窗口大小设置
(setq default-frame-alist '((height . 40) (width . 140)))
(setq frame-inhibit-implied-resize t)
(set-face-attribute 'default nil :height 160)

(add-to-list 'default-frame-alist '(left . 0.5))
(add-to-list 'default-frame-alist '(top . 0.5))

(use-package emacs
  :if (display-graphic-p)
  :config
  ;; 字体设置
  (if *is_window*
      (progn
	(set-face-attribute 'default nil :font "Menlo")
	(dolist (charset '(kana han symbol cjk-misc bopomofo))
	  (set-fontset-font (frame-parameter nil 'font)
			    charset (font-spec :family "Menlo" :size 18))))
    (set-face-attribute 'default nil :font "Menlo")
    )
  (setq display-line-numbers-type 'position)
  (global-display-line-numbers-mode t)
)

(use-package ace-window 
             :bind (("M-o" . 'ace-window))
)

(provide 'base_ui)
