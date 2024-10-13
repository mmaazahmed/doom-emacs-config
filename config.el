;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
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
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

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
;; Add custom lisp directory to load-path
(add-to-list 'load-path (expand-file-name "lisp" doom-user-dir))

;; Require the background-image-mode package
;; (require 'background-image-mode)

;; ;; Enable background image mode in specific modes or buffers
;; (add-hook 'text-mode-hook 'background-image-mode)
;; (add-hook 'org-mode-hook 'background-image-mode)
;; LSP Mode for TypeScript
(setq auth-sources '("~/.authinfo"))

(setq doom-theme 'doom-moonlight)
;; Function to switch to doom-pine theme in visual mode
;; (defun my/evil-visual-mode-hook ()
;;   (load-theme 'doom-pine t))

;; ;; Function to switch to doom-gruvbox-light theme in normal mode
;; (defun my/evil-normal-mode-hook ()
;;   (load-theme 'doom-gruvbox-light t))

;; ;; Add hooks to change theme on entering/exiting visual mode
;; (add-hook 'evil-visual-state-entry-hook 'my/evil-visual-mode-hook)
;; (add-hook 'evil-normal-state-entry-hook 'my/evil-normal-mode-hook)
(after! evil
  ;; Define \ as a prefix key in Normal mode
  (define-prefix-command 'my-backslash-prefix)
  (define-key evil-normal-state-map (kbd "\\") 'my-backslash-prefix)

  ;; Example key bindings under the \ prefix
  (define-key my-backslash-prefix (kbd "a") 'execute-extended-command) ;; \ a for M-x
  (define-key my-backslash-prefix (kbd "b") 'switch-to-buffer)         ;; \ b for buffer switch
  (define-key my-backslash-prefix (kbd "r") 'evil-redo)         ;; \ b for buffer switch
  (define-key my-backslash-prefix (kbd "o") 'better-jumper-jump-backward)         ;; \ b for buffer switch
  ;; Add other bindings as needed
)

(use-package! key-chord
  :defer t
  :config
  (key-chord-mode 1)
  ;; Set up the key chord with a 0.2-second delay
  (setq key-chord-two-keys-delay 0.2)
  ;; Map 'jk' to escape
  (key-chord-define-global "jk" 'evil-normal-state))
(use-package lsp-mode
  :ensure t
  :commands (lsp lsp-deferred)
  :hook ((typescript-mode . lsp-deferred)
         (tsx-mode . lsp-deferred))
  :custom
  (lsp-headerline-breadcrumb-enable nil)
  :bind
  (("C-c l d" . lsp-describe-session)
   ("C-c l r" . lsp-rename)
   ("C-c l f" . lsp-format-buffer)
   ("C-c l a" . lsp-execute-code-action)))

(use-package typescript-mode
  :ensure t
  :mode ("\\.ts\\'" "\\.tsx\\'")
  :hook ((typescript-mode . flycheck-mode)
         (typescript-mode . eldoc-mode)
         (typescript-mode . smartparens-mode))
  :custom
  (typescript-indent-level 2)
  :delight "ts")

(use-package flycheck
  :ensure t
  :hook (typescript-mode . flycheck-mode)
  :custom
  (flycheck-disabled-checkers '(typescript-tslint)))

(use-package smartparens
  :ensure t
  :config
  (require 'smartparens-config)
  (add-hook 'typescript-mode-hook #'smartparens-mode))

;; Enable Tree-sitter for TypeScript
(use-package tree-sitter
  :ensure t
  :hook (typescript-mode . tree-sitter-mode))

(use-package tree-sitter-langs
  :ensure t
  :after tree-sitter)

(tree-sitter-require 'typescript)

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-position 'bottom)
  (lsp-ui-sideline-enable t))

;; Enable auto-save-visited-mode for TypeScript files
(add-hook 'typescript-mode-hook #'auto-save-visited-mode)
(add-hook 'tsx-mode-hook #'auto-save-visited-mode)
(setq auto-save-visited-interval 0)  ;; Set interval to 0 for immediate saving
(add-hook 'css-mode-hook 'emmet-mode)
(add-hook 'html-mode-hook 'emmet-mode)

;; (defun my/grep-in-project (&optional term) "Run grep in current project. If TERM is not nil it will be used as initial value." (interactive) (let* ((pattern (read-string "Pattern: " (or term ""))) ;; add an extra space to be able to start typing more filters (pattern (concat pattern " "))) (call-interactively #'(lambda () (interactive) (consult-ripgrep (project-root (project-current)) pattern)))))

(defun my-search-for-css-class ()
  "Search for CSS class in related HTML and CSS files."
  (interactive)
  (let ((class-name (thing-at-point 'symbol t)))  ; Ensure class name is extracted as a string
    (if class-name
        (let* ((project-root (projectile-project-root))
               (search-term (regexp-quote (format ".%s" class-name))))  ; Prepare the search term
          (consult-ripgrep project-root  ; Set the project root for the search
                           ;; :grep-args '("rg" "--type" "css" "--type" "html")  ; Specify file types
                           (concat search-term " -- -g *.css")))  ; Place search term last as per usage
      (message "No class name found at point."))))  ; Handle case where no class is found

(map! :leader
      :desc "Search for CSS class" "c s" #'my-search-for-css-class)

;; (defun my-search-for-css-class ()
;;   "Search for CSS class in related HTML and CSS files."
;;   (interactive)
;;   (let ((class-name (thing-at-point 'symbol t)))  ; Ensure class name is extracted as a string
;;     (if class-name
;;         (let* ((project-root (projectile-project-root))
;;                (search-term (regexp-quote (format "#.%s" class-name))))  ; Prepare the search term
;;           ;; Debug output
;;           (message "Searching for: %s in %s" search-term project-root)
;;           (let ((command (format "rg --no-heading --no-line-number --only-matching '%s' '%s' --glob '*.css' --glob '*.html'"
;;                                  search-term project-root)))  ; Construct the command
;;             (message "Running command: %s" command)  ; Show the command being run
;;             (consult--async-command command  ; Execute the command
;;                                      :name (format "Search for class %s" class-name)  ; Name the source for clarity
;;                                      )))  ; Optionally, set a narrow key
;;       (message "No class name found at point."))))  ; Handle case where no class is found

;; (map! :leader
;;       :desc "Search for CSS class" "c s" #'my-search-for-css-class)










(defun my-goto-css-class-definition ()
  "Jump to the definition of the CSS class at point in HTML and CSS files."
  (interactive)
  (let ((class-name (thing-at-point 'symbol t)))  ; Get the class name under the cursor
    (if (and class-name (not (string-empty-p class-name)))  ; Check for valid class name
        (let* ((search-command (format "rg --no-heading --line-number --glob '*.html' --glob '*.css' '\\.%s'" class-name))
               (output (shell-command-to-string search-command)))  ; Run the search command
          (if (string-empty-p output)  ; Check if there are no matches
              (message "No matches found for class: %s" class-name)
            ;; Process the first result
            (let* ((first-result (car (split-string output "\n" t)))  ; Get the first line of output
                   (file-and-line (split-string first-result ":"))  ; Split the line into file and line number
                   (file (car file-and-line))
                   (line (string-to-number (cadr file-and-line))))  ; Convert line number to integer
              ;; Attempt to open the file and jump to the line
              (condition-case err
                  (progn
                    (find-file file)  ; Open the file
                    (goto-char (point-min))  ; Go to the beginning of the file
                    (forward-line (1- line))  ; Move to the specific line (1-based index)
                    (message "Jumped to %s at line %d" file line))  ; Display confirmation
                (error
                 (message "Error opening file: %s" (error-message-string err)))))))
      (message "No class name found at point."))))  ; Handle case where no class name is found

;; Keybinding to trigger the function
(map! :leader
      :desc "Go to CSS class definition" "c S" #'my-goto-css-class-definition)

;; ;; for window-select
;; (custom-set-faces!
;;   '(aw-leading-char-face
;;     :foreground "white" :background "purple"
;;     :weight bold :height 2.5 :box (:line-width 10 :color "red")))
(map! :leader
      :desc "ace-window select" "s w" #'ace-window)
;; (setq fancy-splash-image "~/background-images/eclipse.jpg")
(require 'battery)
(if (and battery-status-function
         (not (equal (alist-get ?L (funcall battery-status-function))
                     "N/A")))
    (prin1-to-string `(display-battery-mode 1))
  "")


(defadvice! prompt-for-buffer (&rest _)
  :after '(evil-window-split evil-window-vsplit)
  (projectile-find-file))


;; (after! consult
;;   (set-face-attribute 'consult-file nil :inherit 'consult-buffer)
;;   (setf (plist-get (alist-get 'perl consult-async-split-styles-alist) :initial) ";"))



(after! centaur-tabs
  (centaur-tabs-mode -1)
  (setq centaur-tabs-height 36
        centaur-tabs-set-icons t
        centaur-tabs-modified-marker "o"
        centaur-tabs-close-button "×"
        centaur-tabs-set-bar 'above
        centaur-tabs-gray-out-icons 'buffer)
  (centaur-tabs-change-fonts "P22 Underground Book" 160))
;; (defun my-evil-state-full-name ()
;;   "Return the full name of the current evil state."
;;   (pcase evil-state
;;     ('N "Normal")
;;     ('insert "Insert")
;;     ('visual "Visual")
;;     ('emacs "Emacs")
;;     ('replace "Replace")
;;     ('motion "Motion")
;;     ('operator "Operator")
;;     (_ (capitalize (symbol-name evil-state)))))


;; (setq doom-modeline-evil-visual-state 'visual)
;; (use-package! doom-modeline
;;   :config
  ;; (setq doom-modeline-modal-icon t ) ; Disable icons for the Evil state
;;   (add-hook 'doom-modeline-mode-hook
;;             (lambda (i)
;;               (setq doom-modeline--modal
;;                     '((:eval (my-evil-state-full-name)))))))
;; (setq powerline-arrow-shape 'curve)
  ;; '(:eval (cond
  ;;      (( eq evil-state 'visual) "V")
  ;;      (( eq evil-state 'normal) "N")
  ;;      (( eq evil-state 'insert) "I")
  ;;      (t "*")) q)
(setq evil-normal-state-tag   (propertize "Normal" 'face '((:background "green" :foreground "black")))
      evil-emacs-state-tag    (propertize "Emacs" 'face '((:background "orange" :foreground "black")))
      evil-insert-state-tag   (propertize "Insert" 'face '((:background "red") :foreground "white"))
      evil-motion-state-tag   (propertize "Motion" 'face '((:background "black") :foreground "white"))
      evil-visual-state-tag   (propertize "Visual" 'face '((:background "grey80" :foreground "black")))
      evil-operator-state-tag (propertize "Operator" 'face '((:background "purple"))))