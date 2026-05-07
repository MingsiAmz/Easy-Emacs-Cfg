(setenv "JAVA_HOME" "C:/Custom/Lib/Java/jdk-21")
(setenv "PATH" (concat (getenv "JAVA_HOME") "/bin;" (getenv "PATH")))
(add-to-list 'exec-path (concat (getenv "JAVA_HOME") "/bin"))

;; LSP Java
(use-package lsp-java
  :ensure t
  :mode ("\\.java\\'" . java-mode)
  :hook (java-mode . lsp-deferred)
  :config
  (setq lsp-java-workspace-dir "~/.emacs.d/java-workspace/"))

(defun java-project-root ()
  (let ((dir (locate-dominating-file default-directory "pom.xml")))
    (if dir dir (locate-dominating-file default-directory "build.gradle"))))

(defun java-run ()
  (interactive)
  (let* ((root (java-project-root))
         (file (buffer-file-name))
         (class-name (file-name-sans-extension (file-name-nondirectory file)))
         (build-dir "./bin"))
    (if root
        (cond
         ((file-exists-p (expand-file-name "pom.xml" root))
          (compile "mvn compile exec:java -Dexec.mainClass=???"))
         ((file-exists-p (expand-file-name "build.gradle" root))
          (compile "gradle build run")))
      (progn
        (unless (file-exists-p build-dir) (make-directory build-dir t))
        (compile (format "javac -d %s %s && java -cp %s %s"
                         build-dir file build-dir class-name))))))

;; gradle 配置
(use-package gradle-mode
  :ensure t
  :hook (java-mode . gradle-mode)
  :config
  (setq gradle-executable "gradlew.bat")
  (setq gradle-switch-to-compilation-buffer t))

;; java运行函数配置
(defun javarun ()
  (interactive)
  (let* ((build-dir "./bin")
         (file (buffer-file-name))
         (class-name (file-name-sans-extension (file-name-nondirectory file)))
         (compile-cmd (format "javac -d %s %s" build-dir file))
         (run-cmd (format "java -cp %s %s" build-dir class-name)))
    (when (not (file-exists-p build-dir))
      (make-directory build-dir t))
    (compile (concat compile-cmd " && " run-cmd))))

(provide 'java_cfg)
