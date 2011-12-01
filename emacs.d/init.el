;; load-pathを追加する関数を定義
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
	(if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))

;; elispとconfディレクトリをサブディレクトリごとにload-pathに追加
(add-to-load-path "elisp" "conf")

;; (install-elisp "http://www.emacswiki.org/emacs/download/auto-install.el")
(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/elisp/")
  (auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup))

(keyboard-translate ?\C-h ?\C-?)
(global-set-key (kbd "C-x ?") 'help-command)

(setq tab-width 4)

(set-language-environment "Japanese")
(prefer-coding-system 'utf-8-unix)
(setq file-name-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)

(setq show-paren-delay 0)
(show-paren-mode t)
(setq show-paren-style 'expression)


(global-font-lock-mode t)

(setq-default transient-mark-mode t)

(global-linum-mode)

;; install-elisp
(require 'install-elisp)
(setq install-elisp-repository-directory "~/.emacs.d/elisp/")

;; auto-complete
(require 'auto-complete)
(global-auto-complete-mode t)

;; jaspace
(require 'jaspace)
(setq jaspace-alternate-eol-string "<\n")
(setq jaspace-highlight-tabs ">")

;; molokai
;;(when (require 'color-theme nil t)
(load "~/.emacs.d/elisp/color-theme-molokai.el")
;;  (color-theme-initialize)
  (color-theme-molokai)

;; redo+
;; http://www.emacswiki.org/emacs/download/redo%2b.el
(when (require 'redo+ nil t)
  (global-set-key (kbd "C-'") 'redo))


;; php-mode
(load-library "php-mode")
(require 'php-mode)
(add-hook 'php-mode-user-hook
	    '(lambda ()
	         (setq tab-width 2)
		      (setq indent-tabs-mode nil)))

;; sr-speedbar
;; install-elisp-from-emacswiki
(require 'sr-speedbar)
(setq sr-speedbar-right-side nil)

;; AceJump
;; https://raw.github.com/winterTTr/ace-jump-mode/770419b7f67424c6559e5090d860c5328b81a599/ace-jump-mode.el
(require 'ace-jump-mode)
(define-key global-map (kbd "C-c p") 'ace-jump-mode)