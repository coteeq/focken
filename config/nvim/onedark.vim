" vim:fdm=marker
" vim color file
" name:       onedark.vim
" maintainer: https://github.com/joshdick/onedark.vim/
" license:    the mit license (mit)
" based on:   https://github.com/maxst/flatcolor/

" a companion [vim-airline](https://github.com/bling/vim-airline) theme is available at: https://github.com/joshdick/airline-onedark.vim

" color reference 

" the following colors were measured inside atom using its built-in inspector.

" +---------------------------------------------+
" |  color name  |         rgb        |   hex   |
" |--------------+--------------------+---------|
" | black        | rgb(40, 44, 52)    | #282c34 |
" |--------------+--------------------+---------|
" | white        | rgb(171, 178, 191) | #abb2bf |
" |--------------+--------------------+---------|
" | light red    | rgb(224, 108, 117) | #e06c75 |
" |--------------+--------------------+---------|
" | dark red     | rgb(190, 80, 70)   | #be5046 |
" |--------------+--------------------+---------|
" | green        | rgb(152, 195, 121) | #98c379 |
" |--------------+--------------------+---------|
" | light yellow | rgb(229, 192, 123) | #e5c07b |
" |--------------+--------------------+---------|
" | dark yellow  | rgb(209, 154, 102) | #d19a66 |
" |--------------+--------------------+---------|
" | blue         | rgb(97, 175, 239)  | #61afef |
" |--------------+--------------------+---------|
" | magenta      | rgb(198, 120, 221) | #c678dd |
" |--------------+--------------------+---------|
" | cyan         | rgb(86, 182, 194)  | #56b6c2 |
" |--------------+--------------------+---------|
" | gutter grey  | rgb(76, 82, 99)    | #4b5263 |
" |--------------+--------------------+---------|
" | comment grey | rgb(92, 99, 112)   | #5c6370 |
" +---------------------------------------------+

" 

" initialization 

let s:overrides = get(g:, "onedark_color_overrides", {})

let s:colors = {
      \ "red": get(s:overrides, "red", { "gui": "#E06C75", "cterm": "204", "cterm16": "1" }),
      \ "dark_red": get(s:overrides, "dark_red", { "gui": "#BE5046", "cterm": "196", "cterm16": "9" }),
      \ "green": get(s:overrides, "green", { "gui": "#98C379", "cterm": "114", "cterm16": "2" }),
      \ "yellow": get(s:overrides, "yellow", { "gui": "#E5C07B", "cterm": "180", "cterm16": "3" }),
      \ "dark_yellow": get(s:overrides, "dark_yellow", { "gui": "#D19A66", "cterm": "173", "cterm16": "11" }),
      \ "blue": get(s:overrides, "blue", { "gui": "#61AFEF", "cterm": "39", "cterm16": "4" }),
      \ "purple": get(s:overrides, "purple", { "gui": "#C678DD", "cterm": "170", "cterm16": "5" }),
      \ "cyan": get(s:overrides, "cyan", { "gui": "#56B6C2", "cterm": "38", "cterm16": "6" }),
      \ "white": get(s:overrides, "white", { "gui": "#ABB2BF", "cterm": "145", "cterm16": "7" }),
      \ "black": get(s:overrides, "black", { "gui": "#282C34", "cterm": "235", "cterm16": "0" }),
      \ "visual_black": get(s:overrides, "visual_black", { "gui": "NONE", "cterm": "NONE", "cterm16": "0" }),
      \ "comment_grey": get(s:overrides, "comment_grey", { "gui": "#5C6370", "cterm": "59", "cterm16": "15" }),
      \ "gutter_fg_grey": get(s:overrides, "gutter_fg_grey", { "gui": "#4B5263", "cterm": "238", "cterm16": "15" }),
      \ "cursor_grey": get(s:overrides, "cursor_grey", { "gui": "#2C323C", "cterm": "236", "cterm16": "8" }),
      \ "visual_grey": get(s:overrides, "visual_grey", { "gui": "#3E4452", "cterm": "237", "cterm16": "15" }),
      \ "menu_grey": get(s:overrides, "menu_grey", { "gui": "#3E4452", "cterm": "237", "cterm16": "8" }),
      \ "special_grey": get(s:overrides, "special_grey", { "gui": "#3B4048", "cterm": "238", "cterm16": "15" }),
      \ "vertsplit": get(s:overrides, "vertsplit", { "gui": "#181A1F", "cterm": "59", "cterm16": "15" }),
      \}

function! onedark#getcolors()
  return s:colors
endfunction


highlight clear

if exists("syntax_on")
  syntax reset
endif

set t_co=256

let g:colors_name="onedark"

" set to "256" for 256-color terminals, or
" set to "16" to use your terminal emulator's native colors
" (a 16-color palette for this color scheme is available; see
" < https://github.com/joshdick/onedark.vim/blob/master/readme.md >
" for more information.)
if !exists("g:onedark_termcolors")
  let g:onedark_termcolors = 256
endif

" not all terminals support italics properly. if yours does, opt-in.
if !exists("g:onedark_terminal_italics")
  let g:onedark_terminal_italics = 0
endif

" this function is based on one from flatcolor: https://github.com/maxst/flatcolor/
" which in turn was based on one found in hemisu: https://github.com/noahfrederick/vim-hemisu/
let s:group_colors = {} " cache of default highlight group settings, for later reference via `onedark#extend_highlight`
function! s:h(group, style, ...)
  if (a:0 > 0) " will be true if we got here from onedark#extend_highlight
    let a:highlight = s:group_colors[a:group]
    for style_type in ["fg", "bg", "sp"]
      if (has_key(a:style, style_type))
        let l:default_style = (has_key(a:highlight, style_type) ? a:highlight[style_type] : { "cterm16": "none", "cterm": "none", "gui": "none" })
        let a:highlight[style_type] = extend(l:default_style, a:style[style_type])
      endif
    endfor
    if (has_key(a:style, "gui"))
      let a:highlight.gui = a:style.gui
    endif
  else
    let a:highlight = a:style
    let s:group_colors[a:group] = a:highlight " cache default highlight group settings
  endif

  if g:onedark_terminal_italics == 0
    if has_key(a:highlight, "cterm") && a:highlight["cterm"] == "italic"
      unlet a:highlight.cterm
    endif
    if has_key(a:highlight, "gui") && a:highlight["gui"] == "italic"
      unlet a:highlight.gui
    endif
  endif

  if g:onedark_termcolors == 16
    let l:ctermfg = (has_key(a:highlight, "fg") ? a:highlight.fg.cterm16 : "none")
    let l:ctermbg = (has_key(a:highlight, "bg") ? a:highlight.bg.cterm16 : "none")
  else
    let l:ctermfg = (has_key(a:highlight, "fg") ? a:highlight.fg.cterm : "none")
    let l:ctermbg = (has_key(a:highlight, "bg") ? a:highlight.bg.cterm : "none")
  endif

  execute "highlight" a:group
    \ "guifg="   (has_key(a:highlight, "fg")    ? a:highlight.fg.gui   : "none")
    \ "guibg="   (has_key(a:highlight, "bg")    ? a:highlight.bg.gui   : "none")
    \ "guisp="   (has_key(a:highlight, "sp")    ? a:highlight.sp.gui   : "none")
    \ "gui="     (has_key(a:highlight, "gui")   ? a:highlight.gui      : "none")
    \ "ctermfg=" . l:ctermfg
    \ "ctermbg=" . l:ctermbg
    \ "cterm="   (has_key(a:highlight, "cterm") ? a:highlight.cterm    : "none")
endfunction

" public 

function! onedark#set_highlight(group, style)
  call s:h(a:group, a:style)
endfunction

function! onedark#extend_highlight(group, style)
  call s:h(a:group, a:style, 1)
endfunction

" 

" 

" color variables 

let s:colors = onedark#getcolors()

let s:red = s:colors.red
let s:dark_red = s:colors.dark_red
let s:green = s:colors.green
let s:yellow = s:colors.yellow
let s:dark_yellow = s:colors.dark_yellow
let s:blue = s:colors.blue
let s:purple = s:colors.purple
let s:cyan = s:colors.cyan
let s:white = s:colors.white
let s:black = s:colors.black
let s:visual_black = s:colors.visual_black " black out selected text in 16-color visual mode
let s:comment_grey = s:colors.red
let s:gutter_fg_grey = s:colors.gutter_fg_grey
let s:cursor_grey = s:colors.cursor_grey
let s:visual_grey = s:colors.visual_grey
let s:menu_grey = s:colors.menu_grey
let s:special_grey = s:colors.special_grey
let s:vertsplit = s:colors.vertsplit

" 

" syntax groups (descriptions and ordering from `:h w18`) 

call s:h("comment", { "fg": s:comment_grey, "gui": "italic", "cterm": "italic" }) " any comment
call s:h("constant", { "fg": s:cyan }) " any constant
call s:h("string", { "fg": s:green }) " a string constant: "this is a string"
call s:h("character", { "fg": s:green }) " a character constant: 'c', '\n'
call s:h("number", { "fg": s:dark_yellow }) " a number constant: 234, 0xff
call s:h("boolean", { "fg": s:dark_yellow }) " a boolean constant: true, false
call s:h("float", { "fg": s:dark_yellow }) " a floating point constant: 2.3e10
call s:h("identifier", { "fg": s:red }) " any variable name
call s:h("function", { "fg": s:blue }) " function name (also: methods for classes)
call s:h("statement", { "fg": s:purple }) " any statement
call s:h("conditional", { "fg": s:purple }) " if, then, else, endif, switch, etc.
call s:h("repeat", { "fg": s:purple }) " for, do, while, etc.
call s:h("label", { "fg": s:purple }) " case, default, etc.
call s:h("operator", { "fg": s:purple }) " sizeof", "+", "*", etc.
call s:h("keyword", { "fg": s:red }) " any other keyword
call s:h("exception", { "fg": s:purple }) " try, catch, throw
call s:h("preproc", { "fg": s:yellow }) " generic preprocessor
call s:h("include", { "fg": s:blue }) " preprocessor #include
call s:h("define", { "fg": s:purple }) " preprocessor #define
call s:h("macro", { "fg": s:purple }) " same as define
call s:h("precondit", { "fg": s:yellow }) " preprocessor #if, #else, #endif, etc.
call s:h("type", { "fg": s:yellow }) " int, long, char, etc.
call s:h("storageclass", { "fg": s:yellow }) " static, register, volatile, etc.
call s:h("structure", { "fg": s:yellow }) " struct, union, enum, etc.
call s:h("typedef", { "fg": s:yellow }) " a typedef
call s:h("special", { "fg": s:blue }) " any special symbol
call s:h("specialchar", {}) " special character in a constant
call s:h("tag", {}) " you can use ctrl-] on this
call s:h("delimiter", {}) " character that needs attention
call s:h("specialcomment", { "fg": s:comment_grey }) " special things inside a comment
call s:h("debug", {}) " debugging statements
call s:h("underlined", { "gui": "underline", "cterm": "underline" }) " text that stands out, html links
call s:h("ignore", {}) " left blank, hidden
call s:h("error", { "fg": s:red }) " any erroneous construct
call s:h("todo", { "fg": s:purple }) " anything that needs extra attention; mostly the keywords todo fixme and xxx

" 

" highlighting groups (descriptions and ordering from `:h highlight-groups`) 
"call s:h("colorcolumn", { "bg": s:cursor_grey }) " used for the columns set with 'colorcolumn'
"call s:h("conceal", {}) " placeholder characters substituted for concealed text (see 'conceallevel')
"call s:h("cursor", { "fg": s:black, "bg": s:blue }) " the character under the cursor
"call s:h("cursorim", {}) " like cursor, but used when in ime mode
"call s:h("cursorcolumn", { "bg": s:cursor_grey }) " the screen column that the cursor is in when 'cursorcolumn' is set
if &diff
  " don't change the background color in diff mode
  call s:h("cursorline", { "gui": "underline" }) " the screen line that the cursor is in when 'cursorline' is set
"else
"  call s:h("cursorline", { "bg": s:cursor_grey }) " the screen line that the cursor is in when 'cursorline' is set
endif
call s:h("directory", { "fg": s:blue }) " directory names (and other special names in listings)
"call s:h("diffadd", { "bg": s:green, "fg": s:black }) " diff mode: added line
"call s:h("diffchange", { "bg": s:yellow, "fg": s:black }) " diff mode: changed line
"call s:h("diffdelete", { "bg": s:red, "fg": s:black }) " diff mode: deleted line
"call s:h("difftext", { "bg": s:black, "fg": s:yellow }) " diff mode: changed text within a changed line
call s:h("errormsg", { "fg": s:red }) " error messages on the command line
call s:h("vertsplit", { "fg": s:vertsplit }) " the column separating vertically split windows
call s:h("folded", { "fg": s:comment_grey }) " line used for closed folds
call s:h("foldcolumn", {}) " 'foldcolumn'
call s:h("signcolumn", {}) " column where signs are displayed
call s:h("incsearch", { "fg": s:yellow, "bg": s:comment_grey }) " 'incsearch' highlighting; also used for the text replaced with ":s///c"
call s:h("linenr", { "fg": s:gutter_fg_grey }) " line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
call s:h("cursorlinenr", {}) " like linenr when 'cursorline' or 'relativenumber' is set for the cursor line.
call s:h("matchparen", { "fg": s:blue, "gui": "underline" }) " the character under the cursor or just before it, if it is a paired bracket, and its match.
call s:h("modemsg", {}) " 'showmode' message (e.g., "-- insert --")
call s:h("moremsg", {}) " more-prompt
call s:h("nontext", { "fg": s:special_grey }) " '~' and '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line).
call s:h("normal", { "fg": s:white, "bg": s:black }) " normal text
call s:h("pmenu", { "bg": s:menu_grey }) " popup menu: normal item.
call s:h("pmenusel", { "fg": s:black, "bg": s:blue }) " popup menu: selected item.
call s:h("pmenusbar", { "bg": s:special_grey }) " popup menu: scrollbar.
call s:h("pmenuthumb", { "bg": s:white }) " popup menu: thumb of the scrollbar.
call s:h("question", { "fg": s:purple }) " hit-enter prompt and yes/no questions
call s:h("search", { "fg": s:black, "bg": s:yellow }) " last search pattern highlighting (see 'hlsearch'). also used for similar items that need to stand out.
call s:h("quickfixline", { "fg": s:black, "bg": s:yellow }) " current quickfix item in the quickfix window.
call s:h("specialkey", { "fg": s:special_grey }) " meta and special keys listed with ":map", also for text used to show unprintable characters in the text, 'listchars'. generally: text that is displayed differently from what it really is.
call s:h("spellbad", { "fg": s:red, "gui": "underline", "cterm": "underline" }) " word that is not recognized by the spellchecker. this will be combined with the highlighting used otherwise.
call s:h("spellcap", { "fg": s:dark_yellow }) " word that should start with a capital. this will be combined with the highlighting used otherwise.
call s:h("spelllocal", { "fg": s:dark_yellow }) " word that is recognized by the spellchecker as one that is used in another region. this will be combined with the highlighting used otherwise.
call s:h("spellrare", { "fg": s:dark_yellow }) " word that is recognized by the spellchecker as one that is hardly ever used. spell this will be combined with the highlighting used otherwise.
call s:h("statusline", { "fg": s:white, "bg": s:cursor_grey }) " status line of current window
call s:h("statuslinenc", { "fg": s:comment_grey }) " status lines of not-current windows note: if this is equal to "statusline" vim will use "^^^" in the status line of the current window.
call s:h("tabline", { "fg": s:comment_grey }) " tab pages line, not active tab page label
call s:h("tablinefill", {}) " tab pages line, where there are no labels
call s:h("tablinesel", { "fg": s:white }) " tab pages line, active tab page label
call s:h("title", { "fg": s:green }) " titles for output from ":set all", ":autocmd" etc.
call s:h("visual", { "fg": s:visual_black, "bg": s:visual_grey }) " visual mode selection
call s:h("visualnos", { "bg": s:visual_grey }) " visual mode selection when vim is "not owning the selection". only x11 gui's gui-x11 and xterm-clipboard supports this.
call s:h("warningmsg", { "fg": s:yellow }) " warning messages
call s:h("wildmenu", { "fg": s:black, "bg": s:blue }) " current match in 'wildmenu' completion

" 

" language-Specific Highlighting {{{

" CSS
call s:h("cssAttrComma", { "fg": s:purple })
call s:h("cssAttributeSelector", { "fg": s:green })
call s:h("cssBraces", { "fg": s:white })
call s:h("cssClassName", { "fg": s:dark_yellow })
call s:h("cssClassNameDot", { "fg": s:dark_yellow })
call s:h("cssDefinition", { "fg": s:purple })
call s:h("cssFontAttr", { "fg": s:dark_yellow })
call s:h("cssFontDescriptor", { "fg": s:purple })
call s:h("cssFunctionName", { "fg": s:blue })
call s:h("cssIdentifier", { "fg": s:blue })
call s:h("cssImportant", { "fg": s:purple })
call s:h("cssInclude", { "fg": s:white })
call s:h("cssIncludeKeyword", { "fg": s:purple })
call s:h("cssMediaType", { "fg": s:dark_yellow })
call s:h("cssProp", { "fg": s:white })
call s:h("cssPseudoClassId", { "fg": s:dark_yellow })
call s:h("cssSelectorOp", { "fg": s:purple })
call s:h("cssSelectorOp2", { "fg": s:purple })
call s:h("cssTagName", { "fg": s:red })

" Go
call s:h("goDeclaration", { "fg": s:purple })

" HTML
call s:h("htmlTitle", { "fg": s:white })
call s:h("htmlArg", { "fg": s:dark_yellow })
call s:h("htmlEndTag", { "fg": s:white })
call s:h("htmlH1", { "fg": s:white })
call s:h("htmlLink", { "fg": s:purple })
call s:h("htmlSpecialChar", { "fg": s:dark_yellow })
call s:h("htmlSpecialTagName", { "fg": s:red })
call s:h("htmlTag", { "fg": s:white })
call s:h("htmlTagName", { "fg": s:red })

" JavaScript
call s:h("javaScriptBraces", { "fg": s:white })
call s:h("javaScriptFunction", { "fg": s:purple })
call s:h("javaScriptIdentifier", { "fg": s:purple })
call s:h("javaScriptNull", { "fg": s:dark_yellow })
call s:h("javaScriptNumber", { "fg": s:dark_yellow })
call s:h("javaScriptRequire", { "fg": s:cyan })
call s:h("javaScriptReserved", { "fg": s:purple })
" https://github.com/pangloss/vim-javascript
call s:h("jsArrowFunction", { "fg": s:purple })
call s:h("jsClassKeyword", { "fg": s:purple })
call s:h("jsClassMethodType", { "fg": s:purple })
call s:h("jsDocParam", { "fg": s:blue })
call s:h("jsDocTags", { "fg": s:purple })
call s:h("jsExport", { "fg": s:purple })
call s:h("jsExportDefault", { "fg": s:purple })
call s:h("jsExtendsKeyword", { "fg": s:purple })
call s:h("jsFrom", { "fg": s:purple })
call s:h("jsFuncCall", { "fg": s:blue })
call s:h("jsFunction", { "fg": s:purple })
call s:h("jsGenerator", { "fg": s:yellow })
call s:h("jsGlobalObjects", { "fg": s:yellow })
call s:h("jsImport", { "fg": s:purple })
call s:h("jsModuleAs", { "fg": s:purple })
call s:h("jsModuleWords", { "fg": s:purple })
call s:h("jsModules", { "fg": s:purple })
call s:h("jsNull", { "fg": s:dark_yellow })
call s:h("jsOperator", { "fg": s:purple })
call s:h("jsStorageClass", { "fg": s:purple })
call s:h("jsSuper", { "fg": s:red })
call s:h("jsTemplateBraces", { "fg": s:dark_red })
call s:h("jsTemplateVar", { "fg": s:green })
call s:h("jsThis", { "fg": s:red })
call s:h("jsUndefined", { "fg": s:dark_yellow })
" https://github.com/othree/yajs.vim
call s:h("javascriptArrowFunc", { "fg": s:purple })
call s:h("javascriptClassExtends", { "fg": s:purple })
call s:h("javascriptClassKeyword", { "fg": s:purple })
call s:h("javascriptDocNotation", { "fg": s:purple })
call s:h("javascriptDocParamName", { "fg": s:blue })
call s:h("javascriptDocTags", { "fg": s:purple })
call s:h("javascriptEndColons", { "fg": s:white })
call s:h("javascriptExport", { "fg": s:purple })
call s:h("javascriptFuncArg", { "fg": s:white })
call s:h("javascriptFuncKeyword", { "fg": s:purple })
call s:h("javascriptIdentifier", { "fg": s:red })
call s:h("javascriptImport", { "fg": s:purple })
call s:h("javascriptMethodName", { "fg": s:white })
call s:h("javascriptObjectLabel", { "fg": s:white })
call s:h("javascriptOpSymbol", { "fg": s:cyan })
call s:h("javascriptOpSymbols", { "fg": s:cyan })
call s:h("javascriptPropertyName", { "fg": s:green })
call s:h("javascriptTemplateSB", { "fg": s:dark_red })
call s:h("javascriptVariable", { "fg": s:purple })

" JSON
call s:h("jsonCommentError", { "fg": s:white })
call s:h("jsonKeyword", { "fg": s:red })
call s:h("jsonBoolean", { "fg": s:dark_yellow })
call s:h("jsonNumber", { "fg": s:dark_yellow })
call s:h("jsonQuote", { "fg": s:white })
call s:h("jsonMissingCommaError", { "fg": s:red, "gui": "reverse" })
call s:h("jsonNoQuotesError", { "fg": s:red, "gui": "reverse" })
call s:h("jsonNumError", { "fg": s:red, "gui": "reverse" })
call s:h("jsonString", { "fg": s:green })
call s:h("jsonStringSQError", { "fg": s:red, "gui": "reverse" })
call s:h("jsonSemicolonError", { "fg": s:red, "gui": "reverse" })

" LESS
call s:h("lessVariable", { "fg": s:purple })
call s:h("lessAmpersandChar", { "fg": s:white })
call s:h("lessClass", { "fg": s:dark_yellow })

" Markdown
call s:h("markdownCode", { "fg": s:green })
call s:h("markdownCodeBlock", { "fg": s:green })
call s:h("markdownCodeDelimiter", { "fg": s:green })
call s:h("markdownHeadingDelimiter", { "fg": s:red })
call s:h("markdownRule", { "fg": s:comment_grey })
call s:h("markdownHeadingRule", { "fg": s:comment_grey })
call s:h("markdownH1", { "fg": s:red })
call s:h("markdownH2", { "fg": s:red })
call s:h("markdownH3", { "fg": s:red })
call s:h("markdownH4", { "fg": s:red })
call s:h("markdownH5", { "fg": s:red })
call s:h("markdownH6", { "fg": s:red })
call s:h("markdownIdDelimiter", { "fg": s:purple })
call s:h("markdownId", { "fg": s:purple })
call s:h("markdownBlockquote", { "fg": s:comment_grey })
call s:h("markdownItalic", { "fg": s:purple, "gui": "italic", "cterm": "italic" })
call s:h("markdownBold", { "fg": s:dark_yellow, "gui": "bold", "cterm": "bold" })
call s:h("markdownListMarker", { "fg": s:red })
call s:h("markdownOrderedListMarker", { "fg": s:red })
call s:h("markdownIdDeclaration", { "fg": s:blue })
call s:h("markdownLinkText", { "fg": s:blue })
call s:h("markdownLinkDelimiter", { "fg": s:white })
call s:h("markdownUrl", { "fg": s:purple })

" Perl
call s:h("perlFiledescRead", { "fg": s:green })
call s:h("perlFunction", { "fg": s:purple })
call s:h("perlMatchStartEnd",{ "fg": s:blue })
call s:h("perlMethod", { "fg": s:purple })
call s:h("perlPOD", { "fg": s:comment_grey })
call s:h("perlSharpBang", { "fg": s:comment_grey })
call s:h("perlSpecialString",{ "fg": s:cyan })
call s:h("perlStatementFiledesc", { "fg": s:red })
call s:h("perlStatementFlow",{ "fg": s:red })
call s:h("perlStatementInclude", { "fg": s:purple })
call s:h("perlStatementScalar",{ "fg": s:purple })
call s:h("perlStatementStorage", { "fg": s:purple })
call s:h("perlSubName",{ "fg": s:yellow })
call s:h("perlVarPlain",{ "fg": s:blue })

" PHP
call s:h("phpVarSelector", { "fg": s:red })
call s:h("phpOperator", { "fg": s:white })
call s:h("phpParent", { "fg": s:white })
call s:h("phpMemberSelector", { "fg": s:white })
call s:h("phpType", { "fg": s:purple })
call s:h("phpKeyword", { "fg": s:purple })
call s:h("phpClass", { "fg": s:yellow })
call s:h("phpUseClass", { "fg": s:white })
call s:h("phpUseAlias", { "fg": s:white })
call s:h("phpInclude", { "fg": s:purple })
call s:h("phpClassExtends", { "fg": s:green })
call s:h("phpDocTags", { "fg": s:white })
call s:h("phpFunction", { "fg": s:blue })
call s:h("phpFunctions", { "fg": s:cyan })
call s:h("phpMethodsVar", { "fg": s:dark_yellow })
call s:h("phpMagicConstants", { "fg": s:dark_yellow })
call s:h("phpSuperglobals", { "fg": s:red })
call s:h("phpConstants", { "fg": s:dark_yellow })

" Ruby
call s:h("rubyBlockParameter", { "fg": s:red})
call s:h("rubyBlockParameterList", { "fg": s:red })
call s:h("rubyClass", { "fg": s:purple})
call s:h("rubyConstant", { "fg": s:yellow})
call s:h("rubyControl", { "fg": s:purple })
call s:h("rubyEscape", { "fg": s:red})
call s:h("rubyFunction", { "fg": s:blue})
call s:h("rubyGlobalVariable", { "fg": s:red})
call s:h("rubyInclude", { "fg": s:blue})
call s:h("rubyIncluderubyGlobalVariable", { "fg": s:red})
call s:h("rubyInstanceVariable", { "fg": s:red})
call s:h("rubyInterpolation", { "fg": s:cyan })
call s:h("rubyInterpolationDelimiter", { "fg": s:red })
call s:h("rubyInterpolationDelimiter", { "fg": s:red})
call s:h("rubyRegexp", { "fg": s:cyan})
call s:h("rubyRegexpDelimiter", { "fg": s:cyan})
call s:h("rubyStringDelimiter", { "fg": s:green})
call s:h("rubySymbol", { "fg": s:cyan})

" Sass
" https://github.com/tpope/vim-haml
call s:h("sassAmpersand", { "fg": s:red })
call s:h("sassClass", { "fg": s:dark_yellow })
call s:h("sassControl", { "fg": s:purple })
call s:h("sassExtend", { "fg": s:purple })
call s:h("sassFor", { "fg": s:white })
call s:h("sassFunction", { "fg": s:cyan })
call s:h("sassId", { "fg": s:blue })
call s:h("sassInclude", { "fg": s:purple })
call s:h("sassMedia", { "fg": s:purple })
call s:h("sassMediaOperators", { "fg": s:white })
call s:h("sassMixin", { "fg": s:purple })
call s:h("sassMixinName", { "fg": s:blue })
call s:h("sassMixing", { "fg": s:purple })
call s:h("sassVariable", { "fg": s:purple })
" https://github.com/cakebaker/scss-syntax.vim
call s:h("scssExtend", { "fg": s:purple })
call s:h("scssImport", { "fg": s:purple })
call s:h("scssInclude", { "fg": s:purple })
call s:h("scssMixin", { "fg": s:purple })
call s:h("scssSelectorName", { "fg": s:dark_yellow })
call s:h("scssVariable", { "fg": s:purple })

" TypeScript
call s:h("typescriptReserved", { "fg": s:purple })
call s:h("typescriptEndColons", { "fg": s:white })
call s:h("typescriptBraces", { "fg": s:white })

" XML
call s:h("xmlAttrib", { "fg": s:dark_yellow })
call s:h("xmlEndTag", { "fg": s:red })
call s:h("xmlTag", { "fg": s:red })
call s:h("xmlTagName", { "fg": s:red })

" 

" Plugin Highlighting 

" airblade/vim-gitgutter
hi link GitGutterAdd    SignifySignAdd
hi link GitGutterChange SignifySignChange
hi link GitGutterDelete SignifySignDelete

" easymotion/vim-easymotion
call s:h("EasyMotionTarget", { "fg": s:red, "gui": "bold", "cterm": "bold" })
call s:h("EasyMotionTarget2First", { "fg": s:yellow, "gui": "bold", "cterm": "bold" })
call s:h("EasyMotionTarget2Second", { "fg": s:dark_yellow, "gui": "bold", "cterm": "bold" })
call s:h("EasyMotionShade",  { "fg": s:comment_grey })

" mhinz/vim-signify
call s:h("SignifySignAdd", { "fg": s:green })
call s:h("SignifySignChange", { "fg": s:yellow })
call s:h("SignifySignDelete", { "fg": s:red })

" neomake/neomake
call s:h("NeomakeWarningSign", { "fg": s:yellow })
call s:h("NeomakeErrorSign", { "fg": s:red })
call s:h("NeomakeInfoSign", { "fg": s:blue })

" tpope/vim-fugitive
call s:h("diffAdded", { "fg": s:green })
call s:h("diffRemoved", { "fg": s:red })

" 

" Git Highlighting 

call s:h("gitcommitComment", { "fg": s:comment_grey })
call s:h("gitcommitUnmerged", { "fg": s:green })
call s:h("gitcommitOnBranch", {})
call s:h("gitcommitBranch", { "fg": s:purple })
call s:h("gitcommitDiscardedType", { "fg": s:red })
call s:h("gitcommitSelectedType", { "fg": s:green })
call s:h("gitcommitHeader", {})
call s:h("gitcommitUntrackedFile", { "fg": s:cyan })
call s:h("gitcommitDiscardedFile", { "fg": s:red })
call s:h("gitcommitSelectedFile", { "fg": s:green })
call s:h("gitcommitUnmergedFile", { "fg": s:yellow })
call s:h("gitcommitFile", {})
call s:h("gitcommitSummary", { "fg": s:white })
call s:h("gitcommitOverflow", { "fg": s:red })
hi link gitcommitNoBranch gitcommitBranch
hi link gitcommitUntracked gitcommitComment
hi link gitcommitDiscarded gitcommitComment
hi link gitcommitSelected gitcommitComment
hi link gitcommitDiscardedArrow gitcommitDiscardedFile
hi link gitcommitSelectedArrow gitcommitSelectedFile
hi link gitcommitUnmergedArrow gitcommitUnmergedFile

" 

" Neovim terminal colors 

if has("nvim")
  let g:terminal_color_0 =  s:black.gui
  let g:terminal_color_1 =  s:red.gui
  let g:terminal_color_2 =  s:green.gui
  let g:terminal_color_3 =  s:yellow.gui
  let g:terminal_color_4 =  s:blue.gui
  let g:terminal_color_5 =  s:purple.gui
  let g:terminal_color_6 =  s:cyan.gui
  let g:terminal_color_7 =  s:white.gui
  let g:terminal_color_8 =  s:visual_grey.gui
  let g:terminal_color_9 =  s:dark_red.gui
  let g:terminal_color_10 = s:green.gui " No dark version
  let g:terminal_color_11 = s:dark_yellow.gui
  let g:terminal_color_12 = s:blue.gui " No dark version
  let g:terminal_color_13 = s:purple.gui " No dark version
  let g:terminal_color_14 = s:cyan.gui " No dark version
  let g:terminal_color_15 = s:comment_grey.gui
"  let g:terminal_color_background = g:terminal_color_0
  let g:terminal_color_foreground = g:terminal_color_7
endif

" 

" Must appear at the end of the file to work around this oddity:
" https://groups.google.com/forum/#!msg/vim_dev/afPqwAFNdrU/nqh6tOM87QUJ
set background=dark"}}}
