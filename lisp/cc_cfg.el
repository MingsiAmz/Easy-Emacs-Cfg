(use-package cc-mode
  :ensure nil
  :mode (("\\.c\\'" . c-mode)
         ("\\.h\\'" . c-mode)
         ("\\.cpp\\'" . c++-mode)
         ("\\.hpp\\'" . c++-mode))
  :hook ((c-mode c++-mode) . my/c-config)
  :config
  (defun my/c-config ()
    (setq c-basic-offset 4
          tab-width 4
          indent-tabs-mode nil)
    (lsp-deferred)))

(provide 'cc_cfg)
