# 统计每日提交到git的代码行数

# 输入的参数，天数
if [ "$1" ];
then
	days=$1
else
	echo "需要参数，参数为数字，代表几日的数据\n"
	exit
fi

#清空目录文件
> ./gitDirectory.txt
#查找玩家home目录下所有的.git目录，并根据关键字忽略部分目录
for line in `find ~/ -type d -name ".git"`
do
	ignore=false
	for ignoreWord in `cat ./ignoreKeyword.txt`
	do
		dir=`echo $line | grep -v $ignoreWord`
		if [ -z $dir ]
		then
			ignore=true
			break
		fi
	done;
	if [ $ignore = false ]
	then
		#echo ${line::-4} >> ./gitDirectory.txt
		echo $line >> ./gitDirectory.txt
	fi
done;

zeroClock="00:00:00"
for ((day=0;day<$days;day++));do 
	dayBegin=$(date -d "$day days ago" "+%Y-%m-%d")
	timeBegin="$dayBegin $zeroClock"
	dayEnd=$(date -d "$((day-1)) days ago" "+%Y-%m-%d")
	timeEnd="$dayEnd $zeroClock"

	# 当日总数
	dayTotal=0

	# 进入每个git目录，计算出总行数
	for gitDir in `cat ./gitDirectory.txt`
	do
		# 当日当文件夹总数
		dirTotal=`git --git-dir $gitDir log --since="$timeBegin" --until="$timeEnd" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { print loc }'`
		dayTotal=$((dayTotal + dirTotal))
	done;

	# 日期 数量
	echo -e "$dayBegin \t$dayTotal \tlines"
done

