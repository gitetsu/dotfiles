(setq load-path (cons "~/.emacs.d/elisp" load-path))

(global-set-key "\C-h" 'delete-backward-char)

(setq tab-width 4)

(prefer-coding-system 'utf-8-unix)

(global-font-lock-mode t)

(setq-default transient-mark-mode t)

(line-number-mode t)
(column-number-mode t)

;; install-elisp
(require 'install-elisp)
(setq install-elisp-repository-directory "~/.emacs.d/elisp/")

;; auto-complete
(require 'auto-complete)
(global-auto-complete-mode t)

;; linum
(require 'linum)
(global-linum-mode)

;; jaspace
(require 'jaspace)
(setq jaspace-alternate-eol-string "<\n")
(setq jaspace-highlight-tabs ">")

;; molokai
(load "~/.emacs.d/elisp/color-theme-molokai.el")
(color-theme-molokai)

;; php-mode
(load-library "php-mode")
(require 'php-mode)
(add-hook 'php-mode-user-hook
	    '(lambda ()
	         (setq tab-width 2)
		      (setq indent-tabs-mode nil)))