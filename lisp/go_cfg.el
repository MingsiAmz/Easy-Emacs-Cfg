(use-package go-mode
  :ensure t
  :mode ("\\.go\\'" . go-mode)
  :hook (go-mode . my/go-config)
  :config
  (defun my/go-config ()
    (setq tab-width 4
          indent-tabs-mode t)
    (lsp-deferred)
    (local-set-key (kbd "C-c C-r") 'go-run)))

(provide 'go_cfg)
