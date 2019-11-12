#!/vendor/bin/sh

# Add by wangwq14, start to record battery log.

umask 022

if [ -d /data/vendor/newlog/aplog ]; then
    APLOG_DIR=/data/vendor/newlog/aplog/battery
else
    APLOG_DIR=/data/local/newlog/aplog/battery
fi

get_product() {
    a=`getprop|grep ro.product.name`
    b=`echo ${a##*\[}`
    product=`echo ${b%]*}`
}

get_platform() {
    a=`getprop|grep ro.board.platform`
    b=`echo ${a##*\[}`
    platform=`echo ${b%]*}`
}
get_product
get_platform

BATT_LOGFILE_GROUP_MAX_SIZE=20971520
FILE_NUM=$(getprop persist.sys.aplogfiles)
if [ $FILE_NUM -gt 0 ]; then
    FILE_NUM=20
else
    FILE_NUM=5
fi
if [[ "$platform" == "msmnile" ]] || [[ "$platform" == "sdm710" ]]; then
    REGISTER_DUMP=1
else
    REGISTER_DUMP=0
fi
if [[ "$product" == "cream" ]]; then
    THERMAL_ZONE=1
    GENERIC_TIME=2000000
else
    THERMAL_ZONE=0
    GENERIC_TIME=10000000
fi

/vendor/bin/batterylogger -n ${FILE_NUM} -s ${BATT_LOGFILE_GROUP_MAX_SIZE} -r ${REGISTER_DUMP} -t ${THERMAL_ZONE} -d ${GENERIC_TIME} -p ${APLOG_DIR}

