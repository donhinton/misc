(defvar csc-mode-map (make-sparse-keymap) "Local keymap for csc-mode buffers.")

(defvar csc-mode-comment-start "//"

  "Comment string to use in csc-mode buffers.")

(defvar csc-mode-syntax-table (make-syntax-table)

  "Syntax table in use in csc-mode buffers.")

(defvar csc-font-lock-keywords

  '(
    (".*\\(//.+\\)" 1 'font-lock-comment-face)
    ("^\\<\\(tag\\|keys\\|constants\\|constraints\\)\\>" . 'font-lock-keyword-face)
    ("tag \\(.*\\)" 1 font-lock-function-name-face)
    ("^[\t ]*[A-Za-z_]+[\t ]+\\([A-Za-z0-9_]+\\)" 1 font-lock-variable-name-face)
    ("^[\t ]*\\<\\(short\\|u_short?\\|int\\|u_int?\\|longlong\\|u_longlong?\\|float\\|double\\|byte\\|cstring\\|pstring\\|blob\\)\\>"
     . 'font-lock-type-face)
    ("\\<\\(null\\|dbstore\\|dbload\\)\\>" 1 font-lock-keyword-face)
    ("^[\t ]*\\(dup\\|recnums\\|datacopy\\)[\t ]" 1 font-lock-builtin-face)
    ("\\<on[ ]+\\(delete\\|update\\)[ ]+cascade\\>" . font-lock-reference-face)
    )
  "Keywords to highlight in CSC mode")

(if csc-mode-syntax-table ()

  (setq csc-mode-syntax-table (make-syntax-table))
  (modify-syntax-entry ?_  "w"  csc-mode-syntax-table)

  )
(defun csc-mode ()

  "Mode for Bloomberg CSC files"
  (interactive)
  (kill-all-local-variables)
  (use-local-map             csc-mode-map)
  (set-syntax-table          csc-mode-syntax-table)


  (make-local-variable       'parse-sexp-ignore-comments)
  (make-local-variable       'comment-start)
  (make-local-variable       'comment-start-skip)
  (make-local-variable       'comment-end)
  (make-local-variable       'executable-command)


  (setq major-mode          'csc-mode
        mode-name           "CSC"


        comment-end         ""
        comment-start       csc-mode-comment-start
        comment-start-skip  ".*\\(//.+\\)"


        parse-sexp-ignore-comments t


        )


  (run-hooks 'csc-mode-hook)

  )

(if (boundp 'font-lock-defaults-alist)
    (add-to-list
     'font-lock-defaults-alist
     (cons 'csc-mode
           (list 'csc-font-lock-keywords nil t nil nil))))


(provide 'csc-mode)
