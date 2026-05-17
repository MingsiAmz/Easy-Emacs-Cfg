;; lsp mode
(with-eval-after-load 'lsp-mode
  (setenv "CPATH" "C:/Custom/Lib/msys2/mingw64/include;C:/Custom/Lib/msys2/usr/include")
  (setenv "C_INCLUDE_PATH" "C:/Custom/Lib/msys2/mingw64/include")
  (setenv "CPLUS_INCLUDE_PATH" "C:/Custom/Lib/msys2/mingw64/include/c++/16.1.0"))

(use-package lsp-mode
  :ensure t
  :hook ((c-mode c++-mode java-mode) . lsp-deferred)
  :config
  (setq lsp-completion-provider :capf
        lsp-diagnostics-provider :none
        lsp-enable-symbol-highlighting nil
        lsp-enable-on-type-formatting nil
        lsp-idle-delay 0.5))

(use-package emmet-mode
  :hook (web-mode . emmet-mode))

(let* ((msys2-base "C:/Custom/Lib/msys2")
       (mingw64-bin (concat msys2-base "/mingw64/bin"))
       (msys2-usr-bin (concat msys2-base "/usr/bin")))
  (setenv "PATH" (concat mingw64-bin ";" msys2-usr-bin ";" (getenv "PATH")))
)

(provide 'lsp)
