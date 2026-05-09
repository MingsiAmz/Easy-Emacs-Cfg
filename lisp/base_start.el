(prefer-coding-system 'utf-8-unix)
(prefer-coding-system 'utf-8-dos)  
(set-default-coding-systems 'utf-8-unix)
(global-set-key (kbd "<f5>") 'shell)
(setq default-buffer-file-coding-system 'utf-8)

(when (not (bound-and-true-p *is_window*))
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8))
(if (bound-and-true-p *is_window*)
    (progn
      (setq file-name-coding-system 'gbk-dos)  
      (setq w32-unicode-filenames t))
  (setq file-name-coding-system 'utf-8))

(if (bound-and-true-p *is_window*)
    (setq process-coding-system-alist
          '(("gcc" . gbk-dos)      
            ("g\\+\+" . gbk-dos)
            ("cl" . gbk-dos)       
            (".*" . utf-8-dos)))   
  (setq process-coding-system-alist '((".*" . utf-8-unix))))

(if (bound-and-true-p *is_window*)
    (setq compilation-coding-system 'gbk-dos)
  (setq compilation-coding-system 'utf-8-unix))

(set-language-environment "UTF-8")

(when (bound-and-true-p *is_window*)
  (setenv "LANG" "en_US.UTF-8")
  (setenv "LC_ALL" "en_US.UTF-8")
  )

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)

(setq gc-cons-threshold most-positive-fixnum)

(setq-default tab-width 8)
(setq tab-always-indent nil)

(global-auto-revert-mode 1)

(provide 'base_start)
