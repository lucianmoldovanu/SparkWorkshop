grep spark /etc/hosts || echo '127.0.1.1 spark' >> /etc/hosts
cd /opt/SparkDatasets && git pull
cd /opt/SparkCode     && git pull
cd /opt/SparkCode     && pyspark
