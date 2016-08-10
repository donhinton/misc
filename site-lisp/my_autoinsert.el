;; autoinsert.el
;;
;; \author: Don Allon Hinton <dhinton@gmail.com>
;; \date: 19 May 2008 20:01:24 UTC

;; To use this file, add (require bb-autoinsert) to your .emacs file
;; and set (setq auto-insert-directory '"~dhinton/insert"), or clone
;; the files found there.  The default is ~/insert.  See autoinsert.el
;; for more details.

(setq auto-insert t)
(add-hook 'find-file-hooks 'auto-insert)


;; need to add more specific templates, e.g., *main.cpp, *main.h
;; think about getting rid of .h for c, and making .hpp work for c and c++
;; add shell scripts
;; make examples compilable/runable
(setq auto-insert-alist
      '(
        (".lrl$" . ["lrl" auto-update-lrl-source-file])
        (".csc2$" . ["csc2" auto-update-csc2-source-file])
        (".cpp$" . ["cpp" auto-update-cpp-source-file])
        (".hpp$" . ["hpp" auto-update-cpp-header-file])
        (".gperf$" . ["gperf" auto-update-cpp-header-file])
        (".c$" . ["c" auto-update-c-source-file])
        (".h$" . ["h" auto-update-c-header-file])
        (".lex$" . ["lex" auto-update-flex-file])
        (".y$" . ["y" auto-update-bison-file])
        ("CMakeLists.txt$" . ["cmake" auto-update-cmake-file])
))


;; replace __USER_NAME__ with users login name
(defun replace-user-name ()
  (while (search-forward "__USER_NAME__" nil t)
    (save-restriction
      (narrow-to-region (match-beginning 0) (match-end 0))
      (replace-match (user-login-name) t)
      ))
  )

;; replace __FILE_NAME_SANS_EXTENTION__ with, well, filename sans ext
(defun replace-filename_sans_ext ()
  (while (search-forward "__FILE_NAME_SANS_EXTENTION__" nil t)
    (save-restriction
      (narrow-to-region (match-beginning 0) (match-end 0))
      (replace-match (file-name-nondirectory
                      (file-name-sans-extension buffer-file-name)) t)
      ))
  )

;; replace __RCS_FILE_NAME__ with ifdef'd rcsid filename
(defun replace-rcsid-filename ()
  (while (search-forward "__RCS_FILE_NAME__" nil t)
    (save-restriction
      (narrow-to-region (match-beginning 0) (match-end 0))
      (replace-match (file-name-nondirectory buffer-file-name) t)
      (subst-char-in-region (point-min) (point-max) ?. ?_)
      ))
  )
;; replace __AUTHOR__ with current user
(defun replace-author-name ()
  (while (search-forward "__AUTHOR__" nil t)
    (save-restriction
      (narrow-to-region (match-beginning 0) (match-end 0))
      (replace-match (concat user-full-name " <" user-mail-address ">" ) t )
      ))
  )

;; replace __INCLUDE_GUARD__ with filename for include guards
(defun replace-filename-in-include-guards-hpp ()
  (while (search-forward "__INCLUDE_GUARD__" nil t)
    (save-restriction
      (narrow-to-region (match-beginning 0) (match-end 0))
      (replace-match (concat "INCLUDED_"
                             (upcase (file-name-sans-extension
                                      (file-name-nondirectory buffer-file-name)))
                             "_HPP"))
      (subst-char-in-region (point-min) (point-max) ?. ?_)
      ))
  )

;; replace __INCLUDE_GUARD__ with filename for include guards
(defun replace-filename-in-include-guards-h ()
  (while (search-forward "__INCLUDE_GUARD__" nil t)
    (save-restriction
      (narrow-to-region (match-beginning 0) (match-end 0))
      (replace-match (concat "INCLUDED_"
                             (upcase (file-name-sans-extension
                                      (file-name-nondirectory buffer-file-name)))
                     "_H"))
      (subst-char-in-region (point-min) (point-max) ?. ?_)
      ))
  )

;; replace __HEADER_FILE__ with cpp filename in #include
(defun replace-cpp-filename-in-include ()
  (while (search-forward "__HEADER_FILE__" nil t)
    (save-restriction
      (narrow-to-region (match-beginning 0) (match-end 0))
      (replace-match (concat (file-name-sans-extension
                              (file-name-nondirectory buffer-file-name))
                             ".hpp") t
                             )
      ))
  )

;; replace __HEADER_FILE__ with c filename in #include
(defun replace-c-filename-in-include ()
  (while (search-forward "__HEADER_FILE__" nil t)
    (save-restriction
      (narrow-to-region (match-beginning 0) (match-end 0))
      (replace-match (concat (file-name-sans-extension
                              (file-name-nondirectory buffer-file-name))
                             ".h") t
                             )
      ))
  )

(defun insert-today ()
  "Insert today's date into buffer"
  (interactive)
  (insert (format-time-string "%d %b %Y %T %Z" (current-time)))
)
;; replace __DATE__ with today's date
(defun replace-date ()
  (while (search-forward "__DATE__" nil t)
    (save-restriction
      (narrow-to-region (match-beginning 0) (match-end 0))
      (replace-match "")
      (insert-today)
      ))
  )

(defun insert-year ()
  "Insert today's year into buffer"
  (interactive)
  (insert (format-time-string "%Y" (current-time)))
)
;; replace __YEAR__ with today's 4 digit year
(defun replace-year ()
  (while (search-forward "__YEAR__" nil t)
    (save-restriction
      (narrow-to-region (match-beginning 0) (match-end 0))
      (replace-match "")
      (insert-year)
      ))
  )

;; replace __FILE_NAME__ with filename
(defun replace-filename ()
  (while (search-forward "__FILE_NAME__" nil t)
    (save-restriction
      (narrow-to-region (match-beginning 0) (match-end 0))
      (replace-match (file-name-nondirectory buffer-file-name) t )
      ))
  )


;; need to look into reducing the number of functions since they
;; basically all do the same thing, the only real difference is the
;; file extention and it's template file

(defun auto-update-c-header-file ()
  (save-excursion (replace-rcsid-filename))
  (save-excursion (replace-filename-in-include-guards-h))
  (save-excursion (replace-filename))
  (save-excursion (replace-date))
  (save-excursion (replace-year))
  (save-excursion (replace-author-name)))

(defun auto-update-c-source-file ()
  (save-excursion (replace-rcsid-filename))
  (save-excursion (replace-filename-in-include-guards-h))
  (save-excursion (replace-c-filename-in-include))
  (save-excursion (replace-filename))
  (save-excursion (replace-date))
  (save-excursion (replace-year))
  (save-excursion (replace-author-name)))

(defun auto-update-cpp-header-file ()
  (save-excursion (replace-rcsid-filename))
  (save-excursion (replace-filename-in-include-guards-hpp))
  (save-excursion (replace-filename))
  (save-excursion (replace-date))
  (save-excursion (replace-year))
  (save-excursion (replace-author-name)))

(defun auto-update-cpp-source-file ()
  (save-excursion (replace-rcsid-filename))
  (save-excursion (replace-filename-in-include-guards-hpp))
  (save-excursion (replace-cpp-filename-in-include))
  (save-excursion (replace-filename))
  (save-excursion (replace-date))
  (save-excursion (replace-year))
  (save-excursion (replace-author-name)))

(defun auto-update-shell-script-file ()
  (save-excursion (replace-rcsid-filename))
  (save-excursion (replace-filename))
  (save-excursion (replace-date))
  (save-excursion (replace-year))
  (save-excursion (replace-author-name)))

(defun auto-update-lrl-source-file ()
  (save-excursion (replace-filename_sans_ext))
  (save-excursion (replace-filename))
  (save-excursion (replace-date))
  (save-excursion (replace-year))
  (save-excursion (replace-user-name))
  (save-excursion (replace-author-name)))

(defun auto-update-csc2-source-file ()
  (save-excursion (replace-filename_sans_ext))
  (save-excursion (replace-filename))
  (save-excursion (replace-date))
  (save-excursion (replace-year))
  (save-excursion (replace-user-name))
  (save-excursion (replace-author-name)))

(defun auto-update-flex-file ()
  (save-excursion (replace-filename_sans_ext))
  (save-excursion (replace-filename))
  (save-excursion (replace-date))
  (save-excursion (replace-year))
  (save-excursion (replace-user-name))
  (save-excursion (replace-author-name)))

(defun auto-update-bison-file ()
  (save-excursion (replace-filename_sans_ext))
  (save-excursion (replace-filename))
  (save-excursion (replace-date))
  (save-excursion (replace-year))
  (save-excursion (replace-user-name))
  (save-excursion (replace-author-name)))

(defun auto-update-cmake-file ()
  (save-excursion (replace-filename_sans_ext))
  (save-excursion (replace-filename))
  (save-excursion (replace-date))
  (save-excursion (replace-year))
  (save-excursion (replace-user-name))
  (save-excursion (replace-author-name)))

(provide 'my_autoinsert)
