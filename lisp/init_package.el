;; 包管理器配置（使用清华镜像）
(require 'package)
(setq package-archives '(("gnu"    . "https://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
("nongnu" . "https://mirrors.tuna.tsinghua.edu.cn/elpa/nongnu/")
("melpa"  . "https://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))
(setq package-check-signature nil)  
;; 初始化包管理器
(package-initialize)
;; 刷新包索引
(unless package-archive-contents
  (package-refresh-contents))
;; 安装包管理工具
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))  

;; default use-package config
(eval-and-compile
  (setq use-package-always-ensure t)
  (setq use-package-always-defer t)
  (setq use-package-always-demand nil)
  (setq use-package-expand-minimally t)
  (setq use-package-verbose t))

(require 'use-package)

(provide 'init_package)
