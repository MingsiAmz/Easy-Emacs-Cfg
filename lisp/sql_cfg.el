(use-package sql
  :ensure nil
  :mode ("\\.sql\\'" . sql-mode)
  :hook (sql-mode . my/sql-config)
  :config
  (defun my/sql-config ()
    (setq sql-product 'mysql)))

(provide 'sql_cfg)
