# СИНТАКСИС:
#	vk_method <имя метода> <аргументы (начиная c &) > <количество попыток>

vk_curl() {
	timeout="1s"
	V="5.131"
	n=10
	i=0
	if [ $# -lt 3 ] 
	then
		n=10
	else
		if [ $3 -eq 0 ]
		then
			n=10
		else
			n=$3
		fi
	fi
	while [ $i -lt $n ]
	do
		if curl "https://api.vk.com/method/$1?v=$V&access_token=$(cat token)$2&lang=ru" 2> /dev/null
		then
			return 0
		else
			sleep $timeout
		fi
	done
	return 1
}

vk_method() {
	local exitcode=0
	if vk_curl $* > response
	then
		S=$(cat response | jq -r ".response")
		if [ "$S" = "null" ]
		then
			cat response | jq ".error" >&2
			rm response
			return 2
		else
			echo $S
		fi
	fi
	rm response	
}
