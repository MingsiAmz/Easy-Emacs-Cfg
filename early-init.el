;;; early-init.el --- 启动最早期设置（先于 init.el / 图形界面初始化） -*- lexical-binding: t; -*-
;; 参考：early-init 里做包激活与外观设置，可以避免启动时先画一帧再改、
;; 也能把 package.el 的检查提前，减少可见的卡顿。

;; 1) 包系统：自己激活，避免 package.el 在启动流程里再做一次扫描
(setq package-enable-at-startup nil)
(setq package-quickstart nil)
(package-initialize)

;; 2) 关掉图形界面里我们用不到的东西（在 frame 创建前设置，避免窗口尺寸抖动）
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(setq frame-inhibit-implied-resize t
      inhibit-compacting-font-caches t)   ; Windows 上中文字体多，缓存压缩很费时

;; 3) 启动期不需要的 UI 元素与警告
(setq inhibit-startup-screen t
      inhibit-startup-echo-area-message user-login-name
      initial-scratch-message nil)

;; 4) 垃圾回收：启动阶段放宽（init.el 会在启动后恢复）
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; 5) 让 -batch / 命令行工具也用 UTF-8
(prefer-coding-system 'utf-8-unix)

(provide 'early-init)
