%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% recipebook.cls 
% Eric King [2022] -- Originally written
% Eric King [2026] -- Updated image to include FPO statement and
%                     uploaded to repository to share with Lilly
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{recipebook}[]
\LoadClass[11pt,oneside]{book}

% Renew Part command to exclude the "Part IV" text. 
\makeatletter
\renewcommand{\part}{%
  \if@openright\cleardoublepage\else\clearpage\fi
  \thispagestyle{plain}%
  \@afterindentfalse
  \secdef\@part\@spart
}

\makeatletter

\renewcommand{\part}{%
  \if@openright\cleardoublepage\else\clearpage\fi
  \thispagestyle{plain}%
  \@afterindentfalse
  \secdef\@part\@spart
}

\def\@part[#1]#2{%
  \refstepcounter{part}%
  \addcontentsline{toc}{part}{#1}%
  \markboth{}{}%
  \begingroup
    \centering
    \interlinepenalty \@M
    \normalfont
    \vspace*{50mm}%
    {\Huge\bfseries #2\par}%
    \vspace{2\baselineskip}%
  \endgroup
  \clearpage
}

\def\@spart#1{%
  \markboth{}{}%
  \begingroup
    \centering
    \interlinepenalty \@M
    \normalfont
    \vspace*{50mm}%
    {\Huge\bfseries #1\par}%
    \vspace{2\baselineskip}%
  \endgroup
  \clearpage
}

\makeatother

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Core packages
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\RequirePackage{fancyhdr}
\RequirePackage{lastpage}
\RequirePackage{extramarks}

\PassOptionsToPackage{final}{graphicx}
\RequirePackage{graphicx}
\graphicspath{{recipes/images/}{recipes/}{images/}}
\AtBeginDocument{\setkeys{Gin}{draft=false}}

\RequirePackage{amsmath}
\RequirePackage{setspace}
\RequirePackage{xparse}
\RequirePackage{enumitem}
\RequirePackage{etoolbox}

% FPO badges
\RequirePackage{xcolor}
\RequirePackage{overpic}
\RequirePackage{tikz}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Margins/Indents/Head
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\topmargin=-0.5in
\evensidemargin=0.in
\oddsidemargin=-0.5in
\textwidth=7.0in
\textheight=9.0in
\headsep=0.5in

% No paragraph indents anywhere
\setlength{\parindent}{0pt}

% Formally set head height to silence fancyhdr warning.
\setlength{\headheight}{14pt}
\addtolength{\topmargin}{-2pt}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Spacing and sizing parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Column widths -- Col sep is universal, right column is calculated
\newlength{\RecipeColSep}
\setlength{\RecipeColSep}{0.02\textwidth}
\newlength{\RecipeLeftColWidth}
\setlength{\RecipeLeftColWidth}{0.30\textwidth}
% Note: Do not set right column with manually as it is calculated
\newlength{\RecipeRightColWidth}
\setlength{\RecipeRightColWidth}{\dimexpr\textwidth-\RecipeLeftColWidth-\RecipeColSep\relax}
% After Title vertical spacing
\newlength{\AfterTitleVSpace}
\setlength{\AfterTitleVSpace}{0.\baselineskip}
% After Description Spacing
\newlength{\AfterDescriptionVSpace}
\setlength{\AfterDescriptionVSpace}{0.5\baselineskip}
% Before Multicol Recipe Ingredients/Procedure vertical spacing
\newlength{\BeforeMultiColVSpace}
\setlength{\BeforeMultiColVSpace}{0.5\baselineskip}
% Before notes vertical spacing
\newlength{\BeforeNotesVSpace}
\setlength{\BeforeNotesVSpace}{2.0\baselineskip}
% Before Nutrition vertical spacing
\newlength{\BeforeNutritionVSpace}
\setlength{\BeforeNutritionVSpace}{0.5\baselineskip}

% Define defaults so headers/macros are always defined
\def\RecipeAuthor{AuthorName}
\def\RecipeTitle{RecipeName}

% Helper to set them globally (critical to avoid environment scoping)
\newcommand{\RecipeSetTitleAuthor}[2]{%
  \gdef\RecipeTitle{#1}%
  \gdef\RecipeAuthor{#2}%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Header/footer styling
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\pagestyle{fancy}

\fancyhf{}
\fancyhead[L]{\nouppercase{\RecipeTitle}}
\fancyhead[R]{\nouppercase{\RecipeAuthor}}
\renewcommand{\headrulewidth}{0.4pt}
\renewcommand{\footrulewidth}{0pt}

% Make 'empty' pages (book chapter openers, etc.) use the same header layout
\fancypagestyle{empty}{%
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}
  \renewcommand{\footrulewidth}{0pt}
}

% Section header style
\newcommand{\RecipeSection}[1]{\underline{\textbf{#1}}\par\medskip}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% List styling: labels flush-left with headers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\setlist[itemize]{%
  leftmargin=0pt,
  labelindent=0pt,
  labelsep=0.6em,
  itemindent=*,
  topsep=0pt,
  itemsep=0.35\baselineskip,
  parsep=0pt
}
\setlist[enumerate]{%
  label=(\arabic*),
  leftmargin=0pt,
  labelindent=0pt,
  labelsep=0.6em,
  itemindent=*,
  align=left,
  topsep=0pt,
  itemsep=0.35\baselineskip,
  parsep=0pt
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% One-line nutrition macro (prints nothing if ALL args are blank)
% Usage: \EstimatedNutrition{<servings>}{<cal>}{<protein>}{<carbs>}{<fat>}
% This was the easiest option to move it around quickly
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\ExplSyntaxOn
\NewDocumentCommand{\EstimatedNutrition}{m m m m m}
  {
    \tl_if_blank:nTF { #1#2#3#4#5 }
      { }
      {
        \par\vspace{\BeforeNutritionVSpace}%
        \noindent\textit{
        Servings \space#1\space(#2\space kcal\space each)\space---\space
        Macros:\space
        Protein\space#3~g,\space
        Carbs\space#4~g,\space
        Fat\space#5~g
        }%
      }
  }
\ExplSyntaxOff

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Title block (like your earlier \recipehead)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newcommand{\RecipeHead}{%
  \vspace{50mm}
  \begin{center}
    \textbf{\huge \RecipeTitle}
    \normalsize
  \end{center}
  \vspace{\AfterTitleVSpace}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Recipe environment: sets title/author (globally), updates headers, prints title
% Usage: \begin{recipe}{Title}{Author} ... \end{recipe}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NewDocumentEnvironment{recipe}{m m}{%
  \RecipeSetTitleAuthor{#1}{#2}%
  \addcontentsline{toc}{section}{\RecipeTitle}%
  \pagestyle{fancy}%
  \thispagestyle{fancy}%
  \onehalfspacing
  \RecipeHead
}{%
  \par\bigskip
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FPO (placeholder) badge for recipe description images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newsavebox{\RecipeDescImageBox}

\newcommand{\RecipeFPOBadge}{%
  \tikz[baseline=(fpo.base)]{%
    \node[%
      inner xsep=6pt,
      inner ysep=3pt,
      fill=red,
      fill opacity=0.6,
      draw=black,
      line width=0.6pt,
      text opacity=1,
      text=white,
      font=\sffamily\bfseries\Huge
    ] (fpo) {FPO};%
  }%
}

\newcommand{\RecipeFPODefaultNote}{%
  Draft / placeholder image (FPO). Not owned; do not publish.
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Description block (no visible header), optional image on the left (minipage layout)
% Defaults:
%   left width  = \RecipeLeftColWidth
%   gap         = \RecipeColSep
%   right width = \textwidth - left - gap
%
% Usage:
%   \begin{RecipeDescription} ... \end{RecipeDescription}
%   \begin{RecipeDescription}[moms_rice_pudding.jpg] ... \end{RecipeDescription}
%   \begin{RecipeDescription}[moms_rice_pudding.jpg][0.38\textwidth] ... \end{RecipeDescription}
%
% Optional args: 
%   [image-file][left-width][draft-note]
% - If draft-note is non-empty, an FPO badge is overlaid and note prints.
% - If draft-note is exactly "draft", a default note is used.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NewDocumentEnvironment{RecipeDescription}{O{} O{\RecipeLeftColWidth} O{}}
{%
  \par\noindent
  \ifstrempty{#1}{%
    \ignorespaces
  }{%
    \begin{minipage}[t]{#2}
      \vspace{0pt}%
      \raggedright
      \ifstrempty{#3}{%
        \noindent\includegraphics[width=\linewidth]{#1}\par
      }{%
        \noindent
        \begin{overpic}[width=\linewidth]{#1}
          % Bottom-centered badge (percent coords), fixed rotation:
          \put(50,50){\makebox(0,0){\rotatebox{35}{\RecipeFPOBadge}}}
        \end{overpic}\par
        {\scriptsize\textit{%
          \ifdefstring{#3}{draft}{\RecipeFPODefaultNote}{#3}%
        }}\par
      }%
    \end{minipage}%
    \hspace{\RecipeColSep}%
    \begin{minipage}[t]{\dimexpr\textwidth-#2-\RecipeColSep\relax}
      \vspace{0pt}%
      \ignorespaces
  }%
}
{%
  \ifstrempty{#1}{}{%
    \end{minipage}%
  }%
  \par\vspace{\AfterDescriptionVSpace}%
  \ignorespacesafterend
}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Two-column helper: left minipage, then \RecipeColumnBreak, then right minipage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newbool{recipe@inright}
\NewDocumentCommand{\RecipeColumnBreak}{}{%
  \end{minipage}\hfill%
  \begin{minipage}[t]{\RecipeRightColWidth}%
  \booltrue{recipe@inright}%
}

\NewDocumentEnvironment{recipecols}{}{%
  \boolfalse{recipe@inright}%
  \par\vspace{\BeforeMultiColVSpace}%
  \begin{minipage}[t]{\RecipeLeftColWidth}%
}{%
  \ifbool{recipe@inright}{%
    \end{minipage}%
  }{%
    \end{minipage}\hfill%
    \begin{minipage}[t]{\RecipeRightColWidth}\end{minipage}%
  }%
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convenience section environments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\NewDocumentEnvironment{Ingredients}{}{%
  \RecipeSection{Ingredients}\begin{itemize}
}{%
  \end{itemize}
}

\NewDocumentEnvironment{Procedure}{}{%
  \RecipeSection{Procedure}\begin{enumerate}
}{%
  \end{enumerate}
}

\NewDocumentEnvironment{Notes}{}{%
  \par\vspace{\BeforeNotesVSpace}%
  \RecipeSection{Notes}%
}{%
}