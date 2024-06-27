(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(safe-local-variable-values
   '((org-publish-project-alist
      ("SICP-Answers" :base-directory "~/SICP-group" :publishing-directory "~/SICP-group/texpub" :publishing-function org-latex-export-to-pdf :makeindex t))
     (org-publish-project-alist
      ("SICP-Answers" :base-directory "~/SICP-group" :publishing-function org-latex-export-to-pdf :makeindex t))
     (org-publish-project-alist quote
      (("SICP-Answers" :base-directory "~/SICP-group" :publishing-function org-latex-export-to-pdf :makeindex t)))
     (org-publish-project-alist quote
      (("SICP-Answers" :base-directory "~/SICP-group" :publishing-function ox-latex-export :makeindex t)))
     (org-update-heading-mod-times . t)
     (org-use-property-inheritance . t)
     (org-use-property-inheritance "header-args")
     (org-use-property-inheritance "results" "cache" "noweb" "noweb-ref" "exports" "tangle"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'narrow-to-region 'disabled nil)
