(setq company-tooltip-align-annotations t)
(setq company-show-quick-access t)

(use-package company
  :hook (after-init . global-company-mode)
  :config (setq company-minimum-prefix-length 1
                company-show-quick-access t))

(use-package swiper
  :ensure t
  :bind (("C-s" . swiper)           
         ("C-r" . swiper)))
(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)
         ("C-c g" . counsel-git)
         ("C-c r" . counsel-rg)))   

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) "))

(use-package flycheck
  :ensure t
  :hook (after-init . global-flycheck-mode)
  :bind (("C-c n" . flycheck-next-error)
         ("C-c p" . flycheck-previous-error)
	 ("C-c l" . flycheck-list-errors))
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enabled)
        flycheck-idle-change-delay 0.5))

(use-package dumb-jump
  :ensure t
  :bind (("C-c j" . dumb-jump-go)
         ("C-c n" . dumb-jump-back)))

(provide 'use_other_package)
