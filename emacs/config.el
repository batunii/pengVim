;; Increase GC threshold during startup (prevents excessive GCs)
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Disable file name handlers during startup (big speed boost)
(defvar batunii--file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;; Restore after Elpaca finishes (not just emacs-startup-hook)
(add-hook 'elpaca-after-init-hook
          (lambda ()
            (setq gc-cons-threshold (* 20 1024 1024)  ; 16MB
                  gc-cons-percentage 0.1
                  file-name-handler-alist batunii--file-name-handler-alist)))

;; Fallback: also restore on emacs-startup-hook if elpaca hook doesn't exist
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 20 1024 1024)
                  gc-cons-percentage 0.1
                  file-name-handler-alist batunii--file-name-handler-alist)))

;; Don't compact font caches during GC
(setq inhibit-compacting-font-caches t)

;; Reduce frame resize overhead during startup
(setq frame-inhibit-implied-resize t)

;; Increase amount of data Emacs reads from processes
(setq read-process-output-max (* 1024 1024))  ; 1MB

(defvar elpaca-installer-version 0.11)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  (elpaca-use-package-mode))

(use-package emacs 
  :ensure nil 
  :config 
  (setq ring-bell-function #'ignore)
  (setq shift-select-mode nil)
  (setq org-support-shift-select nil))

(use-package evil 
  :ensure (:wait t)
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-minibuffer t
        evil-vsplit-window-right t
        evil-split-window-below t
	  evil-undo-system 'undo-redo)
  :config
  (evil-mode 1))

(use-package evil-collection 
  :ensure (:wait t)
  :after evil
  :config
  (setq evil-collection-mode-list '(dashboard dired ibuffer xref minibuffer))
  (setq evil-collection-want-unimpaired-p nil)
  (evil-collection-init))

(use-package general 
  :ensure (:wait t)
  :config
  (general-evil-setup)
  
  (general-create-definer batunii/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC"
    :global-prefix "M-SPC"))

(batunii/leader-keys
  "b"  '(:ignore t :wk "buffer")
  "bb" '(switch-to-buffer :wk "Switch buffer")
  "bk" '(kill-current-buffer :wk "Kill buffer")
  "bn" '(next-buffer :wk "Next buffer")
  "bp" '(previous-buffer :wk "Prev buffer")
  "br" '(revert-buffer :wk "Reload buffer"))

(batunii/leader-keys
  "w"  '(:ignore t :wk "window")
  "ws" '(split-window-below :wk "Split below")
  "wv" '(split-window-right :wk "Split right")
  "wk" '(delete-window :wk "Delete window"))

(batunii/leader-keys
  "l"  '(:ignore t :wk "lsp")
  "ld" '(lsp-find-definition :wk "Go to definition")
  "lD" '(lsp-find-references :wk "Find references")
  "lr" '(lsp-rename :wk "Rename symbol")
  "lf" '(lsp-format-buffer :wk "Format buffer")
  "lh" '(batunii/lsp-show-doc :wk "Show docs")
  "ln" '(flymake-goto-next-error :wk "Next diagnostic")
  "lp" '(flymake-goto-prev-error :wk "Prev diagnostic")
  "le" '(batunii/show-error-at-point :wk "Error at point"))

(batunii/leader-keys
  "sr" '(query-replace :wk "Query replace")
  "e" '(treemacs :wk "Treemacs")
  "cc" '(compile :wk "Compile")
  )

;; Set default frame parameters (applies to all frames)
(setq default-frame-alist
      '((font . "JetBrainsMono Nerd Font-15")))  ; Note: size is part of font string

;; Additional font settings
(set-face-attribute 'variable-pitch nil
                    :font "JetBrainsMono Nerd Font"
                    :height 190
                    :weight 'medium)

(set-face-attribute 'fixed-pitch nil
                    :font "JetBrainsMono Nerd Font Mono"
                    :height 180
                    :weight 'medium)

(set-face-attribute 'font-lock-comment-face nil :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil :weight 'bold :slant 'italic)

(use-package catppuccin-theme
  :ensure t
  :custom
  (catppuccin-italic-comments t)
  (catppuccin-italic-variables nil)
  (catppuccin-italic-blockquotes t)
  (catppuccin-flavor 'mocha)
  
  :config
  (load-theme 'catppuccin :no-confirm)
  
  ;; Override background colors
  (catppuccin-set-color 'base "#181818")
  (catppuccin-set-color 'mantle "#282828")
  (catppuccin-set-color 'crust "#282828")
  
  (catppuccin-reload))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(set-frame-parameter nil 'undecorated t) ; Remove window decorations

(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode +1)
(global-visual-line-mode t)

(use-package which-key
  :ensure t
  :diminish (which-key-mode)
  :init
  (which-key-mode 1)
  :config
  (setq which-key-side-window-location 'bottom
        which-key-sort-order #'which-key-key-order-alpha
        which-key-idle-delay 0.8
        which-key-max-description-length 25))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook)
  (setq dashboard-startup-banner "~/.config/emacs/ascii.txt"
        dashboard-center-content t
        dashboard-items '((recents . 10))
        dashboard-set-heading-icons t
        dashboard-set-file-icons t
        dashboard-banner-logo-title "Welcome to redmacs"
        initial-buffer-choice (lambda () (get-buffer-create "*dashboard*"))))

(use-package toc-org
  :ensure t
  :hook (org-mode . toc-org-enable))

(add-hook 'org-mode-hook #'org-indent-mode)

(use-package org-bullets
  :ensure t
  :after org
  :hook (org-mode . org-bullets-mode))

(when (and (fboundp 'treesit-available-p)
           (treesit-available-p))
  (setq major-mode-remap-alist
        '((python-mode . python-ts-mode)
          (c-mode      . c-ts-mode)
          (c++-mode    . c++-ts-mode)
          (js-mode     . js-ts-mode)
          (css-mode    . css-ts-mode)
          (json-mode   . json-ts-mode)))
  
  (setq treesit-font-lock-level 4))

(use-package lsp-pyright
  :ensure t
  :after lsp-mode
  :hook (python-ts-mode . lsp-pyright))
  (use-package lsp-mode
    :ensure t
    :commands lsp
    :diminish (lsp-mode . " LSP")
    :hook ((python-ts-mode . lsp)
           (c-ts-mode . lsp)
           (c++-ts-mode . lsp)
           (js-ts-mode . lsp)
           (lsp-mode . lsp-headerline-breadcrumb-mode)
           (lsp-headerline-breadcrumb-mode . batunii/lsp-modeline-setup))
    :init
    (setq lsp-keymap-prefix "C-c l")
    :custom
    (read-process-output-max (* 1024 1024))
    :config
    (lsp-enable-which-key-integration)
   (setq lsp-diagnostic-level :error) 
    ;; Breadcrumb configuration
    (setq lsp-headerline-breadcrumb-enable t
          lsp-headerline-breadcrumb-segments '(symbols))
    
    ;; Signature and documentation settings
    (setq lsp-signature-auto-activate t
          lsp-signature-render-documentation nil
          lsp-eldoc-enable-signature-help t
          eldoc-idle-delay 0.1
          eldoc-echo-area-use-multiline-p t
          max-mini-window-height 0.5)
    
    ;; Clean up mode-line
    (setq lsp-modeline-code-actions-enable nil
          lsp-modeline-diagnostics-enable nil
          lsp-modeline-workspace-status-enable nil)

  )

  ;; Move breadcrumbs to mode-line
  (defun batunii/lsp-modeline-setup ()
    "Move LSP breadcrumbs to mode-line after buffer name."
    (setq-local header-line-format nil)
    (setq-local mode-line-format
                (list
                 ;; Left side
                 "%e"
                 mode-line-front-space
                 mode-line-mule-info
                 mode-line-client
                 mode-line-modified
                 mode-line-remote
                 mode-line-frame-identification
                 mode-line-buffer-identification
                 " "
                 ;; LSP Breadcrumbs
                 '(:eval (when lsp-headerline-breadcrumb-mode
                           (lsp-headerline--build-string)))
                 " "
                 ;; Right side
                 mode-line-position
                 (vc-mode vc-mode)
                 " "
                 mode-line-modes
                 mode-line-misc-info
                 mode-line-end-spaces)))

  ;; Show docs in minibuffer
  (defun batunii/lsp-show-doc ()
    "Show LSP documentation in minibuffer."
    (interactive)
    (if (lsp-feature? "textDocument/hover")
        (let* ((hover-info (lsp-request "textDocument/hover" (lsp--text-document-position-params)))
               (contents (when hover-info (gethash "contents" hover-info)))
               (doc (when contents
                      (if (stringp contents)
                          contents
                        (lsp--render-element contents)))))
          (if doc
              (message "%s" doc)
            (message "No documentation available")))
      (message "LSP hover not supported")))

(use-package flymake
  :ensure nil
  :diminish flymake-mode
  :hook (prog-mode . flymake-mode))

(defun batunii/show-error-at-point ()
  "Display Flymake diagnostic at cursor."
  (interactive)
  (let* ((diags (flymake-diagnostics (point)))
         (msg   (mapconcat #'flymake-diagnostic-text diags " | ")))
    (if (string-empty-p msg)
        (message "No diagnostic at point.")
      (message "%s" msg))))

(use-package hydra
  :ensure t)

(use-package treemacs
  :ensure t)

  (use-package lsp-treemacs
  :ensure t
  :after lsp
  :config
  (lsp-treemacs-sync-mode 1))

(use-package vertico 
  :ensure t 
  :init (vertico-mode))

(use-package orderless
  :ensure t
  :init
  (setq completion-styles '(orderless basic)))

(use-package company
  :ensure t
  :hook (prog-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection)
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :custom
  (company-minimum-prefix-length 2)
  (company-idle-delay 0.2)
  (company-selection-wrap-around t)
  (company-tooltip-align-annotations t)
  (company-require-match nil)
  (company-backends '(company-capf)))

;; Hide additional minor modes from mode-line
  (use-package diminish
    :ensure t
    :config
(diminish 'eldoc-mode)
(diminish 'visual-line-mode))

(use-package wdired
  :ensure nil
  :after dired
  :config
  (setq wdired-allow-to-change-permissions t))

(use-package drag-stuff
  :ensure t
  :after evil
  :hook (prog-mode . drag-stuff-mode)
  :config
  (global-set-key (kbd "C-<up>") 'drag-stuff-up)
  (global-set-key (kbd "C-<down>") 'drag-stuff-down))

(use-package transient
  :ensure t)

(use-package magit
  :ensure t
  :commands magit-status)

(defun batunii/load-file()
    "Load a file."
  (interactive)
  (load-file "~/.config/emacs/config.el"))

(defun batunii/reload-config()
  "Reload the config."
  (interactive)
  (org-babel-tangle "~/.config/emacs/config.org")
  (load-file "~/.config/emacs/config.el"))

;; Enable native compilation if available
(when (and (fboundp 'native-comp-available-p)
           (native-comp-available-p))
  (setq native-comp-async-report-warnings-errors nil  ; Silence warnings
        native-comp-deferred-compilation t))  ; Compile packages in background

(use-package tldr
  :ensure t)

(use-package glsl-mode
  :ensure t)
(with-eval-after-load 'lsp-mode
;; Disable the old GLSL server completely
(setq lsp-disabled-clients '(glslls))

;; Register glsl_analyzer explicitly
(lsp-register-client
 (make-lsp-client
  :new-connection
  (lsp-stdio-connection
   '("/usr/local/bin/glsl_analyzer"))
  :activation-fn (lsp-activate-on "glsl")
  :server-id 'glsl-analyzer)))

(add-to-list 'display-buffer-alist
             '("\\*compilation\\*"
               (display-buffer-at-bottom)
               (window-height . 0.3)))
(defun batunii/select-compilation-window (_proc)
  "Select the compilation window after it is displayed."
  (when-let ((win (get-buffer-window "*compilation*" t)))
    (select-window win)))

(add-hook 'compilation-start-hook #'batunii/select-compilation-window)
