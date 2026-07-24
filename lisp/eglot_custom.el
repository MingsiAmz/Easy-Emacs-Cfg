;; eglot configure
(add-hook 'c-mode-hook      #'eglot-ensure)
(add-hook 'c++-mode-hook    #'eglot-ensure)
(add-hook 'python-mode-hook #'eglot-ensure)
(add-hook 'java-mode-hook   #'eglot-ensure)

(setq eglot-autoshutdown t
      eglot-sync-connect 1
      eglot-report-progress nil
      eglot-connect-timeout 30)

(setq-default eglot-workspace-configuration
              '((:java
                 (:import (:enabled t)
                  :format (:enabled t)
                  :saveActions (:organizeImports t)
                  :references (:includeDecompiledSources t)))))

(use-package dap-mode
  :ensure t
  :defer t
  :after eglot
  :config
  (dap-mode 1)
  (dap-ui-mode 1)
  (dap-tooltip-mode 1)
  (require 'dap-gdb-lldb)
  (setq dap-auto-configure-mode t))

(provide 'eglot_custom)
