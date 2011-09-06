if [ $1 = "-h" ]
then
	wmctrl -v -r :ACTIVE: -b "add,maximized_horz" &> /dev/null
	exit 1;
fi

if [ $1 = "-v" ]
then
	wmctrl -v -r :ACTIVE: -b "add,maximized_vert" &> /dev/null
	exit 1;
fi

hex_tmp=`xprop -root | awk '/_NET_ACTIVE_WINDOW\(WINDOW\)/{print $NF}'`
echo $hex_tmp > ~/resize-hex.tmp
len=`wc -c ~/resize-hex.tmp| awk '{ print $1 }'`
len=`echo $(( len-1 ))`
if [ $len -eq "9" ]
then
#	hex1=`echo ${hex_tmp:0:2}`
#	hex2="0"
#	hex3=`echo ${hex_tmp:2:8}`
#	hex=`echo ${hex_tmp/0x/0x0}`
	hex=`echo $hex_tmp`
elif [ $len -eq "8" ]
then
#	hex1=`echo ${hex_tmp:0:2}`
#	hex2="00"
#	hex3=`echo ${hex_tmp:2:8}`
	hex=$hex1$hex2$hex3
else
	hex=$hex_tmp
fi

echo $hex > ~/len

wmctrl -l -G -p | grep $hex > ~/resize-dimensions.tmp
awk '{ print $4 }' ~/resize-dimensions.tmp 1> ~/x.tmp
awk '{ print $5 }' ~/resize-dimensions.tmp 1> ~/y.tmp
awk '{ print $6 }' ~/resize-dimensions.tmp 1> ~/width.tmp
awk '{ print $7 }' ~/resize-dimensions.tmp 1> ~/height.tmp
#rm -f ~/resize-dimensions.tmp

x=`cat ~/x.tmp`
x=`echo $(( x/2 - 4 ))`
y=`cat ~/y.tmp`
y=`echo $(( y/2 - 24 ))`
width=`cat ~/width.tmp`
height=`cat ~/height.tmp`
echo "" &> ~/.resize-window-log.txt
echo "Coordinates: ($x, $y) Dimensions: ($width x $height)" &>> ~/.resize-window-log.txt
rm -f ~/x.tmp
rm -f ~/y.tmp
rm -f ~/width.tmp
rm -f ~/height.tmp

if [ $1 = "-l" ]
then
	wmctrl -v -r :ACTIVE: -b "add,maximized_horz" &> /dev/null
	wmctrl -l -G -p | grep $hex > ~/resize-dimensions.tmp
	awk '{ print $6 }' ~/resize-dimensions.tmp 1> ~/width.tmp
	rm -f ~/resize-dimensions.tmp

	width=`cat ~/width.tmp`
	rm -f ~/width.tmp
	width=`echo $(( width/2 ))`
	wmctrl -v -r :ACTIVE: -b "remove,maximized_horz,maximized_vert" &>> ~/.resize-window-log.txt
	wmctrl -v -r :ACTIVE: -e 0,0,$y,$width,$height &>> ~/.resize-window-log.txt
elif [ $1 = "-r" ]
then
	wmctrl -v -r :ACTIVE: -b "add,maximized_horz" &> /dev/null
	wmctrl -l -G -p | grep $hex > ~/resize-dimensions.tmp
	awk '{ print $6 }' ~/resize-dimensions.tmp 1> ~/width.tmp
	rm -f ~/resize-dimensions.tmp

	width=`cat ~/width.tmp`
	rm -f ~/width.tmp
	width=`echo $(( width/2 ))`
	wmctrl -v -r :ACTIVE: -b "remove,maximized_horz,maximized_vert" &>> ~/.resize-window-log.txt
	wmctrl -v -r :ACTIVE: -e 0,$width,$y,$width,$height &>> ~/.resize-window-log.txt
fi

if [ $1 = "-u" ]
then
	wmctrl -v -r :ACTIVE: -b "add,maximized_vert" &> /dev/null
	wmctrl -l -G -p | grep $hex > ~/resize-dimensions.tmp
	awk '{ print $7 }' ~/resize-dimensions.tmp 1> ~/height.tmp
	rm -f ~/resize-dimensions.tmp
	
	height=`cat ~/height.tmp`
	
	rm -f ~/height.tmp
	height=`echo $(( height/2 ))`
	wmctrl -v -r :ACTIVE: -b "remove,maximized_horz,maximized_vert" &>> ~/.resize-window-log.txt
	wmctrl -v -r :ACTIVE: -e 0,$x,0,$width,$height &>> ~/.resize-window-log.txt
elif [ $1 = "-d" ]
then
	wmctrl -v -r :ACTIVE: -b "add,maximized_vert" &> /dev/null
	wmctrl -l -G -p | grep $hex > ~/resize-dimensions.tmp
	awk '{ print $7 }' ~/resize-dimensions.tmp 1> ~/height.tmp
	rm -f ~/resize-dimensions.tmp

	height=`cat ~/height.tmp`
	y=`echo $(( height+45 ))`
	rm -f ~/height.tmp
	height=`echo $(( height/2 ))`
	wmctrl -v -r :ACTIVE: -b "remove,maximized_horz,maximized_vert" &>> ~/.resize-window-log.txt
	wmctrl -v -r :ACTIVE: -e 0,$x,$y,$width,$height &>> ~/.resize-window-log.txt
fi
