(use-package rust-mode
  :ensure t
  :mode ("\\.rs\\'" . rust-mode)
  :hook (rust-mode . my/rust-config)
  :config
  (defun my/rust-config ()
    (setq rust-format-on-save t
          rust-indent-offset 4)
    (lsp-deferred)))

(provide 'rust_cfg)
