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
(load-theme 'tango-dark)

(setq doom-modeline--battery-status t)
(display-battery-mode t) 


;; Global keybinds
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(global-set-key (kbd "C-M-j") 'counsel-switch-buffer)

(set-face-attribute 'default nil :font "Fira Code Retina" :height 150)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (python . t)))

(defun efs/org-babel-tangle-config ()
  (when (string-equal (buffer-file-name)
                      (expand-file-name "~/.emacs.d/Emacs.org"))
   (let ((org-confirm-babel-evaluate nil))
     (org-babel-tangle))))
(add-hook 'org-mode-hook (lambda () (add-hook 'after-save-hook #'efs/org-babel-tangle-config)))

(global-set-key (kbd "C-x C-h") 'split-window-horizontally)
(global-set-key (kbd "C-x C-v") 'split-window-vertically)
(global-set-key (kbd "C-x C-q") 'delete-window)

(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-b") 'counsel-switch-buffer)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			("org" . "https://orgmode.org/elpa/")
			("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(defun efs/run-in-background (command)
  (let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))

(defun efs/update-diplays ()
  (efs/run-in-background "autorandr --change --force")
  (message "Display config: %s"
	   (string-trim (shell-command-to-string "autorandr --current"))))

(defun dw/org-mode-setup
  (org-indent-mode)
  (variable-pitch-mode 1)
  (auto-fill-mode 0)
  (visual-line-mode 0)
  (setq evil-auto-indent nil))
(defun efs/exwm-update-class()
  (exwm-workspace-rename-buffer exwm-class-name))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

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

(use-package org
  :config
  (setq org-ellipsis " ᐁ"))
(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("⦾" "●" "●" "●" "●")))
(setq org-confirm-babel-evaluate nil)
(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src shell"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))



(use-package swiper)
(use-package counsel
  :diminish
  :bind (("C-s" . swiper))
  :config
  (ivy-mode 1))

(use-package doom-modeline
  :ensure t
  :init(doom-modeline-mode 1)
  :custom((doom-modeline-height 10)))
(use-package kaolin-themes
  :config
  (load-theme 'kaolin-aurora t))

(use-package exwm
  :config
  (setq exwm-workspace-number 5))
  (setq exwm-input-prefix-keys ;; Keys i want to use inside any window
      '(?\C-x
        ?\C-u
	?\C-h
	?\M-x))
  (setq exwm-input-global-keys
      '(
       ([s-left] . windmove-left)
       ([s-right] . windmove-right)
       ([s-up] . windmove-up )
       ([s-down] . windmove-down)
       ([?\s-w] . exwm-workspace-switch)))
(require 'exwm-randr)
					;(start-process-shell-command "xrandr" nil "xrandr --output eDP --mode 1920x1080 --pos 1920x0 --rotate normal --output HDMI-A-0 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output DisplayPort-0 --off")))
(setq exwm-randr-workspace-output-plist '(0 "eDP" 1 "HDMI-A-0"))
 (add-hook 'exwm-randr-change-hook
  	   #'efs/update-displays) 
(exwm-enable)
(exwm-randr-enable)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(org-bullets exwm vue-mode use-package rainbow-delimiters magit lsp-mode kaolin-themes doom-modeline counsel company)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
