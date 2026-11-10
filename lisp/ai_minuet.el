(use-package minuet
  :ensure t
  :hook (prog-mode . minuet-auto-suggestion-mode)
  :init
  (setq minuet-provider 'openai-fim-compatible
        minuet-n-completions 1
        minuet-context-window 1024
        minuet-request-timeout 20.0
        minuet-auto-suggestion-throttle-delay 0.8
        minuet-auto-suggestion-debounce-delay 0.4
        minuet-openai-fim-compatible-options
        '(
          :model "qwen3.5-2b"
          :end-point "http://localhost:8520/v1/completions"
          :api-key "TERM"
          :name "Local-Qwen"
          :template (:prompt minuet--default-fim-prompt-function
                             :suffix minuet--default-fim-suffix-function)
          :transform ()
          :get-text-fn minuet--openai-fim-get-text-fn
          :optional (:max_tokens 96))))
  
(global-set-key (kbd "C-c y") 'minuet-complete-with-minibuffer) 

(with-eval-after-load 'minuet
  (define-key minuet-active-mode-map (kbd "TAB") #'minuet-accept-suggestion-line)
  (define-key minuet-active-mode-map (kbd "C-j") #'minuet-accept-suggestion)
  (define-key minuet-active-mode-map (kbd "C-M-n") #'minuet-next-suggestion)
  (define-key minuet-active-mode-map (kbd "C-M-p") #'minuet-previous-suggestion)
  (define-key minuet-active-mode-map (kbd "C-g") #'minuet-dismiss-suggestion)
)

(provide 'ai_minuet)
