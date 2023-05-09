%% gd-llncs.cls 
%% Author:     Michael Hoffmann <hoffmann@inf.ethz.ch>
%% wrapper llncs.cls to obtain a more consistent line numbering
%% we patch/hack some relevant commands and environments and see what happens...

\NeedsTeXFormat{LaTeX2e}[2015/01/01]
\ProvidesClass{gd-llncs}[2020/05/12 v0.1 Adapt llncs class so that lineno counts and numbers relevant lines]

%% prefix output by classname
\newcommand{\gdtypeout}[1]{\typeout{gd-llncs: #1}}%

%% process options
\RequirePackage{ifthen}
\RequirePackage{letltxmacro}

%% with notab, do not wrap tabular into edtable
\newboolean{gdnotab}\setboolean{gdnotab}{false}
\DeclareOption{notab}{\setboolean{gdnotab}{true}}
%% with nolines, run llncs plain
\newboolean{gdnolines}\setboolean{gdnolines}{false}
\DeclareOption{nolineno}{\setboolean{gdnolines}{true}}
%% pass all the rest to llncs
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{llncs}}
\ProcessOptions\relax

%% load llncs class
\LoadClass{llncs}[2018/03/10]%

\ifthenelse{\boolean{gdnolines}}{%
  \gdtypeout{option gdnoline -> no line numbers}%
  \newcounter{gdlastlinecounter}%
  \newcommand{\gdnl}{}%
  \nolinenumbers%
  \endinput
}{%
  \gdtypeout{add line numbers}%
}

\RequirePackage{caption}
\RequirePackage[left,mathlines,longtable]{lineno}
\RequirePackage{amsmath}
\RequirePackage{etoolbox}

%% Patch 'normal' math environments:
\newcommand*\linenomathpatch[1]{%
	\cspreto{#1}{\linenomath}%
	\cspreto{#1*}{\linenomath}%
	\csappto{end#1}{\endlinenomath}%
	\csappto{end#1*}{\endlinenomath}%
}
%% Patch AMS math environments:
\newcommand*\linenomathpatchAMS[1]{%
	\cspreto{#1}{\linenomathAMS}%
	\cspreto{#1*}{\linenomathAMS}%
	\csappto{end#1}{\endlinenomath}%
	\csappto{end#1*}{\endlinenomath}%
}

%% Definition of \linenomathAMS depends on whether the mathlines option is provided
\expandafter\ifx\linenomath\linenomathWithnumbers
\let\linenomathAMS\linenomathWithnumbers
%% The following line gets rid of an extra line numbers at the bottom:
\patchcmd\linenomathAMS{\advance\postdisplaypenalty\linenopenalty}{}{}{}
\else
\let\linenomathAMS\linenomathNonumbers
\fi

\linenomathpatch{equation}
\linenomathpatchAMS{gather}
\linenomathpatchAMS{multline}
\linenomathpatchAMS{align}
\linenomathpatchAMS{alignat}
\linenomathpatchAMS{flalign}

%% put proof end symbols
\let\oldendproof\endproof
\renewcommand\endproof{~\hfill$\qed$\oldendproof}


%% give line numbers to captions
\captionsetup{style=base}
\DeclareCaptionFormat{myformat}{\internallinenumbers{\bfseries #1#2}#3}
\captionsetup{format=myformat,labelsep=period}

% Do not number subfigures' captions
\captionsetup{compatibility=false}
\captionsetup[subfigure]{format=hang}

%% \gdnl = number line: allows to manually add the current linenumber to a
%% single line if placed at the start of that line
\newsavebox{\gdnlbox}%
\newcommand{\gdnl}{%
 \sbox{\gdnlbox}{\mbox{\linenumberfont\LineNumber\hskip\linenumbersep}}%
 \hspace*{-\wd\gdnlbox}\usebox{\gdnlbox}\stepcounter{linenumber}%
}

% %% number footnotes by wrapping them into a minipage
\let\gdfootnote=\footnote
\newcommand{\gdnumberfootnotes}{%
 \gdef\footnote##1{%
   \gdfootnote{%
     \begin{minipage}[t]{.978\linewidth}\internallinenumbers\setlength\linenumbersep{2em}
       ##1
     \end{minipage}\vspace{1pt plus .5pt minus .5pt}%
   }%
 }%
}

%% don't number frontmatter 
\let\gdrealmaketitle=\maketitle
\renewcommand{\maketitle}{\nolinenumbers\gdrealmaketitle\linenumbers}
\let\gdabstract=\abstract
\let\gdendabstract=\endabstract
\newcounter{gdlastlinecounter}
\renewenvironment{abstract}{%
  \gdabstract%
}{%
  \begin{nolinenumbers}
    \gdendabstract\noindent
  \end{nolinenumbers}%
  \gdnumberfootnotes%
}
%% to list the lines, look where the references start
\RequirePackage[absolute]{textpos}
\RequirePackage{color}
\AtBeginDocument{%
  \let\gdthebibliography=\thebibliography
  \renewcommand{\thebibliography}{%
    \setcounter{gdlastlinecounter}{\value{linenumber}}%
    \addtocounter{gdlastlinecounter}{-1}%
    \makeatletter\write\@auxout{\noexpand\setcounter{gdlastlinecounter}{\thegdlastlinecounter}}\makeatother%
    \gdthebibliography}%
  \begin{textblock*}{.75\textwidth}(\oddsidemargin,5em)
    {\ifnum\value{gdlastlinecounter}>400\color{red}\fi{\bfseries Lines:\enskip}\arabic{gdlastlinecounter}\hfill}
  \end{textblock*}}

%% wrap tabular into edtable
\ifthenelse{\boolean{gdnotab}}{%
}{%
  \gdtypeout{fix tabular}
  \let\gdtabular\tabular%
  \let\endgdtabular\endtabular%
  \renewenvironment{tabular}{\begin{edtable}{gdtabular}}{\end{edtable}}%
}

\endinput

% Local Variables:
% mode: latex
% End: