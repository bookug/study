#lang racket/gui
;;;; RacketNote --- a notepad based on racket
;;;; Author: leesper

;;; definition of the RacketNoteGui

(define app-name " RacketNote")
(define version " v0.0.9")
(define app-label (string-append "*Untitled" app-name version))
(define window-width 600)
(define window-height 400)

(define editor (new text%))

(define racket-note-gui%
  (class frame%    
    
    (define/public (clear-all)
      (send editor select-all)
      (send editor clear)
      (send editor set-filename #f)
      (send this refresh))
    
    (define/augment (can-close?)
      (ask-for-save? editor))
    
    (define/public (ask-for-save? editor)
      (if (send editor is-modified?)
          (let ([res (message-box/custom "Save File" "Do you want to save this file ?"
                                         "Yes" "No" "Cancel")])
            (cond
              [(= res 1) (send editor save-file
                               (send editor get-filename))]
              [(= res 2) #t]
              [else #f]))
          #t))
      
    
    (super-new (label app-label)
               (width window-width)
               (height window-height))))

(define note-gui (new racket-note-gui%))

;;; set up the editor on canvas
(define canvas (new editor-canvas%
                    (parent note-gui)))
(send canvas set-editor editor)

;;; menu system
(define menu-bar (new menu-bar%
                      (parent note-gui)))

;;; the file menu items
(define file-menu (new menu%
                       (label "&File")
                       (parent menu-bar)))


(new menu-item%
     (label "&New")
     (parent file-menu)
     (callback (lambda (item event)
                 (when (send note-gui ask-for-save? editor)
                   (send note-gui clear-all)
                   (send editor set-filename #f)
                   (send note-gui set-label
                         (string-append "*Untitled"
                                        app-name
                                        version))))))

(new menu-item%
     (label "&Open")
     (parent file-menu)
     (callback (lambda (item event)
                 (when (send note-gui ask-for-save? editor)
                   (let ([path (send editor get-file #f)])
                     (cond
                       [(path-string? path)
                        (send editor load-file path 'text)
                        (send editor set-filename path)
                        (send note-gui set-label
                              (string-append
                               (path->string (file-name-from-path path))
                               app-name version))
                        (send note-gui refresh)]
                       [else #t]))))))

(new menu-item%
     (label "&Save")
     (parent file-menu)
     (callback (lambda (item event)
                 (send editor save-file
                       (send editor get-filename) 'text)
                 (send note-gui set-label
                       (string-append (path->string (file-name-from-path (send editor get-filename)))
                                      app-name
                                      version))
                 (send note-gui refresh))))

(new separator-menu-item%
     (parent file-menu))
    
(new menu-item%
     (label "&Quit")
     (parent file-menu)
     (callback (lambda (item event)
                 (send note-gui on-exit))))

;;; edit menu and font menu items set using default supporting by Racket
(define edit-menu (new menu%
                       (label "&Edit")
                       (parent menu-bar)))

(define font-menu (new menu%
                       (label "&Font")
                       (parent menu-bar)))

(append-editor-operation-menu-items edit-menu #f)
(append-editor-font-menu-items font-menu)

;;; help menu items
(define help-menu (new menu%
                       (label "&Help")
                       (parent menu-bar)))

(new menu-item%
     (label "&About")
     (parent help-menu)
     (callback (lambda (item event)
                  (message-box "About RacketNote"
                               "RacketNote: A Simple Text Editor\n Author: Leesper"
                               note-gui '(ok caution)))))

(send note-gui show #t)

