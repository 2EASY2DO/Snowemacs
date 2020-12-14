;; Deactivate startup message
(setq inhibit-startup-message t)

;; Change in UI to make it cleaner
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

(menu-bar-mode -1)
;; Activate visible-bell
(setq visible-bell t)

(set-face-attribute 'default nil :font "Fira Code Retina" :height 150)

(load-theme 'tango-dark)
;; Global keybinds
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-M-j") 'counsel-switch-buffer)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			("org" . "https://orgmode.org/elpa/")
			("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))


(unless (package-installed-p 'use-package)
  (package-install 'use-package))
;; Packages installation and configuration
(require 'use-package)
(setq use-package-always-ensure t)
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))
(use-package swiper)
(use-package counsel
  :diminish
  :bind (("C-s" . swiper))
  :config
  (ivy-mode 1))
;; Code completition
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l"))
(use-package vue-mode
  :mode "\\.vue\\'"
  :hook (vue-mode . lsp-deferred))
(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode))

(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; UI and theming
(use-package doom-modeline
  :ensure t
  :init(doom-modeline-mode 1)
  :custom((doom-modeline-height 10)))
(use-package kaolin-themes
  :config
  (load-theme 'kaolin-aurora t)
  kaolin-treemacs-theme)
