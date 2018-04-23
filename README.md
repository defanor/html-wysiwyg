# html-wysiwyg-mode

This is a minor mode for HTML editing, which can be used with
`html-mode`:

```elisp
(require 'html-wysiwyg)
(add-hook 'html-mode-hook 'html-wysiwyg-mode)
```

It hides links and allows to edit them via minibuffer, similarly to
`org-mode`.

![An example](https://defanor.uberspace.net/pictures/html-wysiwyg.png)

It parses HTML with regexps, font lock's multiline handling is
imperfect, and generally it is just a quick hack. But still better
than reading through all the URIs.
