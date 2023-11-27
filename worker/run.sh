#!/bin/bash

until sleep 10; do sleep 10; done

export KERBEROS_ADMIN=admin/admin
export KERBEROS_ADMIN_PASSWORD=admin
export KERBEROS_ROOT_USER_PASSWORD=password
export KRB_REALM=DEITOS.NETWORK
export KEYTAB_DIR=/opt/hadoop/etc/hadoop/keytabs

export SPARK_LOCAL_IP="127.0.0.1"

kadmin -p $KERBEROS_ADMIN -w $KERBEROS_ADMIN_PASSWORD -q "addprinc -pw password root@$KRB_REALM"

kadmin -p $KERBEROS_ADMIN -w $KERBEROS_ADMIN_PASSWORD -q "addprinc -randkey nn/$(hostname -f)@$KRB_REALM"
kadmin -p $KERBEROS_ADMIN -w $KERBEROS_ADMIN_PASSWORD -q "addprinc -randkey hive/$(hostname -f)@$KRB_REALM"
kadmin -p $KERBEROS_ADMIN -w $KERBEROS_ADMIN_PASSWORD -q "addprinc -randkey dn/$(hostname -f)@$KRB_REALM"
kadmin -p $KERBEROS_ADMIN -w $KERBEROS_ADMIN_PASSWORD -q "addprinc -randkey HTTP/$(hostname -f)@$KRB_REALM"
kadmin -p $KERBEROS_ADMIN -w $KERBEROS_ADMIN_PASSWORD -q "addprinc -randkey jhs/$(hostname -f)@$KRB_REALM"
kadmin -p $KERBEROS_ADMIN -w $KERBEROS_ADMIN_PASSWORD -q "addprinc -randkey yarn/$(hostname -f)@$KRB_REALM"
kadmin -p $KERBEROS_ADMIN -w $KERBEROS_ADMIN_PASSWORD -q "addprinc -randkey rm/$(hostname -f)@$KRB_REALM"
kadmin -p $KERBEROS_ADMIN -w $KERBEROS_ADMIN_PASSWORD -q "addprinc -randkey nm/$(hostname -f)@$KRB_REALM"

kadmin -p $KERBEROS_ADMIN -w $KERBEROS_ADMIN_PASSWORD -q "xst -k $HOME/nn.keytab nn/$(hostname -f) HTTP/$(hostname -f) hive/$(hostname -f) "
kadmin -p $KERBEROS_ADMIN -w $KERBEROS_ADMIN_PASSWORD -q "xst -k $HOME/dn.keytab dn/$(hostname -f)"
kadmin -p $KERBEROS_ADMIN -w $KERBEROS_ADMIN_PASSWORD -q "xst -k $HOME/spnego.keytab HTTP/$(hostname -f)"
kadmin -p $KERBEROS_ADMIN -w $KERBEROS_ADMIN_PASSWORD -q "xst -k $HOME/jhs.keytab jhs/$(hostname -f)"
kadmin -p $KERBEROS_ADMIN -w $KERBEROS_ADMIN_PASSWORD -q "xst -k $HOME/hive.keytab hive/$(hostname -f)"

kadmin -p $KERBEROS_ADMIN -w $KERBEROS_ADMIN_PASSWORD -q "xst -k $HOME/yarn.keytab yarn/$(hostname -f)"
kadmin -p $KERBEROS_ADMIN -w $KERBEROS_ADMIN_PASSWORD -q "xst -k $HOME/rm.keytab rm/$(hostname -f)"
kadmin -p $KERBEROS_ADMIN -w $KERBEROS_ADMIN_PASSWORD -q "xst -k $HOME/nm.keytab nm/$(hostname -f)"

mkdir -p $KEYTAB_DIR
mv $HOME/nn.keytab $KEYTAB_DIR
mv $HOME/dn.keytab $KEYTAB_DIR
mv $HOME/spnego.keytab $KEYTAB_DIR
mv $HOME/jhs.keytab $KEYTAB_DIR
mv $HOME/yarn.keytab $KEYTAB_DIR
mv $HOME/rm.keytab $KEYTAB_DIR
mv $HOME/nm.keytab $KEYTAB_DIR
mv $HOME/hive.keytab $KEYTAB_DIR
chmod 400 $KEYTAB_DIR/nn.keytab
chmod 400 $KEYTAB_DIR/dn.keytab
chmod 400 $KEYTAB_DIR/spnego.keytab
chmod 400 $KEYTAB_DIR/jhs.keytab
chmod 400 $KEYTAB_DIR/yarn.keytab
chmod 400 $KEYTAB_DIR/rm.keytab
chmod 400 $KEYTAB_DIR/nm.keytab
chmod 400 $KEYTAB_DIR/hive.keytab

echo 'Checking Credentials ...'
until kinit -kt $KEYTAB_DIR/nn.keytab nn/$(hostname -f)@$KRB_REALM; do sleep 2; done 
until kinit -kt $KEYTAB_DIR/dn.keytab dn/$(hostname -f)@$KRB_REALM; do sleep 2; done 
until kinit -kt $KEYTAB_DIR/spnego.keytab HTTP/$(hostname -f)@$KRB_REALM; do sleep 2; done 
until kinit -kt $KEYTAB_DIR/jhs.keytab jhs/$(hostname -f)@$KRB_REALM; do sleep 2; done 
until kinit -kt $KEYTAB_DIR/yarn.keytab yarn/$(hostname -f)@$KRB_REALM; do sleep 2; done 
until kinit -kt $KEYTAB_DIR/rm.keytab rm/$(hostname -f)@$KRB_REALM; do sleep 2; done 
until kinit -kt $KEYTAB_DIR/nm.keytab nm/$(hostname -f)@$KRB_REALM; do sleep 2; done 

# kdestroy
keytool -genkey -alias $(hostname -f) -keyalg rsa -keysize 1024 -dname "CN=$(hostname -f)" -keypass changeme -keystore $KEYTAB_DIR/keystore.jks -storepass changeme

chmod 700 $KEYTAB_DIR/keystore.jks
chown jovyan $KEYTAB_DIR/keystore.jks

echo "Starting Hadoop data node..."
hdfs --daemon start datanode
# hdfs datanode

echo "Starting Hadoop node manager..."
yarn --daemon start nodemanager
# yarn nodemanager

echo "Starting Spark slave node..."
spark-class org.apache.spark.deploy.worker.Worker "spark://master.deitos.network:7077"

while true; do sleep 1000; done
