#!/bin/bash

function ren {
  if [[ "$1" == *".css"* ]]; then
	inName=${x}
    reversed=$(debrev ${x})
    # if debrev fails to reverse
    if [ $? -ne 0 ]; then
		return 1
    fi
    out=""
    cFound=0
    for ((i = 0; i < ${#reversed}; i++)); do
		c="${reversed:$i:1}"
		if [ $cFound == 1 ]; then
			out+=$c
		else
			if [ "$c" == "?" ]; then
				cFound=1
			fi
		fi
    done
    outName=$(debrev $out)
    mv "${inName}" "${outName}"
  fi
  return 0
}

cd ./out/assets
for x in *; do
	ren $x
done
cd ../..
