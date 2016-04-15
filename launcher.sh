echo $(hostname) > /opt/spark/conf/slaves
cd /opt/SparkDatasets && git pull
cd /opt/SparkCode     && git pull
cd /opt/SparkCode     && pyspark
