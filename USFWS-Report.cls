%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% USFWS-Report.cls
%% Copyright (c) 2012 Nathan Zimpfer <nathan_zimpfer@fws.gov>
%%
%%	REVISION HISTORY:
%%
%%	v0.1: 2012-Oct-26 Nathan Zimpfer
%%			* Initial setup and configuration of class file
%%  v0.2: 2013-May-02 Nathan Zimpfer
%%			* Complete rewrite of wide/narrow header code to utilize  
%%			  tikzpicture commands only. 
%%  v0.3: 0000-???-00  Nathan Zimpfer
%%			* ?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%	LaTeX2e class file for formatting documents according to the
%% 	US Fish & Wildlife Service graphic standards dated (7/01/01).
%%
%%	USAGE:	\documentclass{USFWS-Report}
%%					\documentclass[...options...]{USFWS-Report}
%%
%%	The default settings produce a final, copy ready for publication
%% 	(11pt font, two-sided, single-spaced, onecolumn, narrow heading).
%%
%%	OPTIONS:
%% 
%%   - Any standard option for the LaTeX2e ``report'' class, including
%%     ``10pt'', ``11pt'', ``12pt'', ``oneside'', ``twoside'', etc.
%%  
%%   - ``singlespaced'', ``oneandahalfspaced'', or ``doublespaced'':  Set
%%     the entire document's default line spacing, except for notes,
%%     which are single-spaced by default.

%%	narrowheading wideheading
%%		onecolumn twocolumn
%%	draft, final
%%	letterpaper
%%	
%%	
%%  NEW ENVIRONMENTS and COMMANDS:
%%	
%%		* \title{...}: 		(preamble only; REQUIRED)
%%		* \subtitle{...} 	preamble only. 
%%		* \coverimage{...} preamble only.
%%		* \division{...} preamble only.
%%		* \officeaddress{...} preamble only.
%%
%%		* \makecover	
%%		* \rearcover
%%
%%	Sectioning
%%  Tables & figures	
%%	
%%	
%%	
%%	
%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%        IDENTIFICATION        %%%%%%%%%%%%
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{USFWS-Report}

\def\@version{0.2}
\def\@release{2015 August 17}
\typeout{Document Style `USFWS-Report' v\@version, released \@release\space(N. Zimpfer, DMBM-PHAB)}

\RequirePackage{xkeyval}
%\RequirePackage{lmodern}
%\RequirePackage[T1]{fontenc}
%\RequirePackage{textcomp}
\RequirePackage[obeyspaces,spaces]{url}
\RequirePackage[usenames,dvipsnames]{xcolor}
	\definecolor{airforceblue}{rgb}{0.36, 0.54, 0.66}
	\definecolor{usfwsblue}{rgb}{0, 0.176, .33}
	\definecolor{arsenic}{rgb}{0.23, 0.27, 0.29}
\RequirePackage{tikz}
	\usetikzlibrary{calc, positioning}	

%%%%%%%%%%%%         INITIAL CODE         %%%%%%%%%%%%
%% setup internal variables for fonsize, page-sides
%
\newcommand{\@reportptsz}{}
\newcommand{\@reportside}{}
\newcommand{\@reportlnsp}{}
\newcommand{\@coverstyle}{}

%% Options switch for cover style heading format
%
%\newif\if@coverstylenarrow
%\@coverstylenarrowtrue 		% default to narrow style

%%%%%%%%%%%%      OPTION DECLARATION      %%%%%%%%%%%%
%% Point Size options: change current setting.
%
\DeclareOption{11pt}{\renewcommand{\@reportptsz}{11pt}}
\DeclareOption{12pt}{\renewcommand{\@reportptsz}{12pt}}

%% Number of Page Sides options: change current setting.
%
\DeclareOption{twoside}{\renewcommand{\@reportside}{twoside}}
\DeclareOption{oneside}{\renewcommand{\@reportside}{oneside}}

%% allow for narrow or wide headings on the cover. The default cover style
%% will be narrow.
%
\DeclareOption{narrow}{\renewcommand{\@coverstyle}{narrow}}
\DeclareOption{wide}{\renewcommand{\@coverstyle}{wide}}

%% allow for 2 column reports. one column is the default setting.
%\DeclareOption{twocolumn}{\renewcommand{\@twocolumn}{twocolumn}}
%\DeclareOption{twocolumn}{\newcommand{\@twocolumn}{twocolumn}}

%% Line Spacing options: change current setting.
%
\DeclareOption{singlespaced}{\renewcommand{\@reportlnsp}{1}}
\DeclareOption{oneandahalfspaced}{\renewcommand{\@reportlnsp}{1.25}}
\DeclareOption{doublespaced}{\renewcommand{\@reportlnsp}{1.66}}

% All other options are passed to the base class directly.
%
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}

%%%%%%%%%%%%       OPTION EXECUTION       %%%%%%%%%%%%
%% Default settings.
%
\ExecuteOptions{11pt,letterpaper,twoside,%
	openright,singlespaced,narrow,final}
%
%% Process options.
%
\ProcessOptions

%%%%%%%%%%%%       PACKAGE  LOADING       %%%%%%%%%%%%
%% Load base class using current setting for basic options.
%
\LoadClass[\@reportptsz, \@reportside]{report}


%%%%%%          MAIN  CODE          %%%%%%%%%%%%
%%    New formatting environments and commands.

%% set defaults for private functions
%
\def\@title{}
\def\@subtitle{}
\def\@coverimage{}
\def\@division{}
\def\@officeaddress{}
  
%% Switch for generating a title page
%
\newif\iftitlepage
\titlepagetrue % initially true by default

%% Switch for generating a list of figures
%
\newif\iffigurespage
\figurespagetrue % initially true by default

%% Switch for generating a list of tables
%
\newif\iftablespage
\tablespagetrue % initially true by default

%% Switch for generating a table of contents
%
\newif\ifcontentspage
\contentspagetrue % initially true by default

%% Store document title
%
\renewcommand{\title}[1]%
  {\ifx\empty#1\empty\else\gdef\@title{#1}\fi}

%% Store document subtitle
%
\newcommand{\subtitle}[1]%
  {\ifx\empty#1\empty\else\gdef\@subtitle{#1}\fi}

%% create command to set coverimage file
%
\newcommand{\coverimage}[1]%
	{\ifx\empty#1\empty\else\gdef\@coverimage{#1}\fi}

%% set this up to allow address as an argument..
%% office & address
\newcommand{\division}[1]%
  {\ifx\empty#1\empty\else\gdef\@division{#1}\fi}

%% Office address. User must insert line break to get address display as 2 lines.
%
\newcommand{\officeaddress}[1]
	{\ifx\empty#1\empty\else\gdef\@officeaddress{#1}\fi}

%% Define fixed style for URL addresses.
%
\def\url@leostyle{%
  \@ifundefined{selectfont}{\def\UrlFont{\sf}}{\def\UrlFont{\small\ttfamily}}}
\urlstyle{leo}

%% Create variable for publication date for use in cover generation
%
\newcommand{\pubDate}[1]{}

%%
%
\newcommand{\monthname}[1]{%
\ifcase#1 \or January \or February \or March \or April
\or May \or June \or July \or August \or September
\or October \or November \or December \fi}

%% Create a command to create the rearcover, with no arguments
%
\newcommand{\rearcover}{%
\clearpage\thispagestyle{empty}
\thispagestyle{empty}
\begin{flushleft}
\@division \\
\@officeaddress
\vspace{0.25in}

U.S.~Fish \& Wildlife Service\\
\url{http://www.fws.gov}
\vspace{0.25in}

For state transfer relay service\\
TTY/Voice: 711\\
\vspace{0.25in}
\monthname{\month}\space\number\year \\
\vspace{0.25in}
\mbox{
	\includegraphics[height=4pc, keepaspectratio]{doiemblem}
	\hspace{1pt}
	\includegraphics[height=4pc, keepaspectratio]{FWSemblem} 
}
\end{flushleft}
}%

%% Create layout for narrow cover heading. 
%% The title falls 1pc below identification bar (fontsize 36pt).. The subtitle begins 1pc below the rule.
%
\newcommand{\@narrow}{
\begin{tikzpicture}[remember picture, overlay, anchor=south west, x=\paperwidth, y=\paperheight]
	\node[yshift=-52pt, xshift=225pt] at (current page.north west) 
	{\begin{tikzpicture}[remember picture, overlay]
		\node[rectangle, 
			fill=usfwsblue, 
			text=white, 
			text width=27.5pc, 
			minimum size=2pc, 
			inner sep=4pt, 
			text depth=-6pt] (head) {\usefont{T1}{pun}{b}{n} \fontsize{14}{14}\selectfont U.S.~Fish \& Wildlife Service\hfill};
		
		\node[rectangle,
			xshift=-4pt, 
			below=1pc of head, 
			text width=27.5pc, 
			inner sep=0pt] (title) {\usefont{T1}{pun}{b}{n} \fontsize{36}{36}\selectfont{\@title\par}};
			
		\node[rectangle, 
			below=1pc of title, 
			text width=27.5pc, 
			inner sep=0pt] {\usefont{T1}{bcn}{m}{it} \fontsize{24}{24}\selectfont{\@subtitle\par}};	
	\end{tikzpicture}};
\end{tikzpicture}
}


%% Create layout for wide header.  USFWS identification bar falls at the top margin (2pc from top page edge).
%% The title fall 1pc below identification bar (fontsize 36pt).  A rule with a width of 0.5pt falls 1pc 
%% below the baseline of the title.  The subtitle begins 1pc below the rule.
%
\newcommand{\@wide}{
\begin{tikzpicture}[remember picture, overlay, anchor=south west, x=\paperwidth, y=\paperheight]
\node[yshift=-52pt, xshift=72pt] at (current page.north west)
	{\begin{tikzpicture}[remember picture, overlay]
	\node[rectangle, 
			fill=black, 
			text=white, 
			text width=494pt, 
			minimum size=2pc, 
			inner sep=4pt, 
			text depth=-6pt] (head) {\usefont{T1}{pun}{b}{n} \fontsize{14}{14}\selectfont U.S.~Fish \& Wildlife Service\hfill};
			
		\node[rectangle, 
			below= 1pc of head, 
			text width=501pt, 
			inner sep=0pt] (title) {\usefont{T1}{pun}{b}{n} \fontsize{36}{36}\selectfont{\@title\par}} ;
		
		\if\@subtitle\empty
			\par
		\else
		\draw[line width=0.5pt, 
					below = 5pt of title,
					black] ($ (title.south west) - (0pt,10pt) $) -- ($ (title.south east) - (0pt,10pt) $);
		
		\node[rectangle, 
			below=22pt of title,  
			text width=501pt, 
			inner sep=0pt] {\usefont{T1}{bcn}{m}{it} \fontsize{24pt}{24}\selectfont{\@subtitle\par}};		
	\fi
	\end{tikzpicture}};
\end{tikzpicture}
}

%% Maketitle command. Pushes out heading, and images if
%% present. Images are limited to a max width of 500px, and 
%% clipped if exceeded.
%
\renewcommand{\maketitle}{%
	\footnote
  \begin{titlepage}%
  % title  
  \begin{center}%
  	 {\large \@date \par}%       % Set date in \large size.
  \end{center}\par
  \vskip 60\p@
  \@thanks
  \vfil\null
  \end{titlepage}%
}

\newcommand{\makecover}{%
	\thispagestyle{empty}
  \begingroup%
	\if@coverstylenarrowtrue
		\@narrow
	\else
		\@wide
	\fi
	
		\if\@coverimage\empty
			\vfill\null
		\else	
		{	\vspace{2.5in}
		\centering \includegraphics[width=500px, keepaspectratio, clip]{\@coverimage}}
  		\vfill\null
		\fi    	  
  \endgroup%
}

%% Change the formatting of the abstract environment
%
\renewenvironment{abstract}{%
			%\if@twocolumn
			%	{\onecolumn \noindent\bfseries\itshape\abstractname:}
			%\else
				{\noindent\bfseries\itshape\abstractname:}
			%\fi}
			}
			{\rule{\textwidth}{0.5pt} \par}

%\setlength{\abovecaptionskip}{2ex}
\setlength{\belowcaptionskip}{2ex}

\renewcommand\@makecaption[2]{
  \vskip\abovecaptionskip
  \sbox\@tempboxa{{\fontfamily{pun} \selectfont #1.} #2}%
  \ifdim \wd\@tempboxa >\hsize
   {\fontfamily{pun} \selectfont #1.} #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}	
	
%%%%%%    Document Layout  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Instead of hard-coding the page layout for letter paper
%% (8.5" x 11"), we will base it on \paperheight and \paperwidth,
%% so that it works with options that change the paper size.
%%
%% Define Margins for each Front/Rear cover type and general text.
%% pc = pica; pt = point
%% 12pt = 1pc; 6pc = 1in
%
%% The front and rear covers follow Grid C, while Text follows Grid D.
% Margins for USFWS Grid C  (pages 3.8--3.9)
% 	Top/Bottom Margin = 2pc
% 	Left/Inside Margin = 6pc
%		Right/Outsize Margin = 2pc

% Margins for USFWS Grid D (pages 3.26--3.29)
% 	Top/Bottom Margin = 3pc
% 	Left/Right Margins = 6pc
% 	Gutter = 1pc (intercolumn space)
\setlength{\textheight}{\paperheight}
\setlength{\textwidth}{\paperwidth}


%% These margins are designed for documents that conform to standard
%% With page numbers falling at the bottom of the page, Using Grid D
%\addtolength{\voffset}{-3pc}
%\setlength{\topmargin}{0pt}
%\setlength{\headheight}{0pc}
%\setlength{\headsep}{0pc}
%\setlength{\columnsep}{1pc}
%\setlength{\oddsidemargin}{0pc}
%\setlength{\evensidemargin}{0pc}
%\setlength{\textwidth}{39pc}
%\setlength{\textheight}{59pc}
%\setlength{\marginparsep}{0pt}
%\setlength{\footskip}{22pt}
%\setlength{\columnsep}{1pc}

%% These margins are modified to allow for page numbering and fancy headers to 
%% occur at the TOP of the page, adds some space for better readability. 
%% Does not conform to Grid D. Allowed additional space at bottom.
%
\addtolength{\voffset}{-3pc}
\setlength{\topmargin}{0pt}
\setlength{\headheight}{15pt} 
\setlength{\headsep}{14pt}
\setlength{\columnsep}{1pc}
\setlength{\oddsidemargin}{0pc}
\setlength{\evensidemargin}{0pc}
\setlength{\textwidth}{39pc}
\setlength{\textheight}{57pc}
\setlength{\marginparsep}{0pt}
\setlength{\footskip}{22pt}
\setlength{\columnsep}{1pc}

%%%%%%%%%%%%%%%%%%%%%      PAGE FLOATS       %%%%%%%%%%%%%%%%%%%%%
%% Set parameters that control the placment of tables/figures (floats).
%
\setcounter{topnumber}{2} 		% max number of floats to appear at top of a page
\setcounter{dbltopnumber}{1} 	% same as top number but extend across columns
\setcounter{bottomnumber}{2} 	% max number of floats to appear at bottom of page
\setcounter{totalnumber}{3}		% max number of floats total on page

\renewcommand{\topfraction}{0.6}
\renewcommand{\bottomfraction}{0.5}
\renewcommand{\floatpagefraction}{0.4}
\renewcommand{\dbltopfraction}{0.4}
\renewcommand{\dblfloatpagefraction}{0.9}

\renewcommand{\floatsep}{0.01pt}
\renewcommand{\textfloatsep}{20.0pt plus 2.0pt minus 4.0pt}	% space between tables and beginning of text 
%\renewcommand{\intextsep}{}
%\renewcommand{\dblfloatsep}{}
%\renewcommand{\dbltextfloatsep}{}

\setlength{\parindent}{2em}
\setlength\parskip{0\p@ \@plus \p@}

%% Define spacing and layout of sectioning commands
%% \@startsection {NAME}{LEVEL}{INDENT}{BEFORESKIP}{AFTERSKIP}{STYLE} 

%% Heading 1: Black bar 2pc from top margin; Heading Text 1pc below bar. 
%% Paragraph text begin 11 pc from top margin. 24pt fontsize

%% The chapter heading works followed by abstract works fine in onecolumn mode, but
%\renewcommand*\@makechapterhead[1]{%
%  {%\parindent \z@ 
%   %\begin{tikzpicture}
%	 %\draw[fill,color=black] (0,0) rectangle (38.9pc,2pc);
%   %\end{tikzpicture}
%  \raggedright \fontfamily{pun}\Huge\bfseries
%    \ifnum \c@secnumdepth >\m@ne
%         \thechapter.\space
%    \fi
%    #1\par\nobreak
%   % \vskip 5pc %\p@
%    \vskip 4pc %\p@
%  }}
  
\renewcommand*\@makechapterhead[1]{%
	\vspace*{-50\p@}%
	{\parindent \z@ \raggedright \fontfamily{pun}
    \ifnum \c@secnumdepth >\m@ne
        \Huge \@chapapp\space \thechapter
        \par\nobreak
        \vskip 20\p@
    \fi
    \interlinepenalty\@M
		\rule{\textwidth}{2pc}
		\vskip 5\p@
    \usefont{T1}{pun}{b}{n}\fontsize{26}{\baselineskip} \selectfont #1\par\nobreak
    \vskip 50\p@
  }}
 
\renewcommand*\@makeschapterhead[1]{%
	\vspace*{-50\p@}%
  {\parindent \z@ \raggedright \fontfamily{pun}
    \interlinepenalty\@M
		\rule{\textwidth}{2pc}
		\vskip 5\p@
    \usefont{T1}{pun}{b}{n}\fontsize{26}{\baselineskip} \selectfont #1\par\nobreak
    \vskip 50\p@
  }}
  
                    
%% Section heading: 25pt Univers font, bold, left justified, alway at the top of the page,
%
\renewcommand{\section}{\@startsection{section}{1}{\z@}%
	{4.0ex \@plus .5ex \@minus .5ex}%
  {2.0ex \@plus .25ex}%
  {\fontfamily{pun}\LARGE\bfseries}}
                                   
%% Subsection heading: 14pt Univers font, bold, left justified
%
\renewcommand{\subsection}{\@startsection{subsection}{2}{\z@}
	{3.25ex\@plus .25ex \@minus .25ex}%
	{1.75ex \@plus .25ex}%
	{\fontfamily{pun}\large}}

%% Subsubsection heading: 10pt normal font, italics
%
\renewcommand{\subsubsection}{\@startsection{subsubsection}{3}{\z@}
	%{3.75ex \@plus 0.75ex \@minus 0.25ex}%
	{\baselineskip}
	{1.75ex \@plus 0.5ex \@minus 0.25ex}%	
	{\normalsize\itshape}}%

%%%%%%%%%%%%%%%% 	Formatting 		%%%%%%%%%%%%%%%% 
%% PROBLEM WHEN USING BABEL
\AtBeginDocument{\renewcommand{\contentsname}{Table of Contents}}

%% Disallow page breaks at hyphens (this will give some underfull vbox's,
%% so an alternative is to use \brokenpenalty=100 and manually search
%% for and fix such page breaks)
%
\brokenpenalty=10000

%% Limit hyphenation - default = 200, max (never hyphenate) = 10,000
%
\hyphenpenalty=300


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  End of USFWS-REPORT.CLS
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Use this for setting fonts in headings..
%%\DeclareTextFontCommand{\textmyfont}{\myfont}