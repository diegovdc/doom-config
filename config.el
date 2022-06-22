;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "videco"
      user-mail-address "vid@eco.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-opera
      doom-font (font-spec :size 16)
      projectile-project-search-path '("~/code/" "~/docs/")
      projectile-enable-caching nil)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;;;;;;;;;
;;; mac
;;;;;;;;;

;; solves package update problem

(when (and (equal emacs-version "27.2")
           (eql system-type 'darwin))
  (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))


(setq mac-control-key-is-meta t)
(setq mac-command-key-is-meta nil)
(setq mac-command-modifier 'control)
(setq mac-control-modifier 'meta)
(setq mac-option-modifier 'super)

;;;;;;;;;;
;;;;;;;;;;
;;;;;;;;;;
(global-set-key (kbd "C-z") 'undo)
;; make ctrl-shift-Z redo
(defalias 'redo 'undo-tree-redo)
(global-set-key (kbd "C-S-z") 'undo-tree-redo)


;; move-text
(global-set-key (kbd "M-s-<up>") 'move-text-up)
(global-set-key (kbd "M-s-<down>") 'move-text-down)
;; copy/paste
(global-set-key (kbd "C-x C-c") 'easy-kill)
(global-set-key (kbd "C-x c") 'easy-kill)
(global-set-key (kbd "C-x v") 'yank)
(global-set-key (kbd "C-x C-v") 'yank)

;; doom's `persp-mode' activation disables uniquify, b/c it says it breaks it.
;; It doesn't cause big enough problems for me to worry about it, so we override
;; the override. `persp-mode' is activated in the `doom-init-ui-hook', so we add
;; another hook at the end of the list of hooks to set our uniquify values.
(add-hook! 'doom-init-ui-hook
           :append ;; ensure it gets added to the end.
           #'(lambda () (require 'uniquify) (setq uniquify-buffer-name-style 'forward)))


(setq +format-with-lsp nil)
;;;;;;;;;;;
;;;;;;;;;;;

(use-package! cider
  :after clojure-mode
  :config
  (setq cider-show-error-buffer t       ;'only-in-repl
        ;; cider-font-lock-dynamically nil ; use lsp semantic tokens
        ;; cider-eldoc-display-for-symbol-at-point nil ; use lsp
        cider-prompt-for-symbol nil
        cider-use-xref nil
        cider-auto-select-error-buffer nil
        lsp-log-io t
        lsp-semantic-tokens-enable nil
        lsp-enable-on-type-formatting nil
        lsp-signature-mode nil
        lsp-signature-render-documentation nil
        lsp-completion-enable t)
  (set-lookup-handlers! '(cider-mode cider-repl-mode) nil) ; use lsp
  (set-popup-rule! "*cider-test-report*" :side 'right :width 0.4)
  (set-popup-rule! "*cider-error" :side 'right :width 0.4)
  (set-popup-rule! "*cider-result" :side 'right :width 0.4)
  (set-popup-rule! "^\\*cider-repl" :side 'bottom :quit nil)
  ;; use lsp completion
  ;; (add-hook 'cider-mode-hook (lambda () (remove-hook 'completion-at-point-functions #'cider-complete-at-point)))
  (add-hook 'before-save-hook 'cider-format-buffer t t))

(use-package! clj-refactor
  :after clojure-mode
  :config
  (set-lookup-handlers! 'clj-refactor-mode nil)
  (setq cljr-warn-on-eval nil
        cljr-eagerly-build-asts-on-startup nil
        cljr-add-ns-to-blank-clj-files nil ; use lsp
        cljr-magic-require-namespaces
        '(("s"   . "schema.core")
          ("gen" . "common-test.generators")
          ("d-pro" . "common-datomic.protocols.datomic")
          ("ex" . "common-core.exceptions.core")
          ("dth" . "common-datomic.test-helpers")
          ("t-money" . "common-core.types.money")
          ("t-time" . "common-core.types.time")
          ("d" . "datomic.api")
          ("m" . "matcher-combinators.matchers")
          ("pp" . "clojure.pprint"))))

(use-package! clojure-mode
  :config
  (setq clojure-indent-style 'align-arguments))

(use-package! company
  :config
  (setq company-tooltip-align-annotations t
        company-frontends '(company-pseudo-tooltip-frontend)))

(use-package! company-quickhelp
  :init
  (company-quickhelp-mode)
  :config
  (setq company-quickhelp-delay nil
        company-quickhelp-use-propertized-text t
        company-quickhelp-max-lines 10))

;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;
(use-package! paredit-mode
  :hook (clojure-mode emacs-lisp-mode))

(after! paredit
  (map! :map 'paredit-mode-map
        "C-}" #'paredit-forward-slurp-sexp
        "C-{" #'paredit-forward-barf-sexp))

;;;;;;;;;;;
;;;;;;;;;;;
(use-package! treemacs-all-the-icons
  :after treemacs)

(after! crux
  (global-set-key (kbd "C-a") 'crux-move-beginning-of-line))

;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;


;;; clojure ;;;;
;;;;;;;;;;;;;;;;

(setq clojure-toplevel-inside-comment-form t)


(after! clj-refactor
  (defun setup-clj-refactor ()
    (clj-refactor-mode 1)
    (yas-minor-mode 1)                ; for adding require/use/import statements
    ;; This choice of keybinding leaves cider-macroexpand-1 unbound
    (cljr-add-keybindings-with-prefix "C-c C-m"))

  (defun cider-clear-repl-buffer* ()
    (interactive)
    (cider-switch-to-repl-buffer)
    (cider-repl-clear-buffer)
    (insert ";; cleared buffer")
    (cider-repl-return)
    (cider-switch-to-last-clojure-buffer))


  (defun clojure-eval-after-save ()
    (interactive)
    (print (and (equal major-mode 'clojure-mode)
                (boundp 'cider-mode) cider-mode))
    (cond
     ((and (equal major-mode 'clojure-mode)
           (boundp 'cider-mode) cider-mode)
      ((lambda ()
         ;; (cider-format-buffer)
         (save-buffer)
         (cider-eval-file (buffer-file-name)))))
     ((and (equal major-mode 'clojurescript-mode)
           (boundp 'cider-mode) cider-mode)
      ((lambda ()
         ;; (cider-format-buffer)
         (save-buffer))))
     (t (save-buffer))))

  (define-key clojure-mode-map (kbd "C-c C-SPC") 'cider-clear-repl-buffer*)
  (define-key cider-repl-mode-map (kbd "C-c C-SPC") 'cider-clear-repl-buffer*)
  (define-key clojure-mode-map (kbd "C-x C-s") 'clojure-eval-after-save)
  (define-key clojure-mode-map (kbd "C-x s") 'clojure-eval-after-save)
  (add-hook 'clojure-mode-hook #'setup-clj-refactor)
  (add-hook 'cider-repl-mode-hook #'lispy-mode)
  )

(after! lispy
  ;; (define-key lispy-mode-map (kbd "M-.") 'lsp-find-definition)
  (define-key lispy-mode-map (kbd "C-a") 'crux-move-beginning-of-line))


(require 'cider-eval-sexp-fu)
(setq eval-sexp-fu-flash-duration 1)

;uniquify-buffer-name-styli;;;;;;;
;;;;;;;;
;; buffer naming
;; https://www.gnu.org/software/emacs/manual/html_node/emacs/Uniquify.html
(setq uniquify-buffer-name-style 'forward)

;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;
(global-wakatime-mode)

;;;;;;;;;;;;;;;;;;
;;; key chords ;;;
;;;;;;;;;;;;;;;;;;
(use-package! key-chord
  :config
  (key-chord-mode 1)
  (setq key-chord-one-key-delay 0.20
        key-chord-two-keys-delay 0.05))
(after! key-chord
  (key-chord-define-global "qq" 'top-level)  ; https://www.reddit.com/r/emacs/comments/4d8gvt/how_do_i_automatically_close_the_minibuffer_after/d1ovv6g/
  (key-chord-define-global "jj" nil)
  (key-chord-define-global "lj" nil)
  (key-chord-define-global "uu" nil)
  (key-chord-define-global "m," 'avy-goto-word-1)
  (key-chord-define-global ".," 'avy-goto-char)
  (key-chord-define-global "fd" 'paredit-forward)
  (key-chord-define-global "cd" 'paredit-backward)
  (key-chord-define-global "xf" 'forward-char)
  (key-chord-define-global "zx" 'consult-buffer)
  (key-chord-define-global "xd" 'backward-char)
  (key-chord-define-global "cz" 'other-window)
  (key-chord-define-global "xv" 'yank)
  (key-chord-define-global "xs" 'save-buffer-always)
  (key-chord-define-global "km" 'lispy-forward)
  (key-chord-define-global "jn" 'lispy-backward)

  (key-chord-define cider-mode-map "cx" 'cider-eval-defun-at-point)
  (key-chord-define cider-mode-map "cv" 'cider-pprint-eval-defun-at-point)
  (defun enlarge-window-horizontally-default ()
  (interactive)
  (enlarge-window-horizontally 30))


  (key-chord-define-global "4w" 'enlarge-window-horizontally-default))



;;;;;;;;;;;;;
;;;;;;;;;;;;;

(defun transpose-buffers (arg)
  "Transpose the buffers shown in two windows."
  (interactive "p")
  (let ((selector (if (>= arg 0) 'next-window 'previous-window)))
    (while (/= arg 0)
      (let ((this-win (window-buffer))
            (next-win (window-buffer (funcall selector))))
        (set-window-buffer (selected-window) next-win)
        (set-window-buffer (funcall selector) this-win)
        ;; (select-window (funcall selector))
        )
      (setq arg (if (plusp arg) (1- arg) (1+ arg))))))

(global-set-key (kbd "C-x C-z") 'transpose-buffers)
;; (define-key projectile-mode-map (kbd "C-x C-z") 'transpose-buffers)
