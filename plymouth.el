;;; plymouth.el --- Edicion de plymouth script
;;
;; Filename: plymouth.el
;; Description: Resaltado de elementos que comforman plymouth script.
;; Author: Miguel Gordian (zoek)
;; Created: sáb jul 14 05:05:27 2012 (-0500)
;; Version: 0.1
;; Status: Develop
;; Last-Updated:
;;           By:
;;     Update #: 0
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;; Resaltado de elementos sencillos que conforman plymouth script,
;; como son palabras reservardas, cadenas, y algunas constantes.
;; Se agrega algunas funcinalidad para editar el codigo como comentar
;; una region seleccionada.
;; De momento es la primera etapa.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:


;; -*- emacs-lisp-mode -*-

(require 'ido)

;; Definicion del grupo plymouth
(defgroup plymouth
  nil
  "Grupo de personalizacion para el modo plymouth en emacs")

(defcustom plymouth nil
  "Modo para editar archivos con extension script de plymouth"
  :group 'languages)

;; Elementos a personalizar
(defcustom plymouth-indent-tab nil
  "Activar tabulador"
  :group 'plymouth :type 'boolean)

(defcustom plymouth-tab-width 4
  "Establece el tamaño del tabulador a 4 caracteres"
  :group 'plymouth :type 'integer)

(defcustom plymouth-hooks nil
  "hook a ser llamados por 'plymouthscript-mode"
  :group 'plymouth :type 'hook)

(defvar plymouth-keymap (make-keymap)
  "Crea el mapa de edición de keymap")

(defvar plymouth-keyword
  '("if" "else" "while" "for" "fun" "return")
  "Plymouth script palabras reservadas")

(defvar plymouth-const
  '("NULL")
  "Plymouth script constantes")

(defvar plymouth-keyword-regexp (regexp-opt plymouth-keyword 'words))


(defvar  plymouth-const-regexp (regexp-opt  plymouth-const 'words) )


(setq plymouth-font-lock-keywords
  `(
    (,plymouth-const-regexp . font-lock-constant-face)
    (,plymouth-keyword-regexp . font-lock-keyword-face)
))

;; comentarios

(defvar plymouth-syntax-table nil "Syntax table dor 'plymouth-mode.")
(setq plymouth-syntax-table
      (let ((synTable (make-syntax-table)))
	(modify-syntax-entry ?# "< b" synTable)
	(modify-syntax-entry ?\n "> b" synTable)
	(modify-syntax-entry ?* ". 23" synTable)
	(modify-syntax-entry ?\/ ". 14" synTable)
      synTable))

(defun plymouth-comment-dwin (arg)
  "Recive un area y la encasilla a travez de los simbolos definidos de
comentarios."
  (interactive "*P")
  (require 'newcomment)
  (let ((comment-start "#") (comment-end ""))
    (comment-dwim arg)))

;; Imenu

;; (easy-menu-define plymouth-mode-menu plymouth-keymap
;;   "Menu de plymouth"
;;   '("Plymouth"
;; 	["Insertar comentario" plymouth-comment-dwim]
;; 	))

;; Menu

(define-key-after
  plymouth-keymap
  [menu-bar plymouth-menu]
  (cons "Plymouth" (make-sparse-keymap "plymouth"))
  'tools)

(define-key
  plymouth-keymap
  [menu-bar plymouth-menu comment]
  '("Comentar region" . plymouth-comment-dwin))


(set (make-local-variable 'tab-width) plymouth-tab-width)
(setq indent-tabs-mode plymouth-indent-tab)


(define-derived-mode plymouth-mode  fundamental-mode "ply-script"
"Modo mayor para editar ficheros .script para plymouth"
:syntax-table plymouth-syntax-table

  ;; code for syntax highlighting
  (setq font-lock-defaults '((plymouth-font-lock-keywords)))
  (define-key plymouth-keymap [remap comment-dwin] 'plymouth-comment-dwin)

)


(setq plymouth-keyword nil)
(setq plymouth-const nil)
(setq plymouth-construct nil)
(setq plymouth-comment nil)

(provide 'plymouth-mode)

(add-to-list 'auto-mode-alist '("\\.script$" . plymouth-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; plymouth.el ends here
