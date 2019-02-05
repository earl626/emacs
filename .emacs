
;;-------------------------------------------------------------------------------------------------------------
;;
;;                                           Earl's .emacs-configuration
;;
;;-------------------------------------------------------------------------------------------------------------

;;; TODO(earl):
;;;     - Configure GDB to work properly
;;;     - Finish CTags (compiler list dependencies, ctags tags file generation)
;;;     - Emacs Latex, AUCTEX (https://www.gnu.org/software/auctex/)
;;;       Prolly simple enough to just write latex-source in Emacs and view result in browser or something
;;;       Improve general editting, indentation, etc...
;;;     - Interesting config file (https://github.com/incandescentman)
;;;     - Emacs real time markdown viewer (necessary?)
;;;     - Emacs Multiple Cursors (https://github.com/magnars/multiple-cursors.el)
;;;     - Video to Watch: https://www.youtube.com/watch?v=5FQwQ0QWBTU
;;;     - Git (https://www.emacswiki.org/emacs/Git)
;;;       (https://www.emacswiki.org/emacs/Magit)
;;;       (https://github.com/magit/magit)
;;;       (https://magit.vc/)
;;;     - Emacs AutoComplete (emacs autocomplete, dropdownlist)
;;;       Write your own c-parser and have emacs use it for autocompletion
;;;     - Python???
;;;     - Review this .emacs file with extra concern for memory consumption, and general performance
;;;       NOTE(ear):
;;;                  See if you can get Emacs down to 14 MB memory consumption before loading any tag-files
;;;                  After upgrading Emacs to version 25.1-2, memory consumption jumped to 30 MB after startup
;;;                  Emacs versions: i686 is the 32-bit version, and x86_64 is the 64-bit version of the OS.
;;;                  I've installed the 64-bit version so it's Kk after all.
;;;     - INTROSPECTION
;;;           Creates something that parses the Emacs-configuration-file and manipulates it
;;;           Like something that asks the user to store something the user has given it for future session
;;;           If yes it locates the config-file (.emacs), if no previous entries creates a new list with unique
;;;           name, otherwise adds to an allready existing list (as long as entry is not allready member)
;;;     - Google search / Dictionary search in Emacs?
;;;     - Emacs Tree View, Project Hierarchy View (not necessary?)
;;;     - Emacs Custom Mode Line

;;; STUDY(earl):
;;;     - Indentation
;;;     - Splitting the window in more than two sections???

;;; NOTE(earl):
;;;     - Caps Lock should equal Left Ctrl for use with Emacs key configuration
;;;     - F1       = help/documentation
;;;     - F1 f/v/k = help function/variable/key sequence respectively
;;;     - F1 ?     = further options

;;; IMPORTANT(earl):
;;;     - This emacs-configuration is made with the UK keyboard layout
;;;     - The Emacs key configuration is from my old setup
;;;     - The Evil Mode is what I'm currently using

;;; NOTE(earl): List of useful functions
;;;     - (print OBJECT &optional PRINTCHARFUN)
;;;     - (message FORMAT-STRING &rest ARGS) e.g. (message "%s" var)
;;;     - (count-lines START END)
;;;     - (push-mark &optional LOCATION NOMSG ACTIVATE), (pop-mark)

;;-------------------------------------------------------------------------------------------------------------
;;
;;                                                Debug Mode
;;
;;-------------------------------------------------------------------------------------------------------------

;;; Enable debug mode
;;; Enable "Enter debugger on error" from the Options menu and add
;;; (setq debug-on-error t) or (custom-set-variables '(debug-on-error t)) to your ~/.emacs.el.
;;; Then you will get a *Backtrace* buffer on C-x C-e:

;; (setq debug-on-error t)

;;; Disable ad-handle-definition warnings
(setq ad-redefinition-action 'accept)

;;-------------------------------------------------------------------------------------------------------------
;;
;;                                             Load Emacs plugins
;;
;;-------------------------------------------------------------------------------------------------------------

;; Setup a folder where we can put all our plugins
;; NOTE(earl): Evil Mode is not within this folder
;;             Evil Mode has its own folder (elpa) which is in the "~/.emacs.d/" directory
;;             Key Chord on the other hand is in the "~/.emacs.d/plugins" directory, and only consists of one el-file

(add-to-list 'load-path "~/.emacs.d/plugins")

;;***************************************
;;
;; Evil Mode
;;
;; https://www.emacswiki.org/emacs/Evil
;; Quick Install
;; Install using the latest version of Emacs and its builtin package system. Start with this in your .emacs:
;;
;;***************************************

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)

;; Then:
;;   M-x list-packages
;;   C-s evil
;; 
;; Moving cursor over package name.
;;   i
;;   x
;; i - mark for installation, x - to execute
;; There should now be a folder named "elpa" in this folder "c:/Users/n06888/AppData/Roaming/.emacs.d/"

;; Require Evil Mode
(require 'evil)
(evil-mode 1)

;;***************************************
;;
;; Org-Mode, OrgMode, Org Mode
;;
;;***************************************

(require 'org)
(setq org-log-done t)

;;***************************************
;;
;; Adaptive Wrap
;;
;;***************************************

;; NOTE: This package resides in the elpa folder together with evil mode
;;       ~/.emacs.d/elpa/
;; Makes sure indented wraped lines stay indented
(require 'adaptive-wrap)

;;***************************************
;;
;; Company Mode
;;
;;***************************************

;; NOTE: This package resides in the elpa folder together with evil mode
;;       ~/.emacs.d/elpa/
;; Company is a text completion framework for Emacs.
;; It uses pluggable back-ends and front-ends to retrieve and display completion candidates.
;; ctags shitty backend for autocompletion,
;; switching to other backend to much work, ctags good enough for finding what I need
;; so not currently using this, only have it here to remind me of with-eval-after-load

(with-eval-after-load "company"
  (defun earl-company-mode-hook ()
    (company-mode))
  (add-hook 'c++-mode-hook 'earl-company-mode-hook))

;;***************************************
;;
;; Misc
;;
;;***************************************

;; ;; Load Key Chord 
;; (require 'key-chord)
;; (key-chord-mode 1)

;; Common Lisp for Emacs 
(require 'cl)

;; Require the ido-package
(require 'ido)

;; Require xref
(require 'xref)

;;-------------------------------------------------------------------------------------------------------------
;;
;;                                                Mode Line
;;
;;-------------------------------------------------------------------------------------------------------------

;; TODO: Remove or add the nyan-cat-section
;;       Remember the mode line hooks throught this file (I think there are three places)
;;       SRC: https://amitp.blogspot.no/2011/08/emacs-custom-mode-line.html

;; ;; Mode line setup
;; (setq-default
;;  mode-line-format
;;  '(; Position, including warning for 80 columns
;;    (:propertize "%4l:" face mode-line-position-face)
;;    (:eval (propertize "%3c" 'face
;;                       (if (>= (current-column) 80)
;;                           'mode-line-80col-face
;;                         'mode-line-position-face)))
;;    ; emacsclient [default -- keep?]
;;    mode-line-client
;;    "  "
;;    ; read-only or modified status
;;    (:eval
;;     (cond (buffer-read-only
;;            (propertize " RO " 'face 'mode-line-read-only-face))
;;           ((buffer-modified-p)
;;            (propertize " ** " 'face 'mode-line-modified-face))
;;           (t "      ")))
;;    "    "
;;    ; directory and buffer/file name
;;    (:propertize (:eval (shorten-directory default-directory 30))
;;                 face mode-line-folder-face)
;;    (:propertize "%b"
;;                 face mode-line-filename-face)
;;    ; narrow [default -- keep?]
;;    " %n "
;;    ; mode indicators: vc, recursive edit, major mode, minor modes, process, global
;;    (vc-mode vc-mode)
;;    "  %["
;;    (:propertize mode-name
;;                 face mode-line-mode-face)
;;    "%] "
;;    (:eval (propertize (format-mode-line minor-mode-alist)
;;                       'face 'mode-line-minor-mode-face))
;;    (:propertize mode-line-process
;;                 face mode-line-process-face)
;;    (global-mode-string global-mode-string)
;;    "    "
;;    ; nyan-mode uses nyan cat as an alternative to %p
;;    (:eval (when nyan-mode (list (nyan-create))))
;;    ))

;; ;; Helper function
;; (defun shorten-directory (dir max-length)
;;   "Show up to `max-length' characters of a directory name `dir'."
;;   (let ((path (reverse (split-string (abbreviate-file-name dir) "/")))
;;         (output ""))
;;     (when (and path (equal "" (car path)))
;;       (setq path (cdr path)))
;;     (while (and path (< (length output) (- max-length 4)))
;;       (setq output (concat (car path) "/" output))
;;       (setq path (cdr path)))
;;     (when path
;;       (setq output (concat ".../" output)))
;;     output))

;; ;; Extra mode line faces
;; (make-face 'mode-line-read-only-face)
;; (make-face 'mode-line-modified-face)
;; (make-face 'mode-line-folder-face)
;; (make-face 'mode-line-filename-face)
;; (make-face 'mode-line-position-face)
;; (make-face 'mode-line-mode-face)
;; (make-face 'mode-line-minor-mode-face)
;; (make-face 'mode-line-process-face)
;; (make-face 'mode-line-80col-face)

;; (set-face-attribute 'mode-line nil
;;     :foreground "gray60" :background "gray20"
;;     :inverse-video nil
;;     :box '(:line-width 6 :color "gray20" :style nil))
;; (set-face-attribute 'mode-line-inactive nil
;;     :foreground "gray80" :background "gray40"
;;     :inverse-video nil
;;     :box '(:line-width 6 :color "gray40" :style nil))

;; (set-face-attribute 'mode-line-read-only-face nil
;;     :inherit 'mode-line-face
;;     :foreground "#4271ae"
;;     :box '(:line-width 2 :color "#4271ae"))
;; (set-face-attribute 'mode-line-modified-face nil
;;     :inherit 'mode-line-face
;;     :foreground "#c82829"
;;     :background "#ffffff"
;;     :box '(:line-width 2 :color "#c82829"))
;; (set-face-attribute 'mode-line-folder-face nil
;;     :inherit 'mode-line-face
;;     :foreground "gray60")
;; (set-face-attribute 'mode-line-filename-face nil
;;     :inherit 'mode-line-face
;;     :foreground "#eab700"
;;     :weight 'bold)
;; (set-face-attribute 'mode-line-position-face nil
;;     :inherit 'mode-line-face
;;     :family "Menlo" :height 100)
;; (set-face-attribute 'mode-line-mode-face nil
;;     :inherit 'mode-line-face
;;     :foreground "gray80")
;; (set-face-attribute 'mode-line-minor-mode-face nil
;;     :inherit 'mode-line-mode-face
;;     :foreground "gray40"
;;     :height 110)
;; (set-face-attribute 'mode-line-process-face nil
;;     :inherit 'mode-line-face
;;     :foreground "#718c00")
;; (set-face-attribute 'mode-line-80col-face nil
;;     :inherit 'mode-line-position-face
;;     :foreground "black" :background "#eab700")

;;-------------------------------------------------------------------------------------------------------------
;;
;;                                   Determine the underlying operating system
;;
;;-------------------------------------------------------------------------------------------------------------

(setq casey-aquamacs (featurep 'aquamacs))
(setq casey-linux (featurep 'x))
(setq casey-win32 (not (or casey-aquamacs casey-linux)))

(setq compilation-directory-locked nil)
(setq shift-select-mode nil)
(setq enable-local-variables nil)

(when casey-win32 
  (setq casey-makescript "build.bat")
  (setq casey-font "outline-Liberation Mono")
  )

(when casey-aquamacs 
  (cua-mode 0) 
  (osx-key-mode 0)
  (tabbar-mode 0)
  (setq mac-command-modifier 'meta)
  (setq x-select-enable-clipboard t)
  (setq aquamacs-save-options-on-quit 0)
  (setq special-display-regexps nil)
  (setq special-display-buffer-names nil)
  (define-key function-key-map [return] [13])
  (setq mac-command-key-is-meta t)
  (scroll-bar-mode nil)
  (setq mac-pass-command-to-system nil)
  (setq casey-makescript "./build.macosx")
  )

(when casey-linux
  (setq casey-makescript "./build.linux")
  (display-battery-mode 1)
  )

(load-library "view")
(require 'cc-mode)
(require 'ido)
(require 'compile)
(ido-mode t)

;; Turn off the bell on Mac OS X
(defun nil-bell ())
(setq ring-bell-function 'nil-bell)

;;-------------------------------------------------------------------------------------------------------------
;;
;;                                                Bright-red TODOs
;;
;;-------------------------------------------------------------------------------------------------------------

(setq fixme-modes '(c++-mode c-mode emacs-lisp-mode))
(make-face 'font-lock-fixme-face)
(make-face 'font-lock-study-face)
(make-face 'font-lock-important-face)
(make-face 'font-lock-note-face)
(mapc (lambda (mode)
        (font-lock-add-keywords
         mode
         '(("\\<\\(TODO\\)" 1 'font-lock-fixme-face t)
           ("\\<\\(STUDY\\)" 1 'font-lock-study-face t)
           ("\\<\\(IMPORTANT\\)" 1 'font-lock-important-face t)
           ("\\<\\(NOTE\\)" 1 'font-lock-note-face t))))
      fixme-modes)
(modify-face 'font-lock-fixme-face "Red" nil nil t nil t nil nil)
(modify-face 'font-lock-study-face "Yellow" nil nil t nil t nil nil)
(modify-face 'font-lock-important-face "Yellow" nil nil t nil t nil nil)
(modify-face 'font-lock-note-face "Light Green" nil nil t nil t nil nil)

;;-------------------------------------------------------------------------------------------------------------
;;
;;                                              Theme configuration
;;
;;-------------------------------------------------------------------------------------------------------------

;;-------------------------------------------------------------------------------------------------------------
;;
;; Earl's colors
;;
;;-------------------------------------------------------------------------------------------------------------

;; Custom light scheme
;; -------------------------------
(defconst earl-color-light-text "#171519")
(defconst earl-color-light-background "#d7d7d7") ; "#d3d3d3"
(defconst earl-color-light-green "#009000") ; "#008000"
(defconst earl-color-light-blue "#167bc2")
(defconst earl-color-light-red "#ff322f")

;; Solarized color scheme
;; -------------------------------
(defconst earl-color-sol-base03 "#002b36")
(defconst earl-color-sol-base02 "#073642")
(defconst earl-color-sol-base01 "#586e75")
(defconst earl-color-sol-base00 "#657b83")
(defconst earl-color-sol-base0 "#839496")
(defconst earl-color-sol-base1 "#93a1a1")
(defconst earl-color-sol-base2 "#eee8d5")
(defconst earl-color-sol-base3 "#fdf6e3")
(defconst earl-color-sol-yellow "#b58900")
(defconst earl-color-sol-orange "#cb4b16")
(defconst earl-color-sol-red "#dc322f")
(defconst earl-color-sol-magenta "#d33682")
(defconst earl-color-sol-violet "#6c71c4")
(defconst earl-color-sol-blue "#268bd2")
(defconst earl-color-sol-cyan "#2aa198")
(defconst earl-color-sol-green "#859900")

;; Color variables
;; -------------------------------
(setq earl-color-text earl-color-sol-base00)
(setq earl-color-comment earl-color-sol-green)
(setq earl-color-type earl-color-sol-blue)
(setq earl-color-string earl-color-sol-cyan)
(setq earl-color-keyword earl-color-sol-orange)
(setq earl-color-emphasized earl-color-sol-base01)
(setq earl-color-cursor earl-color-emphasized)
(setq earl-color-background earl-color-sol-base3)
(setq earl-color-hl-line earl-color-sol-base2)
(setq earl-color-todo earl-color-sol-red)
(setq earl-color-study earl-color-sol-yellow)
(setq earl-color-important earl-color-sol-magenta)
(setq earl-color-note earl-color-sol-blue)

;;-------------------------------------------------------------------------------------------------------------
;;
;; Font type and size
;;
;;-------------------------------------------------------------------------------------------------------------

;; STUDY(earl): Serif font might be better at a 4K-resolution screen? (Serif better at paper)
;;              Sans Serif better at low-resolution screen? (Sans Serif better at computer-screen)

;; NOTE(earl): Liberation Mono - Casey's font type (he uses 11.5 in size)
;;             This requires that the Liberation Mono font is installed

(setq casey-font "outline-DejaVu Sans Mono")

(setq earl-font-list (list "Liberation Mono" "Verdana" "Arial" "Open Sans"
                           "DejaVu Sans Mono" "Source Code Pro" "Nimbus Mono"
                           "Ubuntu Mono" "Inconsolata" "Consolas" "Cousine"))
;; (setq earl-font-list-sizes (list "-9.5" "-10" "-12" "-9" "-10" "-10" "-10" "-10" "-10" "-10" "-10"))
(setq earl-font-list-sizes (list "-11.5" "-10" "-12" "-9" "-10" "-10" "-10" "-10" "-10" "-11" "-11.5"))
(setq earl-last-font-index 10)
(setq earl-default-font 9)
(setq earl-current-font earl-default-font)

(defun earl-current-font ()
  "Display the current font"
  (interactive)
  (message (concat (nth earl-current-font earl-font-list) (nth earl-current-font earl-font-list-sizes)))
  )

;; ;; To change the default font for new (non special-display) frames, put either of these in your init file:
;; (add-to-list 'default-frame-alist '(font . FONT ))
;; (set-face-attribute 'default t :font FONT )

;; ;; To change the default font for the current frame, as well as future frames, put either of these in your init file:
;; (set-face-attribute 'default nil :font FONT ))
;; (set-frame-font FONT nil t)

;; Sets a default fallback-font if it exists, elsewise it's just gonna use the default Emacs-font
(if (member "Cousine" (font-family-list))
    (progn (add-to-list 'default-frame-alist '(font . "Cousine-10"))
           (set-face-attribute 'default t :font "Cousine-10")))

(defun earl-determine-default-font ()
  "Iterates through the list of fonts and chooses the first one that is available.
Its search starts from the index specified by earl-default-font
Pay attention to frame size; earl-next-font needs to toogle-frame-maximized in order to fix the frame size.
See both toggle-frame-maximized and its following if statement."
  (interactive)
  (if (member (nth earl-current-font earl-font-list) (font-family-list))
      (progn (set-frame-font (concat (nth earl-current-font earl-font-list) (nth earl-current-font earl-font-list-sizes)) nil t)
             (toggle-frame-maximized)
             (if (eq 'fullboth (cdr (assoc 'fullscreen (frame-parameters)))) () (toggle-frame-maximized)))
    (progn (setq earl-current-font (+ earl-current-font 1))
           (if (> earl-current-font earl-last-font-index) (setq earl-current-font 0))
           (if (eq earl-current-font earl-default-font)
               (message "Preffered fonts not installed on system. Defaulting to standard Emacs font")
             (earl-determine-default-font)))))

(defun earl-next-font ()
  "Iterates through a list of fonts and chooses the next one"
  (interactive)
  (setq earl-current-font (+ earl-current-font 1))
  (if (eq nil (nth earl-current-font earl-font-list)) (setq earl-current-font 0))
  (when (member (nth earl-current-font earl-font-list) (font-family-list))
    (set-frame-font (concat (nth earl-current-font earl-font-list) (nth earl-current-font earl-font-list-sizes))))
  (toggle-frame-maximized)
  (if (eq 'fullboth (cdr (assoc 'fullscreen (frame-parameters)))) () (toggle-frame-maximized))
  (message (concat (nth earl-current-font earl-font-list) (nth earl-current-font earl-font-list-sizes))))

(defun earl-previous-font ()
  "Iterates through a list of fonts and chooses the previous one"
  (interactive)
  (if (eq earl-current-font 0) (setq earl-current-font earl-last-font-index) (setq earl-current-font (- earl-current-font 1)))
  (when (member (nth earl-current-font earl-font-list) (font-family-list))
    (set-frame-font (concat (nth earl-current-font earl-font-list) (nth earl-current-font earl-font-list-sizes))))
  (toggle-frame-maximized)
  (if (eq 'fullboth (cdr (assoc 'fullscreen (frame-parameters)))) () (toggle-frame-maximized))
  (message (concat (nth earl-current-font earl-font-list) (nth earl-current-font earl-font-list-sizes))))

(defun earl-default-font ()
  "Choose the default font"
  (interactive)
  (setq earl-current-font earl-default-font)
  (when (member (nth earl-current-font earl-font-list) (font-family-list))
    (set-frame-font (concat (nth earl-current-font earl-font-list) (nth earl-current-font earl-font-list-sizes))))
  (toggle-frame-maximized)
  (if (eq 'fullboth (cdr (assoc 'fullscreen (frame-parameters)))) () (toggle-frame-maximized))
  (message "Setting default font (%s)" (concat (nth earl-current-font earl-font-list) (nth earl-current-font earl-font-list-sizes))))

(setq earl-comparison-font earl-default-font)

(defun earl-set-comparison-font ()
  "Remembers a font you want to compare"
  (interactive)
  (setq earl-comparison-font earl-current-font)
  (message "Stored: %s" (concat (nth earl-current-font earl-font-list) (nth earl-current-font earl-font-list-sizes))))

(defun earl-compare-fonts ()
  "Compare comparison font and current font"
  (interactive)
  (let ((tmp earl-current-font))
    (setq earl-current-font earl-comparison-font)
    (setq earl-comparison-font tmp)
    (when (member (nth earl-current-font earl-font-list) (font-family-list))
      (set-frame-font (concat (nth earl-current-font earl-font-list) (nth earl-current-font earl-font-list-sizes))))
    (toggle-frame-maximized)
    (if (eq 'fullboth (cdr (assoc 'fullscreen (frame-parameters)))) () (toggle-frame-maximized))
    (message (concat (nth earl-current-font earl-font-list) (nth earl-current-font earl-font-list-sizes)))))

;; Mouse controls
(global-set-key (kbd "<M-S-wheel-up>") 'earl-next-font)
(global-set-key (kbd "<M-S-wheel-down>") 'earl-previous-font)
(global-set-key (kbd "<M-S-mouse-5>") 'earl-default-font)
(global-set-key (kbd "<M-S-mouse-2>") 'earl-default-font)
(global-set-key (kbd "<M-S-mouse-3>") 'earl-set-comparison-font)
(global-set-key (kbd "<M-S-mouse-1>") 'earl-compare-fonts)

(global-set-key (kbd "<M-C-wheel-up>") '(lambda () (interactive) (text-scale-adjust 1)))
(global-set-key (kbd "<M-C-wheel-down>") '(lambda () (interactive) (text-scale-adjust -1)))
(global-set-key (kbd "<M-C-S-wheel-up>") '(lambda () (interactive) (text-scale-adjust 0.5)))
(global-set-key (kbd "<M-C-S-wheel-down>") '(lambda () (interactive) (text-scale-adjust -0.5)))
(global-set-key (kbd "<M-C-S-mouse-5>") '(lambda () (interactive) (text-scale-adjust 0)))
(global-set-key (kbd "<M-C-mouse-5>") '(lambda () (interactive) (text-scale-adjust 0)))

(setq earl-tiny-text-mode-toggle nil)

(defun earl-tiny-text-mode ()
  (interactive)
  (if earl-tiny-text-mode-toggle
      (progn (text-scale-adjust 0)
             (set-face-background 'hl-line earl-color-hl-line)
             (message "Tiny text mode disabled")
             (setq earl-tiny-text-mode-toggle nil))
    (progn (text-scale-adjust -8)
           (set-face-background 'hl-line earl-color-text)
           (message "Tiny text mode enabled")
           (setq earl-tiny-text-mode-toggle t))))

;;-------------------------------------------------------------------------------------------------------------
;;
;; Minibuffer and Echo Area
;;
;;-------------------------------------------------------------------------------------------------------------

;;; NOTE(earl): This frame is bugged on my linux laptop
;;;             It shows two lines instead of one...

;;; Make the header-line mimic the mode-line, and hide the mode-line
;;; Defacto - Move the mode-line from the bottom to the top
;;; The minibuffer will still be at the bottom though
;; (setq-default header-line-format mode-line-format)
;; (setq-default mode-line-format nil)

;;-------------------------------------------------------------------------------------------------------------
;;
;; Misc stuff
;;
;;-------------------------------------------------------------------------------------------------------------

;; NOTE(earl): Configure the title bar
(setq frame-title-format '("" invocation-name "@" system-name "    %b    "    "%f"))

;; NOTE(earl): Configure the mode line
(setq-default mode-line-format '("%e" mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification "   " mode-line-position evil-mode-line-tag
                                 (vc-mode vc-mode)
                                 "  " mode-line-modes mode-line-misc-info mode-line-end-spaces "   %f"))
(setq earl-mode-line-color (cons (face-background 'mode-line) (face-foreground 'mode-line)))
(setq earl-mode-line-inactive-color (cons (face-background 'mode-line-inactive) (face-foreground 'mode-line-inactive)))
(setq earl-mode-line-compilation-in-progress-color '("#268bd2" . "#ffffff"))
(setq earl-mode-line-compilation-succsess-color '("#859900" . "#ffffff"))
(setq earl-mode-line-compilation-error-color '("#dc322f" . "#ffffff"))

(defun earl-set-face-background-and-foreground (face color)
  (set-face-background face (car color))
  (set-face-foreground face (cdr color)))

;; ;; Set the mode-line specific for the compiler-buffer
;; (add-hook 'compilation-mode-hook
;;           (lambda ()
;;             (face-remap-add-relative
;;              'mode-line '((:foreground "#ffffff" :background "#dc322f") mode-line))
;;             (face-remap-add-relative
;;              'mode-line-inactive '((:foreground "#000000" :background "#FF9895") mode-line)))) ;; "#FF9895", "#FF7F7C"

;; NOTE(earl): Line highlighting
(global-hl-line-mode 1) ;; Current line highlighting

;; NOTE(earl): Selection highlighting
;;             transient-mark-mode activates a bunch of annoying keybindings...
(transient-mark-mode 0) ;; Enable/Disable selection highlightning

;; IMPORTANT(earl): Make sure transient-mark-mode remains deactivated
;;                  defadvice modifies already existing functions (adds to them I think)
(defadvice set-mark-command (after no-bloody-t-m-m activate)
  "Prevent consecutive marks activating bloody `transient-mark-mode'."
  (if transient-mark-mode (setq transient-mark-mode nil)))
(defadvice mouse-set-region-1 (after no-bloody-t-m-m activate)
  "Prevent mouse commands activating bloody `transient-mark-mode'."
  (if transient-mark-mode (setq transient-mark-mode nil)))

;; NOTE(earl): Matching parentheses highlightning
;; (setq show-paren-delay 0) ;; by setting this to 0 paren highlightning should be instantanious,
;; but for some reason it's slower than the default value...
(show-paren-mode 1)
(require 'paren)

;; NOTE(earl): Line numbers
;;(global-linum-mode t)

;; NOTE(earl): Configure margins (They seem to be 0 by default)
;; (setq-default left-margin-width 0 right-margin-width 0) ; Define new widths.
;;  (set-window-buffer nil (current-buffer)) ; Use them now.

;; NOTE(earl): Configure internal or/and external border (fringe) [default ON]
;; (fringe-mode) ; USE THIS ONE - check documentation!
;; (set-fringe-mode 0) ; turn off, overrides fringe-mode

;;; NOTE(earl): Fullscreen
(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized)))))       ; Makes Emacs big window

;;****************************
;;
;; Emacs key configurations
;;
;;****************************

;; (global-set-key (kbd "C-x C-f") 'toggle-frame-fullscreen)         ; Toggle fullscreen (F11)

;;****************************
;;
;; End of Emacs key configurations
;;
;;****************************

;;; NOTE(earl): Disable stuff
(tool-bar-mode -1)     ;;; Disable toolbar
(menu-bar-mode -1)     ;;; Disable menu-bar
(toggle-scroll-bar -1) ;;; Disable scroll-bar

;;-------------------------------------------------------------------------------------------------------------
;;
;; Syntax Highlighting
;;
;;-------------------------------------------------------------------------------------------------------------

(defun earl-c-number-highlighting-hook ()
  (font-lock-add-keywords nil
                          '(
                            
                            ;; Valid hex number (will highlight invalid suffix though)
                            ("\\b0x[[:xdigit:]]+[uUlL]*\\b" . font-lock-constant-face)
                            
                            ;; Invalid hex number
                            ("\\b0x\\(\\w\\|\\.\\)+\\b" . font-lock-warning-face)
                            
                            ;; Valid floating point number.
                            ("\\(\\b[0-9]+\\|\\)\\(\\.\\)\\([0-9]+\\(e[-]?[0-9]+\\)?\\([lL]?\\|[dD]?[fF]?\\)\\)\\b" (1 font-lock-constant-face) (3 font-lock-constant-face))
                            
                            ;; ;; Invalid floating point number.  Must be before valid decimal.
                            ;; ("\\b[0-9].*?\\..+?\\b" . font-lock-warning-face)
                            
                            ;; Valid decimal number.  Must be before octal regexes otherwise 0 and 0l
                            ;; will be highlighted as errors.  Will highlight invalid suffix though.
                            ("\\b\\(\\(0\\|[1-9][0-9]*\\)[uUlL]*\\)\\b" 1 font-lock-constant-face)
                            
                            ;; Valid octal number
                            ("\\b0[0-7]+[uUlL]*\\b" . font-lock-constant-face)
                            
                            ;; Floating point number with no digits after the period.  This must be
                            ;; after the invalid numbers, otherwise it will "steal" some invalid
                            ;; numbers and highlight them as valid.
                            ("\\b\\([0-9]+\\)\\." (1 font-lock-constant-face))
                            
                            ;; Invalid number.  Must be last so it only highlights anything not
                            ;; matched above.
                            ("\\b[0-9]\\(\\w\\|\\.\\)+?\\b" . font-lock-warning-face)
                            )))

;; Highlight numbers in C
(add-hook 'c-mode-common-hook 'earl-c-number-highlighting-hook)

;;-------------------------------------------------------------------------------------------------------------
;;
;; Themes
;;
;;-------------------------------------------------------------------------------------------------------------

(defun earl-set-light-sol-background ()
  "Light sol background"
  (interactive)
  (set-face-background 'hl-line earl-color-sol-base2)
  (set-background-color earl-color-sol-base3)
  (set-face-background 'fringe earl-color-sol-base3))

(defun earl-set-gray-background ()
  "Gray background"
  (interactive)
  (set-face-background 'hl-line earl-color-sol-base3)
  (set-background-color earl-color-light-background)
  (set-face-background 'fringe earl-color-light-background))

(defun earl-set-light-sol-inverted-background ()
  "Light sol inverted background"
  (interactive)
  (set-face-background 'hl-line earl-color-sol-base3)
  (set-background-color earl-color-sol-base2)
  (set-face-background 'fringe earl-color-sol-base2))

(defun casey-dark-theme ()
  "Handmade Hero Theme"
  (interactive)
  
  ;; Color variables
  ;; -------------------------------
  (setq earl-color-text "burlywood3")
  (setq earl-color-comment "gray75")
  (setq earl-color-string "#81B419")
  (setq earl-color-keyword "DarkGoldenrod3")
  (setq earl-color-background "#161616") ;; "#292929", "#161616", "#0C0C0C"
  (setq earl-color-cursor "#40FF40")
  (setq earl-color-hl-line "midnight blue") ;; "midnight blue", "#161616", "#194545"
  (setq earl-color-emphasized "#ffffff")
  (setq earl-color-todo "Red")
  (setq earl-color-study "Yellow")
  (setq earl-color-important "Yellow")
  (setq earl-color-note "Light Green")
  (setq earl-color-region "#194545")
  (setq earl-color-background-insert "#974325")
  (setq earl-color-cursor-insert "#FF0002")
  (setq earl-color-custom01 "#466B6B")
  
  ;; Line highlighting and selection highlighting
  (set-face-background 'hl-line earl-color-hl-line)
  (set-face-background 'region earl-color-region)
  
  ;; Matching parentheses highlighting
  ;; (set-face-background 'show-paren-match (face-background 'default)) ;; 'default, 'region, 'highlight
  (set-face-background 'show-paren-match earl-color-background)
  (set-face-foreground 'show-paren-match earl-color-emphasized)
  ;; (set-face-attribute 'show-paren-match nil :weight 'extra-bold)
  (set-face-background 'show-paren-mismatch earl-color-keyword)
  (set-face-foreground 'show-paren-mismatch earl-color-emphasized)
  
  ;;; IDO-color-configuration (affects mainly the MINIBUFFER)
  (set-face-attribute 'ido-subdir nil :foreground earl-color-text)
  (set-face-attribute 'ido-first-match nil :foreground earl-color-keyword)
  (set-face-attribute 'ido-only-match nil :foreground earl-color-string)
  (set-face-attribute 'ido-indicator nil :foreground earl-color-text)
  (set-face-attribute 'ido-incomplete-regexp nil :foreground earl-color-text)
  
  ;;; isearch
  (set-face-background 'isearch earl-color-string)
  (set-face-foreground 'isearch earl-color-emphasized)
  (set-face-background 'lazy-highlight earl-color-custom01)
  (set-face-foreground 'lazy-highlight earl-color-emphasized)
  ;; (custom-set-faces '(isearch-fail ((((class color)) (:background "#8B0000")))))
  ;; (setq lazy-highlight-cleanup nil)
  
  ;; Misc stuff
  (set-face-attribute 'font-lock-builtin-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-comment-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-comment-delimiter-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-constant-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-doc-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-function-name-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-keyword-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-string-face nil :foreground earl-color-string)
  (set-face-attribute 'font-lock-type-face nil :foreground earl-color-text) ;; earl-color-keyword
  (set-face-attribute 'font-lock-variable-name-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-preprocessor-face nil :foreground earl-color-keyword)
  ;; (set-face-attribute 'default nil :weight 'bold) ;; bold text
  (set-foreground-color earl-color-text)
  (set-background-color earl-color-background)
  (set-face-background 'fringe earl-color-background)
  (set-cursor-color earl-color-cursor)
  
  (modify-face 'font-lock-fixme-face earl-color-todo nil nil t nil t nil nil)
  (modify-face 'font-lock-study-face earl-color-study nil nil t nil t nil nil)
  (modify-face 'font-lock-important-face earl-color-important nil nil t nil t nil nil)
  (modify-face 'font-lock-note-face earl-color-note nil nil t nil t nil nil)
  )

(defun casey-dark-theme-colorful ()
  "Colorful Handmade Hero Theme"
  (interactive)
  
  ;; Color variables
  ;; -------------------------------
  (setq earl-color-text "burlywood3")
  (setq earl-color-comment "gray75")
  (setq earl-color-string "#81B419")
  (setq earl-color-keyword "DarkGoldenrod3")
  (setq earl-color-type earl-color-keyword)
  (setq earl-color-background "#161616") ;; "#292929", "#161616", "#0C0C0C"
  (setq earl-color-cursor "#40FF40")
  (setq earl-color-hl-line "midnight blue") ;; "midnight blue", "#161616", "#194545"
  (setq earl-color-emphasized "#ffffff")
  (setq earl-color-todo "Red")
  (setq earl-color-study "Yellow")
  (setq earl-color-important "Yellow")
  (setq earl-color-note "Light Green")
  (setq earl-color-region "#194545")
  (setq earl-color-background-insert "#974325")
  (setq earl-color-cursor-insert "#FF0002")
  (setq earl-color-custom01 "#466B6B")
  
  ;; Line highlighting and selection highlighting
  (set-face-background 'hl-line earl-color-hl-line)
  (set-face-background 'region earl-color-region)
  
  ;; Matching parentheses highlighting
  ;; (set-face-background 'show-paren-match (face-background 'default)) ;; 'default, 'region, 'highlight
  (set-face-background 'show-paren-match earl-color-background)
  (set-face-foreground 'show-paren-match earl-color-emphasized)
  ;; (set-face-attribute 'show-paren-match nil :weight 'extra-bold)
  (set-face-background 'show-paren-mismatch earl-color-keyword)
  (set-face-foreground 'show-paren-mismatch earl-color-emphasized)
  
  ;;; IDO-color-configuration (affects mainly the MINIBUFFER)
  (set-face-attribute 'ido-subdir nil :foreground earl-color-text)
  (set-face-attribute 'ido-first-match nil :foreground earl-color-keyword)
  (set-face-attribute 'ido-only-match nil :foreground earl-color-string)
  (set-face-attribute 'ido-indicator nil :foreground earl-color-text)
  (set-face-attribute 'ido-incomplete-regexp nil :foreground earl-color-text)
  
  ;;; isearch
  (set-face-background 'isearch earl-color-string)
  (set-face-foreground 'isearch earl-color-emphasized)
  (set-face-background 'lazy-highlight earl-color-custom01)
  (set-face-foreground 'lazy-highlight earl-color-emphasized)
  ;; (custom-set-faces '(isearch-fail ((((class color)) (:background "#8B0000")))))
  ;; (setq lazy-highlight-cleanup nil)
  
  ;; Misc stuff
  (set-face-attribute 'font-lock-builtin-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-comment-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-comment-delimiter-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-constant-face nil :foreground earl-color-type)
  (set-face-attribute 'font-lock-doc-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-function-name-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-keyword-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-string-face nil :foreground earl-color-string)
  (set-face-attribute 'font-lock-type-face nil :foreground earl-color-type)
  (set-face-attribute 'font-lock-variable-name-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-preprocessor-face nil :foreground earl-color-keyword)
  ;; (set-face-attribute 'default nil :weight 'bold) ;; bold text
  (set-foreground-color earl-color-text)
  (set-background-color earl-color-background)
  (set-face-background 'fringe earl-color-background)
  (set-cursor-color earl-color-cursor)
  
  (modify-face 'font-lock-fixme-face earl-color-todo nil nil t nil t nil nil)
  (modify-face 'font-lock-study-face earl-color-study nil nil t nil t nil nil)
  (modify-face 'font-lock-important-face earl-color-important nil nil t nil t nil nil)
  (modify-face 'font-lock-note-face earl-color-note nil nil t nil t nil nil)
  )

(defun earl-gray-theme ()
  "Gray theme"
  (interactive)
  
  ;; Color variables
  ;; -------------------------------
  (setq earl-color-text "#000000") ; earl-color-sol-base03, "#000000"
  (setq earl-color-comment earl-color-light-green)
  (setq earl-color-string earl-color-light-blue) ; earl-color-sol-blue
  (setq earl-color-keyword earl-color-text)
  (setq earl-color-background earl-color-light-background)
  (setq earl-color-cursor "#000000") ; earl-color-sol-blue
  (setq earl-color-hl-line earl-color-sol-base3) ; earl-color-sol-base3, "#ffffff" 
  (setq earl-color-emphasized earl-color-text)
  (setq earl-color-todo earl-color-sol-red)
  (setq earl-color-study earl-color-sol-yellow)
  (setq earl-color-important earl-color-sol-magenta)
  (setq earl-color-note earl-color-sol-blue)
  (setq earl-color-region "#194545")
  (setq earl-color-background-insert "#974325")
  (setq earl-color-cursor-insert "#FF0002")
  (setq earl-color-custom01 "#466B6B")
  
  ;; Line highlighting, selection highlighting
  (set-face-background 'hl-line earl-color-hl-line)
  (set-face-background 'region earl-color-region)
  
  ;; Matching parentheses highlightning
  ;; (set-face-background 'show-paren-match (face-background 'default))
  (set-face-background 'show-paren-match "#92D4FF")
  (set-face-foreground 'show-paren-match "#ffffff")
  ;; (set-face-attribute 'show-paren-match nil :weight 'extra-bold)
  (set-face-background 'show-paren-mismatch earl-color-sol-red)
  (set-face-foreground 'show-paren-mismatch "#ffffff")
  
  ;; IDO-color-configuration (affects mainly the MINIBUFFER)
  (set-face-attribute 'ido-subdir nil :foreground earl-color-text)
  (set-face-attribute 'ido-first-match nil :foreground earl-color-sol-blue)
  (set-face-attribute 'ido-only-match nil :foreground earl-color-light-green)
  (set-face-attribute 'ido-indicator nil :foreground earl-color-text)
  (set-face-attribute 'ido-incomplete-regexp nil :foreground earl-color-text)
  
  ;; isearch
  (set-face-background 'isearch "#6AA67D")
  (set-face-background 'isearch earl-color-sol-green)
  (set-face-foreground 'isearch "#ffffff")
  (set-face-background 'lazy-highlight "#67addf")
  (set-face-foreground 'lazy-highlight "#ffffff")
  ;; (custom-set-faces '(isearch-fail ((((class color)) (:background "#8B0000")))))
  ;; (setq lazy-highlight-cleanup nil)
  
  ;; Misc stuff
  (set-face-attribute 'font-lock-builtin-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-comment-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-constant-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-doc-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-function-name-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-keyword-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-string-face nil :foreground earl-color-string)
  (set-face-attribute 'font-lock-type-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-variable-name-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-preprocessor-face nil :foreground earl-color-keyword)
  ;; (set-face-attribute 'default nil :weight 'medium) ;; Not bold text
  (set-foreground-color earl-color-text)
  (set-background-color earl-color-background)
  (set-face-background 'fringe earl-color-background)
  (set-cursor-color earl-color-cursor)
  
  (modify-face 'font-lock-fixme-face earl-color-todo nil nil t nil t nil nil)
  (modify-face 'font-lock-study-face earl-color-study nil nil t nil t nil nil)
  (modify-face 'font-lock-important-face earl-color-important nil nil t nil t nil nil)
  (modify-face 'font-lock-note-face earl-color-note nil nil t nil t nil nil)
  )

(defun earl-white-theme ()
  "White theme"
  (interactive)
  
  ;; Color variables
  ;; -------------------------------
  (setq earl-color-text "#000000")
  (setq earl-color-comment earl-color-light-green)
  (setq earl-color-string earl-color-light-blue)
  (setq earl-color-keyword earl-color-text)
  (setq earl-color-background "#ffffff")
  (setq earl-color-cursor "#000000")
  (setq earl-color-hl-line earl-color-sol-base2)
  (setq earl-color-emphasized earl-color-text)
  (setq earl-color-todo earl-color-sol-red)
  (setq earl-color-study earl-color-sol-yellow)
  (setq earl-color-important earl-color-sol-magenta)
  (setq earl-color-note earl-color-sol-blue)
  (setq earl-color-region "#194545")
  (setq earl-color-background-insert "#974325")
  (setq earl-color-cursor-insert "#FF0002")
  (setq earl-color-custom01 "#466B6B")
  
  ;; Line highlighting, selection highlighting
  (set-face-background 'hl-line earl-color-hl-line)
  (set-face-background 'region earl-color-region)
  
  ;; Matching parentheses highlightning
  ;; (set-face-background 'show-paren-match (face-background 'default))
  (set-face-background 'show-paren-match "#92D4FF") ;; "#82C4D5", "#92D4E5", "#92D4FF"
  (set-face-foreground 'show-paren-match "#ffffff")
  ;; (set-face-attribute 'show-paren-match nil :weight 'extra-bold)
  (set-face-background 'show-paren-mismatch earl-color-sol-red) ; "#F77C8D"
  (set-face-foreground 'show-paren-mismatch "#ffffff")
  
  ;; IDO-color-configuration (affects mainly the MINIBUFFER)
  (set-face-attribute 'ido-subdir nil :foreground earl-color-text)
  (set-face-attribute 'ido-first-match nil :foreground earl-color-sol-blue)
  (set-face-attribute 'ido-only-match nil :foreground earl-color-light-green)
  (set-face-attribute 'ido-indicator nil :foreground earl-color-text)
  (set-face-attribute 'ido-incomplete-regexp nil :foreground earl-color-text)
  
  ;; isearch
  (set-face-background 'isearch "#6AA67D") ; "#76AC85"
  (set-face-foreground 'isearch "#ffffff")
  (set-face-background 'lazy-highlight "#82C4D5")
  (set-face-foreground 'lazy-highlight "#ffffff")
  ;; (custom-set-faces '(isearch-fail ((((class color)) (:background "#8B0000")))))
  ;; (setq lazy-highlight-cleanup nil)
  
  ;; Misc stuff
  (set-face-attribute 'font-lock-builtin-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-comment-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-constant-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-doc-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-function-name-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-keyword-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-string-face nil :foreground earl-color-string)
  (set-face-attribute 'font-lock-type-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-variable-name-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-preprocessor-face nil :foreground earl-color-keyword)
  ;; (set-face-attribute 'default nil :weight 'medium) ;; Not bold text
  (set-foreground-color earl-color-text)
  (set-background-color earl-color-background)
  (set-face-background 'fringe earl-color-background)
  (set-cursor-color earl-color-cursor)
  
  (modify-face 'font-lock-fixme-face earl-color-todo nil nil t nil t nil nil)
  (modify-face 'font-lock-study-face earl-color-study nil nil t nil t nil nil)
  (modify-face 'font-lock-important-face earl-color-important nil nil t nil t nil nil)
  (modify-face 'font-lock-note-face earl-color-note nil nil t nil t nil nil)
  )

(defun earl-light-sol-theme ()
  "Light sol theme"
  (interactive)
  
  ;; Default light-sol-values
  ;; earl-color-sol-base01 - emphasized content
  ;; earl-color-sol-base00 - body text
  ;; earl-color-sol-base1  - comments
  ;; earl-color-sol-base2  - background highlights
  ;; earl-color-sol-base3  - background
  
  ;; Color variables
  ;; -------------------------------
  (setq earl-color-text earl-color-sol-base00)
  (setq earl-color-comment earl-color-sol-base1)
  (setq earl-color-type earl-color-sol-blue)
  (setq earl-color-string earl-color-sol-green)
  (setq earl-color-keyword earl-color-sol-orange)
  (setq earl-color-emphasized earl-color-sol-base01)
  (setq earl-color-cursor earl-color-emphasized)
  (setq earl-color-background earl-color-sol-base3)
  (setq earl-color-hl-line earl-color-sol-base2)
  (setq earl-color-todo earl-color-sol-red)
  (setq earl-color-study earl-color-sol-yellow)
  (setq earl-color-important earl-color-sol-magenta)
  (setq earl-color-note earl-color-sol-blue)
  
  ;; Line highlighting, selection highlighting
  (set-face-background 'hl-line earl-color-hl-line)
  (set-face-background 'region earl-color-light-background)
  
  ;; Matching parentheses highlightning
  (set-face-background 'show-paren-match "#92D4FF")
  (set-face-foreground 'show-paren-match "#ffffff")
  (set-face-background 'show-paren-mismatch earl-color-sol-red)
  (set-face-foreground 'show-paren-mismatch "#ffffff")
  ;; (set-face-attribute 'show-paren-match nil :box '(:line-width -1 :color "black" :style nil))
  
  ;; IDO-color-configuration (affects mainly the MINIBUFFER)
  (set-face-attribute 'ido-subdir nil :foreground earl-color-text)
  (set-face-attribute 'ido-first-match nil :foreground earl-color-sol-blue)
  (set-face-attribute 'ido-only-match nil :foreground earl-color-sol-green)
  (set-face-attribute 'ido-indicator nil :foreground earl-color-text)
  (set-face-attribute 'ido-incomplete-regexp nil :foreground earl-color-text)
  
  ;; isearch
  (set-face-background 'isearch earl-color-sol-green)
  (set-face-foreground 'isearch "#ffffff")
  (set-face-background 'lazy-highlight "#82C4D5")
  (set-face-foreground 'lazy-highlight "#ffffff")
  
  ;; Compilation
  (set-face-foreground 'compilation-error earl-color-sol-red)
  (set-face-foreground 'compilation-info earl-color-sol-green)
  
  ;; Misc stuff
  (set-face-attribute 'font-lock-builtin-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-comment-delimiter-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-comment-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-constant-face nil :foreground earl-color-type)
  (set-face-attribute 'font-lock-doc-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-function-name-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-keyword-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-negation-char-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-preprocessor-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-string-face nil :foreground earl-color-string)
  (set-face-attribute 'font-lock-type-face nil :foreground earl-color-type)
  (set-face-attribute 'font-lock-variable-name-face nil :foreground earl-color-text)
  ;; (set-face-attribute 'font-lock-warning-face nil :foreground earl-color-text)
  ;; (set-face-attribute 'font-lock-warning-face nil :weight 'medium)
  
  (set-foreground-color earl-color-text)
  (set-background-color earl-color-background)
  (set-face-background 'fringe earl-color-hl-line)
  (set-cursor-color earl-color-cursor)
  
  (modify-face 'font-lock-fixme-face earl-color-todo nil nil t nil t nil nil)
  (modify-face 'font-lock-study-face earl-color-study nil nil t nil t nil nil)
  (modify-face 'font-lock-important-face earl-color-important nil nil t nil t nil nil)
  (modify-face 'font-lock-note-face earl-color-note nil nil t nil t nil nil)
  )

(defun earl-light-sol-theme-contrast ()
  "Light sol theme with stronger contrast"
  (interactive)
  
  ;; Default light-sol-values
  ;; earl-color-sol-base01 - emphasized content
  ;; earl-color-sol-base00 - body text
  ;; earl-color-sol-base1  - comments
  ;; earl-color-sol-base2  - background highlights
  ;; earl-color-sol-base3  - background
  
  ;; Color variables
  ;; -------------------------------
  (setq earl-color-text earl-color-sol-base02) ;; earl-color-sol-base02, earl-color-sol-base01
  (setq earl-color-comment earl-color-sol-base01) ;; earl-color-sol-base00, earl-color-sol-base0
  (setq earl-color-type earl-color-sol-blue)
  (setq earl-color-string earl-color-sol-green)
  (setq earl-color-keyword earl-color-sol-red) ;; earl-color-sol-orange
  (setq earl-color-emphasized earl-color-sol-base03) ;; earl-color-sol-base03, earl-color-sol-base02
  (setq earl-color-cursor earl-color-emphasized)
  (setq earl-color-background "#ffffff") ;; earl-color-sol-base3, "#ffffff"
  (setq earl-color-hl-line earl-color-sol-base3) ;; earl-color-sol-base3, earl-color-sol-base2, "#ffffff", earl-color-background
  (setq earl-color-todo earl-color-sol-red)
  (setq earl-color-study earl-color-sol-blue) ;; earl-color-sol-yellow
  (setq earl-color-important earl-color-sol-red) ;; earl-color-sol-magenta
  (setq earl-color-note earl-color-sol-blue)
  
  ;; Line highlighting, selection highlighting
  (set-face-background 'hl-line earl-color-hl-line)
  (set-face-background 'region earl-color-light-background)
  
  ;; Matching parentheses highlightning
  (set-face-background 'show-paren-match "#92D4FF")
  (set-face-foreground 'show-paren-match "#ffffff")
  (set-face-background 'show-paren-mismatch earl-color-sol-red)
  (set-face-foreground 'show-paren-mismatch "#ffffff")
  ;; (set-face-attribute 'show-paren-match nil :box '(:line-width -1 :color "black" :style nil))
  ;; (set-face-attribute 'show-paren-mismatch nil :box '(:line-width -1 :color "black" :style nil))
  
  ;; IDO-color-configuration (affects mainly the MINIBUFFER)
  (set-face-attribute 'ido-subdir nil :foreground earl-color-text)
  (set-face-attribute 'ido-first-match nil :foreground earl-color-sol-blue)
  (set-face-attribute 'ido-only-match nil :foreground earl-color-sol-green)
  (set-face-attribute 'ido-indicator nil :foreground earl-color-text)
  (set-face-attribute 'ido-incomplete-regexp nil :foreground earl-color-text)
  
  ;; isearch
  (set-face-background 'isearch earl-color-sol-green)
  (set-face-foreground 'isearch "#ffffff")
  (set-face-background 'lazy-highlight "#82C4D5")
  (set-face-foreground 'lazy-highlight "#ffffff")
  
  ;; Compilation
  (set-face-foreground 'compilation-error earl-color-sol-red)
  (set-face-foreground 'compilation-info earl-color-sol-green)
  
  ;; Misc stuff
  (set-face-attribute 'font-lock-builtin-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-comment-delimiter-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-comment-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-constant-face nil :foreground earl-color-type)
  (set-face-attribute 'font-lock-doc-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-function-name-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-keyword-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-negation-char-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-preprocessor-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-string-face nil :foreground earl-color-string)
  (set-face-attribute 'font-lock-type-face nil :foreground earl-color-type)
  (set-face-attribute 'font-lock-variable-name-face nil :foreground earl-color-text)
  ;; (set-face-attribute 'font-lock-warning-face nil :foreground earl-color-text)
  ;; (set-face-attribute 'font-lock-warning-face nil :weight 'medium)
  
  (set-foreground-color earl-color-text)
  (set-background-color earl-color-background)
  (set-face-background 'fringe earl-color-background) ;; earl-color-hl-line
  (set-cursor-color earl-color-cursor)
  
  (modify-face 'font-lock-fixme-face earl-color-todo nil nil t nil t nil nil)
  (modify-face 'font-lock-study-face earl-color-study nil nil t nil t nil nil)
  (modify-face 'font-lock-important-face earl-color-important nil nil t nil t nil nil)
  (modify-face 'font-lock-note-face earl-color-note nil nil t nil t nil nil)
  )

(defun earl-light-sol-theme-super-contrast ()
  "Light sol theme with stronger contrast"
  (interactive)
  
  ;; Color variables
  ;; -------------------------------
  (setq earl-color-text "000000")
  (setq earl-color-comment earl-color-sol-base01)
  (setq earl-color-type "#0D72B9")
  (setq earl-color-string "#6C8000")
  (setq earl-color-keyword "#C31916")
  (setq earl-color-emphasized "000000")
  (setq earl-color-cursor earl-color-emphasized)
  (setq earl-color-background earl-color-sol-base3) ;; earl-color-sol-base3, "#ffffff"
  (setq earl-color-hl-line "#ffffff") ;; earl-color-sol-base2, "#ffffff"
  (setq earl-color-todo earl-color-keyword)
  (setq earl-color-study earl-color-sol-yellow)
  (setq earl-color-important earl-color-sol-magenta)
  (setq earl-color-note earl-color-type)
  
  ;; Line highlighting, selection highlighting
  (set-face-background 'hl-line earl-color-hl-line)
  (set-face-background 'region earl-color-light-background)
  
  ;; Matching parentheses highlightning
  (set-face-background 'show-paren-match "#92D4FF")
  (set-face-foreground 'show-paren-match "#ffffff")
  (set-face-background 'show-paren-mismatch earl-color-sol-red)
  (set-face-foreground 'show-paren-mismatch "#ffffff")
  ;; (set-face-attribute 'show-paren-match nil :box '(:line-width -1 :color "black" :style nil))
  ;; (set-face-attribute 'show-paren-mismatch nil :box '(:line-width -1 :color "black" :style nil))
  
  ;; IDO-color-configuration (affects mainly the MINIBUFFER)
  (set-face-attribute 'ido-subdir nil :foreground earl-color-text)
  (set-face-attribute 'ido-first-match nil :foreground earl-color-sol-blue)
  (set-face-attribute 'ido-only-match nil :foreground earl-color-sol-green)
  (set-face-attribute 'ido-indicator nil :foreground earl-color-text)
  (set-face-attribute 'ido-incomplete-regexp nil :foreground earl-color-text)
  
  ;; isearch
  (set-face-background 'isearch earl-color-sol-green)
  (set-face-foreground 'isearch "#ffffff")
  (set-face-background 'lazy-highlight "#82C4D5")
  (set-face-foreground 'lazy-highlight "#ffffff")
  
  ;; Compilation
  (set-face-foreground 'compilation-error earl-color-sol-red)
  (set-face-foreground 'compilation-info earl-color-sol-green)
  
  ;; Misc stuff
  (set-face-attribute 'font-lock-builtin-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-comment-delimiter-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-comment-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-constant-face nil :foreground earl-color-type)
  (set-face-attribute 'font-lock-doc-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-function-name-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-keyword-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-negation-char-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-preprocessor-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-string-face nil :foreground earl-color-string)
  (set-face-attribute 'font-lock-type-face nil :foreground earl-color-type)
  (set-face-attribute 'font-lock-variable-name-face nil :foreground earl-color-text)
  ;; (set-face-attribute 'font-lock-warning-face nil :foreground earl-color-text)
  ;; (set-face-attribute 'font-lock-warning-face nil :weight 'medium)
  
  (set-foreground-color earl-color-text)
  (set-background-color earl-color-background)
  (set-face-background 'fringe earl-color-background) ;; earl-color-hl-line
  (set-cursor-color earl-color-cursor)
  
  (modify-face 'font-lock-fixme-face earl-color-todo nil nil t nil t nil nil)
  (modify-face 'font-lock-study-face earl-color-study nil nil t nil t nil nil)
  (modify-face 'font-lock-important-face earl-color-important nil nil t nil t nil nil)
  (modify-face 'font-lock-note-face earl-color-note nil nil t nil t nil nil)
  )

(defun earl-dark-sol-theme ()
  "Dark sol theme"
  (interactive)
  
  ;; Default dark-sol-values
  ;; earl-color-sol-base1   - emphasized content
  ;; earl-color-sol-base0   - body text
  ;; earl-color-sol-base01  - comments
  ;; earl-color-sol-base02  - background highlights
  ;; earl-color-sol-base03  - background
  
  ;; Color variables
  ;; -------------------------------
  (setq earl-color-text earl-color-sol-base0)
  (setq earl-color-comment earl-color-sol-base01)
  (setq earl-color-string earl-color-sol-blue)
  (setq earl-color-keyword earl-color-sol-yellow)
  (setq earl-color-background earl-color-sol-base03)
  (setq earl-color-cursor earl-color-sol-green)
  (setq earl-color-hl-line earl-color-sol-base02)
  (setq earl-color-emphasized earl-color-sol-base1)
  (setq earl-color-todo earl-color-sol-red)
  (setq earl-color-study earl-color-sol-yellow)
  (setq earl-color-important earl-color-sol-magenta)
  (setq earl-color-note earl-color-sol-green)
  
  ;; Line highlighting, selection highlighting
  (set-face-background 'hl-line earl-color-hl-line)
  (set-face-background 'region earl-color-sol-red)
  
  ;; Matching parentheses highlightning
  (set-face-background 'show-paren-match earl-color-background)
  (set-face-foreground 'show-paren-match "#ffffff")
  (set-face-background 'show-paren-mismatch earl-color-sol-red)
  (set-face-foreground 'show-paren-mismatch "#ffffff")
  
  ;; IDO-color-configuration (affects mainly the MINIBUFFER)
  (set-face-attribute 'ido-subdir nil :foreground earl-color-text)
  (set-face-attribute 'ido-first-match nil :foreground earl-color-sol-blue)
  (set-face-attribute 'ido-only-match nil :foreground earl-color-sol-green)
  (set-face-attribute 'ido-indicator nil :foreground earl-color-text)
  (set-face-attribute 'ido-incomplete-regexp nil :foreground earl-color-text)
  
  ;; isearch
  (set-face-background 'isearch earl-color-sol-green)
  (set-face-foreground 'isearch "#ffffff")
  (set-face-background 'lazy-highlight earl-color-sol-blue)
  (set-face-foreground 'lazy-highlight "#ffffff")
  
  ;; Misc stuff
  (set-face-attribute 'font-lock-builtin-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-comment-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-constant-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-doc-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-function-name-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-keyword-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-string-face nil :foreground earl-color-string)
  (set-face-attribute 'font-lock-type-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-variable-name-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-preprocessor-face nil :foreground earl-color-keyword)
  
  (set-foreground-color earl-color-text)
  (set-background-color earl-color-background)
  (set-face-background 'fringe earl-color-hl-line)
  (set-cursor-color earl-color-cursor)
  
  (modify-face 'font-lock-fixme-face earl-color-todo nil nil t nil t nil nil)
  (modify-face 'font-lock-study-face earl-color-study nil nil t nil t nil nil)
  (modify-face 'font-lock-important-face earl-color-important nil nil t nil t nil nil)
  (modify-face 'font-lock-note-face earl-color-note nil nil t nil t nil nil)
  )

(defun earl-dark-sol-theme-colorful ()
  "Colorful Dark sol theme"
  (interactive)
  
  ;; Default dark-sol-values
  ;; earl-color-sol-base1   - emphasized content
  ;; earl-color-sol-base0   - body text
  ;; earl-color-sol-base01  - comments
  ;; earl-color-sol-base02  - background highlights
  ;; earl-color-sol-base03  - background
  
  ;; Color variables
  ;; -------------------------------
  (setq earl-color-text earl-color-sol-base0)
  (setq earl-color-comment earl-color-sol-base01)
  (setq earl-color-type earl-color-sol-blue)
  (setq earl-color-string earl-color-sol-green)
  (setq earl-color-keyword earl-color-sol-orange)
  (setq earl-color-background earl-color-sol-base03)
  (setq earl-color-hl-line earl-color-sol-base02)
  (setq earl-color-emphasized earl-color-sol-base1)
  (setq earl-color-cursor earl-color-sol-green)
  (setq earl-color-todo earl-color-sol-red)
  (setq earl-color-study earl-color-sol-yellow)
  (setq earl-color-important earl-color-sol-magenta)
  (setq earl-color-note earl-color-sol-green)
  
  ;; Line highlighting, selection highlighting
  (set-face-background 'hl-line earl-color-hl-line)
  (set-face-background 'region earl-color-sol-red)
  
  ;; Matching parentheses highlightning
  (set-face-background 'show-paren-match earl-color-background)
  (set-face-foreground 'show-paren-match "#ffffff")
  (set-face-background 'show-paren-mismatch earl-color-sol-red)
  (set-face-foreground 'show-paren-mismatch "#ffffff")
  
  ;; IDO-color-configuration (affects mainly the MINIBUFFER)
  (set-face-attribute 'ido-subdir nil :foreground earl-color-text)
  (set-face-attribute 'ido-first-match nil :foreground earl-color-sol-blue)
  (set-face-attribute 'ido-only-match nil :foreground earl-color-sol-green)
  (set-face-attribute 'ido-indicator nil :foreground earl-color-text)
  (set-face-attribute 'ido-incomplete-regexp nil :foreground earl-color-text)
  
  ;; isearch
  (set-face-background 'isearch earl-color-sol-green)
  (set-face-foreground 'isearch "#ffffff")
  (set-face-background 'lazy-highlight earl-color-sol-blue)
  (set-face-foreground 'lazy-highlight "#ffffff")
  
  ;; Misc stuff
  (set-face-attribute 'font-lock-builtin-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-comment-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-constant-face nil :foreground earl-color-type)
  (set-face-attribute 'font-lock-doc-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-function-name-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-keyword-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-string-face nil :foreground earl-color-string)
  (set-face-attribute 'font-lock-type-face nil :foreground earl-color-type)
  (set-face-attribute 'font-lock-variable-name-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-preprocessor-face nil :foreground earl-color-keyword)
  
  (set-foreground-color earl-color-text)
  (set-background-color earl-color-background)
  (set-face-background 'fringe earl-color-hl-line)
  (set-cursor-color earl-color-cursor)
  
  (modify-face 'font-lock-fixme-face earl-color-todo nil nil t nil t nil nil)
  (modify-face 'font-lock-study-face earl-color-study nil nil t nil t nil nil)
  (modify-face 'font-lock-important-face earl-color-important nil nil t nil t nil nil)
  (modify-face 'font-lock-note-face earl-color-note nil nil t nil t nil nil)
  )

(defun jblow-dark-theme ()
  "Jonathan Blow's theme"
  (interactive)
  
  ;; Color variables
  ;; -------------------------------
  (setq earl-color-text "#C4B19C")
  (setq earl-color-comment "#F3F843")
  (setq earl-color-string "#B3B2B3")
  (setq earl-color-keyword "#FFFFFF")
  (setq earl-color-background "#2A282A") ;; "#292929", "#161616", "#0C0C0C"
  (setq earl-color-cursor "#8FED90")
  (setq earl-color-hl-line "#1B1A1C") ;; earl-color-background, "#393638", "#1B1A1C", "#161616"
  (setq earl-color-emphasized earl-color-keyword)
  (setq earl-color-todo "Red")
  (setq earl-color-study "Cyan")
  (setq earl-color-important "White")
  (setq earl-color-note "Light Green")
  (setq earl-color-region "#194545")
  (setq earl-color-background-insert "#974325")
  (setq earl-color-cursor-insert "#FF0002")
  (setq earl-color-custom01 "#466B6B")
  (setq earl-color-constant "#8BF4D8")
  
  ;; Line highlighting and selection highlighting
  (set-face-background 'hl-line earl-color-hl-line)
  (set-face-background 'region earl-color-region)
  
  ;; Matching parentheses highlighting
  ;; (set-face-background 'show-paren-match (face-background 'default)) ;; 'default, 'region, 'highlight
  (set-face-background 'show-paren-match earl-color-background)
  (set-face-foreground 'show-paren-match earl-color-emphasized)
  ;; (set-face-attribute 'show-paren-match nil :weight 'extra-bold)
  (set-face-background 'show-paren-mismatch earl-color-keyword)
  (set-face-foreground 'show-paren-mismatch earl-color-emphasized)
  
  ;;; IDO-color-configuration (affects mainly the MINIBUFFER)
  (set-face-attribute 'ido-subdir nil :foreground earl-color-text)
  (set-face-attribute 'ido-first-match nil :foreground earl-color-keyword)
  (set-face-attribute 'ido-only-match nil :foreground earl-color-string)
  (set-face-attribute 'ido-indicator nil :foreground earl-color-text)
  (set-face-attribute 'ido-incomplete-regexp nil :foreground earl-color-text)
  
  ;;; isearch
  (set-face-background 'isearch earl-color-string)
  (set-face-foreground 'isearch earl-color-emphasized)
  (set-face-background 'lazy-highlight earl-color-custom01)
  (set-face-foreground 'lazy-highlight earl-color-emphasized)
  ;; (custom-set-faces '(isearch-fail ((((class color)) (:background "#8B0000")))))
  ;; (setq lazy-highlight-cleanup nil)
  
  ;; Misc stuff
  (set-face-attribute 'font-lock-builtin-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-comment-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-comment-delimiter-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-constant-face nil :foreground earl-color-constant) ;; earl-color-text
  (set-face-attribute 'font-lock-doc-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-function-name-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-keyword-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-string-face nil :foreground earl-color-string)
  (set-face-attribute 'font-lock-type-face nil :foreground earl-color-cursor) ;; earl-color-keyword, earl-color-text
  (set-face-attribute 'font-lock-variable-name-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-preprocessor-face nil :foreground earl-color-cursor) ;; earl-color-keyword
  ;; (set-face-attribute 'default nil :weight 'bold) ;; bold text
  (set-foreground-color earl-color-text)
  (set-background-color earl-color-background)
  (set-face-background 'fringe earl-color-background)
  (set-cursor-color earl-color-cursor)
  
  (modify-face 'font-lock-fixme-face earl-color-todo nil nil t nil t nil nil)
  (modify-face 'font-lock-study-face earl-color-study nil nil t nil t nil nil)
  (modify-face 'font-lock-important-face earl-color-important nil nil t nil t nil nil)
  (modify-face 'font-lock-note-face earl-color-note nil nil t nil t nil nil)
  )

(defun 4coder-theme ()
  "Light sol theme with stronger contrast"
  (interactive)
  
  ;; Default light-sol-values
  ;; earl-color-sol-base01 - emphasized content
  ;; earl-color-sol-base00 - body text
  ;; earl-color-sol-base1  - comments
  ;; earl-color-sol-base2  - background highlights
  ;; earl-color-sol-base3  - background
  
  ;; Color variables
  ;; -------------------------------
  (setq earl-color-text "#E4E3E4")
  (setq earl-color-comment "#908E90")
  (setq earl-color-type earl-color-sol-blue)
  (setq earl-color-string earl-color-sol-green)
  (setq earl-color-keyword earl-color-sol-yellow)
  (setq earl-color-emphasized "#E4E3E4")
  (setq earl-color-cursor earl-color-emphasized)
  (setq earl-color-background "#312F31")
  (setq earl-color-hl-line "#211F21")
  (setq earl-color-todo earl-color-sol-red)
  (setq earl-color-study earl-color-sol-blue)
  (setq earl-color-important earl-color-sol-red)
  (setq earl-color-note earl-color-sol-blue)
  
  ;; Line highlighting, selection highlighting
  (set-face-background 'hl-line earl-color-hl-line)
  (set-face-background 'region earl-color-light-background)
  
  ;; Matching parentheses highlighting
  ;; (set-face-background 'show-paren-match (face-background 'default)) ;; 'default, 'region, 'highlight
  (set-face-background 'show-paren-match earl-color-comment)
  (set-face-foreground 'show-paren-match earl-color-background)
  ;; (set-face-attribute 'show-paren-match nil :weight 'extra-bold)
  (set-face-background 'show-paren-mismatch earl-color-sol-red)
  (set-face-foreground 'show-paren-mismatch earl-color-text)
  
  ;; IDO-color-configuration (affects mainly the MINIBUFFER)
  (set-face-attribute 'ido-subdir nil :foreground earl-color-text)
  (set-face-attribute 'ido-first-match nil :foreground earl-color-sol-blue)
  (set-face-attribute 'ido-only-match nil :foreground earl-color-sol-green)
  (set-face-attribute 'ido-indicator nil :foreground earl-color-text)
  (set-face-attribute 'ido-incomplete-regexp nil :foreground earl-color-text)
  
  ;; isearch
  (set-face-background 'isearch earl-color-sol-green)
  (set-face-foreground 'isearch "#ffffff")
  (set-face-background 'lazy-highlight "#82C4D5")
  (set-face-foreground 'lazy-highlight "#ffffff")
  
  ;; Compilation
  (set-face-foreground 'compilation-error earl-color-sol-red)
  (set-face-foreground 'compilation-info earl-color-sol-green)
  
  ;; Misc stuff
  (set-face-attribute 'font-lock-builtin-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-comment-delimiter-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-comment-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-constant-face nil :foreground earl-color-type)
  (set-face-attribute 'font-lock-doc-face nil :foreground earl-color-comment)
  (set-face-attribute 'font-lock-function-name-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-keyword-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-negation-char-face nil :foreground earl-color-text)
  (set-face-attribute 'font-lock-preprocessor-face nil :foreground earl-color-keyword)
  (set-face-attribute 'font-lock-string-face nil :foreground earl-color-string)
  (set-face-attribute 'font-lock-type-face nil :foreground earl-color-type)
  (set-face-attribute 'font-lock-variable-name-face nil :foreground earl-color-text)
  ;; (set-face-attribute 'font-lock-warning-face nil :foreground earl-color-text)
  ;; (set-face-attribute 'font-lock-warning-face nil :weight 'medium)
  
  (set-foreground-color earl-color-text)
  (set-background-color earl-color-background)
  (set-face-background 'fringe earl-color-background) ;; earl-color-hl-line
  (set-cursor-color earl-color-cursor)
  
  (modify-face 'font-lock-fixme-face earl-color-todo nil nil t nil t nil nil)
  (modify-face 'font-lock-study-face earl-color-study nil nil t nil t nil nil)
  (modify-face 'font-lock-important-face earl-color-important nil nil t nil t nil nil)
  (modify-face 'font-lock-note-face earl-color-note nil nil t nil t nil nil)
  )

;;-------------------------------------------------------------------------------------------------------------
;;
;;                                         Dynamically change the theme
;;
;;-------------------------------------------------------------------------------------------------------------

(setq earl-theme-list (list 'casey-dark-theme 'casey-dark-theme-colorful
                            'earl-gray-theme 'earl-white-theme
                            'earl-light-sol-theme 'earl-light-sol-theme-contrast 'earl-light-sol-theme-super-contrast
                            'earl-dark-sol-theme 'earl-dark-sol-theme-colorful
                            'jblow-dark-theme))

(setq earl-last-theme-index 9)
(setq earl-default-theme 5)
(setq earl-current-theme earl-default-theme)

(defun earl-current-theme ()
  "Display current theme"
  (interactive)
  (message "%s" (nth earl-current-theme earl-theme-list))
  )

(defun earl-next-theme ()
  "Iterate through a list of fonts and choose the next one"
  (interactive)
  (setq earl-current-theme (+ earl-current-theme 1))
  (if (eq nil (nth earl-current-theme earl-theme-list)) (setq earl-current-theme 0))
  (funcall (nth earl-current-theme earl-theme-list))
  (message "%s" (nth earl-current-theme earl-theme-list)))

(defun earl-previous-theme ()
  "Iterate through a list of fonts and choose the next one"
  (interactive)
  (if (eq earl-current-theme 0) (setq earl-current-theme earl-last-theme-index) (setq earl-current-theme (- earl-current-theme 1)))
  (funcall (nth earl-current-theme earl-theme-list))
  (message "%s" (nth earl-current-theme earl-theme-list)))

(global-set-key (kbd "<M-wheel-up>") 'earl-next-theme)
(global-set-key (kbd "<M-wheel-down>") 'earl-previous-theme)

;;-------------------------------------------------------------------------------------------------------------
;;
;; Post load stuff
;;
;;-------------------------------------------------------------------------------------------------------------

(defun post-load-stuff ()
  (interactive)
  ;; (maximize-frame)
  
  ;; ;; Fullscreen
  ;; (toggle-frame-fullscreen) ;; Makes Emacs fullscreen (F11), (toggle-frame-maximized), (maximize-frame)
  
  ;;; Default Theme
  (funcall (nth earl-default-theme earl-theme-list))
  
  ;;; Default Font
  ;; NOTE(earl): Pay attention to this if something weird starts happening to the frame size; see the earl-next-font function
  (earl-determine-default-font)
  )
(add-hook 'window-setup-hook 'post-load-stuff t)

;;-------------------------------------------------------------------------------------------------------------
;;
;;                                             Functions and Variables
;;
;;-------------------------------------------------------------------------------------------------------------

;;;**************************************************************
;;;
;;; Key variables
;;;
;;;**************************************************************

(defvar earl-compilation-key "g")

;;;**************************************************************
;;;
;;; Use lockfiles to avoid editing collisions
;;;
;;;**************************************************************

(setq create-lockfiles nil) ;; Turned Off

;;;**************************************************************
;;;
;;; Custom-set-variables, Backups, Version Control, Auto Save
;;;
;;;**************************************************************

;; If you edit it by hand, you could mess it up, so be careful.
;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
(custom-set-variables
 '(auto-save-default nil)
 '(auto-save-interval 0)
 '(auto-save-list-file-prefix nil)
 '(auto-save-timeout 0)
 '(auto-show-mode t t)
 '(delete-auto-save-files nil)
 '(delete-old-versions (quote other)) ;; delete-old-versions (quote other), delete-old-versions t
 '(imenu-auto-rescan t)
 '(imenu-auto-rescan-maxout 500000)
 '(kept-new-versions 5)
 '(kept-old-versions 5)
 '(make-backup-file-name-function (quote ignore))
 '(make-backup-files nil)
 '(backup-inhibited t)
 '(mouse-wheel-follow-mouse nil)
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount (quote (15)))
 '(version-control nil))

;; ;; If auto save is enabled and anything happens, you can recover a file with "M-x recover-file"

;; ;; If you've ever had your ass saved by an Emacs backup file, you probably want more of them, not less of them.
;; ;; It is annoying that they go in the same directory as the file you're editing, but that is easy to change.
;; ;; You can make all backup files go into a directory by putting something like the following in your .emacs.
;; (setq backup-directory-alist `(("." . "~/.emacs.backups")))

;; ;; Set where to store auto save files
;; (setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

;; ;; There are a number of arcane details associated with how Emacs might create your backup files.
;; ;; Should it rename the original and write out the edited buffer? What if the original is linked? In general,
;; ;; the safest but slowest bet is to always make backups by copying.
;; ;; If that's too slow for some reason you might also have a look at backup-by-copying-when-linked
;; (setq backup-by-copying t)

;;----------------------------------------------
;;
;; Compilation
;;
;;----------------------------------------------

(setq compilation-context-lines 0)
(setq compilation-error-regexp-alist
      (cons '("^\\([0-9]+>\\)?\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)) : \\(?:fatal error\\|warnin\\(g\\)\\) C[0-9]+:" 2 3 nil (4))
            compilation-error-regexp-alist))

(defun find-project-directory-recursive ()
  "Recursively search for a makefile."
  (interactive)
  (if (file-exists-p casey-makescript) t
    (cd "../")
    (find-project-directory-recursive)))

(defun lock-compilation-directory ()
  "The compilation process should NOT hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked t)
  (message "Compilation directory is locked."))

(defun unlock-compilation-directory ()
  "The compilation process SHOULD hunt for a makefile"
  (interactive)
  (setq compilation-directory-locked nil)
  (message "Compilation directory is roaming."))

(defun find-project-directory ()
  "Find the project directory."
  (interactive)
  (setq find-project-from-directory default-directory)
  (if (= (count-windows) 1) (switch-to-buffer "*compilation*")
    (switch-to-buffer-other-window "*compilation*"))
  (if compilation-directory-locked (cd last-compilation-directory)
    (cd find-project-from-directory)
    (find-project-directory-recursive)
    (setq last-compilation-directory default-directory)))

(defun make-without-asking ()
  "Make the current build."
  (interactive)
  (save-some-buffers 1)
  (if (find-project-directory) (compile casey-makescript))
  (if (eq earl-close-compile-buffer-automatically t)
      (progn (switch-to-prev-buffer) (other-window 1)
             (earl-set-face-background-and-foreground 'mode-line earl-mode-line-compilation-in-progress-color))
    (progn
      (if (= (count-windows) 1) (switch-to-prev-buffer) (other-window 1))
      (earl-set-face-background-and-foreground 'mode-line earl-mode-line-compilation-in-progress-color))))

(defun casey-big-fun-compilation-hook ()
  (make-local-variable 'truncate-lines)
  (setq truncate-lines nil))
(add-hook 'compilation-mode-hook 'casey-big-fun-compilation-hook)

;;-------------------------------------------
;;
;; Automatically close the compilation buffer uppon successful completion without warnings
;;

;; Set this to "t" or "nil" depending on whether or not you want to automatically close the compile buffer
(setq earl-close-compile-buffer-automatically t)

;; Set this to "t" or "nil" depending on whether or not you want to automatically close the compile buffer with a delay
(setq earl-close-compile-buffer-with-delay nil)

;; Set this to "t" or "nil" depending on whether or not you want emacs to ignore
;; "LINK : fatal error LNK1104: cannot open file"
;; and not display the compilation buffer
(setq earl-ignore-compiler-error-cannot-open-file-variable nil)

(defun earl-ignore-compiler-error-cannot-open-file ()
  "Toggle whether or not emacs will ignore the compiler error cannot open file when
    window count == 1"
  (interactive)
  (if (eq earl-ignore-compiler-error-cannot-open-file-variable t)
      (progn
        (setq earl-ignore-compiler-error-cannot-open-file-variable nil)
        (message "NOT ignoring compiler error 'cannot open file'"))
    (progn
      (setq earl-ignore-compiler-error-cannot-open-file-variable t)
      (message "Ignoring compiler error 'cannot open file'"))))

(defun earl-close-compile-buffer-automatically ()
  "Toggle whether or not to close the compile buffer automatically when successful without warnings"
  (interactive)
  (if (eq earl-close-compile-buffer-automatically t)
      (progn
        (setq earl-close-compile-buffer-automatically nil)
        (message "Not closing compile buffer automatically"))
    (progn
      (setq earl-close-compile-buffer-automatically t)
      (message "Closing compile buffer automatically"))))

(defun earl-close-compile-buffer-with-delay ()
  "Toggle whether or not to close the compile buffer with delay when successful without warnings"
  (interactive)
  (if (eq earl-close-compile-buffer-with-delay t)
      (progn
        (setq earl-close-compile-buffer-with-delay nil)
        (message "Closing compile buffer without delay"))
    (progn
      (setq earl-close-compile-buffer-with-delay t)
      (message "Closing compile buffer with delay"))))

(defun earl-change-mode-line-color-after-compilation (mode-line color-start color-end delay)
  "Change mode-line color based on compilation status"
  (earl-set-face-background-and-foreground mode-line color-start)
  (run-with-timer
   delay nil (lambda (mode color) (earl-set-face-background-and-foreground mode color)) mode-line color-end))

(defun earl-compilation-successfull (buffer string)
  (and
   (string-match "compilation" (buffer-name buffer))
   (string-match "finished" string)
   (with-current-buffer buffer
     (goto-char (point-min))
     (let ((done-searching nil)
           (found-errors t))
       (while (not done-searching)
         (if (search-forward-regexp "error\\|warning" nil t)
             (if earl-ignore-compiler-error-cannot-open-file-variable
                 (if (search-forward-regexp "LNK1104: cannot open file" (line-end-position) t) () ;; the error can be ignored, continue loop
                   (progn (setq done-searching t) (setq found-errors t))) ;; founc errors, and not the ones we can ignore
               (progn (setq done-searching t) (setq found-errors t))) ;; found errors (don't ignore warnings)
           (progn (setq done-searching t) (setq found-errors nil)))) ;; found no errors
       (not found-errors)))))

;; Close compilation buffer if finished with no errors
(defun earl-bury-compile-buffer-if-successful (buffer string)
  "Bury a compilation buffer if succeeded without warnings"
  (if (eq earl-close-compile-buffer-automatically t)
      (if (earl-compilation-successfull buffer string)
          (progn (earl-change-mode-line-color-after-compilation 'mode-line earl-mode-line-compilation-succsess-color earl-mode-line-color 1)
                 ;; (earl-change-mode-line-color-after-compilation 'mode-line-inactive earl-mode-line-compilation-succsess-color earl-mode-line-inactive-color 1)
                 (if (eq earl-close-compile-buffer-with-delay t)
                     (run-with-timer 1 nil
                                     (lambda (buf)
                                       (bury-buffer buf)
                                       (let ((compilation-window (get-buffer-window buf)))
                                         (if compilation-window (switch-to-prev-buffer compilation-window 'kill)
                                           (kill-buffer buf))))
                                     buffer)
                   (progn
                     (bury-buffer buffer)
                     (let ((compilation-window (get-buffer-window buffer)))
                       (if compilation-window (switch-to-prev-buffer compilation-window 'kill)
                         (kill-buffer buffer))))))
        (progn (earl-change-mode-line-color-after-compilation 'mode-line earl-mode-line-compilation-error-color earl-mode-line-color 1)
               (earl-change-mode-line-color-after-compilation 'mode-line-inactive earl-mode-line-compilation-error-color earl-mode-line-inactive-color 1)
               (if (= (count-windows) 1) (split-window-horizontally))
               (switch-to-buffer-other-window "*compilation*")
               (other-window 1)))
    (if (earl-compilation-successfull buffer string)
        (progn (earl-change-mode-line-color-after-compilation 'mode-line earl-mode-line-compilation-succsess-color earl-mode-line-color 1)
               (if (= (count-windows) 1) (switch-to-buffer "*compilation*")))
      (progn (earl-change-mode-line-color-after-compilation 'mode-line earl-mode-line-compilation-error-color earl-mode-line-color 1)
             (earl-change-mode-line-color-after-compilation 'mode-line-inactive earl-mode-line-compilation-error-color earl-mode-line-inactive-color 1)
             (if (= (count-windows) 1)
                 (progn (split-window-horizontally)
                        (switch-to-buffer-other-window "*compilation*")
                        (other-window 1)))))))
(add-hook 'compilation-finish-functions 'earl-bury-compile-buffer-if-successful)

;;********************************
;;
;; Emacs key configuration
;;
;;********************************

;; Configures C-f to eval-last-sexp when in emacs-lisp-mode
;; Use a hook for the mode. A hool will load your code whenever that mode is activated.
;; A hook is a variable, its value is a list of function (lisp symbols or lambda)
(defun commit-one-emacs-configuration ()
  "When in .emacs-configuration-file C-f should eval-last-sexp"
  (local-set-key (kbd "C-f") 'eval-last-sexp)
  ;; (local-set-key (kbd "C-f") 'load-file)
  ;; more here...
  ) ;; closing paranthesis

;; add to hook
;; the mode is named "emacs-lisp-mode" and its corresponding hook is named "emacs-lisp-mode-hook"
(add-hook 'emacs-lisp-mode-hook 'commit-one-emacs-configuration)

;;********************************
;;
;; End of Emacs key configuration
;;
;;********************************

;;********************************
;;
;; Evil key configuration
;;
;;********************************

(defun commit-one-emacs-configuration ()
  "When in .emacs-configuration-file earl-compilation-key should eval-last-sexp"
  (define-key evil-normal-state-local-map earl-compilation-key 'eval-last-sexp))

(add-hook 'emacs-lisp-mode-hook 'commit-one-emacs-configuration)

;;********************************
;;
;; End of Evil key configuration
;;
;;********************************

;;**************************************************************
;;
;; Find todo- and log-file 
;;
;;**************************************************************

(setq casey-todo-file "todo.txt")
(setq casey-log-file "log.txt")

(defun load-todo ()
  "Load the todo-file"
  (interactive)
  (setq current-directory default-directory)
  (if (= (count-windows) 1) (split-window-horizontally))
  (switch-to-buffer-other-window "earl-loading-tmp")
  (cd current-directory)
  (let ((i 0))
    (while (< i 16) (progn
                      (if (file-exists-p casey-todo-file)
                          (progn
                            (find-file casey-todo-file)
                            (kill-buffer "earl-loading-tmp")
                            (setq i 1024))
                        (cd "../"))
                      (setq i (+ i 1)))))
  (cd current-directory)
  (if (get-buffer "earl-loading-tmp") (progn
                                        (kill-buffer "earl-loading-tmp")
                                        (other-window 1)) ())
  )

(defun insert-timeofday ()
  (interactive "*")
  (insert (format-time-string "---------------- %a, %d %b %y: %I:%M%p")))

(defun load-log-work ()
  (interactive)
  (find-file casey-log-file)
  (visual-line-mode t)
  (end-of-buffer)
  (newline-and-indent)
  (insert-timeofday)
  (newline-and-indent)
  (newline-and-indent)
  (end-of-buffer)
  )

(defun load-log ()
  "Load the log-file"
  (interactive)
  (setq current-directory default-directory)
  (if (= (count-windows) 1) (split-window-horizontally))
  (switch-to-buffer-other-window "earl-loading-tmp")
  (cd current-directory)
  (let ((i 0))
    (while (< i 16) (progn
                      (if (file-exists-p casey-log-file)
                          (progn
                            (load-log-work)
                            (kill-buffer "earl-loading-tmp")
                            (setq i 1024))
                        (cd "../"))
                      (setq i (+ i 1)))))
  (cd current-directory)
  (if (get-buffer "earl-loading-tmp") (progn
                                        (kill-buffer "earl-loading-tmp")
                                        (other-window 1)) ())
  )

;;**************************************************************
;;
;; Accepted file extensions and their appropriate modes
;;
;;**************************************************************

(setq auto-mode-alist
      (append
       '(("\\.cpp$"    . c++-mode)
         ("\\.hin$"    . c++-mode)
         ("\\.cin$"    . c++-mode)
         ("\\.inl$"    . c++-mode)
         ("\\.rdc$"    . c++-mode)
         ("\\.h$"    . c++-mode)
         ("\\.c$"   . c++-mode)
         ("\\.cc$"   . c++-mode)
         ("\\.c8$"   . c++-mode)
         ("\\.txt$" . indented-text-mode)
         ("\\.emacs$" . emacs-lisp-mode)
         ("\\.gen$" . gen-mode)
         ("\\.ms$" . fundamental-mode)
         ("\\.m$" . objc-mode)
         ("\\.mm$" . objc-mode)
         ) auto-mode-alist))

;;**************************************************************
;;
;; C Commenting
;;
;;**************************************************************

;; NOTE(earl): The following function creates "/* " instead of "/*" as the first line of a multi-line comment

(defun my-prettify-c-block-comment (orig-fun &rest args)
  (let* ((first-comment-line (looking-back "/\\*\\s-*.*"))
         (star-col-num (when first-comment-line
                         (save-excursion
                           (re-search-backward "/\\*")
                           (1+ (current-column))))))
    (apply orig-fun args)
    (when first-comment-line
      (save-excursion
        (newline)
        (dotimes (cnt star-col-num)
          (insert " "))
        (move-to-column star-col-num)
        (insert "*/"))
      ;; (move-to-column star-col-num) ; comment this line if using bsd style
      ;; (insert "*") ; comment this line if using bsd style
      ))
  ;; Ensure one space between the asterisk and the comment
  (when (not (looking-back " "))
    (insert " "))
  ;; Ensure one space between the asterisk and the comment of the previous line
  (previous-line)
  (when (not (looking-back " "))
    (insert " "))
  (next-line))
(advice-add 'c-indent-new-comment-line :around #'my-prettify-c-block-comment)
;; (advice-remove 'c-indent-new-comment-line #'my-prettify-c-block-comment)

;;**************************************************************
;;
;; CC++ mode handling, Indentation, Tab
;;
;;**************************************************************

(defun casey-big-fun-c-hook ()
  ;; Set my style for the current buffer
  (c-add-style "BigFun" casey-big-fun-c-style t)
  
  ;; 4-space tabs
  (setq tab-width 4
        indent-tabs-mode nil)
  
  ;; Additional style stuff
  (c-set-offset 'member-init-intro '++)
  
  ;; No hungry backspace
  (c-toggle-auto-hungry-state -1)
  
  ;; Newline indents, semi-colon doesn't
  (define-key c++-mode-map "\C-m" 'newline-and-indent)
  (setq c-hanging-semi&comma-criteria '((lambda () 'stop)))
  
  ;; Handle super-tabbify (TAB completes, shift-TAB actually tabs)
  (setq dabbrev-case-replace t)
  (setq dabbrev-case-fold-search t)
  (setq dabbrev-upcase-means-case-search t)
  
  ;; Abbrevation expansion
  (abbrev-mode 1)
  
  ;; Headers
  (defun casey-header-format ()
    "Format the given file as a header file."
    (interactive)
    (setq BaseFileName (file-name-sans-extension (file-name-nondirectory buffer-file-name)))
    (insert "#if !defined(")
    (push-mark)
    (insert BaseFileName)
    (upcase-region (mark) (point))
    (pop-mark)
    (insert "_H)\n")
    (insert "/* ========================================================================\n")
    (insert "   $File: $\n")
    (insert "   $Date: $\n")
    (insert "   $Revision: $\n")
    (insert "   $Creator: Earl $\n")
    (insert "   $Notice: (C) Copyright 2016 by Earl. $\n")
    (insert "   ======================================================================== */\n")
    (insert "\n")
    (insert "#define ")
    (push-mark)
    (insert BaseFileName)
    (upcase-region (mark) (point))
    (pop-mark)
    (insert "_H\n")
    (insert "#endif")
    )
  
  (defun casey-source-format ()
    "Format the given file as a source file."
    (interactive)
    (setq BaseFileName (file-name-sans-extension (file-name-nondirectory buffer-file-name)))
    (insert "/* ========================================================================\n")
    (insert "   $File: $\n")
    (insert "   $Date: $\n")
    (insert "   $Revision: $\n")
    (insert "   $Creator: Earl $\n")
    (insert "   $Notice: (C) Copyright 2016 by Earl. $\n")
    (insert "   ======================================================================== */\n")
    )
  
  (cond ((file-exists-p buffer-file-name) t)
        ((string-match "[.]hin" buffer-file-name) (casey-source-format))
        ((string-match "[.]cin" buffer-file-name) (casey-source-format))
        ((string-match "[.]h" buffer-file-name) (casey-header-format))
        ((string-match "[.]hpp" buffer-file-name) (casey-header-format))
        ((string-match "[.]cpp" buffer-file-name) (casey-source-format)))
  
  (defun casey-find-corresponding-file ()
    "Find the file that corresponds to this one."
    (interactive)
    (setq CorrespondingFileName nil)
    (setq BaseFileName (file-name-sans-extension buffer-file-name))
    (if (string-match "\\.c" buffer-file-name)
        (setq CorrespondingFileName (concat BaseFileName ".h")))
    (if (string-match "\\.h" buffer-file-name)
        (if (file-exists-p (concat BaseFileName ".c")) (setq CorrespondingFileName (concat BaseFileName ".c"))
          (setq CorrespondingFileName (concat BaseFileName ".cpp"))))
    (if (string-match "\\.hpp" buffer-file-name)
        (if (file-exists-p (concat BaseFileName ".c")) (setq CorrespondingFileName (concat BaseFileName ".c"))
          (setq CorrespondingFileName (concat BaseFileName ".cpp"))))
    (if (string-match "\\.hin" buffer-file-name)
        (setq CorrespondingFileName (concat BaseFileName ".cin")))
    (if (string-match "\\.cin" buffer-file-name)
        (setq CorrespondingFileName (concat BaseFileName ".hin")))
    (if (string-match "\\.cpp" buffer-file-name)
        (if (file-exists-p (concat BaseFileName ".h")) (setq CorrespondingFileName (concat BaseFileName ".h"))
          (setq CorrespondingFileName (concat BaseFileName ".hpp"))))
    (if CorrespondingFileName (find-file CorrespondingFileName)
      (error "Unable to find a corresponding file")))
  (defun casey-find-corresponding-file-other-window ()
    "Find the file that corresponds to this one."
    (interactive)
    (if (= (count-windows) 1) (split-window-horizontally))
    (find-file-other-window buffer-file-name)
    (casey-find-corresponding-file)
    (other-window -1))
  
  ;; devenv.com error parsing
  (add-to-list 'compilation-error-regexp-alist 'casey-devenv)
  (add-to-list 'compilation-error-regexp-alist-alist '(casey-devenv
                                                       "*\\([0-9]+>\\)?\\(\\(?:[a-zA-Z]:\\)?[^:(\t\n]+\\)(\\([0-9]+\\)) : \\(?:see declaration\\|\\(?:warnin\\(g\\)\\|[a-z ]+\\) C[0-9]+:\\)"
                                                       2 3 nil (4)))
  
  ;;****************************
  ;;
  ;; Commenting, Comments
  ;;
  ;;****************************
  
  ;; (setq comment-start "/*") ;; "/* "
  ;; (setq comment-continue " *") ;; " * "
  ;; (setq comment-end " */")
  ;; (setq comment-style 'extra-line) ; multi-line, extra-line
  
  ;;****************************
  ;;
  ;; Emacs key configurations
  ;;
  ;;****************************
  
  ;; (define-key c++-mode-map [f12] 'casey-find-corresponding-file)
  ;; (define-key c++-mode-map [M-f12] 'casey-find-corresponding-file-other-window)
  
  (global-set-key (kbd "C-#") 'casey-find-corresponding-file)
  (global-set-key (kbd "M-#") 'casey-find-corresponding-file-other-window)
  (global-set-key (kbd "C-M-#") 'casey-find-corresponding-file-other-window)
  ;; Not bound to any keys: recursive-edit, abort-recursive-edit (haven't used them yet)
  
  ;; ;;Tab definitions, Indentation
  ;; ;;NOTE(earl): There are some tab definitions here (C++ mode handling)
  ;; (define-key c++-mode-map "\t" 'dabbrev-expand)
  ;; (define-key c++-mode-map [S-tab] 'indent-for-tab-command)
  ;; ;; (define-key c++-mode-map "\C-y" 'indent-for-tab-command)
  ;; (define-key c++-mode-map [C-tab] 'indent-region)
  ;; (define-key c++-mode-map "       " 'indent-region)
  
  (local-unset-key (kbd "C-M-h"))
  (local-unset-key (kbd "C-d"))  
  
  ;; Something is overwriting this, so I set again
  (global-set-key (kbd "C-M-j") 'backward-word)
  (local-set-key (kbd "C-M-j") 'backward-word)
  (global-set-key (kbd "M-e") 'rename-this-buffer-and-file)
  (local-set-key (kbd "M-e") 'rename-this-buffer-and-file)
  (global-set-key (kbd "C-c C-c") 'execute-extended-command)
  (local-set-key (kbd "C-c C-c") 'execute-extended-command)
  (global-set-key (kbd "M-j") 'backward-words)
  (local-set-key (kbd "M-j") 'backward-words)
  
  ;;****************************
  ;;
  ;; End of Emacs key configurations
  ;;
  ;;****************************
  
  ;;****************************
  ;;
  ;; Evil key configurations
  ;;
  ;;****************************
  
  (defun earl-newline-check-for-comment ()
    "Regular newline, but checks to see if inside a comment, if so uses a different type of newline"
    (interactive)
    (if (not (eq (nth 4 (syntax-ppss)) nil)) ;; not nil == inside comment, eq nil == outside comment
        (c-indent-new-comment-line)
      (earl-newline-and-indent)))
  
  ;; Indent each new line automatically
  (define-key evil-normal-state-local-map [return] 'earl-newline-and-indent)
  (define-key evil-insert-state-local-map [return] 'earl-newline-and-indent)
  
  ;;****************************
  ;;
  ;; End of Evil key configurations
  ;;
  ;;****************************
  
  ;; ;; Autofill comments (fucks up regular code...)
  ;; (setq-local comment-auto-fill-only-comments t)
  ;; (setq-default fill-column 120)
  ;; (auto-fill-mode 1)
  
  ;; Configure the mode line
  (setq-local mode-line-format '("%e" mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification "   " mode-line-position evil-mode-line-tag
                                 (vc-mode vc-mode)
                                 "  " mode-line-modes mode-line-misc-info mode-line-end-spaces "   %f"))
  )
(add-hook 'c-mode-common-hook 'casey-big-fun-c-hook)

;;**************************************************************
;;
;; TXT mode handling, Indentation, Tab
;;
;;**************************************************************

(defun casey-big-fun-text-hook ()
  ;; 4-space tabs
  (setq tab-width 4
        indent-tabs-mode nil)
  
  ;;********************************
  ;;
  ;; Emacs key configuration
  ;;
  ;;********************************
  
  ;; ;; Newline indents, semi-colon doesn't
  ;; (define-key text-mode-map "\C-m" 'newline-and-indent)
  
  ;; ;; Prevent overriding of alt-s
  ;; ;; (define-key text-mode-map "\es" 'casey-save-buffer)
  
  ;;********************************
  ;;
  ;; End of Emacs key configuration
  ;;
  ;;********************************
  
  ;; Word-wrap in text mode
  (visual-line-mode)
  
  ;; Keep indented word wrapped lines indented
  (adaptive-wrap-prefix-mode)
  
  ;;; Line highlighting
  ;;; NOTE this get's overridden by global-hl-line-mode for some reason
  ;;;      hl-line-mode is supposed to be for the local mode and this should work
  ;; (hl-line-mode 0)
  )
(add-hook 'text-mode-hook 'casey-big-fun-text-hook)

;;**************************************************************
;;
;; C++ indentation style
;;
;;**************************************************************

(defconst casey-big-fun-c-style
  '((c-electric-pound-behavior   . nil)
    (c-tab-always-indent         . t)
    (c-comment-only-line-offset  . 0)
    (c-hanging-braces-alist      . ((class-open)
                                    (class-close)
                                    (defun-open)
                                    (defun-close)
                                    (inline-open)
                                    (inline-close)
                                    (brace-list-open)
                                    (brace-list-close)
                                    (brace-list-intro)
                                    (brace-list-entry)
                                    (block-open)
                                    (block-close)
                                    (substatement-open)
                                    (statement-case-open)
                                    (class-open)))
    (c-hanging-colons-alist      . ((inher-intro)
                                    (case-label)
                                    (label)
                                    (access-label)
                                    (access-key)
                                    (member-init-intro)))
    (c-cleanup-list              . (scope-operator
                                    list-close-comma
                                    defun-close-semi))
    (c-offsets-alist             . ((arglist-close         .  c-lineup-arglist)
                                    (label                 . -4)
                                    (access-label          . -4)
                                    (substatement-open     .  0)
                                    (statement-case-intro  .  4)
                                    (statement-block-intro .  4)
                                    (case-label            .  4)
                                    (block-open            .  0)
                                    (inline-open           .  0)
                                    (topmost-intro-cont    .  0)
                                    (knr-argdecl-intro     . -4)
                                    (brace-list-open       .  0)
                                    (brace-list-intro      .  4)))
    (c-echo-syntactic-information-p . t))
  "Casey's Big Fun C++ Style")

;;**************************************************************
;;
;; Grep Commands
;;
;;**************************************************************

(set-variable 'grep-command "grep -irHn ")
(when casey-win32
  (setq grep-use-null-device t)
  (set-variable 'grep-command "findstr -s -n -i -l "))

;;**************************************************************
;;
;; Handle super-tabbify (TAB completes, shift-TAB actually tabs)
;;
;;**************************************************************

(setq dabbrev-case-replace t)
(setq dabbrev-case-fold-search t)
(setq dabbrev-upcase-means-case-search t)

;;**************************************************************
;;
;; C++ mode handling, Indentation, Tab
;;
;;**************************************************************

(defun my-c++-mode-hook ()
  (setq c-basic-offset 4)
  (c-set-offset 'substatement-open 0))
(add-hook 'c++-mode-hook 'my-c++-mode-hook)

;;--------------------------------------------------------------
;;
;; Shell and terminal
;;
;;--------------------------------------------------------------

(defun beginning-of-eshell-bol-or-line ()
  "Move point to the beginning of text on the current line; if that is already
the current position of point, then move it to the beginning of the line."
  (interactive)
  (let ((pt (point)))
    (eshell-bol)
    (when (eq pt (point))
      (beginning-of-indentation-or-line))))

;;********************************
;;
;; Emacs key configuration
;;
;;********************************

(defun earl-eshell-configuration-hook ()
  "Configurations for the eshell command"
  (interactive)
  (local-unset-key (kbd "C-M-l"))
  (local-set-key (kbd "C-M-l") 'forward-word)
  (local-unset-key (kbd "C-a"))
  (local-set-key (kbd "C-a") 'other-window)
  (local-unset-key (kbd "C-c C-c"))
  (local-set-key (kbd "C-c C-c") 'execute-extended-command)
  (local-unset-key (kbd "C-M-,"))
  (local-set-key (kbd "C-M-,") 'eshell-previous-matching-input-from-input)
  (local-unset-key (kbd "C-M-."))
  (local-set-key (kbd "C-M-.") 'eshell-next-matching-input-from-input)
  (local-unset-key (kbd "C-u"))
  (local-set-key (kbd "C-u") 'beginning-of-eshell-bol-or-line)
  )
(add-hook 'eshell-mode-hook 'earl-eshell-configuration-hook)

;;********************************
;;
;; End of Emacs key configuration
;;
;;********************************

;;------------------------------------
;;
;; My own save-some-buffers function
;;
;;------------------------------------

(defun earl-save-some-buffers ()
  "My save-some-buffers function"
  (interactive)
  (save-some-buffers t))

;;------------------------------------
;;
;; Function to scroll with the cursor in place, moving the page instead
;;
;;------------------------------------

(defun scroll-down-in-place (n)
  (interactive "p")
  (previous-line n)
  (unless (eq (window-start) (point-min))
    (scroll-down n)))

(defun scroll-up-in-place (n)
  (interactive "p")
  (next-line n)
  (unless (eq (window-end) (point-max))
    (scroll-up n)))

;;------------------------------------
;;
;; Vertical Scrolling
;;
;;------------------------------------

;;; Scroll one line at a time (less "jumpy" than defaults)
(setq mouse-wheel-scroll-amount '(15 ((shift) . 1)))       ;; eight lines at a time
(setq mouse-wheel-progressive-speed nil)                   ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't)                         ;; scroll window under mouse
(setq scroll-step 1)                                       ;; keyboard smooth scroll

;; NOTE(earl): Fixing a performance bug that I have not noticed before
;; When holding down 'k' (next-line) emacs starts to lag while moving
;; the cursor downwards. This fixes that to some extent
(setq auto-window-vscroll nil)

;;------------------------
;;
;; Horizontal scrolling
;;
;;------------------------

;; The point autoscrolls when it moves off the right edge, this fucks up the manual scrolling, thus scroll-left/right takes two args,
;; the first (ARG) decides how many columns to scroll, the second (SET-MINIMUM) to constrict autoscrolling to the first arg (F1)

(defun earl-scroll-left ()
  "Scroll left and move point left"
  (interactive)
  (scroll-left 50)
  (let ((pt (point)))
    (end-of-line)
    (let ((d (- (point) pt)))
      (if (> d 50) (backward-char (- d 50))))))

(defun earl-scroll-right ()
  "Scroll right and move point right"
  (interactive)
  (scroll-right 50)
  (let ((pt (point)))
    (beginning-of-line)
    (let ((d (- pt (point))))
      (if (> d 50) (forward-char (- d 50))))))

;;------------------------
;;
;; Misc
;;
;;------------------------

(defun append-as-kill ()
  "Performs copy-region-as-kill as an append."
  (interactive)
  (append-next-kill) 
  (copy-region-as-kill (mark) (point))
  )

(defun casey-save-buffer ()
  "Save the buffer after untabifying it."
  (interactive)
  (save-excursion
    (save-restriction
      (widen)
      (untabify (point-min) (point-max))))
  (save-buffer))

(defun rename-this-buffer-and-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (cond ((get-buffer new-name)
               (error "A buffer named '%s' already exists!" new-name))
              (t
               (rename-file filename new-name 1)
               (rename-buffer new-name)
               (set-visited-file-name new-name)
               (set-buffer-modified-p nil)
               (message "File '%s' successfully renamed to '%s'" name (file-name-nondirectory new-name))))))))

(defun earl-current-line-empty ()
  (beginning-of-line)
  (looking-at "[[:space:]]*$"))

(defun earl-goto-previous-blank-line ()
  (if (search-backward-regexp "^\\s-*$" nil t)
      (goto-char (match-beginning 0))
    (goto-char (point-min))))

(defun earl-goto-next-blank-line ()
  (if (search-forward-regexp "^\\s-*$" nil t)
      (goto-char (match-beginning 0))
    (goto-char (point-max))))

(defun earl-previous-blank-line ()
  "Moves to the previous line containing nothing but whitespace.
   If several of these lines together, then treat them all - except the one furtherst away - as one.
   If none are found, then move to beginning-of-buffer"
  (interactive)
  (if (earl-current-line-empty)
      (progn
        (previous-line) 
        (if (earl-current-line-empty)
            (progn (loop do (previous-line) while (looking-at "[[:space:]]*$")) (goto-char (match-beginning 0)))
          (earl-goto-previous-blank-line)))
    (earl-goto-previous-blank-line)))

(defun earl-next-blank-line ()
  "Moves to the next line containing nothing but whitespace.
   If several of these lines together, then treat them all - except the one furtherst away - as one.
   If none are found, then move to end-of-buffer"
  (interactive)
  (if (earl-current-line-empty)
      (progn
        (next-line) 
        (if (earl-current-line-empty)
            (progn (loop do (next-line) while (looking-at "[[:space:]]*$")) (goto-char (match-beginning 0)))
          (earl-goto-next-blank-line)))
    (earl-goto-next-blank-line)))

(defun append-as-kill ()
  "Performs copy-region-as-kill as an append."
  (interactive)
  (append-next-kill) 
  (copy-region-as-kill (mark) (point))
  )

;;; Configure how to switch windows
(defun pre-window () (interactive)
       (let ((current-prefix-arg -1))
         (call-interactively 'other-window)
         )
       )

;;Replace a string without moving point
(defun casey-replace-string (FromString ToString)
  "Replace a string without moving point."
  (interactive "sReplace: \nsReplace: %s  With: ")
  (save-excursion
    (replace-string FromString ToString)
    ))

;;Perform a replace-string in the current region
(defun casey-replace-in-region (old-word new-word)
  "Perform a replace-string in the current region."
  (interactive "sReplace: \nsReplace: %s  With: ")
  (save-excursion (save-restriction
                    (narrow-to-region (mark) (point))
                    (beginning-of-buffer)
                    (replace-string old-word new-word)
                    ))
  )

;;--------------------------------------------------
;;
;; Functions for moving faster horizontally
;; NOTE(earl): Move several words or characters?
;;
;;--------------------------------------------------

(defun forward-words (arg)
  "Move point forward arg words"
  (interactive "p")
  (forward-word 2))
(defun backward-words (arg)
  "Move point backward arg words"
  (interactive "p")
  (backward-word 2))

;;--------------------------------------------------

;; Move to the beginning of the line, or indentation
;; This one defaults first to the beginning of the line
(defun beginning-of-line-or-indentation ()
  "move to beginning of line, or indentation"
  (interactive)
  (if (bolp)
      (back-to-indentation)
    (beginning-of-line)))

;; This one defaults first to the beginning of the indentation/text
(defun beginning-of-indentation-or-line ()
  "Move point to the beginning of text on the current line; if that is already
the current position of point, then move it to the beginning of the line."
  (interactive)
  (let ((pt (point)))
    (back-to-indentation) ;; beginning-of-line-text
    (when (eq pt (point))
      (beginning-of-line))))

;; Moves the point to the end of the line, or to the middle of the line
(defun end-or-middle-of-line ()
  "Move point to the end or the middle of the line. Defaults to end"
  (interactive)
  (let ((pt (point)))
    (end-of-line)
    (when (eq pt (point))
      (goto-char (/ (+ (point-at-bol) (point-at-eol)) 2))))) ;; middle of line

;;-----------------------------
;;
;; Define current line into X chunks and move one chunk at a time
;;
;;-----------------------------

(defun earl-backward-line-chunck (chunks)
  "Define current line into X chunks and move one chunk at a time"
  (interactive)
  (let ((current-line-length (- (point-at-eol) (point-at-bol))))
    (let ((chunk-length (+ (/ current-line-length chunks) 1)))
      (if (eq (point) (point-at-bol))
          (backward-char)
        (if (< (- (point) chunk-length) (point-at-bol))
            (beginning-of-line)
          ;; 1. If you are at an index point (e.g. 2) remember to subtract 1 from the current index you are in
          ;;    If you are not at an index point (e.g. 2.71)
          ;;    then integer division will be enough to bring you from index 2.71 to 2
          ;; 2. Figure out distance between poinit-at-bol and point
          ;; 3. Fiugre out what index you are in by dividing by the chunk-length
          ;; 4. You want to go to previous index, so depending on the first step, subtract or don't subtract
          ;; 5. Multiply the index you want to go to with the chunk-length to get how many
          ;;    characters you want to be moving from the point-at-bol
          ;; 6. Go there
          (if (eq (% (- (point) (point-at-bol)) chunk-length) 0)
              (goto-char (+ (point-at-bol) (* (- (/ (- (point) (point-at-bol)) chunk-length) 1) chunk-length)))
            (goto-char (+ (point-at-bol) (* (/ (- (point) (point-at-bol)) chunk-length) chunk-length)))))))))

(defun backward-line-chunck ()
  (interactive)
  (earl-backward-line-chunck 4))

(defun earl-forward-line-chunck (chunks)
  "Define current line into X chunks and move one chunk at a time"
  (interactive)
  (let ((current-line-length (- (point-at-eol) (point-at-bol))))
    (let ((chunk-length (+ (/ current-line-length chunks) 1)))
      (if (eq (point) (point-at-eol))
          (forward-char)
        (if (> (+ (point) chunk-length) (point-at-eol))
            (end-of-line)
          ;; 1. Figure out distance between point-at-bol and point
          ;; 2. Fiugre out what index you are in by dividing by the chunk-length
          ;; 3. You want to go to the next index so add one to the index you are currently in
          ;; 4. Multiply the index you want to go to with the chunk-length to get how many
          ;;    characters you want to be moving from the point-at-bol
          ;; 5. Go there
          (goto-char (+ (point-at-bol) (* (+ (/ (- (point) (point-at-bol)) chunk-length) 1) chunk-length))))))))

(defun forward-line-chunck ()
  (interactive)
  (earl-forward-line-chunck 4))

;;-----------------------------
;;
;; My own newline and indent
;;
;;-----------------------------

(defun earl-newline-and-indent ()
  "My own newline and indent"
  (interactive)
  (newline-and-indent)
  
  ;; Version 1
  ;; (let ((pt (point)))
  ;;   (previous-line)
  ;;   (indent-for-tab-command)
  ;;   (goto-char pt))
  
  ;; Version 2
  (previous-line)
  (indent-for-tab-command)
  (next-line)
  
  (back-to-indentation))

;;-------------------------------------------------------------------------------------------------------------
;;
;; Find alternate file and move point to the position you had when calling the function
;;
;;-------------------------------------------------------------------------------------------------------------

(defun find-alternate-file-and-return (filename &optional wildcards)
  "Find file FILENAME, select its buffer, kill previous buffer.
If the current buffer now contains an empty file that you just visited
\(presumably by mistake), use this command to visit the file you really want.

See \\[find-file] for the possible forms of the FILENAME argument.

Interactively, or if WILDCARDS is non-nil in a call from Lisp,
expand wildcards (if any) and replace the file with multiple files.

If the current buffer is an indirect buffer, or the base buffer
for one or more indirect buffers, the other buffer(s) are not
killed."
  (interactive
   (let ((file buffer-file-name)
         (file-name nil)
         (file-dir nil))
     (and file
          (setq file-name (file-name-nondirectory file)
                file-dir (file-name-directory file)))
     (list (read-file-name
            "Find alternate file: " file-dir nil
            (confirm-nonexistent-file-or-buffer) file-name)
           t)))
  (unless (run-hook-with-args-until-failure 'kill-buffer-query-functions)
    (error "Aborted"))
  (and (buffer-modified-p) buffer-file-name
       (not (yes-or-no-p "Kill and replace the buffer without saving it? "))
       (error "Aborted"))
  (let ((pt (point))
        (obuf (current-buffer))
        (ofile buffer-file-name)
        (onum buffer-file-number)
        (odir dired-directory)
        (otrue buffer-file-truename)
        (oname (buffer-name)))
    ;; Run `kill-buffer-hook' here.  It needs to happen before
    ;; variables like `buffer-file-name' etc are set to nil below,
    ;; because some of the hooks that could be invoked
    ;; (e.g., `save-place-to-alist') depend on those variables.
    ;;
    ;; Note that `kill-buffer-hook' is not what queries whether to
    ;; save a modified buffer visiting a file.  Rather, `kill-buffer'
    ;; asks that itself.  Thus, there's no need to temporarily do
    ;; `(set-buffer-modified-p nil)' before running this hook.
    (run-hooks 'kill-buffer-hook)
    ;; Okay, now we can end-of-life the old buffer.
    (if (get-buffer " **lose**")
        (kill-buffer " **lose**"))
    (rename-buffer " **lose**")
    (unwind-protect
        (progn
          (unlock-buffer)
          ;; This prevents us from finding the same buffer
          ;; if we specified the same file again.
          (setq buffer-file-name nil)
          (setq buffer-file-number nil)
          (setq buffer-file-truename nil)
          ;; Likewise for dired buffers.
          (setq dired-directory nil)
          (find-file filename wildcards))
      (when (eq obuf (current-buffer))
        ;; This executes if find-file gets an error
        ;; and does not really find anything.
        ;; We put things back as they were.
        ;; If find-file actually finds something, we kill obuf below.
        (setq buffer-file-name ofile)
        (setq buffer-file-number onum)
        (setq buffer-file-truename otrue)
        (setq dired-directory odir)
        (lock-buffer)
        (rename-buffer oname)))
    (unless (eq (current-buffer) obuf)
      (with-current-buffer obuf
        ;; We already ran these; don't run them again.
        (let (kill-buffer-query-functions kill-buffer-hook)
          (kill-buffer obuf))))
    (goto-char pt)))

;;-------------------------------------------------------------------------------------------------------------
;;
;; Moving by parenthesis, square brackets or curly braces
;;
;;-------------------------------------------------------------------------------------------------------------

(defun forward-or-backward-sexp (&optional arg)
  "Go to the matching parenthesis character if one is adjacent to point."
  (interactive "^p")
  (cond ((looking-at "\\s(") (forward-sexp arg) (backward-char 1))
        ((looking-at "\\s)") (forward-char)(backward-sexp arg)))
  (cond ((looking-at "'") (forward-char))))

(defun search-move-forward-paren-opening-and-closing (&optional arg)
  "Move forward to the next parenthesis, square bracket or curly bracket, closing and opening"
  (interactive "P")
  (if (or (looking-at "\\s(") (looking-at "\\s)")) (forward-char 1))
  (while (and (not (looking-at "\\s(")) (not (looking-at "\\s)"))) (forward-char 1))
  )

(defun search-move-backward-paren-opening-and-closing (&optional arg)
  "Move backward to the previous parenthesis, square bracket or curly bracket, closing and opening"
  (interactive "P")
  (if (or (looking-at "\\s(") (looking-at "\\s)")) (backward-char 1))
  ;; (if (looking-back "\\s)" 1) (backward-char 2) (if (looking-at "\\s)") (backward-char 1) (if (looking-at "\\s(") (backward-char 1))))
  (while (and (not (looking-at "\\s(")) (not (looking-at "\\s)"))) (backward-char 1))
  ;; (if (looking-at "\\s)") (forward-char 1))
  )

;;-------------------------------------------------------------------------------------------------------------
;;
;; Cutting and copying by function or expression (parenthesis, square brackets and curly braces)
;;
;;-------------------------------------------------------------------------------------------------------------

(defun earl-cut-expression (&optional arg)
  "Cut the current paren-expression marked by the pointer"
  (interactive "^p")
  (let ((pt (point)))
    (forward-or-backward-sexp arg)
    (if (eq pt (point))                             ;; Cut function
        (progn(end-of-defun)
              (setq pt (point))
              (beginning-of-defun)
              (kill-region (- pt 1) (point)))
      (if(< pt (point))                             ;; Cut paren-expression
          (kill-region pt (+ (point) 1))
        (kill-region (point) (+ pt 1))
        ))))

(defun earl-copy-expression (&optional arg)
  "Copy the current paren-expression marked by the pointer"
  (interactive "^p")  
  (let ((pt (point))
        (tmp))
    (forward-or-backward-sexp arg)
    (if (eq pt (point))                             ;; Copy function
        (progn(end-of-defun)
              (setq tmp (point))
              (beginning-of-defun)
              (kill-ring-save (- tmp 1) (point))
              (goto-char pt))
      (if(< pt (point))                             ;; Copy paren-expression
          (kill-ring-save pt (+ (point) 1))
        (kill-ring-save (point) (+ pt 1)))
      (forward-or-backward-sexp arg)
      )))

;;**************************************************************
;;
;; Frame and Window behaviour, Window splitting, Window Organization
;;
;;**************************************************************

(defun casey-never-split-a-window ()
    "Never, ever split a window. Why would anyone EVER want you to do that??"
  nil)

(defun earl-split-window-sensibly (&optional window)
  (let ((window (or window (selected-window))))
    (if (= (count-windows) 1)
        (or (and (window-splittable-p window t)
                 ;; Split window horizontally.
                 (with-selected-window window
                   (split-window-right)))
            (and (eq window (frame-root-window (window-frame window)))
                 (not (window-minibuffer-p window))
                 ;; If WINDOW is the only window on its frame and is not the
                 ;; minibuffer window, try to split it horizontally disregarding
                 ;; the value of `split-width-threshold'.
                 (let ((split-width-threshold 0))
                   (when (window-splittable-p window)
                     (with-selected-window window
                       (split-window-right)))))))))

;; split-window-preferred-function default value is split-window-sensibly
;; You can control the behavior of split-window-sensibly by adjusting the variables
;; split-width-threshold and split-height-threshold
;; (setq split-width-threshold nil) ;;This tells display-buffer never to split windows horizontally
(setq split-height-threshold nil) ;;This tells display-buffer never to split windows vertically
(setq split-window-preferred-function 'earl-split-window-sensibly) ;; casey-never-split-a-window

;; Display the *Completions* buffer in the inactive side window, not a new temporary window at the bottom
(push '("\\*Completions\\*"
        (display-buffer-use-some-window display-buffer-pop-up-window)
        (inhibit-same-window . t))
      display-buffer-alist)

(defun w32-restore-frame ()
  "Restore a minimized frame"
  (interactive)
  (w32-send-sys-command 61728))

(defun maximize-frame ()
  "Maximize the current frame"
  (interactive)
  (when casey-aquamacs (aquamacs-toggle-full-frame))
  (when casey-win32 (w32-send-sys-command 61488)))

(defun casey-ediff-setup-windows (buffer-A buffer-B buffer-C control-buffer)
  (ediff-setup-windows-plain buffer-A buffer-B buffer-C control-buffer)
  )
(setq ediff-window-setup-function 'casey-ediff-setup-windows)
(setq ediff-split-window-function 'split-window-horizontally)

;;; NOTE(earl): Easy fix for 'find-file-other-window' and 'ido-switch-buffer-other-window'
;;;             When 1 window they open into a completely new frame, this shit fixes that

(defun earl-find-file-other-window (filename &optional wildcards)
  "If one window, then split window, then do 'find-file-other-window'"
  (interactive
   (find-file-read-args "Find file in other window: "
                        (confirm-nonexistent-file-or-buffer)))
  (if (= (count-windows) 1) (split-window-horizontally))
  (find-file-other-window filename wildcards))

(defun earl-ido-switch-buffer-other-window ()
  "Do 'ido-switch-buffer-other-window', if one window then delete frame and create window to display buffer"
  (interactive)
  (ido-switch-buffer-other-window)
  (if (= (count-windows) 1)
      (let ((result (current-buffer)))
        (delete-frame)
        (split-window-horizontally)
        (switch-to-buffer-other-window result))))

(defun earl-ido-switch-buffer-other-window-old ()
  "If one window, then split window, then do 'ido-switch-buffer-other-window'"
  (interactive)
  (if (= (count-windows) 1) (split-window-horizontally))
  (ido-switch-buffer-other-window))

;; NOTE(earl): ido-display-buffer - Display a buffer in another window but don’t select it.

;;Defines a function that splits the emacs window
(defun split-window-multiple-ways (x y)
  "Split the current frame into a grid of X columns and Y rows."
  (interactive "nColumns: \nnRows: ")
  ;; one window
  (delete-other-windows)
  (dotimes (i (1- x))
    (split-window-horizontally)
    (dotimes (j (1- y))
      (split-window-vertically))
    (other-window y))
  (dotimes (j (1- y))
    (split-window-vertically))
  (balance-windows))

;;; Splits the emacs window by calling the function we just defined
;; (split-window-multiple-ways 2 1)

;;; Splits the window in focus horizontally
;; (split-window-below)

;;; Changes which window is in focus
;; (other-window 2)

;;; Display Clock
(display-time)

;; Startup windowing
;; Newline when at buffer end, line wrap and horizontal window splitting
(setq next-line-add-newlines nil)            ;; Add newline when at buffer end
(setq-default truncate-lines t)              ;; Line wrap - This is a BufferLocalVariable (one in every buffer) [does not apply to horizontally-split windows]
(setq truncate-partial-width-windows nil)    ;; Turn wrapping on in horizontally-split windows
(split-window-horizontally)                  ;; Split window horizontally

;;**************************************************************
;;
;; My own yank and yank-pop
;;
;;**************************************************************

(defun earl-yank (&optional arg)
  "Reinsert (\"paste\") the last stretch of killed text.
More precisely, reinsert the most recent kill, which is the
stretch of killed text most recently killed OR yanked.  Put point
at the end, and set mark at the beginning without activating it.
With just \\[universal-argument] as argument, put point at beginning, and mark at end.
With argument N, reinsert the Nth most recent kill.

When this command inserts text into the buffer, it honors the
`yank-handled-properties' and `yank-excluded-properties'
variables, and the `yank-handler' text property.  See
`insert-for-yank-1' for details.

See also the command `yank-pop' (\\[yank-pop])."
  (interactive "*P")
  (setq yank-window-start (window-start))
  ;; If we don't get all the way thru, make last-command indicate that
  ;; for the following command.
  (setq this-command t)
  (push-mark (point))
  (insert-for-yank (current-kill (cond
				  ((listp arg) 0)
				  ((eq arg '-) -2)
				  (t (1- arg)))))
  (if (consp arg)
      ;; This is like exchange-point-and-mark, but doesn't activate the mark.
      ;; It is cleaner to avoid activation, even though the command
      ;; loop would deactivate the mark because we inserted text.
      (goto-char (prog1 (mark t)
		   (set-marker (mark-marker) (point) (current-buffer)))))
  ;; If we do get all the way thru, make this-command indicate that.
  (if (eq this-command t)
      (setq this-command 'yank))
  nil)

(defun earl-yank-pop (&optional arg)
  "Replace just-yanked stretch of killed text with a different stretch.
This command is allowed only immediately after a `yank' or a `yank-pop'.
At such a time, the region contains a stretch of reinserted
previously-killed text.  `yank-pop' deletes that text and inserts in its
place a different stretch of killed text.

With no argument, the previous kill is inserted.
With argument N, insert the Nth previous kill.
If N is negative, this is a more recent kill.

The sequence of kills wraps around, so that after the oldest one
comes the newest one.

When this command inserts killed text into the buffer, it honors
`yank-excluded-properties' and `yank-handler' as described in the
doc string for `insert-for-yank-1', which see."
  (interactive "*p")
  (if (not (eq last-command 'yank))
      (error "Previous command was not a yank"))
  (setq this-command 'yank)
  (unless arg (setq arg 1))
  (let ((inhibit-read-only t)
	(before (< (point) (mark t))))
    (if before
	(funcall (or yank-undo-function 'delete-region) (point) (mark t))
      (funcall (or yank-undo-function 'delete-region) (mark t) (point)))
    (setq yank-undo-function nil)
    (set-marker (mark-marker) (point) (current-buffer))
    (insert-for-yank (current-kill arg))
    ;; Set the window start back where it was in the yank command,
    ;; if possible.
    (set-window-start (selected-window) yank-window-start t)
    (if before
	;; This is like exchange-point-and-mark, but doesn't activate the mark.
	;; It is cleaner to avoid activation, even though the command
	;; loop would deactivate the mark because we inserted text.
	(goto-char (prog1 (mark t)
		     (set-marker (mark-marker) (point) (current-buffer))))))
  nil)

;;**************************************************************
;;
;; Utils
;;
;;**************************************************************

(defun current-line-empty-p ()
  (save-excursion
    (beginning-of-line)
    (looking-at "[[:space:]]*$")))

;;**************************************************************
;;
;; Misc
;;
;;**************************************************************

(defun earl-print-elements-of-list (list)
  "Print each element of LIST on a line of its own."
  (while list
    (print (car list))
    (setq list (cdr list))))

;; Define alias for yes/no questions
(defalias 'yes-or-no-p 'y-or-n-p)

;;; Enable all disabled commands in one fell swoop
;; (setq disabled-command-function nil)

;; Disable startup message
(setq inhibit-startup-message t)

;;; Stop Emacs from losing undo information by
;;; setting very high limits for undo buffers
(setq undo-limit 20000000)
(setq undo-strong-limit 40000000)

;; Buffer switching (ido)
(ido-mode 'buffers) ;; only use this line to turn off ido for file names!
(setq ido-ignore-buffers '("^ " "*Completions*" "*Shell Command Output*"
                           "*Messages*" "Async Shell Command"))
(setq ido-enable-flex-matching t)

(setq compilation-directory-locked nil)
(scroll-bar-mode -1)
(setq shift-select-mode nil)
(setq enable-local-variables nil)

(setq c-hanging-semi&comma-criteria '((lambda () 'stop)))

(defun earl-write-buffer-to-home ()
  "Saves the buffer, and writes it to the home directory"
  (interactive)
  (save-buffer)
  (let ((full-path-list (split-string (buffer-file-name) "/")))
    (let ((relative-file-name (nth (- (length full-path-list) 1) full-path-list)))
      (write-region nil nil (concat "~/" relative-file-name)))))

;; ;; You can disable messages by setting the command-error-function to a function
;; ;; that ignores signals (buffer-read-only, beginning-of-buffer, end-of-buffer, etc.)
;; (defun earl-command-error-function (data context caller)
;;   "Ignore the buffer-read-only, beginning-of-buffer,
;; end-of-buffer signals; pass the rest to the default handler."
;;   (when (not (memq (car data) '(buffer-read-only
;;                                 beginning-of-buffer
;;                                 end-of-buffer)))
;;     (command-error-default-function data context caller)))
;; (setq command-error-function #'earl-command-error-function)

;;**************************************************************
;;
;; Delete, Kill, Cut, Copy, Paste, Yank
;;
;;**************************************************************

;; ;; If non-nil, `kill-line' with no arg at start of line kills the whole line.
;; (setq kill-whole-line t) ;; Original value was nil

(defun backward-kill-line (arg)
  "Kill ARG lines backward."
  (interactive "p")
  (if (bolp)
      (backward-delete-char-untabify 1)
    (kill-line 0)))

(defun backward-delete-word (arg)
  "Delete characters backward until encountering the beginning of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (backward-word arg) (point))))

(defun delete-word (arg)
  "Delete characters until encountering the ending of a word.
With argument ARG, do this that many times."
  (interactive "p")
  (delete-region (point) (progn (forward-word arg) (point))))

(defun delete-line (&optional arg)
  "Kill the rest of the current line; if no nonblanks there, kill thru newline.
With prefix argument ARG, kill that many lines from point.
Negative arguments kill lines backward.
With zero argument, kills the text before point on the current line.

When calling from a program, nil means \"no arg\",
a number counts as a prefix arg.

To kill a whole line, when point is not at the beginning, type \
\\[move-beginning-of-line] \\[kill-line] \\[kill-line].

If `show-trailing-whitespace' is non-nil, this command will just
kill the rest of the current line, even if there are only
nonblanks there.

If option `kill-whole-line' is non-nil, then this command kills the whole line
including its terminating newline, when used at the beginning of a line
with no argument.  As a consequence, you can always kill a whole line
by typing \\[move-beginning-of-line] \\[kill-line].

If you want to append the killed line to the last killed text,
use \\[append-next-kill] before \\[kill-line].

If the buffer is read-only, Emacs will beep and refrain from deleting
the line, but put the line in the kill ring anyway.  This means that
you can use this command to copy text from a read-only buffer.
\(If the variable `kill-read-only-ok' is non-nil, then this won't
even beep.)"
  (interactive "P")
  (delete-region (point)
                 ;; It is better to move point to the other end of the kill
                 ;; before killing.  That way, in a read-only buffer, point
                 ;; moves across the text that is copied to the kill ring.
                 ;; The choice has no effect on undo now that undo records
                 ;; the value of point from before the command was run.
                 (progn
                   (if arg
                       (forward-visible-line (prefix-numeric-value arg))
                     (if (eobp)
                         (signal 'end-of-buffer nil))
                     (let ((end
                            (save-excursion
                              (end-of-visible-line) (point))))
                       (if (or (save-excursion
                                 ;; If trailing whitespace is visible,
                                 ;; don't treat it as nothing.
                                 (unless show-trailing-whitespace
                                   (skip-chars-forward " \t" end))
                                 (= (point) end))
                               (and kill-whole-line (bolp)))
                           (forward-visible-line 1)
                         (goto-char end))))
                   (point))))

(defun backward-delete-line (arg)
  "Kill ARG lines backward."
  (interactive "p")
  (if (bolp)
      (backward-delete-char-untabify 1)
    (delete-line 0)))

;;**************************************************************
;;
;; AutoPairs, Auto paren, auto pair
;;
;;**************************************************************

;; ;; It can be useful to insert parentheses, braces, quotes and the like in matching pairs – e.g., pressing '(' inserts "()"
;; (electric-pair-mode t)

;;**************************************************************
;;
;; Indentation
;;
;;**************************************************************

(setq-default indent-tabs-mode nil)

;; My own c-indent-region that does not skip blank lines
;; I just write over the original c-indent-region with my own version of it since figuring out how to tell emacs to use
;; earl-c-indent-region for example takes more time
;; If something is wrong with this, delete it, copy the original and start anew (tip)
(defun c-indent-region (start end &optional quiet)
  "Indent syntactically every line whose first char is between START
and END inclusive.  If the optional argument QUIET is non-nil then no
syntactic errors are reported, even if `c-report-syntactic-errors' is
non-nil."
  (save-excursion
    (goto-char end)
    (skip-chars-backward " \t\n\r\f\v")
    (setq end (point))
    (goto-char start)
    (beginning-of-line)
    (setq start (point))
    (setq c-parsing-error
          (or (let ((endmark (copy-marker end))
                    (c-parsing-error nil)
                    ;; shut up any echo msgs on indiv lines
                    (c-echo-syntactic-information-p nil)
                    (ml-macro-start     ; Start pos of multi-line macro.
                     (and (c-save-buffer-state ()
                            (save-excursion (c-beginning-of-macro)))
                          (eq (char-before (c-point 'eol)) ?\\)
                          start))
                    (c-fix-backslashes nil)
                    syntax)
                (unwind-protect
                    (progn
                      (c-progress-init start end 'c-indent-region)
                      
                      (while (and (bolp) ;; One line each time round the loop.
                                  (not (eobp))
                                  (< (point) endmark))
                        ;; update progress
                        (c-progress-update)
                        (unless (and ml-macro-start (looking-at "\\s *\\\\$"))
                          ;; Get syntax and indent.
                          (c-save-buffer-state nil
                            (setq syntax (c-guess-basic-syntax)))
                          (c-indent-line syntax t t))
                        
                        (if ml-macro-start
                            ;; End of current multi-line macro?
                            (when (and c-auto-align-backslashes
                                       (not (eq (char-before (c-point 'eol)) ?\\)))
                              ;; Fixup macro backslashes.
                              (c-backslash-region ml-macro-start (c-point 'bonl) nil)
                              (setq ml-macro-start nil))
                          ;; New multi-line macro?
                          (if (and (assq 'cpp-macro syntax)
                                   (eq (char-before (c-point 'eol)) ?\\))
                              (setq ml-macro-start (point))))
                        
                        (forward-line))
                      
                      (if (and ml-macro-start c-auto-align-backslashes)
                          (c-backslash-region ml-macro-start (c-point 'bopl) nil t)))
                  (set-marker endmark nil)
                  (c-progress-fini 'c-indent-region))
                (c-echo-parsing-error quiet))
              c-parsing-error))))

;; My own indent-region that does not skip blank lines
;; I could call this one earl-indent-region and call that one in order to preserve indent-region in its original state
(defun indent-region (start end &optional column)
  "Indent each nonblank line in the region.
A numeric prefix argument specifies a column: indent each line to that column.

With no prefix argument, the command chooses one of these methods and
indents all the lines with it:

  1) If `fill-prefix' is non-nil, insert `fill-prefix' at the
     beginning of each line in the region that does not already begin
     with it.
  2) If `indent-region-function' is non-nil, call that function
     to indent the region.
  3) Indent each line via `indent-according-to-mode'.

Called from a program, START and END specify the region to indent.
If the third argument COLUMN is an integer, it specifies the
column to indent to; if it is nil, use one of the three methods above."
  (interactive "r\nP")
  (cond
   ;; If a numeric prefix is given, indent to that column.
   (column
    (setq column (prefix-numeric-value column))
    (save-excursion
      (goto-char end)
      (setq end (point-marker))
      (goto-char start)
      (or (bolp) (forward-line 1))
      (while (< (point) end)
	(delete-region (point) (progn (skip-chars-forward " \t") (point)))
	(or (eolp)
	    (indent-to column 0))
        (forward-line 1))
      (move-marker end nil)))
   ;; If a fill-prefix is specified, use it.
   (fill-prefix
    (save-excursion
      (goto-char end)
      (setq end (point-marker))
      (goto-char start)
      (let ((regexp (regexp-quote fill-prefix)))
	(while (< (point) end)
	  (or (looking-at regexp)
	      (and (bolp) (eolp))
	      (insert fill-prefix))
	  (forward-line 1)))))
   ;; Use indent-region-function is available.
   (indent-region-function
    (funcall indent-region-function start end))
   ;; Else, use a default implementation that calls indent-line-function on
   ;; each line.
   (t
    (save-excursion
      (setq end (copy-marker end))
      (goto-char start)
      (let ((pr (unless (minibufferp)
		  (make-progress-reporter "Indenting region..." (point) end))))
	(while (< (point) end)
          (indent-according-to-mode)
          (forward-line 1)
          (and pr (progress-reporter-update pr (point))))
	(and pr (progress-reporter-done pr))
        (move-marker end nil)))))
  ;; In most cases, reindenting modifies the buffer, but it may also
  ;; leave it unmodified, in which case we have to deactivate the mark
  ;; by hand.
  (deactivate-mark))

(defun earl-beginning-of-defun (&optional arg)
  (interactive "^p")
  (or (not (eq this-command 'beginning-of-defun))
      (eq last-command 'beginning-of-defun)
      (and transient-mark-mode mark-active))
  (and (beginning-of-defun-raw arg)
       (progn (beginning-of-line) t)))

(defun earl-end-of-defun (&optional arg)
  "Move forward to next end of defun.
With argument, do it that many times.
Negative argument -N means move back to Nth preceding end of defun.

An end of a defun occurs right after the close-parenthesis that
matches the open-parenthesis that starts a defun; see function
`beginning-of-defun'.

If variable `end-of-defun-function' is non-nil, its value
is called as a function to find the defun's end."
  (interactive "^p")
  (or (not (eq this-command 'end-of-defun))
      (eq last-command 'end-of-defun)
      (and transient-mark-mode mark-active))
  (if (or (null arg) (= arg 0)) (setq arg 1))
  (let ((pos (point))
        (beg (progn (end-of-line 1) (beginning-of-defun-raw 1) (point)))
	(skip (lambda ()
		;; When comparing point against pos, we want to consider that if
		;; point was right after the end of the function, it's still
		;; considered as "in that function".
		;; E.g. `eval-defun' from right after the last close-paren.
		(unless (bolp)
		  (skip-chars-forward " \t")
		  (if (looking-at "\\s<\\|\n")
		      (forward-line 1))))))
    (funcall end-of-defun-function)
    (funcall skip)
    (cond
     ((> arg 0)
      ;; Moving forward.
      (if (> (point) pos)
          ;; We already moved forward by one because we started from
          ;; within a function.
          (setq arg (1- arg))
        ;; We started from after the end of the previous function.
        (goto-char pos))
      (unless (zerop arg)
        (beginning-of-defun-raw (- arg))
        (funcall end-of-defun-function)))
     ((< arg 0)
      ;; Moving backward.
      (if (< (point) pos)
          ;; We already moved backward because we started from between
          ;; two functions.
          (setq arg (1+ arg))
        ;; We started from inside a function.
        (goto-char beg))
      (unless (zerop arg)
        (beginning-of-defun-raw (- arg))
	(setq beg (point))
        (funcall end-of-defun-function))))
    (funcall skip)
    (while (and (< arg 0) (>= (point) pos))
      ;; We intended to move backward, but this ended up not doing so:
      ;; Try harder!
      (goto-char beg)
      (beginning-of-defun-raw (- arg))
      (if (>= (point) beg)
	  (setq arg 0)
	(setq beg (point))
        (funcall end-of-defun-function)
	(funcall skip)))))

(defun earl-auto-indent-around-point ()
  "Automatic indentation of code around point"
  (interactive)
  (let ((pt (point))
        (nlines 64))
    (ignore-errors ;; Ignores the Beginning of buffer error
      (beginning-of-line)(previous-line nlines))
    (let ((start (point)))
      (goto-char pt)
      (ignore-errors ;; Ignores the End of buffer error
        (next-line nlines)(end-of-line))
      (let ((end (point)))
        (goto-char pt)
        (indent-region start end)))))

(defun earl-auto-indent-function ()
  "Automatically indents the function that the point is currently in. If point is not inside a function,
   then indents from start of first function above point, or point-min if no such function exits,
   and all the way to the end of a function after point, or point-max if no such function exits."
  (interactive)
  (let ((pt (point)))
    (earl-beginning-of-defun)
    (let ((start (point)))
      (goto-char pt) (earl-end-of-defun)
      (let ((end (point)))
        (goto-char pt) (indent-region start end)))))

;;**************************************************************
;;
;; ISearch dabbrev-expand
;;
;;**************************************************************

(require 'dabbrev)
(require 'cl-lib)
(defvar isearch-dabbrev/expansions-list nil)
(defvar isearch-dabbrev/expansions-list-idx 0)

(defun isearch-dabbrev/unquote-regexp (string)
  "Replace quoted instances of regex special character with its unquoted form."
  (let ((inverted "")
        (index 0)
        current-char
        next-char)
    (cl-loop until (equal index (length string)) do
             (setq current-char (elt string index))
             (setq next-char
                   (unless (equal (1+ index) (length string))
                     (elt string (1+ index))))
             (if (and (equal current-char ?\\)
                      (member next-char
                              '(?. ?\\ ?+ ?* ?? ?^ ?$ ?\[ ?\])))
                 (progn
                   (setq inverted (concat inverted (list next-char)))
                   (cl-incf index 2))
               (setq inverted (concat inverted (list current-char)))
               (cl-incf index)))
    inverted))

;;;###autoload
(defun isearch-dabbrev-expand ()
  "Dabbrev-expand in isearch-mode"
  (interactive)
  (let ((dabbrev-string (if isearch-regexp
                            (isearch-dabbrev/unquote-regexp isearch-string)
                          isearch-string))
        istring)
    (if (eq last-command this-command)
        (progn
          (setq isearch-dabbrev/expansions-list-idx
                (if (= isearch-dabbrev/expansions-list-idx
                       (1- (length isearch-dabbrev/expansions-list)))
                    0
                  (1+ isearch-dabbrev/expansions-list-idx))))
      (let (expansion expansions-before expansions-after
                      (dabbrev-check-all-buffers nil)
                      (dabbrev-check-other-buffers nil))
        (setq isearch-dabbrev/expansions-list nil)
        (setq isearch-dabbrev/expansions-list-idx 0)
        (save-excursion
          (let ((point-start
                 (ignore-errors
                   (if isearch-forward
                       (backward-sexp)
                     (forward-sexp))
                   (point))))
            
            (dabbrev--reset-global-variables)
            (while (setq expansion
                         (dabbrev--find-expansion dabbrev-string
                                                  -1
                                                  isearch-case-fold-search))
              (setq expansions-after (cons expansion expansions-after)))
            (goto-char point-start)
            (dabbrev--reset-global-variables)
            (while (setq expansion
                         (dabbrev--find-expansion dabbrev-string
                                                  1
                                                  isearch-case-fold-search))
              (setq expansions-before (cons expansion expansions-before)))))
        (setq isearch-dabbrev/expansions-list
              (if isearch-forward
                  (append (reverse expansions-after) expansions-before)
                (append (reverse expansions-before) expansions-after)))))
    
    (when (not isearch-dabbrev/expansions-list)
      (error "No dynamic expansion for \"%s\" found in this-buffer"
             isearch-string))
    
    (setq istring (nth isearch-dabbrev/expansions-list-idx
                       isearch-dabbrev/expansions-list))
    (if (and isearch-case-fold-search
             (eq 'not-yanks search-upper-case))
        (setq istring (downcase istring)))
    (if isearch-regexp (setq istring (regexp-quote istring)))
    (setq isearch-yank-flag t)
    
    (setq isearch-string istring
          isearch-message (mapconcat 'isearch-text-char-description istring ""))
    (isearch-search-and-update)))

(setq isearch-allow-scroll t)

(defun earl-isearch-exit-recenter ()
  (interactive)
  (isearch-exit)
  (recenter))

;;**************************************************************
;;
;; Debugging, Debugger mode
;;
;;**************************************************************

;; Use (debug-on-entry 'function-name) to mark a function for debugging next time it is called

(defun earl-debugger-mode-hook ()
  (define-key evil-normal-state-local-map [f5] 'debugger-continue)
  (define-key evil-normal-state-local-map [f8] 'top-level) ;; Stop debugging
  (define-key evil-normal-state-local-map [f9] 'debugger-record-expression)
  (define-key evil-normal-state-local-map [f10] 'debugger-eval-expression)
  (define-key evil-normal-state-local-map [f11] 'debugger-step-through)
  (define-key evil-normal-state-local-map [f12] 'debugger-toggle-locals))

(add-hook 'debugger-mode-hook 'earl-debugger-mode-hook)

;;**************************************************************
;;
;; Emacs lisp mode
;;
;;**************************************************************

(defun earl-emacs-lisp-mode-hook ()
  ;; Make Enter indent for you
  (define-key evil-normal-state-local-map [return] 'earl-newline-and-indent)
  (define-key evil-insert-state-local-map [return] 'earl-newline-and-indent)
  
  ;; Configure mode line
  (setq-local mode-line-format '("%e" mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification "   " mode-line-position evil-mode-line-tag
                                 (vc-mode vc-mode)
                                 "  " mode-line-modes mode-line-misc-info mode-line-end-spaces "   %f")))

(add-hook 'emacs-lisp-mode-hook 'earl-emacs-lisp-mode-hook)

;;**************************************************************
;;
;; Compilation mode
;;
;;**************************************************************

(defun earl-compilation-mode-hook ()
  (local-set-key (kbd "<SPC>") 'set-mark-command))

(add-hook 'compilation-mode-hook 'earl-compilation-mode-hook)

;;**************************************************************
;;
;; Assembly
;;
;;**************************************************************

(defun earl-asm-mode-hook ()
  ;; Make Enter indent for you
  (define-key evil-normal-state-local-map [return] 'earl-newline-and-indent)
  (define-key evil-insert-state-local-map [return] 'earl-newline-and-indent))

(add-hook 'asm-mode-hook 'earl-asm-mode-hook)

(defun earl-nasm-mode-hook ()
  ;; (setq nasm-basic-offset 4) ;; default value is 8
  (earl-asm-mode-hook))

(when (require 'nasm-mode nil 'noerror)
  (add-to-list 'auto-mode-alist '("\\.\\(asm\\|s\\)$" . nasm-mode))
  (add-hook 'nasm-mode-hook 'earl-nasm-mode-hook))

;;**************************************************************
;;
;; Uniquify
;;
;;**************************************************************

;; Constructs buffers with unique names
(require 'uniquify)
;; (setq uniquify-strip-common-suffix nil)
(setq uniquify-buffer-name-style 'forward)

;;**************************************************************
;;
;; ETags, CTags, CScope, Compiler Dependencies, Tags file generation
;;
;;**************************************************************

;; NOTE NOTE(earl): It might be better to run this system after a user saves their file, not on compilation
;;                  compilation-finish-functions, after-save-hook

;; NOTE(earl): - Simple CTags commands: "ctags -e -R *.cpp *.hpp *.h" (target fire)
;;                                      "ctags -e -R ." (fire everything!)

;; TODO(earl):
;;               Go over this section and figure out what needs to be run only in c/c++ mode
;;               There might be issuses when I start working with other languages like Python for example
;;               I don't know, I'm only speculating
;;               Maybe hook stuff to the c-mode-common-hook or c++-mode-hook or whatever needed to solve potential problems
;;
;;               There also might be possible problems when I start working on Linux
;;               Easy solution (when casey-win32 / casey-aquamacs / casey-linux)
;;
;;               Summary:
;;                           - Test Emacs with different programming languages if needed
;;                           - Test Emacs on Linux
;;                           - Go through this section and do a cleanup
;;                           - Rework the entire thing

;; IMPORTANT: After changing back directory, the source paths might still be relative, run ctags...source FIX THIS (cl-compiler)
;;            Compiler might need to run from one dir because of relative path, after changing the directory back to
;;            the previous directory ctags will generate the tags file in that directory. When listing dependencies
;;            with the cl-compiler, you have to supply earl-ctags-source-files directly to the ctags-command,
;;            but the paths are relative and the directory have been changed back...
;;            This concerns the cl-compiler since it doesn't list the source-file itself as one of the dependencies

;; IMPORTANT: The cl-compiler does not list the source-file as a dependency, but the gcc/g++ compilers do
;;            This is the reason for an important distinction between the two

;; TODO(earl): - Listing dependencies for gcc/g++ on Windows using CygWin outputs unix-style paths
;;             - If compiler gives ignorable warnings the tags file won't be generated (compilation must be perfect...) [too brittle?]
;;             - Test generating tags with no libraries, (cl)
;;             - Start using tags file name?
;;             - After generating tags-file tags-buffer has opened?
;;             - Make earl-refactor-gcc-gpp-dependencies-for-ctags convert linux-paths to windows-paths
;;               when refactoring dependencies for the windows platform
;;             - Multiple tag files in tags-table-list seem to conflict with each other when finding tags
;;             - Ctags doesn't handle relative paths (cl-compiler)
;;             - Support earl-ctags-source-files with multiple entries?
;;             - counting_sheep.cpp (w:\sandbox\counting_sheep) No tags containing cstdlib, fstream

;; Make emacs automatically reload tags file after update without asking
(setq tags-revert-without-query 1)

;; STUDY(earl): Find out if you should use tags-table-list or tags-file-name
;;              In order to use tags-file-name I think you have to set it locally to each buffer
;;              A possible solution to this is to set it each time the user tries to find a tag
;;              Move out of the buffers local directory, checking each directory in search of the tags file
;;              Once found set tags-file-name equal to it and then initiate find-tag
;;              NOTE(earl): The purpose to use multiple tag files in sub-folders instead of one tag file
;;                          in root folder is to scan less code files.

;; NOTE(earl):  Currently using tags-table-list
;;              tags-table-list works by storing tag-files received from earl-add-tags-table
;;              earl-add-tags-table is only called a handful of places
;;              Also check out earl-register-local-tags-file, it is called one time at the end of this section (Ctags)
;;              It checks the local directory Emacs starts up in to see if there is a tags file available for registering

;; If tags-file-name is set, then tags-table-list must be nil
;; If tags-table-list is set, then tags-file-name must be nil
(setq tags-file-name nil)
(setq tags-table-list nil)

;; NOTE(earl): Currently using ctags, not etags
(when casey-win32
  (setq earl-etags-shell-command "dir /b /s *.cpp *.hpp *.c *.h | etags -"))

(when casey-aquamacs
  (setq earl-etags-shell-command "find . -type f -iname \"*.[ch]\" | etags -"))

(when casey-linux
  (setq earl-etags-shell-command "find . -type f -iname \"*.[ch]\" | etags -"))

(defun earl-verify-tags-table-list ()
  "Checks each entry to see if the tags file exists"
  (let ((i 0))
    (while (< i (length tags-table-list))
      (let ((path (nth i tags-table-list)))
        (if (or (file-exists-p (concat path "tags")) (file-exists-p (concat path "TAGS")))
            (setq i (+ i 1))
          (setq tags-table-list (delete path tags-table-list)))))))

(defun earl-add-tags-table (ELEMENT)
  "Adds a new tags table to the tags-table-list"
  (interactive)
  (let ((a (replace-regexp-in-string "[\\]+" "/" ELEMENT)))
    (if (not (string-suffix-p "/" a))
        (if (not (or (string-suffix-p "tags" a)
                     (string-suffix-p "TAGS" a)
                     (string-suffix-p "Tags" a)))
            (setq a (concat a "/"))
          (setq a (nth 0 (split-string a "tags")))))
    (if (not (member a tags-table-list))
        (add-to-list 'tags-table-list a))))

(defun earl-register-local-tags-file ()
  "Registers the local projects tags file"
  (interactive)
  (setq current-directory default-directory)
  (let ((i 0))
    (while (< i 8)
      (progn
        (if (or (file-exists-p "TAGS")
                (file-exists-p "tags")
                (file-exists-p casey-makescript)
                (file-exists-p casey-todo-file)
                (file-exists-p casey-log-file))
            (progn
              (earl-add-tags-table default-directory)
              (setq i 1024))
          (cd "../"))
        (setq i (+ i 1)))))
  (cd current-directory))

;; NOTE(earl):
;;               This system checks the buffer's corresponding project's folder for a file denoted by the variable casey-makescript
;;               If no file is found, nothing will happen
;;               If found the file will be searched for three pieces of information:
;;                   - The compiler used to compile the project
;;                   - The projects "source" files
;;                   - The projects "library" files
;;               Once found the system will figure out the projects dependencies and from that create a tags file for the project
;;
;;               At the moment the system searches for:
;;                   - "cl" "gcc" "g++"
;;                   - "set SOURCE_FILES="
;;                   - "set LIBRARY_FILES="
;;                   - "set WORKING_DIRECTORY=" (Optional: important for relative paths)

(setq earl-ctags-compiler nil)
(setq earl-ctags-source-files nil)
(setq earl-ctags-library-files nil)
(setq earl-ctags-working-directory nil)

(setq earl-ctags-compiler-regexp "\\s-*cl\\s-+\\|\\s-*gcc\\s-+\\|\\s-*g\\+\\+\\s-+")
(setq earl-ctags-source-files-regexp "^\\(\\s-\\)*set\\(\\s-\\)+SOURCE_FILES=")
(setq earl-ctags-library-files-regexp "^\\(\\s-\\)*set\\(\\s-\\)+LIBRARY_FILES=")
(setq earl-ctags-working-directory-regexp "^\\(\\s-\\)*set\\(\\s-\\)+WORKING_DIRECTORY=")

(defun earl-parse-file-for-phrase (phrase)
  (interactive)
  (goto-char (point-min))
  (let ((done 'nil)
        (output 'nil))
    (while (not (eq done 't))
      (if (search-forward-regexp phrase (point-max) t)
          (let ((right (point)))
            (if (search-backward-regexp "^\\(\\s-\\)*rem\\(\\s-\\)+\\|^\\(\\s-\\)*REM\\(\\s-\\)+" (point-at-bol) t) ;; skip if comment
                (goto-char right)
              (progn
                (search-backward-regexp phrase (point-at-bol))
                (setq output (buffer-substring-no-properties (point) (- right 1)))
                (setq done 't))))
        (setq done 't)))
    (eval output)))

(defun earl-parse-file-for-line (phrase)
  (interactive)
  (goto-char (point-min))
  (let ((done 'nil)
        (output 'nil))
    (while (not (eq done 't))
      (if (search-forward-regexp phrase (point-max) t)
          (let ((left (point)))
            (if (search-backward-regexp "^\\(\\s-\\)*rem\\(\\s-\\)+\\|^\\(\\s-\\)*REM\\(\\s-\\)+" (point-at-bol) t) ;; skip if comment
                (goto-char left)
              (progn
                (end-of-line)
                (setq output (buffer-substring-no-properties left (point)))
                (setq done 't))))
        (setq done 't)))
    (eval output)))

(defun earl-parse-build-file ()
  "Check the earl-ctags-*-regexp for what patterns this function searches for
   Compiler keywords: cl, gcc, g++
   Source files keywords: SOURCE_FILES
   Library files keywords: LIBRARY_FILES"
  (interactive)
  (setq earl-ctags-compiler (earl-parse-file-for-phrase earl-ctags-compiler-regexp))
  (setq earl-ctags-source-files (earl-parse-file-for-line earl-ctags-source-files-regexp))
  (setq earl-ctags-library-files (earl-parse-file-for-line earl-ctags-library-files-regexp))
  (setq earl-ctags-working-directory (earl-parse-file-for-line earl-ctags-working-directory-regexp)))

;; Used by the process that will list all the dependencies of a c/c++ project
;; Stops the running of more than one instance of the emacs-earl-determine-dependencies process at the same time
(setq emacs-earl-determine-dependencies-process nil)
;; Stores the timer being used to check if emacs-earl-determine-dependencies-process has exited
(setq emacs-earl-determine-dependencies-timer nil)
(setq emacs-earl-determine-dependencies-process-name "emacs-earl-determine-dependencies")
(setq emacs-earl-determine-dependencies-buffer-name "*emacs-earl-determine-dependencies-tmp*")

;; Used by the process that will take the list of all the dependencies of a c/c++ project and use them to make a tags-file
(setq emacs-earl-ctags-process nil)
(setq emacs-earl-ctags-timer nil)
(setq emacs-earl-ctags-process-name "emacs-earl-ctags")
(setq emacs-earl-ctags-buffer-name "*emacs-earl-ctags-tmp*")

;; IMPORTANT: Pass inn the arguments as quoted ('arg1 'arg2 'arg3), except for input-region-min and input-region-max and directory
(defun earl-start-process-shell-command (process process-name buffer-name command input-region-min input-region-max process-timer timer-function &optional directory)
  "My own start-process-shell-command
   process - keeps track of the process and whether or not it's allready running
   process-name - Labels the process
   buffer-name - Labels the buffer that will store the process's output
   command - function that outputs a text-command for start-process-shell-command
   input-region-min and input-region-max - defines the region for which to use as input to the newly
   created process. The region concerns the current buffer
   process-timer - Keeps a reference to the timer being used to check for process-completion
   The timer ticks every 0.25 seconds and checks for process-completion, if so it calls timer-function
   timer-function - function that runs when process is finished running
   directory - optional argument passed so the user might do something concerning directories in timer-function"
  (interactive)
  (if (eq (symbol-value process) nil)
      (progn
        (set process
             (start-process-shell-command (symbol-value process-name) (symbol-value buffer-name) (funcall command)))
        (if (and (not (eq input-region-min nil)) (not (eq input-region-max nil)))
            (progn
              (process-send-region (symbol-value process) input-region-min input-region-max)
              (process-send-eof (symbol-value process))))
        (set process-timer
             (run-with-timer
              0.25 0.25
              (lambda (process-arg function-arg buffer-arg process-name-arg timer-arg &optional directory-arg) (interactive)
                (if (or (eq (process-status (symbol-value process-arg)) nil)
                        (eq (process-status (symbol-value process-arg)) 'exit))
                    (progn
                      (if (not (eq directory-arg nil))
                          (funcall function-arg (symbol-value buffer-arg) (symbol-value process-name-arg) directory-arg)
                        (funcall function-arg (symbol-value buffer-arg) (symbol-value process-name-arg)))
                      (kill-buffer (symbol-value buffer-arg)) ;; NOTE: Comment this line to keep the tmp-buffers open
                      (set process-arg nil)
                      (cancel-timer (symbol-value timer-arg))
                      (set timer-arg nil))))
              process timer-function buffer-name process-name process-timer directory)))
    (message (concat (concat "Process not started - There is allready a \"" process-name) "\" process running"))))

(defun earl-print-buffer-to-messages (arg)
  "Prints the current buffer to the messages buffer"
  (interactive)
  (message " ") (message "---- Start of buffer")
  (message (buffer-substring-no-properties (point-min) (point-max)))
  (message "---- End of buffer") (message " ")
  (message nil)
  (message arg))

(defun earl-handle-ctags-output (buffer-name-arg process-name-arg &optional directory)
  "When the ctags-process completes it outputs its result into buffer-name-arg.
   This function processes that output."
  (interactive)
  (with-current-buffer buffer-name-arg
    (let ((ctags-warnings nil))
      (goto-char (point-min))
      (if (search-forward "warning" nil t)
          (setq ctags-warnings t))
      (goto-char (point-min))
      (if (search-forward (concat (concat "Process " process-name-arg) " finished") nil t)
          (progn
            (earl-add-tags-table default-directory)
            (if (eq ctags-warnings nil)
                (message "Tags file successfully generated")
              (earl-print-buffer-to-messages "Tags file generated with warnings (check messages)")))
        (earl-print-buffer-to-messages "Something went wrong when generating the tags file")))))

(defun earl-refactor-cl-dependencies-for-ctags ()
  "Reworks the output from cl dependency listing so ctags will understand it
   Primarilly looks for warning-lines and removes them"
  (interactive)
  (let ((done nil))
    (while (not (eq done t))
      (if (search-forward-regexp ") : warning " (point-max) t)
          (progn
            (beginning-of-line) (let ((left (point))) (end-of-line) (forward-char 1) (delete-region left (point))))
        (setq done t)))))

;; NOTE(earl): Notes for earl-build-tags-file-for-cl-compiler
;; The first shell command lists all the dependencies of the c/c++ project
;; Every cpp, hpp, c and h file. Except for the source file itself
;; Original batch-command run from its own script:
;; @FOR /F "tokens=1,2,3,*" %%A IN ('cl /nologo /c %1 /Zs /showIncludes /I %2') DO @IF NOT "%%D"=="" echo %%D \
;; %1 and %2 are arguments provided from the command line to the batch file. E.g. batch-file arg1 arg2...

(defun earl-build-tags-file-for-cl-compiler (tags-file-directory)
  "Builds the tags file for the cl compiler"
  (interactive)
  
  ;; First shell command, lists all dependencies
  (earl-start-process-shell-command
   'emacs-earl-determine-dependencies-process 'emacs-earl-determine-dependencies-process-name 'emacs-earl-determine-dependencies-buffer-name
   (if earl-ctags-library-files ;; not nil
       '(lambda () (interactive) (concat (concat (concat "@FOR /F \"tokens=1,2,3,*\" %A IN ('cl /nologo /c \"" earl-ctags-source-files) "\" /Zs /showIncludes /I \"" earl-ctags-library-files) "\"') DO @IF NOT \"%D\"==\"\" echo %D"))
     '(lambda () (interactive) (concat (concat "@FOR /F \"tokens=1,2,3,*\" %A IN ('cl /nologo /c \"" earl-ctags-source-files) "\" /Zs /showIncludes ') DO @IF NOT \"%D\"==\"\" echo %D")))
   'nil 'nil 'emacs-earl-determine-dependencies-timer
   '(lambda (buffer-name process-name &optional directory-name) (interactive)
      (with-current-buffer buffer-name
        
        ;; Check if paths in earl-ctags-source-files are relative, if so convert to absolute
        ;; NOTE: For the moment only supports earl-ctags-source-files containing one file
        ;; Tips:
        ;; (file-truename "blih"))
        ;; (expand-file-name "relative/path" (file-name-directory load-file-name))
        (if (not (file-name-absolute-p earl-ctags-source-files))
            (setq earl-ctags-source-files (file-truename earl-ctags-source-files)))
        
        ;; Push earl-ctags-source-files on top of buffer-name
        (goto-char (point-min)) (insert (concat earl-ctags-source-files "\n"))
        (if directory-name (if (not (string= default-directory directory-name)) (cd directory-name)))
        
        ;; Checks to see if process completed successfully
        ;; If so refactors the output and then starts the ctags-process
        (goto-char (point-min))
        (if (search-forward (concat (concat "Process " process-name) " finished") nil t)
            (progn
              (goto-char (point-min)) (earl-refactor-cl-dependencies-for-ctags)
              (goto-char (point-min)) (search-forward (concat (concat "Process " process-name) " finished") nil t) (previous-line)
              
              ;; Second shell command, creates the tags-file
              (earl-start-process-shell-command
               'emacs-earl-ctags-process 'emacs-earl-ctags-process-name 'emacs-earl-ctags-buffer-name
               '(lambda () (interactive) "ctags -e -L - --c++-kinds=+p --fields=+iaS --extra=+q")
               (point-min) (point) 'emacs-earl-ctags-timer
               'earl-handle-ctags-output))
          (earl-print-buffer-to-messages "Something went wrong when listing the projects dependencies for generating the tags file (check messages)"))))
   tags-file-directory))

(defun earl-check-if-file-open-in-buffer (current-directory file)
  "Checks if the file is open in buffer. Takes into account several buffers of the same name.
   Returns buffer name if found, or nil if not"
  (interactive)
  (let ((absolute-path-list (split-string (concat current-directory file) "/"))
        (correct-buffer-name nil))
    (let ((list-length (length absolute-path-list)))
      (let ((i (- list-length 1)))
        (while (>= i -1)
          (let ((j (- list-length 1)))
            (let ((buffer-test-name (nth j absolute-path-list)))
              (while (> j i)
                (setq j (- j 1))
                (if (eq i -1) ;; special case to test /foo/bar/build.bat (without w:)
                    (if (eq j 0)
                        (progn
                          (setq buffer-test-name (concat "/" buffer-test-name))
                          (setq j i))
                      (setq buffer-test-name (concat (concat (nth j absolute-path-list) "/") buffer-test-name)))
                  (setq buffer-test-name (concat (concat (nth j absolute-path-list) "/") buffer-test-name))))
              (let ((buffer-object (get-buffer buffer-test-name)))
                (if (not (eq buffer-object nil))
                    (if (string= (buffer-file-name buffer-object) (concat current-directory file))
                        (progn
                          (setq correct-buffer-name buffer-test-name)
                          (setq j -1024)
                          (setq i -512)))))))
          (setq i (- i 1)))))
    (eval correct-buffer-name)))

(setq earl-windows-file-name-absolute "\\w:\\(\\\\\\([-a-zA-Z0-9_.#~+*]\\)+\\)+")
(setq earl-linux-file-name-absolute "\\(/[-a-zA-Z0-9_.#~+*]+\\)+")

(defun earl-refactor-gcc-gpp-dependencies-for-ctags (process-name)
  "Reworks the output from gcc/g++ -M so ctags will understand it"
  (interactive)
  
  ;; Remove initial clutter
  (search-forward ": " (point-max) t)
  (delete-region (point-min) (point))
  
  ;; Figure out if we are on Windows or Unix
  (if (looking-at-p earl-windows-file-name-absolute) ;; Windows
      (progn
        
        ;; Process first line
        (end-of-line) (backward-delete-char-untabify 2) (forward-char 1) ;; Starting on the first char of a new line
        (while (eq (eobp) nil)
          (if (looking-at (concat " " earl-linux-file-name-absolute))
              
              ;; TODO(earl): If looking at Linux-path, convert to Windows-path
              ;;             At the moment not supporting gcc/g++ libraries
              ;;             Now deletes every line
              ;; #include <sys/cygwin.h>
              ;; ssize_t cygwin_conv_path(cygwin_conv_path_t what, const void * from, void * to, size_t size);
              ;; Example:
              ;; /* Conversion from incoming Win32 path given as wchar_t *win32 to POSIX path.
              ;; If incoming path is a relative path, stick to it.  First ask how big
              ;; the output buffer has to be and allocate space dynamically. */
              ;; ssize_t size;
              ;; char *posix;
              ;; size = cygwin_conv_path (CCP_WIN_W_TO_POSIX | CCP_RELATIVE, win32, NULL, 0);
              ;; if (size < 0)
              ;; perror ("cygwin_conv_path");
              ;; else
              ;; {
              ;; posix = (char *) malloc (size);
              ;; if (cygwin_conv_path (CCP_WIN_W_TO_POSIX | CCP_RELATIVE, win32,
              ;;                                          posix, size))
              ;; perror ("cygwin_conv_path");
              ;; }
              
              (let ((beginning (point)))
                (if (search-forward-regexp earl-linux-file-name-absolute (point-at-eol) t)
                    (if (looking-at " [\\]$")
                        (progn (end-of-line) (forward-char 1) (delete-region beginning (point)))
                      (progn (insert "\n") (delete-region beginning (point))))))
            (if (looking-at (concat " " earl-windows-file-name-absolute))
                (progn (delete-char 1)
                       (if (search-forward-regexp earl-windows-file-name-absolute (point-at-eol) t)
                           (if (looking-at " [\\]$")
                               (progn (delete-char 2) (forward-char 1))
                             (insert "\n"))))
              
              ;; If not looking at windows file, delete the rest of the buffer
              (delete-region (point) (point-max))))))
    
    (if (looking-at-p earl-linux-file-name-absolute) ;; Linux
        (progn
          
          ;; Process first line
          (end-of-line) (backward-delete-char-untabify 2) (forward-char 1) ;; Starting on the first char of a new line
          (while (eq (eobp) nil)
            (if (looking-at (concat " " earl-linux-file-name-absolute))
                (progn (delete-char 1)
                       (if (search-forward-regexp earl-linux-file-name-absolute (point-at-eol) t)
                           (if (looking-at " [\\]$")
                               (progn (delete-char 2) (forward-char 1))
                             (insert "\n"))))
              
              ;; If not looking at linux file, delete the rest of the buffer
              (delete-region (point) (point-max)))))
      (earl-print-buffer-to-messages "Error refactoring the dependencies for the ctags program (check messages)"))))

;; NOTE: Notes for earl-build-tags-file-for-gcc-gpp-compiler
;; Original bash-script:
;;     #!/bin/bash
;;     # ./ctags_with_dep.sh file1.c file2.c ... to generate a tags file for these files.
;;     gcc -M $* | sed -e 's/[\\ ]/\n/g' | \
;;     sed -e '/^$/d' -e '/\.o:[ \t]*$/d' | \
;;     ctags -L - --c++-kinds=+p --fields=+iaS --extra=+q
;; Alternatively you could possibly use "#!/bin/sh" instead of "#!/bin/bash"?
;; What if you have other directories besides the standard /usr/include that containing the header files you need?
;; You could do a little modification on this script. For example, you have some header files in ~/include,
;; then you could pass -I ~/include to the gcc command. Just like below:
;;     gcc -M -I ~/include $* | sed -e 's/[\\ ]/\n/g' | \
;;     sed -e '/^$/d' -e '/\.o:[ \t]*$/d' | \
;;     ctags -L - --c++-kinds=+p --fields=+iaS --extra=+q
;; gcc and g++ options:
;; -llibrary - Search the library named library when linking.
;; It makes a difference where in the command you write this option; the linker searches processes libraries
;; and object files in the order they are specified. Thus, `foo.o -lz bar.o' searches library `z' after file `foo.o'
;; but before `bar.o'. If `bar.o' refers to functions in `z', those functions may not be loaded.
;; The directories searched include several standard system directories plus any that you specify with `-L'.

(defun earl-build-tags-file-for-gcc-gpp-compiler (tags-file-directory)
  "Builds the tags file for the gcc and g++ compiler"
  (interactive)
  
  ;; First shell command, lists all dependencies
  (earl-start-process-shell-command
   'emacs-earl-determine-dependencies-process 'emacs-earl-determine-dependencies-process-name 'emacs-earl-determine-dependencies-buffer-name
   (if (not (eq earl-ctags-library-files nil))
       '(lambda () (interactive) (concat (concat (concat (concat earl-ctags-compiler " -M ") earl-ctags-source-files) " -L ") earl-ctags-library-files))
     '(lambda () (interactive) (concat (concat earl-ctags-compiler " -M ") earl-ctags-source-files)))
   'nil 'nil 'emacs-earl-determine-dependencies-timer
   '(lambda (buffer-name process-name &optional directory-name) (interactive)
      (with-current-buffer buffer-name
        
        ;; If compiler was running in tmp working directory, then now is the time to change back
        (if directory-name (if (not (string= default-directory directory-name)) (cd directory-name)))
        
        ;; Check that the process finished successfully.
        ;; If so refactor output and create a new process to generate the tags-file
        ;; Pipe the refactored output to the CTags process
        (goto-char (point-min))
        (if (search-forward (concat (concat "Process " process-name) " finished") nil t)
            (progn
              (goto-char (point-min))
              (earl-refactor-gcc-gpp-dependencies-for-ctags process-name)
              
              ;; Second shell command, creates the tags-file
              (earl-start-process-shell-command
               'emacs-earl-ctags-process 'emacs-earl-ctags-process-name 'emacs-earl-ctags-buffer-name
               '(lambda () (interactive) "ctags -e -L - --c++-kinds=+p --fields=+iaS --extra=+q")
               (point-min) (point-max) 'emacs-earl-ctags-timer
               'earl-handle-ctags-output))
          (earl-print-buffer-to-messages "Something went wrong when listing the projects dependencies for generating the tags file (check messages)"))))
   tags-file-directory))

(defun earl-update-tag-file ()
  "Updates the tag file
   Always working from local directory"
  (interactive)
  (setq earl-ctags-compiler nil) (setq earl-ctags-source-files nil) (setq earl-ctags-library-files nil) (setq earl-ctags-working-directory nil)
  (setq current-directory default-directory)
  (message " ") (message "---- Updating the tags file")
  (let ((i 0))
    (while (< i 8)
      (if (file-exists-p casey-makescript)
          (progn
            
            ;; Check to see if the file is allready open, if not open-parse-close
            ;; Uses special function to check for several buffers of same name and handle that issue
            (let ((build-buffer (earl-check-if-file-open-in-buffer default-directory casey-makescript)))
              (if (not (eq build-buffer nil))
                  (with-current-buffer build-buffer
                    (let ((pt (point)))
                      (earl-parse-build-file)
                      (goto-char pt)))
                (progn
                  (find-file casey-makescript)
                  (earl-parse-build-file)
                  (setq build-buffer (earl-check-if-file-open-in-buffer default-directory casey-makescript))
                  (kill-buffer build-buffer))))
            
            ;; NOTE(earl): 
            ;; The source files might be relative paths which means the compiler must be run from a
            ;; "working directory" for listing dependencies. After the listing ctags will generate
            ;; a tags file, but we do not want the tags file to be located in the working directory.
            ;; Therefore we must pass on a reference to the directory where we found our casey-makescript
            ;; so that the compiler may run in the "working directory" and when it's time ctags may run
            ;; in the same directory where casey-makescript is located
            ;; A different solution would be to not pass on a directory and rather convert the
            ;; relative paths over to absolute paths. Then I could remove the directory parameter from
            ;; many of these functions.
            ;; earl-start-process-shell-command is allready packed with params as it is...
            ;; Meditate on this, I will.
            
            ;; Creating a list of dependencies using the compiler and creating a tags-file using ctags are two separate
            ;; operations that might want to happen in different folders. The following code stores the current directory
            ;; where we found our casey-makescript in the variable casey-makescript-directory. Then we check to see the value of
            ;; earl-ctags-working-directory, whose value is set by parsing the casey-makescript. earl-ctags-working-directory
            ;; holds the directory the compiler must be run from. If nil it can be run from the same directory where we found
            ;; casey-makescript. In that case we do not need to change the working directory. Later, when the compiler is finished
            ;; listing the dependencies, a timer will trigger a function, and in this function we check if our current working
            ;; directory (default-directory) is different from casey-makescript-directory (the directory we found casey-makescript).
            ;; If so, we change the directory back to casey-makescript-directory so the tags-file can be generated in the same
            ;; directory that casey-makescript resides.
            ;; We do this because the casey-makescript files might be using relative-paths instead of absolute-paths
            ;; If so the compiler needs a working directory from where to make sense of the relative-paths,
            ;; but at the same time we don't want to place our tags-file in the working directory...
            ;; Or do we? Lots of tags files on Dropbox? Gonna take a lot of space...
            
            ;; IMPORTANT(earl): Maybe we do want to store our tag-files in the working directory, so this entire
            ;;                  passing along directory might not be necessary. After a lot of projects
            ;;                  storing their tags file alongside their build files (Dropbox), Dropbox might
            ;;                  get short on disk-space...
            
            (let ((casey-makescript-directory default-directory))
              (if earl-ctags-working-directory ;; not equal nil
                  (progn
                    (message (concat (concat "Setting current working directory to \"" earl-ctags-working-directory) "\""))
                    (cd earl-ctags-working-directory)))
              (message (concat (concat "Current working directory is \"" default-directory) "\""))
              (if (string= earl-ctags-compiler "cl")
                  (if earl-ctags-source-files
                      (earl-build-tags-file-for-cl-compiler casey-makescript-directory)
                    (message "Please provide source files for generating the tags-file"))
                (if (or (string= earl-ctags-compiler "gcc")
                        (string= earl-ctags-compiler "g++"))
                    (if earl-ctags-source-files
                        (earl-build-tags-file-for-gcc-gpp-compiler casey-makescript-directory)
                      (message "Please provide source files for generating the tags-file"))
                  (message "Could not determine compiler for generating the tags-file"))))
            (setq i 1024))
        (progn
          (cd "../")
          (setq i (+ i 1)))))
    (if (eq i 8)
        (message (concat (concat "Error updating the tags file: couldn't find \"" casey-makescript) "\""))))
  (cd current-directory))

;;**************************************************************
;;
;; Simple Ctags system
;;
;;**************************************************************

(setq earl-update-simple-tag-file-process nil)
(setq earl-update-simple-tag-file-timer nil)
(setq earl-update-simple-tag-file-process-name "earl-update-simple-tag-file-process-name")
(setq earl-update-simple-tag-file-buffer-name "earl-update-simple-tag-file-buffer-name")

(defun earl-start-simple-tag-file-process ()
  (earl-start-process-shell-command
   'earl-update-simple-tag-file-process 'earl-update-simple-tag-file-process-name 'earl-update-simple-tag-file-buffer-name
   '(lambda () (interactive) "ctags -e -R * --c++-kinds=+p --fields=+iaS --extra=+q *.cpp *.hpp *.c *.h")
   nil nil 'earl-update-simple-tag-file-timer
   'earl-handle-ctags-output))

(defun earl-update-simple-tag-file ()
  "Creates a simple tags file"
  (interactive)
  (let ((starting-directory default-directory))
    (if (earl-find-file-recursively casey-makescript)
        (progn (earl-start-simple-tag-file-process) (earl-register-local-tags-file))
      (message "Could not find the file %s from directory %s" casey-makescript starting-directory))
    (cd starting-directory)))

;;**************************************************************
;;
;; End of Simple Ctags system
;;
;;**************************************************************

;; Toggle whether or not you want to build the tags file after a successful compilation without warnings
(setq earl-build-tags-file-after-successful-compilation t)

;; Toggle whether or not you want to use the simple ctags system
(setq earl-simple-ctags-system t)

(defun earl-build-tags-file-after-successful-compilation ()
  "Toggle whether or not to close the compile buffer automatically when successful without warnings"
  (interactive)
  (if (eq earl-build-tags-file-after-successful-compilation t)
      (progn
        (setq earl-build-tags-file-after-successful-compilation nil)
        (message "Not building tags file after successful compilation"))
    (progn
      (setq earl-build-tags-file-after-successful-compilation t)
      (message "Building tags file after successful compilation"))))

(defun earl-simple-ctags-system ()
  "Toggle whether or not you want to use the simple ctags system"
  (interactive)
  (if (eq earl-simple-ctags-system t)
      (progn
        (setq earl-simple-ctags-system nil)
        (message "Not using the simple Ctags system"))
    (progn
      (setq earl-simple-ctags-system t)
      (message "Using the simple Ctags system"))))

;; Update the tags file uppon successful compilation without warnings
(defun earl-update-tag-file-on-successful-compilation (buffer string)
  "Uppon successful compilation without warnings update the tag file"
  (interactive)
  (if (eq earl-build-tags-file-after-successful-compilation t)
      (if (earl-compilation-successfull buffer string)
          (if earl-simple-ctags-system (earl-update-simple-tag-file) (earl-update-tag-file)))))
(add-hook 'compilation-finish-functions 'earl-update-tag-file-on-successful-compilation)

;;; View tags other window
(defun view-tag-other-window (tagname &optional next-p regexp-p)
  "Same as `find-tag-other-window' but doesn't move the point"
  (interactive (find-tag-interactive "View tag other window: "))
  (let ((window (get-buffer-window)))
    (find-tag-other-window tagname next-p regexp-p)
    (recenter 0)
    (select-window window)))

;; Register the local tags file if there is one
(earl-register-local-tags-file)

;;**************************************************************
;;
;; OrgMode, Org-Mode, Org Mode
;;
;;**************************************************************

;; I like to press enter to follow a link. mouse clicks also work.
(setq org-return-follows-link t)

;; ;; Setup the frame configuration for following links.
;; (setq org-link-frame-setup (quote ((gnus . org-gnus-no-new-news)
;;                                    (file . find-file))))

;; ; Use the current window for C-c ' source editing
;; (setq org-src-window-setup 'current-window)

;; ;; use this code in emacs-lisp for folding code.
;; (global-set-key (kbd "C-M-]") (lambda () (interactive) (org-cycle t)))
;; (global-set-key (kbd "M-]") (lambda ()
;;                               (interactive)
;;                               (ignore-errors
;;                                 (end-of-defun)
;;                                 (beginning-of-defun))
;;                               (org-cycle)))

;; ;; use ido completion wherever possible
;; (setq org-completion-use-ido t)

;; allow lists with letters in them.
(setq org-list-allow-alphabetical t)

;; TODO: Take what you need from here
;;       Source: https://www.youtube.com/watch?v=fgizHHd7nOo
;;               https://github.com/jkitchin/jmax/blob/master/jmax-org.el#L147
;; ;; capture key binding
;; (define-key global-map "\C-c c" 'org-capture)

;; Outline Navigation
;; ------------------
;; f   (org-speed-move-safe (quote org-forward-heading-same-level))
;; b   (org-speed-move-safe (quote org-backward-heading-same-level))
;; F   org-next-block
;; B   org-previous-block
;; u   (org-speed-move-safe (quote outline-up-heading))
;; g   (org-refile t)

;; Outline Visibility
;; ------------------
;; c   org-cycle
;; C   org-shifttab
;;     org-display-outline-path
;; s   org-narrow-to-subtree
;; =   org-columns

;; Outline Structure Editing
;; -------------------------

;; i   (progn (forward-char 1) (call-interactively (quote org-insert-heading-respect-content)))
;; ^   org-sort
;; w   org-refile
;; a   org-archive-subtree-default-with-confirmation
;; @   org-mark-subtree
;; #   org-toggle-comment

;; Clock Commands
;; --------------
;; I   org-clock-in
;; O   org-clock-out

;; Meta Data Editing
;; -----------------
;; t   org-todo
;; ,   (org-priority)
;; 0   (org-priority 32)
;; 1   (org-priority 65)
;; 2   (org-priority 66)
;; 3   (org-priority 67)
;; :   org-set-tags-command
;; e   org-set-effort
;; E   org-inc-effort
;; W   (lambda (m) (interactive "sMinutes before warning: ") (org-entry-put (point) "APPT_WARNTIME" m))

;; Agenda Views etc
;; ----------------
;; v   org-agenda
;; /   org-sparse-tree

;; Misc
;; ----
;; o   org-open-at-point
;; ?   org-speed-command-help
;; <   (org-agenda-set-restriction-lock (quote subtree))
;; >   (org-agenda-remove-restriction-lock)

;; STUDY:
;; One more thing—it's best to set aside a separate directory where your org files will be kept.
;; I recommend using ~/org.

;; The global TODO list
;; (setq org-agenda-files (list "~/org/work.org"
;;                              "~/org/school.org" 
;;                              "~/org/home.org"))
;; Press C-c a t to enter the global todo list. Org-mode will scan the files in org-agenda-files
;; and present a listing of all the open TODO items:
;; You can move the cursor around to the different todo items, and hit "t" to mark an item DONE,
;; or hit RET to jump to the source file where the TODO is located.

;; Scheduling tasks (agenda)
;; Move the point after a TODO item and run org-schedule. A calendar pops up. Select date and org-mode
;; inserts a scheduling timestamp after the TODO  item. Now save the file and run org-agenda. A display
;; of this week's scheduled items are displayed. Now press lowercase L to turn on log display. This displays
;; all the finished tasks and their completion times.

;; NOTE:
;;     URL's - [[link][description]]

;; TODO: Keybindings for the following commands:
;;       - org-todo (C-c C-t)
;;       - org-insert-todo-heading (M-S-ENT)
;;       - org-open-at-point (C-c C-o)
;;       - org-store-link (C-c l)
;;       - org-insert-link (C-c C-l) [may need to press arrow-keys to scroll through list]
;;       - org-schedule (C-c C-s)
;; (define-key global-map "\C-cl" 'org-store-link)
;; (define-key global-map "\C-ca" 'org-agenda)

(evil-define-key 'normal org-mode-map (kbd "RET") 'org-return)
(evil-define-key 'insert org-mode-map (kbd "RET") 'org-return)
(evil-define-key 'normal org-mode-map (kbd "<tab>") 'org-cycle)
;; (evil-define-key 'insert org-mode-map (kbd "<tab>") 'org-cycle) ;; do we want dabbrev-expand here?
(evil-define-key 'normal org-mode-map (kbd "<S-tab>") 'org-shifttab)
(evil-define-key 'insert org-mode-map (kbd "<S-tab>") 'org-shifttab) ;; can we use this for something else?

(evil-define-key 'normal org-mode-map (kbd "]") 'outline-next-visible-heading)
(evil-define-key 'normal org-mode-map (kbd "[") 'outline-previous-visible-heading)
(evil-define-key 'normal org-mode-map (kbd "'") 'org-metaleft)
(evil-define-key 'normal org-mode-map (kbd "#") 'org-metaright)
(evil-define-key 'normal org-mode-map (kbd "@") 'org-shiftmetaleft)
(evil-define-key 'normal org-mode-map (kbd "~") 'org-shiftmetaright)
(evil-define-key 'normal org-mode-map (kbd "-") 'org-metaup)
(evil-define-key 'normal org-mode-map (kbd "=") 'org-metadown)
(evil-define-key 'normal org-mode-map (kbd "_") 'org-shiftmetaup)
(evil-define-key 'normal org-mode-map (kbd "+") 'org-shiftmetadown)

(evil-define-key 'normal org-mode-map (kbd "c") 'org-goto)

;;**************************************************************
;;
;; Help Mode
;;
;;**************************************************************

(evil-define-key 'normal help-mode-map (kbd "RET") 'help-follow)
(evil-define-key 'insert help-mode-map (kbd "RET") 'help-follow)
(evil-define-key 'normal help-mode-map (kbd "<tab>") 'forward-button)
(evil-define-key 'insert help-mode-map (kbd "<tab>") 'forward-button)
(evil-define-key 'normal help-mode-map (kbd "<S-tab>") 'backward-button)
(evil-define-key 'insert help-mode-map (kbd "<S-tab>") 'backward-button)

;;**************************************************************
;;
;; Python
;;
;;**************************************************************

(defun earl-python-mode-hook ()
  (setq earl-close-compile-buffer-automatically nil)
  (setq earl-build-tags-file-after-successful-compilation nil)
  (define-key evil-normal-state-local-map "*" 'earl-auto-indent-around-point))

(add-hook 'python-mode-hook 'earl-python-mode-hook)

;;**************************************************************
;;
;; Auto Revert, Auto Update, Auto Refresh, Auto Reload
;;
;; Automatically update buffers whose files
;; have been modified in another program
;;
;;**************************************************************

(global-auto-revert-mode t)
(setq auto-revert-interval 1) ;; Default check is 5 seconds
(auto-revert-set-timer)

;; All the "reverting buffer foo" messages are _really_ distracting.
(setq auto-revert-verbose nil)

(setq global-auto-revert-non-file-buffers t)

;;**************************************************************
;;
;; Kill all buffers
;;
;;**************************************************************

(defun earl-kill-all-buffers ()
  "Kill all buffers without a leading space in the buffer-name (emacs-internal-buffers)"
  (interactive)
  (mapc
   (lambda (x)
     (let ((name (buffer-name x)))
       (unless (eq ?\s (aref name 0))
         (kill-buffer x))))
   (buffer-list))
  (message "Killed all buffers"))

(defun earl-kill-all-buffers-visiting-a-file ()
  "Kill all buffers visiting a file"
  (interactive)
  (mapc
   (lambda (x)
     (let ((name (buffer-name x)))
       (if (and (not (eq ?\s (aref name 0))) (buffer-file-name x))
           (kill-buffer x))))
   (buffer-list))
  (message "Killed all buffers visiting a file"))

(defun earl-kill-all-buffers-not-visiting-a-file ()
  "Kill all buffers not visiting a file"
  (interactive)
  (mapc
   (lambda (x)
     (let ((name (buffer-name x)))
       (if (and (not (eq ?\s (aref name 0))) (not (buffer-file-name x)))
           (kill-buffer x))))
   (buffer-list))
  (message "Killed all buffers visiting a file"))

;;**************************************************************
;;
;; Load project
;;
;;**************************************************************

(setq earl-project-file "setup.prj")

(defun earl-find-file-recursively (file)
  "Recursively search for a file."
  (if (file-exists-p file) t
    (if (or (string-match "^[a-zA-Z]:/$" default-directory) (string= default-directory "/")) nil
      (progn (cd "../") (earl-find-file-recursively file)))))

(defun earl-load-project-from-project-file (file)
  "Loads a project from a project file"
  (let ((previous-buffer (current-buffer))
        (project-file-buffer (find-file file)))
    ;; Parse project file
    (switch-to-buffer project-file-buffer)
    (goto-char (point-min))
    (while (not (eq (point) (point-max))) ;; while not finished
      (let ((line (buffer-substring-no-properties (point) (progn (end-of-line) (point))))) ;; read line
        (if (not (string= line "")) ;; if line is valid
            (progn
              (find-file line t) ;; execute line
              ;; NOTE Kill buffers that were not supposed to be created
              ;; E.G. if regular expression line "*.*" doesn't result in any files a buffer named "*.*" is created
              ;; Windows does not allow * in their file/folder names, so we can easily find and kill these buffers
              (if (string-match "[*]+" (buffer-name))
                  (if (buffer-modified-p) (progn (undo-tree-undo) (kill-buffer)) (kill-buffer)))
              ;; Switch back to project buffer after find-file switched to the new buffer
              (switch-to-buffer project-file-buffer))))
      (if (not (eq (point) (point-max))) (progn (next-line) (beginning-of-line)))) ;; next line
    ;; Close project file and finish
    (if (eq previous-buffer project-file-buffer)
        (kill-buffer project-file-buffer)
      (progn (kill-buffer project-file-buffer) (switch-to-buffer previous-buffer)))
    (message "Successfully loaded: %s" file)))

(defun earl-load-project-backend (path)
  "Loads an entire project as described in the projects setup.prj file"
  (let ((previous-directory default-directory))
    (cd path)
    (if (earl-find-file-recursively earl-project-file)
        (earl-load-project-from-project-file (concat default-directory earl-project-file))
      (message "Found no setup.prj file in directory: %s" path))
    (cd previous-directory)))

(defun earl-load-project ()
  "Looks for a file named setup.prj at the specified location and if found processes it line by line.
   If no file is found, looks recursivelly in the parent directory untill root.
   Usage:
            Create a file named setup.prf in your project folder
            Each line in setup.prj is an argument to find-file.
            Argument examples: main.cpp, *.cpp, *.*, data/main.cpp, data/*.cpp and data/*.*
            NOTE: Be careful with * (it includes folders) For files use *.* (hidden folders?)"
  (interactive)
  (let ((path (read-directory-name "Enter project path: " default-directory default-directory t)))
    (earl-load-project-backend path)))

(defun earl-load-project-without-promt ()
  "Loads a project in current directory or one of the parent directories"
  (interactive)
  (earl-load-project-backend default-directory))

;;**************************************************************
;;
;; Files and Directories
;;
;;**************************************************************

;; Find file in directory without knowing exactly where it is
;; Looks recursivelly inwards in DIR searching for file matching PATTERN
;; (find-name-dired DIR PATTERN)

;; Delete File
;; (delete-file FILENAME &optional TRASH)

(defun delete-file-and-buffer ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (when filename
      (delete-file filename)
      (message "Deleted file %s" filename)
      (kill-buffer))))

;; Create Directory
;; (make-directory DIR &optional PARENTS)

;; Copy Directory
;; (copy-directory DIRECTORY NEWNAME &optional KEEP-TIME PARENTS COPY-CONTENTS)

;; Delete Directory
;; (delete-directory DIRECTORY &optional RECURSIVE TRASH)

;;**************************************************************
;;
;; Completions
;;
;;**************************************************************

;; Change *Completions* list to sort vertically
(setq completions-format 'vertical)

;;**************************************************************
;;
;; Calculator
;;
;;**************************************************************

(defun calc-eval-region (beg end)
  "Eval the arithmetic expression in the region and replace it with the result"
  (interactive "r")
  (let ((val (calc-eval (buffer-substring beg end))))
    (delete-region beg end)
    (insert val)))

;;**************************************************************
;;
;; CygWin
;;
;;**************************************************************

;; ;; Make sure that the bash executable can be found
;; (setq explicit-shell-file-name "C:/cygwin64/bin/bash.exe")
;; (setq shell-file-name explicit-shell-file-name)
;; (add-to-list 'exec-path "C:/cygwin64/bin")

;;**************************************************************
;;
;; Keymaps
;;
;;**************************************************************

(defun earl-keymap-symbol (keymap)
  "Return the symbol to which KEYMAP is bound, or nil if no such symbol exists."
  (catch 'gotit
    (mapatoms (lambda (sym)
                (and (boundp sym)
                     (eq (symbol-value sym) keymap)
                     (not (eq sym 'keymap))
                     (throw 'gotit sym))))))

(defun earl-get-current-keymap ()
  (interactive)
  (print (earl-keymap-symbol (current-local-map))))

;;**************************************************************
;;
;; Dired Mode
;;
;;**************************************************************

(defun earl-dired-mode-hook ()
  (define-key evil-normal-state-local-map "i" 'previous-line)
  (define-key evil-normal-state-local-map "I" 'earl-previous-blank-line)
  (define-key evil-normal-state-local-map "k" 'next-line)
  (define-key evil-normal-state-local-map "K" 'earl-next-blank-line)
  (define-key evil-normal-state-local-map "j" 'backward-char)
  (define-key evil-normal-state-local-map "J" 'backward-word)
  (define-key evil-normal-state-local-map "l" 'forward-char)
  (define-key evil-normal-state-local-map "L" 'forward-word)
  
  (local-set-key (kbd "<S-up>") 'previous-blank-line)
  (local-set-key (kbd "<S-left>") 'backward-word)
  (local-set-key (kbd "<S-down>") 'next-blank-line)
  (local-set-key (kbd "<S-right>") 'forward-word)
  
  (define-key evil-normal-state-local-map "o" 'end-of-line) ;; end-or-middle-of-line
  (define-key evil-normal-state-local-map "u" 'beginning-of-indentation-or-line)
  (define-key evil-normal-state-local-map "'" 'forward-or-backward-sexp) ;; Go to the matching parenthesis character if one is adjacent to point.
  (define-key evil-normal-state-local-map "[" 'search-move-backward-paren-opening-and-closing)
  (define-key evil-normal-state-local-map "]" 'search-move-forward-paren-opening-and-closing)
  (define-key evil-normal-state-local-map "{" 'earl-beginning-of-defun)
  (define-key evil-normal-state-local-map "}" 'earl-end-of-defun)
  (define-key evil-normal-state-local-map "(" 'backward-up-list)
  (define-key evil-normal-state-local-map "<" '(lambda () (interactive) (goto-char (point-min)))) ;; beginning-of-buffer
  (define-key evil-normal-state-local-map ">" '(lambda () (interactive) (goto-char (point-max)))) ;; end-of-buffer
  
  (define-key evil-normal-state-local-map "a" 'other-window)
  (define-key evil-normal-state-local-map "Z" 'kill-this-buffer)
  )
(add-hook 'dired-mode-hook 'earl-dired-mode-hook)

;;**************************************************************
;;
;; Benchmarking, Profiling
;;
;;**************************************************************

;; Benchmark package is autoloaded
;; usage: (benchmark 100 (form (to be evaluated)))

;; Benchmark is good at overall tests,
;; but if you’re having performance problems
;; it doesn’t tell you which functions are causing the problem.
;; For that, you have the (also built-in) profiler.

;;     Start it with M-x profiler-start.
;;     Pick between processor usage, memory usage, or both.
;;     Do some time consuming operations.
;;     Stop it with M-x profiler-stop
;;     Get the report with M-x profiler-report.

(evil-define-key 'normal profiler-report-mode-map (kbd "RET") 'profiler-report-expand-entry)
(evil-define-key 'insert profiler-report-mode-map (kbd "RET") 'profiler-report-expand-entry)

;; In addition to @Malabara's answer, I tend to use a custom-made with-timer macro to permanently instrument various parts of my code (e.g my init.el file).
;; The difference is that while benchmark allows to study the performance of a specific bit of code that you instrument,
;; with-timer always gives you the time spent in each instrumented part of the code (without much overhead for sufficiently large parts),
;; which gives you the input to know which part should be investigated further.

(defmacro with-timer (title &rest forms)
  "Run the given FORMS, counting the elapsed time.
A message including the given TITLE and the corresponding elapsed
time is displayed."
  (declare (indent 1))
  (let ((nowvar (make-symbol "now"))
        (body   `(progn ,@forms)))
    `(let ((,nowvar (current-time)))
       (message "%s..." ,title)
       (prog1 ,body
         (let ((elapsed
                (float-time (time-subtract (current-time) ,nowvar))))
           (message "%s... done (%.3fs)" ,title elapsed))))))

;; ;; Usage example:
;; (with-timer "Doing things"
;;   (form (to (be evaluated))))

;; ----------------------
;; Emacs Startup Profiler
;; ----------------------

;; Emacs records the total init time. You can show it with the command emacs-init-time

;;-------------------------------------------------------------------------------------------------------------
;;
;;                                                     Evil Mode
;;
;;-------------------------------------------------------------------------------------------------------------

;;************************************************
;;
;; Functions and variables 
;;
;;************************************************

;; Make horizontal movement cross lines
(setq-default evil-cross-lines t)

;; Move cursor back when it reaches eol
(setq evil-move-cursor-back nil)

;;************************************************
;;
;; Overriding and intercept keymaps
;;
;;************************************************

;; If you set these two to nil, then the active Evil keymaps have precedence over other active keymaps.
(setq evil-overriding-maps nil)
(setq evil-intercept-maps nil)

;;************************************************
;;
;; Modes' initial state
;;
;;************************************************

;; While Buffer Menu comes up in motion state, other modes such as Ediff come up in Emacs state where all Evil keymaps are inactive.
;; You may change a mode’s initial state by customizing the evil-*-state-modes variables.
;; The Minibuffer is an exception: it is always in Emacs state regardless of these variables.
;; To move all elements of evil-emacs-state-modes to evil-motion-state-modes:

(setq evil-normal-state-modes (append evil-emacs-state-modes evil-normal-state-modes))
(setq evil-normal-state-modes (append evil-motion-state-modes evil-normal-state-modes))
(setq evil-normal-state-modes (append evil-normal-state-modes '(shell-mode)))
(setq evil-insert-state-modes (delete 'shell-mode evil-insert-state-modes))
(setq evil-emacs-state-modes nil)
(setq evil-default-state 'normal)

;;************************************************
;;
;; Making the most of RET and SPC
;;
;;************************************************

;; It is common for Emacs modes like Buffer Menu, Ediff, and others to define key bindings for RET and SPC.
;; Since these are motion commands, Evil places its key bindings for these in evil-motion-state-map.
;; However, these commands are fairly worthless to a seasoned Vim user, since they do the same thing as j and l commands.
;; Thus it is useful to remove them from evil-motion-state-map so as when modes define them,
;; RET and SPC bindings are available directly. 

;; (defun my-move-key (keymap-from keymap-to key)
;;   "Moves key binding from one keymap to another, deleting from the old location. "
;;   (define-key keymap-to key (lookup-key keymap-from key))
;;   (define-key keymap-from key nil))
;; (my-move-key evil-motion-state-map evil-normal-state-map (kbd "RET"))
;; (my-move-key evil-motion-state-map evil-normal-state-map " ")

;;************************************************
;;
;; Make some key quit pretty much anything (like pending prompts in the minibuffer)
;;
;;************************************************

(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))

;;************************************************
;;
;; Changing color by state - Dark Theme
;;
;;************************************************

;; ;; change mode-line color by evil state [default-color, '("#974325" . "#ffffff")]
;; (lexical-let ((default-color (cons (face-background 'mode-line)
;;                                    (face-foreground 'mode-line))))
;;   (add-hook 'post-command-hook
;;             (lambda ()
;;               (let ((color (cond ((minibufferp) '("#439725" . "#ffffff"))
;;                                  ((evil-insert-state-p) '("#974325" . "#ffffff"))
;;                                  ((evil-emacs-state-p)  '("#444488" . "#ffffff"))
;;                                  ((buffer-modified-p)   default-color) ; '("#006fa0" . "#ffffff")
;;                                  (t '("#439725" . "#ffffff")))))
;;                 (set-face-background 'mode-line (car color))
;;                 (set-face-foreground 'mode-line (cdr color))))))

;; ;; change fringe color by evil state
;; (lexical-let ((default-color earl-color-background))
;;   (add-hook 'post-command-hook
;;             (lambda ()
;;               (let ((color (cond ((minibufferp) default-color)
;;                                  ((evil-insert-state-p) default-color)
;;                                  ((evil-emacs-state-p)  default-color)
;;                                  (t default-color))))
;;                 (set-face-background 'fringe color)))))

;; ;; change cursor color by evil state
;; (lexical-let ((default-color earl-color-cursor))
;;   (add-hook 'post-command-hook
;;             (lambda ()
;;               (let ((color (cond ((minibufferp) default-color)
;;                                  ((evil-insert-state-p) "#ff4040")
;;                                  (t default-color))))
;;                 (set-cursor-color color)))))

;; ;; change cursor shape
;; (setq evil-insert-state-cursor evil-normal-state-cursor)

;; ;; change vertical border color by evil state
;; (lexical-let ((default-color (cons (face-background 'vertical-border)
;;                                    (face-foreground 'vertical-border))))
;;   (add-hook 'post-command-hook
;;             (lambda ()
;;               (let ((color (cond ((minibufferp) '("#40FF40" . "#439725"))
;;                                  ((evil-insert-state-p) '("#161616" . "#974325"))
;;                                  (t '("#40FF40" . "#439725")))))
;;                 (set-face-background 'vertical-border (car color))
;;                 (set-face-foreground 'vertical-border (cdr color))))))

;;************************************************
;;
;; Changing color by state - Light Theme
;;
;;************************************************

;; ;; change mode-line color by evil state
;; (lexical-let ((default-color (cons (face-background 'mode-line)
;;                                    (face-foreground 'mode-line))))
;;   (add-hook 'post-command-hook
;;             (lambda ()
;;               (let ((color (cond ((minibufferp)  default-color)
;;                                  ((evil-insert-state-p) '("#268bd2" . "#fdf6e3"))
;;                                  ((evil-emacs-state-p)  '("#d33682" . "#fdf6e3"))
;;                                  ((buffer-modified-p)   '("#dc322f" . "#fdf6e3"))
;;                                  (t default-color))))
;;                 (set-face-background 'mode-line (car color))
;;                 (set-face-foreground 'mode-line (cdr color))))))

;; ;; change fringe color by evil state
;; (lexical-let ((default-color earl-color-hl-line))
;;   (add-hook 'post-command-hook
;;             (lambda ()
;;               (let ((color (cond ((minibufferp) default-color)
;;                                  ((evil-insert-state-p) earl-color-sol-blue)
;;                                  ((evil-emacs-state-p)  earl-color-sol-magenta)
;;                                  (t default-color))))
;;                 (set-face-background 'fringe color)))))

;; ;; change cursor color by evil state
;; (lexical-let ((default-color earl-color-cursor))
;;   (add-hook 'post-command-hook
;;             (lambda ()
;;               (let ((color (cond ((minibufferp) default-color)
;;                                  ((evil-insert-state-p) earl-color-sol-blue)
;;                                  (t default-color))))
;;                 (set-cursor-color color)))))

;; ;; change cursor shape
;; (setq evil-insert-state-cursor evil-normal-state-cursor)

;; ;; change vertical border color by evil state
;; (lexical-let ((default-color (cons (face-background 'vertical-border)
;;                                    (face-foreground 'vertical-border))))
;;   (add-hook 'post-command-hook
;;             (lambda ()
;;               (let ((color (cond ((minibufferp) default-color)
;;                                  ((evil-insert-state-p) '("#268bd2" . "#fdf6e3"))
;;                                  (t default-color))))
;;                 (set-face-background 'vertical-border (car color))
;;                 (set-face-foreground 'vertical-border (cdr color))))))

;;-------------------------------------------------------------------------------------------------------------
;;
;;                                               Evil key configuration
;;
;;-------------------------------------------------------------------------------------------------------------

;;************************
;;
;; Movement
;;
;;************************

(define-key evil-normal-state-map "i" 'previous-line)
(define-key evil-normal-state-map "I" 'earl-previous-blank-line)
(define-key evil-normal-state-map "k" 'next-line)
(define-key evil-normal-state-map "K" 'earl-next-blank-line)
(define-key evil-normal-state-map "j" 'backward-char)
(define-key evil-normal-state-map "J" 'backward-word)
(define-key evil-normal-state-map "l" 'forward-char)
(define-key evil-normal-state-map "L" 'forward-word)

(global-set-key (kbd "<S-up>") 'previous-blank-line)
(global-set-key (kbd "<S-left>") 'backward-word)
(global-set-key (kbd "<S-down>") 'next-blank-line)
(global-set-key (kbd "<S-right>") 'forward-word)

(define-key evil-normal-state-map "o" 'end-of-line) ;; end-or-middle-of-line
(define-key evil-normal-state-map "u" 'beginning-of-indentation-or-line)
(define-key evil-normal-state-map "'" 'forward-or-backward-sexp) ;; Go to the matching parenthesis character if one is adjacent to point.
(define-key evil-normal-state-map "[" 'search-move-backward-paren-opening-and-closing)
(define-key evil-normal-state-map "]" 'search-move-forward-paren-opening-and-closing)
(define-key evil-normal-state-map "{" 'earl-beginning-of-defun)
(define-key evil-normal-state-map "}" 'earl-end-of-defun)
(define-key evil-normal-state-map "(" 'backward-up-list)
(define-key evil-normal-state-map "<" '(lambda () (interactive) (goto-char (point-min)))) ;; beginning-of-buffer
(define-key evil-normal-state-map ">" '(lambda () (interactive) (goto-char (point-max)))) ;; end-of-buffer

;;************************
;;
;; Scrolling
;;
;;************************

;; TODO(earl): This shit is lagging on 4k monitor for some reason
;;             Profiling reveals it's the lambda that is the problem.
;;             Have to optimize emacs's c source code to fix...
;;             (or it might be this specific emacs version...)
;; (define-key evil-normal-state-map "p" (lambda () (interactive) (scroll-down 4)))
;; (define-key evil-normal-state-map ";" (lambda () (interactive) (scroll-up 4)))
;; (define-key evil-normal-state-map "P" (lambda () (interactive) (scroll-down 24)))
;; (define-key evil-normal-state-map ":" (lambda () (interactive) (scroll-up 24)))

;; Can't get emacs to fucking compile...
;; Fuck it, this shit seem to work without lag
;; ---------------------------------------------------------------------------------------------------
(defun earl-when-frame-size-changed (frame)
  (setq next-screen-context-lines (/ (* (window-total-height) 18) 20)))
(add-hook 'window-size-change-functions 'earl-when-frame-size-changed)

(define-key evil-normal-state-map "p" 'scroll-down)
(define-key evil-normal-state-map ";" 'scroll-up)
(define-key evil-normal-state-map "P" 'scroll-down)
(define-key evil-normal-state-map ":" 'scroll-up)
;; ---------------------------------------------------------------------------------------------------

(setq hscroll-margin 1) ; NOTE(earl): This one gets set further down in the emacs section
;; (setq hscroll-step 50) ; controls how many columns to scroll the window when point too close to edge, default = center point
(define-key evil-normal-state-map "O" (lambda () (interactive) (scroll-left 64 64)))
(define-key evil-normal-state-map "U" (lambda () (interactive) (scroll-right 64 64)))

;;************************
;;
;; Replace, Search
;;
;;************************

(define-key evil-normal-state-map "d" 'casey-replace-in-region)
(define-key evil-normal-state-map "D" 'query-replace)
(define-key evil-normal-state-map "s" 'isearch-forward)
(define-key evil-normal-state-map "S" 'isearch-backward) ;; isearch-forward-regexp
(define-key isearch-mode-map "\t" 'isearch-repeat-forward)
(define-key isearch-mode-map [S-tab] 'isearch-repeat-backward)
(define-key isearch-mode-map [return] 'earl-isearch-exit-recenter)

(eval-after-load "isearch"
  '(define-key isearch-mode-map (kbd "C-<tab>") 'isearch-dabbrev-expand))

;;********************************
;;
;; Delete, kill, cut, copy, paste, yank
;;
;;********************************

(define-key evil-normal-state-map [backspace] 'backward-delete-char-untabify)
(define-key evil-normal-state-map [S-backspace] 'backward-delete-word) ;; backward-kill-word
(define-key evil-normal-state-map [C-backspace] 'backward-delete-line) ;; backward-kill-line
(define-key evil-normal-state-map "\377" 'delete-horizontal-space) ; \377 is alt-backspace
(define-key evil-normal-state-map [del] 'delete-char)

(define-key evil-normal-state-map "h" 'delete-char)
(define-key evil-normal-state-map "H" 'delete-word) ;; kill-word
(define-key evil-normal-state-map "n" 'delete-line) ;; kill-line
(define-key evil-normal-state-map "N" 'kill-rectangle) ;; delete-rectangle
(define-key evil-normal-state-map "&" 'earl-yank-pop) ;; yank-pop, evil-paste-pop
(define-key evil-normal-state-map "y" 'earl-yank) ;; yank, evil-paste-after, evil-paste-before
(define-key evil-normal-state-map "Y" 'yank-rectangle)
(define-key evil-normal-state-map "m" 'kill-region)
(define-key evil-normal-state-map "M" 'kill-ring-save)
(define-key evil-normal-state-map "#" 'earl-cut-expression)
(define-key evil-normal-state-map "~" 'earl-copy-expression)

;;************************
;;
;; Window, buffer, file
;;
;;************************

(define-key evil-normal-state-map "t" 'find-alternate-file-and-return)
(define-key evil-normal-state-map "T" 'rename-this-buffer-and-file)
(define-key evil-normal-state-map "r" 'earl-ido-switch-buffer-other-window)
(define-key evil-normal-state-map "R" 'earl-find-file-other-window)
(define-key evil-normal-state-map "e" 'ido-switch-buffer)
(define-key evil-normal-state-map "E" 'find-file)
(define-key evil-normal-state-map "w" 'save-buffer)
(define-key evil-normal-state-map "W" 'earl-save-some-buffers)
(define-key evil-normal-state-map "q" 'write-file)
(define-key evil-normal-state-map "Q" 'insert-file)
(define-key evil-normal-state-map "a" 'other-window)
(define-key evil-normal-state-map "Z" 'kill-this-buffer)
(define-key evil-normal-state-map (kbd "C-¬") 'save-buffers-kill-terminal) ;; C-x C-c
(define-key evil-normal-state-map "|" 'delete-other-windows) ;; delete-other-windows, delete-window

;; C-x C-z runs the command suspend-frame
(global-unset-key (kbd "C-x C-z"))

;;*****************************************
;;
;; ETags, CTags, CScope
;;
;;*****************************************

(setq earl-xref-find-definitions-other-window-var nil)

(defun earl-xref-goto-xref ()
  (interactive)
  (if earl-xref-find-definitions-other-window-var
      (progn
        (other-window 1)                                            ;; Move away from xrefs window
        (let ((previous-buffer-point (point))                       ;; Store that window point
              (previous-buffer (current-buffer)))                   ;; Store that window
          (other-window 1)                                          ;; Move back to xrefs window
          (xref-goto-xref)
          (let ((result-point (point))
                (result (current-buffer)))
            (switch-to-buffer previous-buffer)
            (goto-char previous-buffer-point)
            (switch-to-buffer-other-window result)
            (goto-char result-point))))
    (if (= (count-windows) 1)
        (progn
          (split-window-horizontally)
          (xref-goto-xref)
          (switch-to-buffer-other-window (current-buffer))
          (delete-other-windows))
      (progn
        (other-window 1)
        (let ((other-previous-buffer-point (point))
              (other-previous-buffer (current-buffer)))
          (other-window 1)
          (xref-goto-xref)
          (let ((result (current-buffer)))
            (switch-to-buffer other-previous-buffer)
            (switch-to-buffer-other-window result)
            (other-window 1) (goto-char other-previous-buffer-point) (other-window 1)))))))

(defun earl-xref--read-identifier (prompt)
  "Return the identifier read from the minibuffer."
  (let* ((backend (xref-find-backend))
         (id (xref-backend-identifier-at-point backend)))
    (completing-read (if id
                         (format "%s (default %s): "
                                 (substring prompt 0 (string-match
                                                      "[ :]+\\'" prompt))
                                 id)
                       prompt)
                     (xref-backend-identifier-completion-table backend)
                     nil nil nil
                     'xref--read-identifier-history id)))

(defun earl-get-xrefs-argument (identifier)
  "Without this function xref-find-definitions will search for identifier at point, and when that identifier
   is something nonsensical - like '00000' - the user will have to move point to a blank space in order to
   to call xref-find-definitions again and get prompted for a definition. Whatever is at point is blindly sent
   into the system, and thus the user must move the point in order to get prompted for input.
   This function solves this by forcing a read from buffer and having xref--find-definitions
   continuously call it untill a proper identifier is returned by prompting the user."
  (interactive (list (earl-xref--read-identifier "Find definitions of: ")))
  (funcall (intern (format "xref-backend-%s" 'definitions))
           (xref-find-backend)
           identifier))

(defun xref--find-definitions (id display-action)
  "    Used by xref-find-definitions, xref-find-definitions-other-window and xref-find-definitions-other-frame
    IMPORTANT(earl):
       This function is rewritten in my .emacs file. NB! This could cause trouble!
    I rewrote this function because I wanted to change the behaviour of xref when trying to find a definition (xref-find-definitions)
    and xref returning multiple possible matches back in a buffer called xref. The xref buffer would display and
    consquently hide one of my buffers and then stay there even when it had helped me find what I was looking for.
    I wanted it to hide automatically by itself. Another annoyance was that finding a definition in another window
    would open in the current window when multiple matches prompted the xref buffer. The xref buffer would pop up
    in the other window and stay there. I wanted to streamline this so I wouldn't have to manually correct
    which buffers were displaying.
       A simple solution to this would be to add simple window commands to when I selected a match in the xref buffer (earl-xref-goto-xref).
    These window commands would take care of everything I would need to do manually. This system would need to
    know in what window to display the definition i chose, so I created a simple global variable to keep track of this.
    Now I only needed to tweak xref-find-definitions and xref-find-definitions-other-window in such a way that they
    would set this global variable when called uppon. This however changed their behaviour, and I still don't understand
    why. To me it seems like I've come across some sort of bug, but statistically speaking it's probably me.
    I will point out though that i coppied the original functions word by word - only changing the name
    of these functions to include the prefix 'earl-' (indicating my functions) - and that was enough to change
    the behaviour. I have no explanation for this."
  (let ((xrefs (funcall (intern (format "xref-backend-%s" 'definitions)) ;; (if (cdr xrefs) == If multiple definitions found (opens a xref buffer)
                        (xref-find-backend)
                        id)))
    (while (not xrefs) (setq xrefs (call-interactively 'earl-get-xrefs-argument))) ;; NOTE xrefs must be valid
    (if display-action
        (progn
          (setq earl-xref-find-definitions-other-window-var t)
          (if (= (count-windows) 1)
              (progn
                (if (get-buffer "*xref*") (kill-buffer "*xref*"))
                (split-window-horizontally)
                (xref--show-xrefs xrefs display-action))
            (xref--show-xrefs xrefs display-action)))
      (progn
        (setq earl-xref-find-definitions-other-window-var nil)
        (if (cdr xrefs) ;; If multiple definitions found (opens a xref buffer)
            (if (= (count-windows) 1)
                (progn
                  (split-window-horizontally)
                  (xref--show-xrefs xrefs display-action)
                  (delete-other-windows))
              (progn
                (xref--show-xrefs xrefs display-action)
                (switch-to-prev-buffer)
                (switch-to-buffer-other-window "*xref*")))
          (xref--show-xrefs xrefs display-action))))))

(define-key evil-normal-state-map "`" 'imenu)
(define-key evil-normal-state-map "F" 'xref-find-definitions)                     ;; find-tag
(define-key evil-normal-state-map "G" 'xref-find-definitions-other-window)        ;; find-tag-other-window without moving point, view-tag-other-window
(define-key evil-normal-state-map "$" 'xref-find-apropos)                         ;; tags-apropos
(define-key evil-normal-state-map "%" 'tags-query-replace)                        ;; tags-query-replace, xref-query-replace-in-results
(define-key evil-normal-state-map "X" 'xref-pop-marker-stack)                     ;; pop-tag-mark
(define-key evil-normal-state-map "£" 'xref-find-references)
(define-key xref--button-map [return] 'earl-xref-goto-xref)

;; (define-key evil-normal-state-map "\"" (lambda () (interactive)
;;                                          (let ((current-prefix-arg 4))            ;; emulate C-u
;;                                            (call-interactively 'find-tag))))      ;; Find next tag
;; (define-key evil-normal-state-map "£" (lambda () (interactive)
;;                                         (let ((current-prefix-arg '-))            ;; emulate C-u -
;;                                           (call-interactively 'find-tag))))       ;; Find previous tag

;; find-tag-regexp, tags-search, 
;; find next tag regexp (lambda () (interactive) (let ((current-prefix-arg 4)) (call-interactively 'find-tag-regexp)))
;; tags-loop-continue – resume ‘tags-search’ or ‘tags-query-replace’ starting at point in a source file
;; tags-apropos – list all tags in a tags file that match a regexp
;; list-tags - displays a list of tags from one of the tag files in the tag table list
;; next-file - visits files covered by the tag table list. Visits next file, unless a prefix argument is supplied

;;*****************************************
;;
;; Misc
;;
;;*****************************************

;; (define-key evil-normal-state-map "^" 'electric-pair-mode) ;; Toggle Auto Paren mode on and off. Probably don't need it...

(define-key evil-normal-state-map "\\" 'quick-calc) ;; calc-eval-region
(define-key evil-normal-state-map "z" 'grep)
(define-key evil-normal-state-map "¬" 'eshell) ;; 'shell, 'term, 'eshell
(define-key evil-normal-state-map "!" 'universal-argument)

(define-key evil-normal-state-map "x" 'evil-ex)
;; (define-key evil-normal-state-map "x" 'execute-extended-command)
(define-key evil-normal-state-map " " 'set-mark-command)
(define-key evil-normal-state-map "\r" 'newline)
(define-key evil-normal-state-map "/" 'undo-tree-undo)
(define-key evil-normal-state-map "?" 'undo-tree-redo)
(define-key evil-normal-state-map "A" 'comment-or-uncomment-region)
(define-key evil-normal-state-map "@" 'exchange-point-and-mark)
(define-key evil-normal-state-map ")" 'goto-line)

;; no screwing with my middle mouse button
(global-unset-key [mouse-2])

(define-key evil-normal-state-map "-" 'casey-find-corresponding-file)
(define-key evil-normal-state-map "_" 'casey-find-corresponding-file-other-window)

(define-key evil-normal-state-map "=" 'load-todo)
(define-key evil-normal-state-map "+" 'load-log)

;; To convert tabs to spaces or vice versa
;; M-x untabify, M-x tabify

;; Macro
;; ‘M-x apply-macro-to-region-lines’
;; ‘M-x name-last-kbd-macro’
;; ‘M-x insert-kbd-macro’

(define-key evil-normal-state-map "C" 'start-kbd-macro)
(define-key evil-normal-state-map "V" 'end-kbd-macro)
(define-key evil-normal-state-map "B" 'call-last-kbd-macro)

;; Compilation
(define-key evil-normal-state-map earl-compilation-key 'make-without-asking)
(define-key evil-normal-state-map "c" 'first-error)
(define-key evil-normal-state-map "v" 'previous-error)
(define-key evil-normal-state-map "b" 'next-error)

;; (define-key evil-normal-state-map "\C-f" 'eval)
;; (define-key evil-normal-state-map "\C-f" 'eval-last-sexp)
;; (define-key evil-normal-state-map "\C-f" 'eval-region)
;; (define-key evil-normal-state-map "\C-f" 'eval-buffer)

;; Loading project
(define-key evil-normal-state-map [f12] 'earl-load-project)
(define-key evil-insert-state-map [f12] 'earl-load-project)

;; Overview mode
(define-key evil-normal-state-map "^" 'earl-tiny-text-mode)

;;*****************************************
;;
;; Define my own escape key
;;
;;*****************************************

(define-key evil-normal-state-map "f" 'evil-insert)

(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key evil-insert-state-map [escape] 'evil-normal-state)
(define-key evil-emacs-state-map [escape] 'keyboard-quit)
(define-key evil-ex-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(define-key isearch-mode-map [escape] 'isearch-abort)
(define-key minibuffer-local-filename-completion-map [escape] 'abort-recursive-edit)
(define-key minibuffer-local-filename-must-match-map [escape] 'abort-recursive-edit)
(global-set-key [escape] 'keyboard-quit)

;;*****************************************
;;
;; Space, tab, indent, newline, whitespace
;;
;;*****************************************

(define-key evil-normal-state-map "," 'newline-and-indent)
(define-key evil-normal-state-map "." 'open-line)

(define-key evil-normal-state-map "*" 'earl-auto-indent-function)
(define-key evil-insert-state-map "   " 'dabbrev-expand)
(define-key evil-insert-state-map "\t" 'dabbrev-expand)
(define-key evil-normal-state-map "\t" 'indent-region)
(define-key evil-normal-state-map [S-tab] 'indent-for-tab-command)
(define-key evil-insert-state-map [S-tab] 'indent-for-tab-command)
(define-key evil-normal-state-map [backtab] 'indent-for-tab-command)

(global-set-key (kbd "M-RET") (lambda () (interactive) (insert "    "))) ;; manual indentation (C-M-m)/(M-RETURN)
(global-set-key (kbd "<C-return>") (lambda () (interactive) (insert "    "))) ;; manual indentation (C-RETURN)
(global-set-key (kbd "<C-M-return>") (lambda () (interactive) (insert "    "))) ;; manual indentation (C-M-RETURN)
;; M-SPC = just-one-space, delete trailing spaces so there's just one left
;; M-BACKSPACE = 0 spaces, Delete all spaces and tabs around point.

;;*****************************************
;;
;; My own Caps Lock
;;
;;*****************************************

(setq earl-caps-lock 0)

(global-set-key (kbd "<f4>") (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))
(define-key evil-normal-state-map [f4] (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))
(define-key evil-insert-state-map [f4] (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))

(global-set-key (kbd "<f5>") (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))
(define-key evil-normal-state-map [f5] (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))
(define-key evil-insert-state-map [f5] (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))

(global-set-key (kbd "<f6>") (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))
(define-key evil-normal-state-map [f6] (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))
(define-key evil-insert-state-map [f6] (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))

(global-set-key (kbd "<f7>") (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))
(define-key evil-normal-state-map [f7] (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))
(define-key evil-insert-state-map [f7] (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))

(global-set-key (kbd "<f8>") (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))
(define-key evil-normal-state-map [f8] (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))
(define-key evil-insert-state-map [f8] (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))

(global-set-key (kbd "<f9>") (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))
(define-key evil-normal-state-map [f9] (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))
(define-key evil-insert-state-map [f9] (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))

(global-set-key (kbd "<f10>") (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))
(define-key evil-normal-state-map [f10] (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))
(define-key evil-insert-state-map [f10] (lambda () (interactive) (if (eq earl-caps-lock 1) (setq earl-caps-lock 0) (setq earl-caps-lock 1))))

(define-key evil-insert-state-map "q" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "Q") (insert "q"))))
(define-key evil-insert-state-map "w" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "W") (insert "w"))))
(define-key evil-insert-state-map "e" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "E") (insert "e"))))
(define-key evil-insert-state-map "r" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "R") (insert "r"))))
(define-key evil-insert-state-map "t" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "T") (insert "t"))))
(define-key evil-insert-state-map "y" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "Y") (insert "y"))))
(define-key evil-insert-state-map "u" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "U") (insert "u"))))
(define-key evil-insert-state-map "i" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "I") (insert "i"))))
(define-key evil-insert-state-map "o" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "O") (insert "o"))))
(define-key evil-insert-state-map "p" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "P") (insert "p"))))

(define-key evil-insert-state-map "Q" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "q") (insert "Q"))))
(define-key evil-insert-state-map "W" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "w") (insert "W"))))
(define-key evil-insert-state-map "E" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "e") (insert "E"))))
(define-key evil-insert-state-map "R" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "r") (insert "R"))))
(define-key evil-insert-state-map "T" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "t") (insert "T"))))
(define-key evil-insert-state-map "Y" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "y") (insert "Y"))))
(define-key evil-insert-state-map "U" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "u") (insert "U"))))
(define-key evil-insert-state-map "I" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "i") (insert "I"))))
(define-key evil-insert-state-map "O" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "o") (insert "O"))))
(define-key evil-insert-state-map "P" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "p") (insert "P"))))

(define-key evil-insert-state-map "a" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "A") (insert "a"))))
(define-key evil-insert-state-map "s" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "S") (insert "s"))))
(define-key evil-insert-state-map "d" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "D") (insert "d"))))
(define-key evil-insert-state-map "f" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "F") (insert "f"))))
(define-key evil-insert-state-map "g" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "G") (insert "g"))))
(define-key evil-insert-state-map "h" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "H") (insert "h"))))
(define-key evil-insert-state-map "j" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "J") (insert "j"))))
(define-key evil-insert-state-map "k" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "K") (insert "k"))))
(define-key evil-insert-state-map "l" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "L") (insert "l"))))

(define-key evil-insert-state-map "A" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "a") (insert "A"))))
(define-key evil-insert-state-map "S" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "s") (insert "S"))))
(define-key evil-insert-state-map "D" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "d") (insert "D"))))
(define-key evil-insert-state-map "F" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "f") (insert "F"))))
(define-key evil-insert-state-map "G" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "g") (insert "G"))))
(define-key evil-insert-state-map "H" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "h") (insert "H"))))
(define-key evil-insert-state-map "J" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "j") (insert "J"))))
(define-key evil-insert-state-map "K" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "k") (insert "K"))))
(define-key evil-insert-state-map "L" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "l") (insert "L"))))

(define-key evil-insert-state-map "z" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "Z") (insert "z"))))
(define-key evil-insert-state-map "x" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "X") (insert "x"))))
(define-key evil-insert-state-map "c" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "C") (insert "c"))))
(define-key evil-insert-state-map "v" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "V") (insert "v"))))
(define-key evil-insert-state-map "b" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "B") (insert "b"))))
(define-key evil-insert-state-map "n" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "N") (insert "n"))))
(define-key evil-insert-state-map "m" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "M") (insert "m"))))

(define-key evil-insert-state-map "Z" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "z") (insert "Z"))))
(define-key evil-insert-state-map "X" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "x") (insert "X"))))
(define-key evil-insert-state-map "C" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "c") (insert "C"))))
(define-key evil-insert-state-map "V" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "v") (insert "V"))))
(define-key evil-insert-state-map "B" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "b") (insert "B"))))
(define-key evil-insert-state-map "N" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "n") (insert "N"))))
(define-key evil-insert-state-map "M" (lambda () (interactive) (if (eq earl-caps-lock 1) (insert "m") (insert "M"))))

(add-hook 'evil-insert-state-entry-hook (lambda () (interactive) (setq earl-caps-lock 0)))
(add-hook 'evil-insert-state-exit-hook (lambda () (interactive) (setq earl-caps-lock 0)))

;;-------------------------------------------------------------------------------------------------------------
;;
;;                                             Emacs key configurations
;;
;;-----------------------------------------------------------------------------------------------------------------------------------

;;---------------------------
;;
;; Movement
;;
;;---------------------------

;;NOTE: there's a bug with C-j in the scratch buffer
(global-set-key (kbd "C-j") 'backward-char)
(global-set-key (kbd "C-M-j") 'backward-word)
(global-set-key (kbd "C-l") 'forward-char)
(global-set-key (kbd "C-M-l") 'forward-word)
(global-set-key (kbd "M-#") 'recenter-top-bottom)                  ;; takes over for C-l
(global-unset-key "\M-j")
(global-set-key (kbd "M-j") 'backward-words)
(global-set-key (kbd "M-l") 'forward-words)

;;; Translating C-M-i -> C-<f12>
(define-key key-translation-map (kbd "C-M-i") (kbd "C-<f12>"))
(global-set-key (kbd "C-<f12>") 'previous-blank-line)                       ; backward-paragraph
(global-set-key (kbd "M-i") (lambda () (interactive) (previous-line 2)))

;;; C-i is the same as TAB, so here we have to do something extra
;;; Translate the problematic keys to the function key Hyper:
(keyboard-translate ?\C-i ?\H-i)
(global-set-key [?\H-i] 'previous-line)

(global-set-key (kbd "C-M-k") 'next-blank-line)                              ; forward-paragraph
(global-set-key (kbd "M-k") (lambda () (interactive) (next-line 2)))
(global-set-key (kbd "C-k") 'next-line)
(global-set-key (kbd "C-c a") 'universal-argument)
(global-set-key (kbd "C-o") 'end-or-middle-of-line)
(global-set-key (kbd "C-u") 'beginning-of-indentation-or-line)
(global-set-key (kbd "M-L") 'forward-line-chunck)
(global-set-key (kbd "M-J") 'backward-line-chunck)
(global-set-key (kbd "M-/") 'forward-or-backward-sexp) ;; Go to the matching parenthesis character if one is adjacent to point.
(global-set-key (kbd "M-u") 'search-move-backward-paren-opening-and-closing)
(global-set-key (kbd "M-o") 'search-move-forward-paren-opening-and-closing)
(global-set-key (kbd "M-U") 'beginning-of-defun)
(global-set-key (kbd "M-O") 'end-of-defun)

;;-------------------------------------------------------------------------------------------------------------
;;
;; Scrolling
;;
;;----------------------------------------------------------------------------------------------------------------------------

(global-set-key (kbd "C-p") (lambda () (interactive) (scroll-down 4)))
(global-set-key (kbd "C-;") (lambda () (interactive) (scroll-up 4)))
(global-set-key (kbd "C-M-p") (lambda () (interactive) (scroll-down 24)))
(global-set-key (kbd "C-M-;") (lambda () (interactive) (scroll-up 24)))
(global-set-key (kbd "M-P") (lambda () (interactive) (scroll-other-window-down 24)))
(global-set-key (kbd "M-p") (lambda () (interactive) (scroll-other-window 24)))

;;; Scrolling the window
;; (global-set-key (kbd "M-i") (lambda () (interactive) (scroll-down-in-place 3)))
;; (global-set-key (kbd "M-k") (lambda () (interactive) (scroll-up-in-place 3)))

;;; Scrolling the window faster
(global-set-key (kbd "M-I") (lambda () (interactive) (scroll-down-in-place 8)))     ;; Capital letter implies Shift
(global-set-key (kbd "M-K") (lambda () (interactive) (scroll-up-in-place 8)))       ;; Capital letter implies Shift

;;---------------------------
;;
;; Horizontal Scrolling
;;
;;---------------------------

;;; My old way of scrolling (one window width [-2] at a time)
;; (global-set-key (kbd "C-M-o") 'scroll-left)
;; (put 'scroll-left 'disabled nil) ;; What did this line do?
;; (global-set-key (kbd "C-M-u") 'scroll-right)
;; (put 'scroll-right 'disabled nil) ;; What did this line do?

(setq hscroll-margin 1) ; controls how close point can get to left/right edges before scrolling
;; (setq hscroll-step 50) ; controls how many columns to scroll the window when point too close to edge, default = center point
(global-set-key (kbd "C-M-o") (lambda () (interactive) (scroll-left 64 64)))  ; scroll-left
(global-set-key (kbd "C-M-u") (lambda () (interactive) (scroll-right 64 64))) ; scroll-right

;;-------------------------------------------------------------------------------------------------------------
;;
;; Replace, Search
;;
;;--------------------------------------------------------------------------------------------------------------------------------

(global-set-key (kbd "M-m") 'casey-replace-string)
(global-set-key (kbd "C-.") 'casey-replace-in-region)
(global-set-key (kbd "C-,") 'query-replace) ; Also M-%
(global-set-key (kbd "C-M-'") 'find-tag)
(global-set-key (kbd "C-=") 'tags-loop-continue)
(global-set-key (kbd "C-e") 'isearch-backward)
(define-key isearch-mode-map "\C-e" 'isearch-repeat-backward)

;;-------------------------------------------------------------------------------------------------------------
;;
;; Delete, cut, copy, paste, yank
;;
;;--------------------------------------------------------------------------------------------------------------------------------

;; backspace = backward-delete-char-untabify, C-backspace = backward-kill-word
(global-set-key (kbd "<C-M-backspace>") 'backward-kill-line)
(global-set-key (kbd "<S-backspace>") 'backward-kill-sexp)
(define-key global-map "\377" 'delete-horizontal-space) ; \377 is alt-backspace
;; delete = delete-char
(define-key global-map [M-delete] 'kill-word)
(global-set-key (kbd "C-h") 'delete-char)
(global-set-key (kbd "M-h") 'kill-sexp)
(global-set-key (kbd "C-M-h") 'kill-word)
(global-set-key (kbd "C-n") 'kill-line)
(global-set-key (kbd "M-n") 'kill-rectangle)
(global-set-key (kbd "C-M-n") 'delete-blank-lines)
(global-set-key (kbd "C-\\") 'rotate-yank-pointer) ; used to be toggle-input-method
(global-set-key (kbd "C-y") 'yank)
(global-set-key (kbd "C-M-y") 'yank-pop)
(global-set-key (kbd "M-y") 'yank-rectangle)

;;-------------------------------------------------------------------------------------------------------------
;;
;; window, buffer, file
;;
;;--------------------------------------------------------------------------------------------------------------------------------

;; rename-this-buffer-and-file = C-x w, write-file = C-x C-w, save-buffer = C-x C-s, save-some-buffers = C-x s
(global-set-key (kbd "C-x o") 'pre-window)
(global-set-key (kbd "C-x p") 'other-window)
(global-set-key (kbd "C-a") 'other-window)
(global-set-key (kbd "C-v") 'ido-switch-buffer)
(global-set-key (kbd "C-b") 'earl-ido-switch-buffer-other-window)
(global-set-key (kbd "C-r") 'find-file)
(global-set-key (kbd "C-t") 'earl-find-file-other-window)
(global-set-key (kbd "C-x <up>") 'windmove-up)
(global-set-key (kbd "C-x <down>") 'windmove-down)
(global-set-key (kbd "C-x <right>") 'windmove-right)
(global-set-key (kbd "C-x <left>") 'windmove-left)
(global-set-key (kbd "C-x w") 'rename-this-buffer-and-file)
;; (define-key global-map "\er" 'revert-buffer) ; C-c r = revert-buffer
;; (define-key global-map "\ek" 'kill-this-buffer) ; C-x k = kill-this-buffer
;; (define-key global-map "\es" 'save-buffer) ; C-x C-s = save-buffer, C-x s = save-some-buffers

;; C-x C-z runs the command suspend-frame
(global-unset-key (kbd "C-x C-z"))

;;; Reload buffer
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "C-z") 'find-alternate-file)
;;You can also use "C-x C-v RET". 
;;This will prompt you to find an alternate file, and as a default,
;;suggests you the current file (ie reload file)

;;-------------------------------------------------------------------------------------------------------------
;; ;;
;; ;; space, tab, indent, newline, whitespace
;; ;;
;; ;;--------------------------------------------------------------------------------------------------------------------------------

;; (global-set-key (kbd "M-,") 'newline-and-indent)
;; (global-set-key (kbd "M-.") 'open-line)
;; (define-key global-map "\t" 'dabbrev-expand)
;; (define-key global-map [S-tab] 'indent-for-tab-command)
;; (define-key global-map [backtab] 'indent-for-tab-command)
;; ;;(define-key global-map "\C-y" 'indent-for-tab-command)
;; (define-key global-map [C-tab] 'indent-region)
;; (define-key global-map "   " 'indent-region)
;; (global-set-key (kbd "M-RET") (lambda () (interactive) (insert "    "))) ;; manual indentation (C-M-m)/(M-RETURN)
;; (global-set-key (kbd "<C-return>") (lambda () (interactive) (insert "    "))) ;; manual indentation (C-RETURN)
;; (global-set-key (kbd "<C-M-return>") (lambda () (interactive) (insert "    "))) ;; manual indentation (C-M-RETURN)
;; ;; M-SPC = just-one-space, delete trailing spaces so there's just one left
;; ;; M-BACKSPACE = 0 spaces, Delete all spaces and tabs around point.

;;-------------------------------------------------------------------------------------------------------------
;;
;; Macro
;;
;;--------------------------------------------------------------------------------------------------------------------------------

(global-set-key (kbd "C-]") 'start-kbd-macro)
(global-set-key (kbd "M-]") 'end-kbd-macro)
(global-set-key (kbd "C-M-]") 'call-last-kbd-macro)

;;-------------------------------------------------------------------------------------------------------------
;;
;; Misc
;;
;;--------------------------------------------------------------------------------------------------------------------------------

(global-set-key (kbd "C-c C-c") 'execute-extended-command)
(global-set-key (kbd "C-c v") 'comment-region)
(global-set-key (kbd "C-c C-v") 'uncomment-region)
(global-set-key (kbd "C-c C-a") 'c-fill-paragraph) ;; alternatively (M-q)
(global-set-key (kbd "C-c C-f") 'c-mark-function)
(global-set-key (kbd "C-c C-w") 'upcase-word)
(global-set-key (kbd "C-c w") 'captilize-word)

(global-set-key (kbd "C-d") 'exchange-point-and-mark)
(global-set-key (kbd "M-d") 'exchange-point-and-mark)                ;; up for grabs
(global-set-key (kbd "C-M-d") 'exchange-point-and-mark)              ;; up for grabs
(global-set-key (kbd "M-a") 'goto-line)
(global-set-key (kbd "C-x C-x") 'goto-line)
(global-set-key (kbd "C-'") 'imenu)
(global-set-key (kbd "C-c q") 'quick-calc)
;; (global-set-key (kbd "C-x C-a") 'global-hl-line-mode)
;;; C-x i = insert-file

;; no screwing with my middle mouse button
(global-unset-key [mouse-2])

;; Grep command
(global-set-key (kbd "C-c C-s") 'grep)

;;-------------------------------------------------------------------------------------------------------------
;;
;; Compilation
;;
;;-------------------------------------------------------------------------------------------------------------

;; (define-key global-map "\em" 'make-without-asking)
(global-set-key (kbd "C-f") 'make-without-asking)
(global-set-key (kbd "M-f") 'make-without-asking)
(global-set-key (kbd "C-M-/") 'first-error)
(global-set-key (kbd "C-M-.") 'next-error)
(global-set-key (kbd "C-M-,") 'previous-error)

;;-------------------------------------------------------------------------------------------------------------
;;
;; Shell and terminal
;;
;;-------------------------------------------------------------------------------------------------------------

(global-set-key (kbd "C-c f") 'shell)
(global-set-key (kbd "C-c C-f") 'term)
(global-set-key (kbd "C-c d") 'eshell)
(global-set-key (kbd "C-c C-d") 'eshell)
