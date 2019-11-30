" Custom javascript highlighting
" TODO(aria): Maybe this should be a colorscheme?

" general lang
hi! def link ariaKey NONE
hi! def Noise ctermfg=Blue
hi! def ariaDecl ctermfg=Cyan
hi! def ariaClass ctermfg=Green
hi! def link StorageClass ariaDecl
hi! def link Type Noise

" js
hi! def link jsNull Special
hi! def link jsUndefined jsOperatorKeyword
hi! def link jsObjectKey ariaKey
hi! def link jsObjectMethodType jsObjectKey
hi! def link jsFuncCall NONE
hi! def link jsClassFuncName jsObjectKey
hi! def link Include ariaDecl
hi! def link jsArrowFunction Noise
hi! def link jsObjectFuncName ariaKey
hi! def link jsSpreadOperator Noise
hi! def link jsRestOperator Noise
hi! def link jsBlockLabel ariaKey
hi! def link jsClassKeyword ariaDecl
hi! def link jsClassExtends ariaDecl
hi! def link jsFuncName ariaClass

" jsx
hi! def link jsxTagName Noise
hi! def link jsxDot jsxTagName
hi! def link jsxComponentName ariaClass
hi! def link jsxAttrib jsObjectKey
hi! def link jsxPunct Noise
hi! def link jsxCloseString jsxPunct
hi! def link jsxEqual Noise
hi! def link jsxSpreadOperator Noise

