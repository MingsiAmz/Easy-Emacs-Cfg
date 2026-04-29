(use-package json-mode
  :ensure t
  :mode ("\\.json\\'" . json-mode)
  :hook (json-mode . (lambda () (setq js-indent-level 2))))

(use-package yaml-mode
  :ensure t
  :mode ("\\.ya?ml\\'" . yaml-mode))

(use-package toml-mode
  :ensure t
  :mode ("\\.toml\\'" . toml-mode))

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind-keymap ("C-c p" . projectile-command-map))

(provide 'profile_cfg)
