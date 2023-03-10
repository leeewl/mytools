# 查看那些git项目进行了修改
# 共享cout_code_lines.sh的gitDirectory.txt
#
project_dir=`pwd`

echo "Those dirs have been modified, please commit:"
for line in `cat ./gitDirectory.txt`
do
	gitdir=${line::-4}
	cd $gitdir
	status=`git status`
	result=`echo $status | grep "nothing to commit"`
	if [ -z "$result" ]
	then
		echo "    "$gitdir
	fi
	
	#grep "nothing to commit"
	cd $project_dir
done;
