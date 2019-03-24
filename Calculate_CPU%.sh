#!$SHELL

declare -x PID_NUM=$1
declare -x Total_Time=$2
declare -x Every_Time=$3
declare -i Result=1
declare -i Result_PID=1
declare -x judge=""
declare -x judge_PID=""
declare -x CPU_In=0
declare -x Average=0
declare -x Command=""
declare -x Total=0

function quit(){
	if [ $1 == "q" ] &>/dev/null;then
	echo -e "\t"
	exit 0
	fi
}

function num_decide(){
	judge=$(echo $1 | sed 's/[0-9]//g')	#所有数字替换成空字符
	if [ "$1" == "" -o "$judge" != "" ];then
	Result=0
	else
	Result=1
	fi
}

function zero_decide(){		#判断输入的时间是否为零
	if [ "$1" == 0 ];then
	Result=0
	echo -e "The TotalTime or EveryTime can't be 0 \n"
	fi
}

function PID_decide(){
	judge_PID=$(ps $1 | sed -n '2p')
	if [ "$judge_PID" == "" ];then
	Result_PID=0
	echo -e "The PID Number is not exit"
	else
	Result_PID=1
	fi
}

num_decide $PID_NUM
PID_decide $PID_NUM
while [ "$Result" == 0 -o "$Result_PID" == 0 ]	#判断输入的第一个参数是否为数字
do
echo -e "The first para is not right \n"
echo -e "Please Input again\n"
echo -e "Input q or Q is quit\n"
read -p "Please Input PID Number: " PID_NUM
num_decide $PID_NUM
PID_decide $PID_NUM
quit $PID_NUM
done

num_decide $Total_Time
zero_decide $Total_Time
while [ "$Result" == 0 ]	#判断输入的第二个参数是否为数字或者是0
do
echo -e "The second para is not right \n"
echo -e "Please Input again\n"
echo -e "Input q or Q is quit\n"
read -p "Please Input Total Time: " Total_Time
quit $Total_Time
num_decide $Total_Time
zero_decide $Total_Time
done

num_decide $Every_Time
zero_decide $Every_Time
while [ "$Result" == 0 ]	#判断输入的第三个参数是否为数字或者是0
do
echo -e "The third para is not right \n"
echo -e "Please Input again\n"
echo -e "Input q or Q is quit\n"
read -p "Please Input Every Time: " Every_Time
quit $Every_Time
num_decide $Every_Time
zero_decide $Every_Time
done

declare -i Times=$(($2/$3))

for (( i=0; i < $Times; i++ ))
do
sleep $Every_Time
ps -aux | awk '$2=="'$PID_NUM'" { print "'$(($i+1))' times: " "[PID: " $2 "\t" "%CPU: " $3 "\t" "COMMAND: " $11 "]" }'
Command=$(ps -aux | awk '$2=='$PID_NUM' {print $11}')
CPU_In=$(ps -aux | awk '$2=="'$PID_NUM'" { print $3 }')
Total=$(echo "scale=2;$CPU_In+$Total" | bc)
done

Average=$(echo "scale=2;$Total/$Times" | bc)

echo -e "the Process \"$Command\"'s Average CPU% is $Average"
