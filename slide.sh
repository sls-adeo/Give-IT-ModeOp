#!/bin/sh
#
#
#  slide.sh : Generate a Pandoc file with photos
#
# Echantillon couleur https://htmlcolorcodes.com/fr/
#
# 20210913 pandoc use xelatex for generating pdf
#---------------- var
MDFILE="slide2.md"
DESCSLIDE="legende.csv"
SLIDESHOW="ModOpGiveIT.html"
PDF="ModOpGiveIT.pdf"
export LC_ALL=C
DATEJ=`date +'%a %d %Y'`
#---------------- functions 

syntaxe() {
	echo "$0 [mode] : Generate a [mode] document for installation of GiveIT desktop/laptop"
	echo "[mode] is pdf or html format"	
	exit 1
}

header_pdf()
{

    echo "% Installation Guide" > $MDFILE 
    echo "% Team Give IT / $DATEJ" >> $MDFILE  
    echo "% Well, installation will be done in 7mn without a mouse, YES!"  >> $MDFILE
    echo " "  >> $MDFILE
}

body_pdf()
{
  echo "# $TITRE"                                                                        >> $MDFILE
  #echo "========"                                                                        >> $MDFILE
  echo "![$LEGENDE](./images/$IMAGENAME \"$LEGENDE\"){ width=250px }"                    >> $MDFILE
  echo " "                                                                               >> $MDFILE

}



header_html()
{

    echo "% Installation Guide" > $MDFILE 
    echo "% Team Give IT / $DATEJ" >> $MDFILE 
    echo "% Well, installation will be done in 7mn without a mouse, YES!"  >> $MDFILE
    #echo ""                    >> $MDFILE
    echo " "  >> $MDFILE
}

body_html() 
{

    echo "# $TITRE {style=\"background: #$COLOR; text-align:center;\"}"                             >> $MDFILE
    echo "<!-- ---------------PAGE $NBPAGE------------------------------------- -->"                >> $MDFILE 
    echo " "                                                                                        >> $MDFILE 
    echo "<table border=\"0\" cellspacing=\"0\" cellpadding=\"4\" align=\"center\" width=\"90%\">" >> $MDFILE
    echo "   <tr><td align=\"center\"><img src=\"./images/$IMAGENAME\" width=\"75%\" /></td></tr>"   >> $MDFILE
    echo "   <tr><td align=\"center\">$LEGENDE</tr>"                                                >> $MDFILE
    echo "</table>"                                                                                 >> $MDFILE
  
}

#-------------- Main

if [ $# -ne 1 ]; then 
	syntaxe 
fi

PARAM1=`echo $1 | awk '{print toupper($0)}'`
if [ "X$PARAM1" != "XPDF" ] && [ "X$PARAM1" != "XHTML" ]; then
	echo ; echo "Bad Parameter 1 <$1>" ; echo
	syntaxe
fi 	

#-------------- Treatment 

if [ "$PARAM1" = "PDF" ]; then
	header_pdf 
else 
	header_html 
fi

NBPAGE=0
COLOR="DBCECB"
while read line
do
   if [ $NBPAGE -gt 0 ]; then                      # Skip first line
	IMAGENAME=`echo $line | cut -f1 -d'|'`
	TITRE=`echo $line | cut -f2 -d'|'`
	LEGENDE=`echo $line | cut -f3 -d'|'`

	COLOR=`printf "%X\n" $((0x${COLOR} + 1))` 
	if [ "$PARAM1" = "PDF" ]; then
		body_pdf
	else
		body_html
	fi
   fi
   NBPAGE=`expr $NBPAGE + 1`
done < ${DESCSLIDE}

#---------- Produce Pdf/ SlideShow
if [ "$PARAM1" = "PDF" ]; then
	#pandoc -t beamer $MDFILE -V theme:Warsaw -o $PDF
	pandoc --pdf-engine=xelatex $MDFILE -V theme:Warsaw -o $PDF
	[ $? -eq 0 ] && echo "Generating PDF <$PDF> OK"
else
	pandoc -t slidy -s $MDFILE  -o $SLIDESHOW
	[ $? -eq 0 ] && echo "Generating SlideShow <$SLIDESHOW> OK"
fi

