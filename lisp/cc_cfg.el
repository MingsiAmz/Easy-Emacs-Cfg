(when (eq system-type 'windows-nt)
  (let ((mingw64-root "C:/Custom/Lib/msys2/mingw64")
        (msys2-root "C:/Custom/Lib/msys2"))
    
    (setenv "PATH" (concat mingw64-root "/bin;"
                          msys2-root "/usr/bin;"
                          (getenv "PATH")))
    (setq exec-path (append (list (concat mingw64-root "/bin")
                                  (concat msys2-root "/usr/bin"))
                            exec-path))
    
    (setenv "C_INCLUDE_PATH" (concat mingw64-root "/include"))
    (setenv "CPLUS_INCLUDE_PATH" (concat mingw64-root "/include/c++/14.2.0;"
                                        mingw64-root "/include/c++/14.2.0/x86_64-w64-mingw32;"
                                        mingw64-root "/include/c++/14.2.0/backward;"
                                        mingw64-root "/include"))
    (setenv "LIBRARY_PATH" (concat mingw64-root "/lib"))
    
    (setenv "LANG" "C")
    (setenv "LC_ALL" "C")
    
    (setq compilation-coding-system 'utf-8-dos)
    
    (setq compilation-environment
          `("LANG=C"
            "LC_ALL=C"
            ,(concat "C_INCLUDE_PATH=" (getenv "C_INCLUDE_PATH"))
            ,(concat "CPLUS_INCLUDE_PATH=" (getenv "CPLUS_INCLUDE_PATH"))
            ,(concat "LIBRARY_PATH=" (getenv "LIBRARY_PATH"))))))

(use-package cc-mode
  :ensure nil
  :mode (("\\.c\\'" . c-mode)
         ("\\.h\\'" . c-mode)
         ("\\.cpp\\'" . c++-mode)
         ("\\.hpp\\'" . c++-mode)
         ("\\.cc\\'" . c++-mode)
         ("\\.cxx\\'" . c++-mode))
  :hook ((c-mode . my/c-mode-config)
         (c++-mode . my/cpp-mode-config))
  :config
  (defun my/c-mode-config ()
    (setq c-basic-offset 4
          tab-width 4
          indent-tabs-mode nil)
    (when (and buffer-file-name (executable-find "clangd"))
      (lsp-deferred)))
  
  (defun my/cpp-mode-config ()
    (setq c-basic-offset 4
          tab-width 4
          indent-tabs-mode nil)
    (setq-local c-default-style "linux")
    (when (executable-find "clangd")
      (lsp-deferred)))
  
)

(defun my/check-cpp-environment ()
  (interactive)
  (message "GCC: %s" (if (executable-find "gcc") "Found" "Missing"))
  (message "Clangd: %s" (if (executable-find "clangd") "Found" "Missing"))
  (message "LSP status: %s" (if (bound-and-true-p lsp-mode) "Active" "Inactive")))

(provide 'cc_cfg)
