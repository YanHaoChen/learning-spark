#!/bin/bash
# Program:
#       This program is install mesos.
# History:
# 2015/12/21 Kyle.b Release
# 

function install_jdk {
	cmd $1 "sudo apt-get purge openjdk* &>/dev/null"
	cmd $1 "sudo apt-get -y autoremove &>/dev/null"
	cmd $1 "sudo add-apt-repository -y ppa:webupd8team/java &>/dev/null"
	cmd $1 "sudo apt-get update &>/dev/null"
	AOL=$(echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true")
	echo $AOL | cmd $1 "sudo debconf-set-selections"
	cmd $1 "sudo apt-get -y install oracle-java8-installer &>/dev/null"
}

function install_other {
	cmd $1 "sudo apt-get install -y expect "
}

function install_hadoop {
	cmd $2 "sudo rm -rf /hadoop/hadoop-${1}"
	URL="http://files.imaclouds.com/packages/hadoop/hadoop-${1}.tar.gz"
	cmd $2 "curl -s $URL | sudo tar -xz -C /opt/ "
}

function install_spark {
	local spark_version=${1:-"1.5.2"}
	URL="http://files.imaclouds.com/packages/spark/spark-${spark_version}-bin-hadoop2.6.tgz"
	cmd $2 "curl -s $URL | sudo tar -xz -C /opt/"
	cmd $2 "sudo mv /opt/spark-${spark_version}-bin-hadoop2.6 /opt/spark"
}

function install_hbase {
	if [ "$1" == "true" ]; then
		cmd $2 "sudo apt-get install -y zookeeper zookeeperd"
	fi
	URL="http://files.imaclouds.com/packages/hadoop/hbase-1.1.2-bin.tar.gz"
	cmd $2 "curl -s $URL | sudo tar -xz -C /opt/"
}

function install_hive {
	MYSQL_PASSWD="mysql-server mysql-server/root_password password passwd"
	MYSQL_AGAIN_PASSWD="mysql-server mysql-server/root_password_again password passwd"
	echo ${MYSQL_PASSWD} | cmd $1 "sudo debconf-set-selections"
	echo ${MYSQL_AGAIN_PASSWD} | cmd $1 "sudo debconf-set-selections"

	cmd $1 "sudo apt-get install -y libmysql-java mysql-server-5.5"
	URL="http://files.imaclouds.com/packages/hadoop/hive-1.2.1-bin.tar.gz"
	cmd $1 "curl -s $URL | sudo tar -xz -C /opt/"
}