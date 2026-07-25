;;; eglot_custom.el -*- lexical-binding: t; -*-

(require 'eglot)

(when (eq system-type 'windows-nt)
  (setq process-connection-type nil
        w32-pipe-buffer-size 65536
        w32-pipe-read-delay 0))

(add-hook 'c-mode-hook      #'eglot-ensure)
(add-hook 'c++-mode-hook    #'eglot-ensure)
(add-hook 'python-mode-hook #'eglot-ensure)
(add-hook 'java-mode-hook   #'eglot-ensure)
(add-hook 'java-ts-mode-hook #'eglot-ensure)

(setq eglot-autoshutdown t
      eglot-sync-connect nil
      eglot-report-progress nil
      eglot-connect-timeout 60
      eglot-send-changes-idle-time 0.5
      flymake-no-changes-timeout 1.5
      eglot-events-buffer-size 0)

(defun my/eglot-init-options (orig server)
  (let ((opts (funcall orig server)))
    (append (if (listp opts) opts nil)
            (list :extendedClientCapabilities (list :classFileContentsSupport t)
                  :settings (list :java (list :contentProvider (list :preferred "fernflower")
                                               :references (list :includeDecompiledSources t)
                                               :saveActions (list :organizeImports t)
                                               :import (list :enabled t)))))))
(advice-add 'eglot-initialization-options :around #'my/eglot-init-options)

;; jdt:// 反编译
(defvar eglot-jdt-cache (expand-file-name "jdt-cache" temporary-file-directory))
(defun eglot-jdt-uri-to-path (orig uri)
  (if (not (string-prefix-p "jdt://" uri))
      (funcall orig uri)
    (let ((file (expand-file-name (secure-hash 'md5 uri) eglot-jdt-cache)))
      (unless (file-exists-p file)
        (make-directory eglot-jdt-cache t)
        (with-temp-file file
          (insert (jsonrpc-request (eglot-current-server)
                   :java/classFileContents (list :uri uri)))))
      file)))
(if (fboundp 'eglot-uri-to-path)
    (advice-add 'eglot-uri-to-path :around #'eglot-jdt-uri-to-path)
  (advice-add 'eglot--uri-to-path :around #'eglot-jdt-uri-to-path))

;; ---- DAP ----
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
