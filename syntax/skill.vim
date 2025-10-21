" Vim syntax file
" Language:     SKILL / SKILL ++
" License:      Same as VIM
" Authors:      Yannick Uhlmann <ynk2401@gmail.com>
" URL:          http://github.com/augustunderground/vim-skill
"
" Based on Morten Linderud's (mcfoxax@gmail.com) and Alejandro Gómez's (alejandro@dialelo.com)
" Syntax file for Hy: http://github.com/hylang/vim-hy
" And the basic SKILL syntax file included with vim by Toby Schaffer (jtschaff@eos.ncsu.edu)

if exists("b:current_syntax")
    finish
endif

let b:current_syntax = "skill"


syn keyword skillConstants t nil unbound

" enumerate all the SKILL reserved words/functions

syntax keyword skillConditional caseq cond if then else when unless

syntax keyword skillKeywords begin declare declareN declareSQN declareLambda
            \ defmacro defprop defstruct defun define defUserInitProc defvar
            \ editor lambda last let letseq letrec list procedure prog return

syntax keyword skillRepeat go for forall foreach while

syntax keyword skillFunction abs acos cos add1 addDefstructClass alias
            \ alphalessp alphaNumCmp append1 apply arrayp arrayref asin sin
            \ assoc assq assv atan tan atom bcdp booleanp boundp buildString
            \ callInitProc ceiling changeWorkingDir charToInt clearExitProcs
            \ close compareTime compress concat cons copy copyDefstructDeep
            \ createDir csh defstructp delete deleteDir deleteFile display drain
            \ dtpr edit envobj equal eqv err error errset errsetstring eval
            \ evalstring evenp exists exit exp expandMacro file fileLength
            \ fileSeek fileTell fileTimeModified fixp floatp floor printf
            \ fprintf sprintf lsprintf scanf fscanf funobj funcall gc gensym get
            \ get_pname get_string getc getchar getCurrentTime getd
            \ getDirFiles getFnWriteProtect getRunType getInstallPath getqq getq
            \ gets getShellEnvVar getSkill getSkillPath getSkillVersion
            \ getVarWriteProtect getVersion getWarn getWorkingDir index infile
            \ inportp inScheme inSkill instring integerp intToChar isCallable
            \ isDir isExecutable isFile isFileEncrypted isFileName isLink
            \ isMacro isWritable lconc length lindex lineread readstring listp
            \ listToVector load loadContext loadi loadstring log lowerCase
            \ lowerLeft makeTable makeTempFileName makeVector map mapc mapcar
            \ mapcan mapcon maplist plus difference quotient times max
            \ measureTime member memq memv min minusp mod modf nconc ncons
            \ needNCells negativep neq nequal newline nindex not nth nthcdr
            \ nthelem null numberp numOpenFiles oddp onep otherp outfile
            \ outportp pairp parseString plist plusp portp pprint
            \ prependInstallPath print println procedurep putd putpropq
            \ putpropqq random read readString readTable realp regExitAfter
            \ regExitBefore remainder remdq remd remExitProc remove remprop remq
            \ reverse rexCompile rexExecute rexMagic rexMatchAssocList
            \ rexMatchList rexMatchp rexReplace rexSubstitute rindex round
            \ rplacad schemeTopLevelEnv set setq setSGq setSG setarray setcdr
            \ setcadr setFnWriteProtect setof setplist setShellEnvVar
            \ setSkillPath setVarWriteProtect sh shell simplifyFilename sort
            \ sortcar sqrt srandom sstatus strcat strn strncat strncmp stringp
            \ stringToFunction stringToSymbol stringToTime strlen sub1 subst
            \ substring sxtd symbolp symbolToString symeval symstrp system
            \ tablep tableToList tailp tconc timeToString timeToTm tmToTime
            \ truncate typep unalias upperCase upperRight vector vectorToList
            \ warn write writeTable xCoord xcons yCoord zerop zxtd


" DFII procedural interface routines

" \<   beginning of word
" (\@= followed by '\' but '\' is not included in the match
syntax match skillCustomFunction "\<\%(\w\+\)(\@="

syntax match skillDFIIFunction "\<awv\%(\w\+\)(\@="
syntax match skillDFIIFunction "\<cdf\%(\w\+\)(\@="
syntax match skillDFIIFunction "\<ccp\%(\w\+\)(\@="
syntax match skillDFIIFunction "\<db\%(\w\+\)(\@="
syntax match skillDFIIFunction "\<dd\%(\w\+\)(\@="
syntax match skillDFIIFunction "\<de\%(\w\+\)(\@="
syntax match skillDFIIFunction "\<df\%(\w\+\)(\@="
syntax match skillDFIIFunction "\<dr\%(\w\+\)(\@="
syntax match skillDFIIFunction "\<fam\%(\w\+\)(\@="
syntax match skillDFIIFunction "\<gdm\%(\w\+\)(\@="
syntax match skillDFIIFunction "\<ge\%(\w\+\)(\@="
syntax match skillDFIIFunction "\<hi\%(\w\+\)(\@="
syntax match skillDFIIFunction "\<le\%(\w\+\)(\@="
syntax match skillDFIIFunction "\<pc\%(\w\+\)(\@="
syntax match skillDFIIFunction "\<tc\%(\w\+\)(\@="
syntax match skillDFIIFunction "\<tech\%(\w\+\)(\@="

syntax match skillFunction "\<c\(a\|d\)\{1,4}r(\@="

" strings
syn region skillString				start=+"+ skip=+\\"+ end=+"+

syn keyword skillTodo contained		TODO FIXME XXX
syn keyword skillNote contained		NOTE IMPORTANT

" comments are either C-style or begin with a semicolon
syn region skillComment				start="/\*" end="\*/" contains=skillTodo,skillNote
syn match skillComment				";.*" contains=skillTodo,skillNote
syn match skillCommentError			"\*/"

syntax match skillNumber            "\v<[-+]?%(0\o*|0x\x+|[1-9]\d*)N?>"
syntax match skillNumber            "\v<[-+]?%(0|[1-9]\d*|%(0|[1-9]\d*)\.\d*)%(M|[eE][-+]?\d+)?>"
syntax match skillNumber            "\v<[-+]?%(0|[1-9]\d*)/%(0|[1-9]\d*)>"

syn match   skillVarArg             "\c@\{1,2}[a-z0-9?!\-_+*.=<>#$]\+\(/[a-z0-9?!\-_+*.=<>#$]\+\)\?"
syn match   skillSymbol             "\c['`]\{1,2}[a-z0-9?!\-_+*.=<>#$]\+\(/[a-z0-9?!\-_+*.=<>#$]\+\)\?"

syntax match skillArrow    "->\(\w\+\)\@="
syntax match skillSquiggle "\~>\(\w\+\)\@="
syntax match skillProperty "\(->\|\~>\)\@<=\(\w\+\)"

syn sync ccomment skillComment minlines=10

" Define the default highlighting.
" Only when an item doesn't have highlighting yet

hi def link skillConstants		Constant
hi def link skillDFIIFunction   Function
hi def link skillQuote          Constant
hi def link skillVarArg         Special
hi def link skillSymbol         Special

hi def link skillArrow          Delimiter
hi def link skillSquiggle       Delimiter
hi def link skillProperty       Identifier

hi def link skillFunction		Function
hi def link skillCustomFunction	String
hi def link skillKeywords		Define
hi def link skillConditional	Conditional
hi def link skillRepeat			Repeat
hi def link skillString			String
hi def link skillNumber			Number
hi def link skillTodo			Todo
hi def link skillNote			Todo
hi def link skillComment		Comment
hi def link skillCommentError	Error

let b:current_syntax = "skill"
