;;;; keybindings

; make ctrl-right go to end of line
(global-set-key "\033[5C" 'end-of-line)
(global-set-key (kbd "C-<right>") 'end-of-line)

; make ctrl-left go to start of line
(global-set-key "\033[5D" 'beginning-of-line)
(global-set-key (kbd "C-<left>") 'beginning-of-line)

; make ctrl-up move up by paragraphs
(global-set-key "\033[H" 'backward-paragraph)
(global-set-key (kbd "C-<up>") 'backward-paragraph)

; ...and ctrl-dn move down by paragraphs
(global-set-key "\033[F" 'forward-paragraph)
(global-set-key (kbd "C-<down>") 'forward-paragraph)

; make meta-up and meta-dn page up/dn
(global-set-key (kbd "M-<down>") 'scroll-up)
(global-set-key (kbd "ESC <down>") 'scroll-up)
(global-set-key (kbd "M-<up>") 'scroll-down)
(global-set-key (kbd "ESC <up>") 'scroll-down)

; windows keyboard crap:
; make <next>/<prior> and ctrl-<next>/<prior> page up/dn
(global-set-key (kbd "C-<next>") 'scroll-up)
(global-set-key (kbd "<next>") 'scroll-up)
(global-set-key (kbd "C-<prior>") 'scroll-down)
(global-set-key (kbd "<prior>") 'scroll-down)

; make <end> go to end of doc
(global-set-key (kbd "<end>") 'end-of-buffer)

; make <home> go to start of doc
(global-set-key (kbd "<home>") 'beginning-of-buffer)

; make a custom occur regex for python, and bind it to something close to the default occur kb
(defun py-occur ()
  "run occur mode with a regex for python methods and classes"
  (interactive)
  (occur "\\(def\\|class\\)\\s-"))

(global-set-key (kbd "M-s p") 'py-occur)

;;;; highlight indentation mode

(add-to-list 'load-path "~/.emacs.d/highlight-indentation")

(require 'highlight-indentation)
(set-face-background 'highlight-indentation-face "#222222")
(set-face-background 'highlight-indentation-current-column-face "#444444")

(add-hook 'python-mode-hook 'highlight-indentation-mode)

;;;; `Pyrex' mode.

(add-to-list 'auto-mode-alist '("\\.pyx\\'" . pyrex-mode))

(define-derived-mode pyrex-mode python-mode "Pyrex"
  (font-lock-add-keywords
   nil
   `((,(concat "\\<\\(NULL"
	       "\\|c\\(def\\|har\\|typedef\\)"
	       "\\|e\\(num\\|xtern\\)"
	       "\\|float"
	       "\\|in\\(clude\\|t\\)"
	       "\\|object\\|public\\|struct\\|type\\|union\\|void"
	       "\\)\\>")
      1 font-lock-keyword-face t))))

;;;; color-theme init

(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0/")
(require 'color-theme)
(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-hober)))

;;;; show column numbers and line numbers
(column-number-mode 1)
(line-number-mode 1)

;;; cleanup whitespace before save

(add-hook 'before-save-hook 'whitespace-cleanup)

;;; confirm before close (prevent fat-finger errors)

(setq confirm-kill-emacs 'y-or-n-p)

;;; ido mode

(ido-mode 'both)                   ; enable for files and buffers
(setq ido-enable-flex-matching t)  ; for fuzzy matching of characters

; Display ido results vertically, rather than horizontally
(setq ido-decorations (quote ("\n-> " "" "\n   " "\n   ..." "[" "]" " [No match]" " [Matched]" " [Not readable]" " [Too big]" " [Confirm]")))
(defun ido-disable-line-trucation () (set (make-local-variable 'truncate-lines) nil))
(add-hook 'ido-minibuffer-setup-hook 'ido-disable-line-trucation)

; sort ido filelist by mtime instead of alphabetically
(add-hook 'ido-make-file-list-hook 'ido-sort-mtime)
(add-hook 'ido-make-dir-list-hook 'ido-sort-mtime)
(defun ido-sort-mtime ()
  (setq ido-temp-list
	(sort ido-temp-list
	      (lambda (a b)
		(time-less-p
		 (sixth (file-attributes (concat ido-current-directory b)))
		 (sixth (file-attributes (concat ido-current-directory a)))))))
  (ido-to-end  ;; move . files to end (again)
   (delq nil (mapcar
	      (lambda (x) (and (string-match-p "^\\.." x) x))
	      ido-temp-list))))
