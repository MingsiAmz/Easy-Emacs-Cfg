(use-package web-mode
  :ensure t
  :mode (("\\.html?\\'" . web-mode)
         ("\\.css\\'" . web-mode)
         ("\\.scss\\'" . web-mode)
         ("\\.vue\\'" . web-mode))
  :hook (web-mode . my/web-config)
  :config
  (defun my/web-config ()
    (setq web-mode-markup-indent-offset 2
          web-mode-css-indent-offset 2
          web-mode-code-indent-offset 2)
    (lsp-deferred)))

(provide 'web_cfg)
