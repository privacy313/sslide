#!/bin/bash

# SSlide v1.82
# Dylan Warn
# May 2021

echo "
	WARNING: This script will create a directory and files wherever it is run.
	Please be sure of your current working directory.

	"

# Create working directory
timestamp=$(date "+%Y-%b-%d_%H:%M")
if [ ! -d "$timestamp" ]; then
	mkdir "$timestamp"
fi

# User input prompts
read -p "Create how many slides? " slnum
echo -e "\r"
[[ "$slnum" = "" ]] && exit 1

for n in $(seq $slnum); do
	echo "
	Enter information for slide $n...
	"
	read -p "Name: " name
	read -p "City: " city
	read -p "Height: " height
	read -p "Chest: " chest
	read -p "Waist: " waist
	read -p "Hip: " hip
	read -p "Shoes: " shoe
	read -p "Google Drive link: " imglink
	read -p "Instagram handle: " instlink
	echo "Select image 1: "
	img1=$(zenity --file-selection --filename=/home/nani/Documents/Work/People/ --file-filter='Image files (jpg, jpeg, png) | *.jpg *.jpeg *.pdf *.png *.bmp')
	echo "Select image 2: "
	img2=$(zenity --file-selection --filename=/home/nani/Documents/Work/People/ --file-filter='Image files (jpg, jpeg, png) | *.jpg *.jpeg *.pdf *.png *.bmp')
	echo "
	Done!
	"
# Title uppercase
	upname=${name^^}
	upcity=${city^^}
# Data to LaTeX
	cat <<- EOF > "$timestamp/$name.tex"
		\documentclass[handout,aspectratio=169]{beamer}
		\usepackage{graphicx}
		\usepackage{forloop}
		\usepackage{rotating}
		\usepackage{tabto}
		\usepackage{hyperref}
		\usepackage[T1]{fontenc}
		\usepackage[absolute,overlay]{textpos}

		\hypersetup{
		    colorlinks=true,
		    linkcolor=blue,
		    filecolor=blue,
		    urlcolor=blue,
		    pdftitle={Overleaf Example},
		    pdfpagemode=FullScreen,
		    }

		\begin{document}
			\begin{frame}
				\begin{columns}

					\column{.01\textwidth}
					\raisebox{21em}{\rotatebox[origin=r]{90}{\footnotesize $upname | $upcity}}

					\column{.42\textwidth}
						\centering
						\includegraphics[height=\textheight,width=\textwidth,keepaspectratio]{"$img1"}

					\column{.42\textwidth}
						\centering
						\includegraphics[height=\textheight,width=\textwidth,keepaspectratio]{"$img2"}

					\column{.15\textwidth}
					\vspace{15em}
						\tiny

						Height \tabto{4em} $height

						Chest \tabto{4em} $chest

						Waist \tabto{4em} $waist

						Hips \tabto{4em} $hip

						Shoes \tabto{4em} $shoe
				\end{columns}

			\begin{textblock*}{5cm}(13.5cm,0.3cm)
				\tiny \href{$imglink}{IMAGES}
			\end{textblock*}

			\begin{textblock*}{5cm}(13.5cm,8.4cm)
				\tiny \href{https://www.instagram.com/$instlink}{INSTAGRAM}
			\end{textblock*}

			\end{frame}
		\end{document}
	EOF

done

# Create and merge PDF files.
cd $timestamp
latexmk -pdf
pdfunite *.pdf slides_$timestamp.pdf

# Clean up
latexmk -c
rm  *.tex
