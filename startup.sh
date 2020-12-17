#!/usr/bin/env bash
cd `dirname $0`
cd ..
DEPLOY_DIR=`pwd`
CONF_DIR=$DEPLOY_DIR/conf
LOGS_DIR=$DEPLOY_DIR/logs

PID=`ps -ef | grep -v grep | grep "$CONF_DIR" |awk '{print $2}'`
if [ -n "$PID" ]; then
    echo "ERROR: already started!"
    echo "PID: $PID"
    exit 1
fi

if [ ! -d $LOGS_DIR ]; then
    mkdir $LOGS_DIR
fi

STDOUT_FILE=$LOGS_DIR/stdout.log

LIB_DIR=$DEPLOY_DIR/lib
LIB_JARS=`ls $LIB_DIR|grep .jar|awk '{print "'$LIB_DIR'/"$0}'| xargs | sed "s/ /:/g"`
CLASS_PATH=$CONF_DIR:$LIB_JARS
APP_MAINCLASS=com.example.springdemo1.SpringDemo1Application


echo -e "Starting the spring demo ...\c"
nohup java -Dapp.home=$DEPLOY_DIR -Xms64m -Xmx1024m -classpath $CLASS_PATH $APP_MAINCLASS >$STDOUT_FILE 2>&1 &
sleep 1
echo "started"
PIDS=`ps -ef | grep java | grep "$DEPLOY_DIR" | awk '{print $2}'`
echo "PID: $PIDS"