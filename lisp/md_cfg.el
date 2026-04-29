(use-package markdown-mode
  :ensure t
  :mode (("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :hook (markdown-mode . my/markdown-config)
  :config
  (defun my/markdown-config ()
    (setq markdown-command "pandoc"
          markdown-open-command "start")))

(provide 'md_cfg)
