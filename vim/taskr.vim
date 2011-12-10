" Vim syntax file
" Language:     Taskr
" Maintainer:   Khaja Minhajuddin <minhajuddin@cosmicvent.com>
" Filenames:    *.taskr

if exists("b:current_syntax")
  finish
endif

syn match taskrDay '^\d\{8\}'
syn match taskrTime '.\{8,\}\d\{6\}'
syn match taskrNormalTag ':[a-zA-Z0-9_:-]\+'
syn match taskrDateTag ':\d\{8\}'
syn match taskrPriorityText '[+-]\+'
syn match taskrTask ' [a-zA-Z0-9 ]*'



hi link taskrDay Function
hi link taskrTime PreProc
hi link taskrNormalTag Keyword
hi link taskrDateTag Keyword
hi link taskrPriorityText Identifier
hi link taskrTask String
