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

;;;; python code-folding via outline-minor-mode

; the commented line treats everything vaguely blocky as a subtree
; the uncommented line (what i prefer) treats only classes and defs as subtrees.
(defvar py-outline-regexp
;  "^\\([ \t]*\\)\\(def\\|class\\|if\\|elif\\|else\\|while\\|for\\|try\\|except\\|with\\)"
  "^\\([ \t]*\\)\\(@[a-zA-Z0-9\\_\\-\\.]+\\|def\\|class\\)"
  "This variable defines what constitutes a 'headline' to outline mode.")

(defun py-outline-level ()
  "Report outline level for Python outlining."
  (save-excursion
    (end-of-line)
    (let ((indentation (progn
			 (re-search-backward py-outline-regexp)
			 (match-string-no-properties 1))))
      (if (and (> (length indentation) 0)
	       (string= "\t" (substring indentation 0 1)))
	  (length indentation)
	(/ (length indentation) py-indent-offset)))))

(add-hook 'python-mode-hook
	  '(lambda ()
	     (outline-minor-mode 1)
	     (setq
	      outline-regexp py-outline-regexp
	      outline-level 'py-outline-level)
			 (hide-body)))

;;;; outline-minor-mode keymappings

(define-prefix-command 'cm-map nil "Outline-")
(global-set-key "\M-o" cm-map)

; toggles visibility of current subtree
; <C-s-tab> is ctrl + windows keyboard menu key
(global-set-key (kbd "<C-s-tab>") 'outline-toggle-children)

; HIDE
(define-key cm-map "q" 'hide-sublevels)    ; Hide everything but the top-level headings
(define-key cm-map "t" 'hide-body)         ; Hide everything but headings (all body lines)
(define-key cm-map "o" 'hide-other)        ; Hide other branches
(define-key cm-map "c" 'hide-entry)        ; Hide this entry's body
(define-key cm-map "l" 'hide-leaves)       ; Hide body lines in this entry and sub-entries
(define-key cm-map "d" 'hide-subtree)      ; Hide everything in this entry and sub-entries
; SHOW
(define-key cm-map "a" 'show-all)          ; Show (expand) everything
(define-key cm-map "e" 'show-entry)        ; Show this heading's body
(define-key cm-map "i" 'show-children)     ; Show this heading's immediate child sub-headings
(define-key cm-map "k" 'show-branches)     ; Show all sub-headings under this heading
(define-key cm-map "s" 'show-subtree)      ; Show (expand) everything in this heading & below
; NAVIGATE
(define-key cm-map "u" 'outline-up-heading)                ; Up
(define-key cm-map "n" 'outline-next-visible-heading)      ; Next
(define-key cm-map "p" 'outline-previous-visible-heading)  ; Previous
(define-key cm-map "f" 'outline-forward-same-level)        ; Forward - same level
(define-key cm-map "b" 'outline-backward-same-level)       ; Backward - same level
(global-set-key (kbd "<C-s-down>") 'outline-next-visible-heading)   ; Next (ctrl + alt + down)
(global-set-key (kbd "<C-s-up>") 'outline-previous-visible-heading) ; Previous (ctrl + alt + up)

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

(add-hook 'before-save-hook 'whitespace-cleanup)