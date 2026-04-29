(use-package doom-themes
  :ensure t
  :demand t
  :init
  :config
  (load-theme 'doom-one t)
  
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

(use-package dracula-theme)

(provide 'init_theme)
