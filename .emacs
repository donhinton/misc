;; -*- emacs-list -*-


(define-generic-mode 'bnf-mode
  '("#")
  nil
  '(("^<.*?>" . 'font-lock-variable-name-face)
    ("<.*?>" . 'font-lock-keyword-face)
    ("::=" . 'font-lock-warning-face)
    ("\|" . 'font-lock-warning-face))
  '("\\.bnf\\.pybnf\\'")
  nil
  "Major mode for BNF highlighting.")



(setq user-full-name '"Don Hinton")
(setq user-mail-address '"hintonda@gmail.com")

;; Goto line like in XEmacs:
(define-key global-map (kbd "M-g") 'goto-line)

(require 'ido)
(ido-mode 'buffers)
(setq ido-ignore-buffers '("^ " "*Completions*" "*Shell Command Output*"
			   "*Messages*" "Async Shell Command"))

;; uniquify
;; give buffers more intelligent names
(require 'uniquify)
;; create unique buffer names with sahred directory components
(setq uniquify-buffer-name-style 'forward)

(add-to-list 'load-path "~/site-lisp")

;; color scheme
(require 'color-theme)
(add-to-list 'custom-theme-load-path "~/site-lisp/color-theme")
(load-theme 'dark-laptop t)

(require 'cc-mode)
(load '"~/site-lisp/emacs.el")
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

(require 'clang-format)
(require 'git)
(require 'json)
(load '"~/site-lisp/graphviz-dot-mode")

(require 'my_autoinsert)
(setq auto-insert-directory '"~/site-lisp/insert")

(require 'tablegen-mode)

(require 'llvm-mode)

(require 'cmake-mode)
(setq auto-mode-alist
      (append '(("CMakeLists\\.txt\\'" . cmake-mode)
		("\\.cmake\\'" . cmake-mode))
	      auto-mode-alist))

(menu-bar-mode -1)

(setq auto-revert-interval 1)
;; global auto revert
(global-auto-revert-mode t)

(setq-default tab-width 2)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes (quote ("400994f0731b2109b519af2f2d1f022e7ced630a78890543526b9342a3b04cf1" default)))
 '(safe-local-variable-values (quote ((related-file-name . "../include/click/driver.hh") (related-file-name . "../include/click/userutils.hh") (related-file-name . "../../lib/master.cc") (related-file-name . "../../lib/router.cc") (related-file-name . "../../../elements/standard/scheduleinfo.cc"))))
 '(tab-stop-list (quote (2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 52 54 56 58 60 62 64 68 70 72 74 76 78 80))))

;; don't show startup message
(setq inhibit-startup-message t)

;; don't need shift for undo
(global-set-key [(control -)] 'undo)

;; turn on pending delete (when region is selected, typing replaces it)
(delete-selection-mode t)

;; when on a tab, make cursor tab length
(setq-default x-stretch-cursor t)

;; enable line/column display on status line
(setq line-number-mode t)
(setq column-number-mode t)

;; replace "yes or no" with "y or n"
(defun yes-or-no-p (arg)
  "An alias for y-or-n-p, because I hate having to type 'yes' or 'no'."
  (y-or-n-p arg))

;; show time in 24 hour clock
(setq display-time-24hr-format t)
(display-time)

;; enable contex coloring
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;; don't use tabs, ever
;;(setq-default indent-tabs-mode nil)

;; set default tab width 2
;;(setq-default tab-width 2)

;; always end file with newline (makes other tools happy)
(setq require-final-newline t)

;; stop at end of file, just keep adding lines
(setq next-line-add-newline nil)

;; visual feedback on selections
(setq-default transient-mark-mode t)

;; highlight matching parens
(show-paren-mode)

;; save place in file on re-visiting
(toggle-save-place-globally)

;; recent file completion
(recentf-mode 1)
;; enable multiple minibuffers
(setq minibuffer-max-depth nil)

(icomplete-mode nil) ;completion in mini-buffer
(setq frame-title-format "%b - emacs") ; use buffer name as fram title
(global-set-key "\C-x\C-b" 'buffer-menu) ;C-x C-b pust point on buffer list
(setq ispell-dictionary "english")
(setq calendar-week-start-day 1) ; week starts on monday
(setq undo-limit 1000000) ; increase undo limit


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
