(setq python-shell-interpreter "python")
(setq python-shell-interpreter-args "-i")

;; 禁用部分优化
(setq python-shell-interpreter-args "-i -u -c \"import sys; sys.stdout.reconfigure(line_buffering=True)\"")
(use-package python-mode
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :hook (python-mode . my/python-config)
  :config
  (defun my/python-config ()
    (setq indent-tabs-mode nil
          python-indent-offset 4)
    (require 'lsp-pyright)
    (lsp-deferred)))

(defun pythonrun ()
  (interactive)
  (compile (format "set PYTHONIOENCODING=utf-8 && python \"%s\"" (buffer-file-name))))

(provide 'python_cfg)
