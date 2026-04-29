;; LSP 服务器配置
(setq lsp-clients-javascript-typescript-server "typescript-language-server")
(setq lsp-clients-javascript-typescript-server-args
      '("--stdio" "--tcp" "--log-level" "2"))

;; Node.js REPL
(use-package nodejs-repl
  :ensure t
  :config
  (setq nodejs-repl-command "node"))

;; npm 模式
(use-package npm-mode
  :ensure t
  :hook (js2-mode . npm-mode))

;; JS2 模式
(use-package js2-mode
  :ensure t
  :mode ("\\.js\\'" . js2-mode)
  :mode ("\\.cjs\\'" . js2-mode)
  :mode ("\\.mjs\\'" . js2-mode)
  :hook (js2-mode . my/js-config)
  :config
  (defun my/js-config ()
    (setq-local tab-width tab-width)
    (setq-local indent-tabs-mode nil)
    (when (or (not (boundp 'tab-width)) (eq tab-width nil))
      (setq-local tab-width 4))
    (lsp-deferred)))

;; TypeScript 模式
(use-package typescript-mode
  :ensure t
  :mode ("\\.ts\\'" . typescript-mode)
  :mode ("\\.tsx\\'" . typescript-mode)
  :hook (typescript-mode . my/ts-config)
  :config
  (defun my/ts-config ()
    (setq-local tab-width tab-width)
    (setq-local indent-tabs-mode nil)
    (when (or (not (boundp 'tab-width)) (eq tab-width nil))
      (setq-local tab-width 4))
    (lsp-deferred)))

(provide 'js_cfg)
