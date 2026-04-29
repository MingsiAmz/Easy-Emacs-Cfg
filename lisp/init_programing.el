(use-package lsp-mode
  :ensure t
  :hook ((python-mode . lsp-deferred)
         (java-mode . lsp-deferred)
         (c-mode . lsp-deferred)
         (c++-mode . lsp-deferred)
         (js-mode . lsp-deferred)
         (typescript-mode . lsp-deferred)
         (go-mode . lsp-deferred)
	 (js2-mode . lsp-deferred)
         (typescript-mode . lsp-deferred)
         (json-mode . lsp-deferred))
)

(use-package lsp-ui
  :ensure t
  :after lsp-mode
  :config
  (setq lsp-ui-doc-position 'at-point
        lsp-ui-sideline-enable nil))

(use-package lsp-pyright
  :ensure t
  :defer t
)

(use-package emmet-mode
  :ensure t
  :hook (web-mode . emmet-mode))

(require 'java_cfg)
(require 'python_cfg)
(require 'js_cfg)
(require 'cc_cfg)
(require 'go_cfg)
(require 'rust_cfg)
(require 'web_cfg)
(require 'sql_cfg)
(require 'md_cfg)
(require 'profile_cfg)

(provide 'init_programing)
