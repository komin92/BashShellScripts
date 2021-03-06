#/bin/bash

#show Chinese lunisolar calender.
# 2011/11/24
#
# Licensed under GPL version 3
#

#日期数据 {{{

# calendar_data format:
# +--------+---------+--------------+------------+---------+
# |单位(位)|  1-4  |   5-16   |   17   | 18-20 |
# +--------+---------+--------------+------------+---------+
# | 说 明 |闰月月份 | 每月的大小月 |闰月的大小月|  空  |
# +--------+---------+--------------+------------+---------+

calendar_data=(
0x04bd8 0x04ae0 0x0a570 0x054d5 0x0d260 0x0d950 0x16554 0x056a0 0x09ad0 0x055d2
0x04ae0 0x0a5b6 0x0a4d0 0x0d250 0x1d255 0x0b540 0x0d6a0 0x0ada2 0x095b0 0x14977
0x04970 0x0a4b0 0x0b4b5 0x06a50 0x06d40 0x1ab54 0x02b60 0x09570 0x052f2 0x04970
0x06566 0x0d4a0 0x0ea50 0x06e95 0x05ad0 0x02b60 0x186e3 0x092e0 0x1c8d7 0x0c950
0x0d4a0 0x1d8a6 0x0b550 0x056a0 0x1a5b4 0x025d0 0x092d0 0x0d2b2 0x0a950 0x0b557
0x06ca0 0x0b550 0x15355 0x04da0 0x0a5b0 0x14573 0x052b0 0x0a9a8 0x0e950 0x06aa0
0x0aea6 0x0ab50 0x04b60 0x0aae4 0x0a570 0x05260 0x0f263 0x0d950 0x05b57 0x056a0
0x096d0 0x04dd5 0x04ad0 0x0a4d0 0x0d4d4 0x0d250 0x0d558 0x0b540 0x0b6a0 0x195a6
0x095b0 0x049b0 0x0a974 0x0a4b0 0x0b27a 0x06a50 0x06d40 0x0af46 0x0ab60 0x09570
0x04af5 0x04970 0x064b0 0x074a3 0x0ea50 0x06b58 0x055c0 0x0ab60 0x096d5 0x092e0
0x0c960 0x0d954 0x0d4a0 0x0da50 0x07552 0x056a0 0x0abb7 0x025d0 0x092d0 0x0cab5
0x0a950 0x0b4a0 0x0baa4 0x0ad50 0x055d9 0x04ba0 0x0a5b0 0x15176 0x052b0 0x0a930
0x07954 0x06aa0 0x0ad50 0x05b52 0x04b60 0x0a6e6 0x0a4e0 0x0d260 0x0ea65 0x0d530
0x05aa0 0x076a3 0x096d0 0x04bd7 0x04ad0 0x0a4d0 0x1d0b6 0x0d250 0x0d520 0x0dd45
0x0b5a0 0x056d0 0x055b2 0x049b0 0x0a577 0x0a4b0 0x0aa50 0x1b255 0x06d20 0x0ada0
0x14b63)

gan=('甲' '乙' '丙' '丁' '戊' '己' '庚' '辛' '壬' '癸')
zhi=('子' '丑' '寅' '卯' '辰' '巳' '午' '未' '申' '酉' '戌' '亥')
sheng_xiao=('鼠' '牛' '虎' '兔' '龍' '蛇' '馬' '羊' '猴' '雞' '狗' '豬')
jieqi_name=('小寒' '大寒' '立春' '雨水' '惊蛰' '春分' '清明' '谷雨' '立夏' '小满' '芒种' '夏至' '小暑' '大暑' '立秋' '处暑' '白露' '秋分' '寒露' '霜降' '立冬' '小雪' '大雪' '冬至')
jieqi_data=(0 21208 42467 63836 85337 107014 128867 150921 173149 195551 218072 240693 263343 285989 308563 331033 353350 375494 397447 419210 440795 462224 483532 504758)
yueri_name1=('初' '十' '廿' '三' '大' '小' '閏')
yueri_name2=('十' '一' '二' '三' '四' '五' '六' '七' '八' '九' '十' '十一' '腊' '正')

#农历节日
jieri=(
[101]='春節' [115]='元宵節' [505]='端午節' [707]='七夕節' [715]='中元節'
[815]='中秋節' [909]='重陽節' [1208]='臘八節' [1223]='小年' [100]='除夕')

# 公歷節日
festival=(
[101]='元旦' [214]='情人节' [308]='妇女节' [312]='植树节' [315]='消费者权益日'
[401]='愚人节' [501]='劳动节' [504]='青年节' [701]='香港回归纪念日 中共诞辰'
[707]='抗日战争纪念日' [801]='建军节' [910]='教师节' [918]='九·一八事变纪念日'
[1001]='国庆节' [1002]='国庆节假日' [1003]='国庆节假日' [1220]='澳门回归纪念'
[1224]='平安夜' [1225]='圣诞节')
#}}}

# 农历年月日计算函数 {{{

# 农历某年哪个月是闰月，没有闰为0
# which_run_yue nian
which_run_yue() { echo $((${calendar_data[$1-1900]} & 0xF));}

# 农历某年闰月的天数
# days_of_run_rue nian
days_of_run_rue() {
  (($(which_run_yue $1))) \
  && echo $((${calendar_data[$1-1900]} & 0x10000?30:29)) \
  || echo 0
}

# 农历某年的天数
# days_of_nian nian
days_of_nian() {
  local nian=$(($1-1900))
  local sum=0
  for ((i=0x8000; i>8; i>>=1)); do
    ((${calendar_data[$nian]}&$i)) && ((sum++))
  done
  echo $(($sum+$(days_of_run_rue $1)+348))
}

# 显示干支名称
# show_ganzhi ganzhi_num
show_ganzhi() {
  echo ${gan[$1%10]}${zhi[$1%12]}
}

# 是否为公历闰年
# is_bissextile year
is_bissextile() {
  ((($1%4 == 0 && $1%100 != 0) || $1%400 == 0)) && return 0 || return 1
}

# 公历某年年初到某月前一月的天数,一月忽略
# sum_to_premonth year month
sum_to_premonth() {
  local sum=$(($2-1?($2-1)*30:0))
  for ((i=1; i<=($2-1); i++)); do
    case $i in
      1|3|5|7|8|10|12) ((sum++)) ;;
      2) ((sum-=2)) && is_bissextile $1 && ((sum++)) ;;
    esac
  done
  echo $sum
}

# 计算两个公历日期的相差天数
# sub_two_date laterDate earlyDate
sub_two_date() {
  local year1=${1:0:4}
  local year2=${2:0:4}

  # 两个年份到年初的天数相减并加上365/366
  sum=$(($(sum_to_premonth $year1 10#${1:4:2}) +365 -\
    $(sum_to_premonth $year2 10#${2:4:2})))
  is_bissextile $year2 && ((sum--))
  ((sum+=10#${1:6:2}-10#${2:6:2}))

  # 闰年365+1
  for ((i=year2+1; i<year1; i++)); do
    is_bissextile $i && ((sum++))
  done
  if (((year1-year2)>0)); then
    ((sum+=(year1-year2-1)*365))
  elif ((year1==year2)); then
    ((sum-=365))
  else
    echo "input is error."&& exit
  fi
  echo $sum
}

# 公历某年的第n个节气为几号(从0小寒算起)
# which_day_is_jieqi year n
which_day_is_jieqi() {
  local days_of_permonth=(0 31 28 31 30 31 30 31 31 30 31 30 31)
  is_bissextile $1 && ((days_of_permonth[2]++))
  # 1900年1月6日2点05分为小寒，精确到分往后推算
  local a=$((525948*($1-1900)-$(sub_two_date ${1}0106 19000106)*24*60+${jieqi_data[$2]}+125))

  # 若为小寒且在6日00点以前，天数减1
  local c=$(($a/(24*60)+6))
  (($a<0)) && ((c--))

  for ((i=0;i<13 && c>28;i++)); do
    ((c-=${days_of_permonth[$i]}))
  done
  echo $c
}

# 计算农历年月日
calc_cal() {
  local run_yue var1
  local is_run_yue=0
  local percalc_val=( 0 18279 36529)
  local all_days=$(($(sub_two_date $1 19000131)))

  # 此处为优化算法，每隔50年置一预计算值,减少碳排放量 ^_^
  for ((i=0; i<5; i++)); do
    ((${1:0:4}>($i*50+1900) && ${1:0:4}<=(($i+1)*50+1900))) && break
  done
  ((all_days-=${percalc_val[$i]}))
  for ((i=$i*50+1900; all_days>0 && i<2050; i++)); do
    var1=$(days_of_nian $i)
    ((all_days-=$var1))
  done
  # --------------------------------------

  ((all_days<0))&& {((all_days+=var1)); ((i--));}
  year=$i

  run_yue=$(which_run_yue $i)

  # TODO 此处尚待优化
  for ((i=1; i<13 && all_days>0; i++)); do
    #如果有农历闰月
    if ((run_yue>0 && i==(run_yue+1) && is_run_yue==0)); then
      ((--i))
      is_run_yue=1
      var1=$(days_of_run_rue $year)
    else
      var1=$(((${calendar_data[$year-1900]} & (0x10000>>$i))?30:29))
    fi
    ((all_days-=var1))
    ((is_run_yue==1 && i==run_yue+1)) && is_run_yue=0
  done
  ((all_days<0)) && {((all_days+=var1));((i--));}
  
  if ((all_days==0 && run_yue>0 && i==run_yue+1)); then
    if ((is_run_yue==1)); then
      is_run_yue=0
    else
      is_run_yue=1
      ((--i))
    fi
  fi

  month=$i
  ((day=all_days+1))
}
#}}}

# 帮助及分析命令行选项 {{{

show_help() {
cat <<EOF
 clcal，显示中国传统农历
 用法：
 clcal [-a | -c | -g | -n | -z | -d date | date ]
 选项：
 -g  显示公历年月日
 -c  显示农历年月日
 -z  显示四柱
 -a  显示所有项
 -n  不显示农历日历
 -d  指定公历年月日时，格式0000年00月00日00时

 -h  显示此帮助

EOF
exit
}

while getopts 'acd:ghnz' argv;do
  case "${argv}" in
    a) SHOW_ALL=true ;;
    c) SHOW_CHINESE_DATE=true ;;
    d) thisdate="${OPTARG}" ;;
    g) SHOW_DATE=true ;;
    n) DONOT_SHOW_CHINESE_CALENDAR=true ;;
    z) SHOW_SIZHU=true ;;
    h) show_help ;;
  esac
  HAVE_ARG=true
done
(($#==1)) && [[ ! $HAVE_ARG ]] && thisdate=$1
# }}}

# 若没有输入则使用当前年月日时
thisdate=${thisdate=$(date +"%Y%m%d%H")}
calc_cal $thisdate

# 计算四柱 {{{
#
# 年柱，以立春划分，1900年立春后为庚子年
nian_zhu=$((${thisdate:0:4}-1900+36))
# 调整立春前的年柱
(((10#${thisdate:4:2}==2 && 10#${thisdate:6:2}<$(which_day_is_jieqi ${thisdate:0:4} 2)) || 10#${thisdate:4:2}==1)) && ((nian_zhu--))

# 月柱，以节（公历每月的第一个节气为节，第二个为气）划分，1900年1月小寒前一天为丙子月
yue_zhu=$(((${thisdate:0:4}-1900)*12+10#${thisdate:4:2}+12))
# 调整节前的月柱
((10#${thisdate:6:2}<$(which_day_is_jieqi ${thisdate:0:4} $(((10#${thisdate:4:2}-1)*2))))) && ((yue_zhu--))

# 日柱，前一天的23时与当天的00时为子时，1900年1月1日为甲戌日
ri_zhu=$(($(sub_two_date $thisdate 19000101)+10))

# 时柱
shi_zhu=$((($(sub_two_date $thisdate 19000101)*24+10#${thisdate:8:2}+1)/2))
# }}}

# 调整显示 {{{

# 判断大小月
if ((is_run_yue)); then
  month_prefix=${yueri_name1[6]}
  month_suffix=$((${calendar_data[$year-1900]} & 0x10000?4:5))
else
  month_suffix=$((${calendar_data[$year-1900]} & 0x10000>>$month?4:5))
fi

# 判断“除夕”
jieri_index=$(($month*100+$day))
if ((month_suffix==4 && jieri_index==1230)); then
  jieri_index=100
elif ((month_suffix==5 && jieri_index==1229)); then
  jieri_index=100
fi

# 判断节气
((10#${thisdate:6:2}==$(which_day_is_jieqi ${thisdate:0:4} $(((10#${thisdate:4:2}-1)*2))))) &&\
jieqi=${jieqi_name[$(((10#${thisdate:4:2}-1)*2))]}
((10#${thisdate:6:2}==$(which_day_is_jieqi ${thisdate:0:4} $(((10#${thisdate:4:2}-1)*2+1))))) &&\
jieqi=${jieqi_name[$(((10#${thisdate:4:2}-1)*2+1))]}

# 调整日期方便显示
((day==10)) && ((day=0))
((day<10)) && day=0$day
# }}}

# 显示公历年月日
[[ $SHOW_ALL || $SHOW_DATE ]] &&
echo ${thisdate:0:4} ${thisdate:4:2} ${thisdate:6:2}

# 显示农历年月日
[[ $SHOW_ALL || $SHOW_CHINESE_DATE ]] &&
echo $year $month $day

# 显示农历年生肖、月份、日、农历节日、节气、公历节日
[[ $SHOW_ALL || ! $DONOT_SHOW_CHINESE_CALENDAR ]] &&
echo $(show_ganzhi $nian_zhu)${sheng_xiao[nian_zhu%12]}年$month_prefix${yueri_name2[month==1?month+12:month]}月${yueri_name1[month_suffix]}${yueri_name1[${day:0:1}]}${yueri_name2[${day:1:1}]} ${jieri[$jieri_index]} $jieqi ${festival[10#${thisdate:4:2}*100+10#${thisdate:6:2}]}

# 显示四柱
[[ $SHOW_ALL || $SHOW_SIZHU ]] &&
echo $(show_ganzhi $nian_zhu)年$(show_ganzhi $yue_zhu)月$(show_ganzhi $ri_zhu)日$(show_ganzhi $shi_zhu)時
  
exit

# vi: set ts=2 sw=2 noet:

