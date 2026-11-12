;;; eg_java.el --- Java (jdtls + eglot) -*- lexical-binding: t; -*-

(defgroup my-java nil
  "Java (jdtls + eglot) 开发环境配置"
  :group 'languages)

(defcustom my-jdtls-dir "C:/Users/Administrator/Custom/Lib/Java/jdtls/"
  "jdtls 安装目录（包含 plugins/org.eclipse.equinox.launcher_*.jar）"
  :type 'directory)

(defcustom my-java-executable nil
  "Java 可执行文件路径；为 nil 时使用 PATH 上的 `java'"
  :type '(choice (const :tag "PATH 上的 java" nil) file))

(defun my-jdtls-launcher ()
  (or (car (file-expand-wildcards
            (expand-file-name "plugins/org.eclipse.equinox.launcher_*.jar" my-jdtls-dir)))
      (user-error "jdtls launcher 不存在，请检查 my-jdtls-dir: %s" my-jdtls-dir)))

(defun my-jdtls-workspace-dir ()
  (let* ((root (or (ignore-errors
                     (file-name-as-directory
                      (expand-file-name (project-root (project-current)))))
                   (file-name-as-directory (expand-file-name default-directory))))
         (slug (replace-regexp-in-string
                "[^A-Za-z0-9._-]" "_"
                (file-name-nondirectory (directory-file-name root))))
         (slug (substring slug 0 (min (length slug) 40)))
         (dir (expand-file-name
               (format "emacs-jdtls/%s-%08x" slug (abs (sxhash root)))
               (or (getenv "APPDATA") temporary-file-directory))))
    (make-directory dir t)
    dir))

(defun my-jdtls-base-command ()
  (let ((java (or my-java-executable "java")))
    (list java
          "-Declipse.application=org.eclipse.jdt.ls.core.id1"
          "-Dosgi.bundles.defaultStartLevel=4"
          "-Declipse.product=org.eclipse.jdt.ls.core.product"
          "-Dlog.level=WARN"
          "-Xms256m" "-Xmx1g"
          "-jar" (my-jdtls-launcher)
          "-configuration" (expand-file-name "config_win" my-jdtls-dir)
          "-data" (my-jdtls-workspace-dir))))

(defun my-jdtls-command (&optional _interactive _project)
  (let ((cmd (my-jdtls-base-command)))
    (if (my-jdtls-eclipse-project-p)
        (append cmd
                (list :initializationOptions
                      (list :settings
                            (list :java
                                  (list :import
                                        (list :gradle
                                              (list :enabled :json-false)))))))
      cmd)))

(use-package eglot-java
  :ensure t
  :hook (java-mode . eglot-java-mode)
  :bind (:map eglot-java-mode-map ("C-c j R" . eglot-java-project-build-refresh))
  :config
  (setq eglot-java-eglot-server-programs-manual-updates t)
  (setq eglot-java-server-install-dir my-jdtls-dir)

  (with-eval-after-load 'eglot
    (push `((java-mode java-ts-mode) . ,#'my-jdtls-command)
          eglot-server-programs)))

(defcustom my-jdtls-init-script
  (expand-file-name "etc/emacs-ide.gradle" user-emacs-directory)
  "用于生成 .project/.classpath 的 Gradle init 脚本路径。"
  :type 'file)

(defun my-jdtls-project-root ()
  (file-name-as-directory
   (expand-file-name (or (ignore-errors (project-root (project-current t)))
                         default-directory))))

(defun my-jdtls-eclipse-project-p (&optional root)
  (file-exists-p (expand-file-name ".classpath" (or root (my-jdtls-project-root)))))

(defun my-jdtls-sync-classpath (&optional arg)
  (interactive "P")
  (let* ((root (my-jdtls-project-root))
         (gradlew (expand-file-name (if (eq system-type 'windows-nt) "gradlew.bat" "gradlew") root))
         (default-directory root)
         (buf "*my-jdtls-sync*"))
    (unless (file-exists-p gradlew)
      (user-error "这里不是 Gradle 工程：%s" root))
    (unless (file-exists-p my-jdtls-init-script)
      (user-error "缺少 Gradle init 脚本：%s" my-jdtls-init-script))
    (message "正在生成类路径（gradle emacsIdeFiles）…")
    (let* ((args (concat "\"" gradlew "\" --offline -q -I \""
                         my-jdtls-init-script "\" emacsIdeFiles"))
           (code (call-process shell-file-name nil buf t
                               shell-command-switch args)))
      (with-current-buffer buf
        (message "类路径生成%s：%s"
                 (if (zerop code) "完成" "失败")
                 (string-trim (buffer-substring-no-properties (point-min) (point-max))))))
    (unless arg
      (when-let* ((server (eglot-current-server)))
        (ignore-errors (eglot-shutdown server 1 nil t)))
      (let ((ws (my-jdtls-workspace-dir)))
        (when (file-directory-p ws) (delete-directory ws t)))
      (my-jdtls-apply-workspace-config t)
      (eglot-ensure)
      (message "已重新导入；jdtls 启动后 %s 等依赖即可补全" "PlayerAnimationFactory"))))

(defun my-jdtls-apply-workspace-config (&optional force)
  (when (or force (my-jdtls-eclipse-project-p))
    (let* ((base (default-value 'eglot-workspace-configuration))
           (java (copy-sequence (plist-get base :java)))
           (java (plist-put java :import '(:gradle (:enabled :json-false)))))
      (setq-local eglot-workspace-configuration
                  (plist-put (copy-sequence base) :java java)))))

(defvar-local my-jdtls-hinted nil)

(defun my-jdtls-maybe-hint ()
  (when (and (derived-mode-p 'java-mode 'java-ts-mode)
             (my-jdtls-project-root)
             (not (my-jdtls-eclipse-project-p))
             (file-exists-p (expand-file-name "build.gradle" (my-jdtls-project-root)))
             (not (bound-and-true-p my-jdtls-hinted)))
    (setq-local my-jdtls-hinted t)
    (message "这是 Gradle 工程但还没有 .classpath；若库类（如 PlayerAnimationFactory）没有补全，按 C-c j c 生成类路径并重连 jdtls")))

(add-hook 'java-mode-hook #'my-jdtls-apply-workspace-config)
(add-hook 'java-ts-mode-hook #'my-jdtls-apply-workspace-config)
(add-hook 'java-mode-hook #'my-jdtls-maybe-hint)
(with-eval-after-load 'eglot-java
  (define-key eglot-java-mode-map (kbd "C-c j c") #'my-jdtls-sync-classpath))

(provide 'eg_java)
