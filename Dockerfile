FROM ubuntu:14.04

ADD launcher.sh /opt/launcher.sh

RUN chmod +x /opt/launcher.sh                                                                   && \
    export DEBIAN_FRONTEND=noninteractive                                                       && \
    apt-get update                                                                              && \
    apt-get install -y wget git default-jre-headless libsm6 libxrender1                         && \
    echo 'Downloading Anaconda ...'                                                             && \
    wget -qO /opt/Anaconda.sh https://repo.continuum.io/archive/Anaconda2-2.5.0-Linux-x86_64.sh && \
    cd /opt                                                                                     && \
    bash Anaconda.sh -b -p /opt/anaconda                                                        && \
    rm Anaconda.sh                                                                              && \
    echo 'Installing seaborn (Python module) ...'                                               && \
    PATH=/opt/anaconda/bin:$PATH pip install seaborn                                            && \
    echo 'Downloading Spark ...'                                                                && \
    wget -qO /opt/spark.tgz http://d3kbcqa49mib13.cloudfront.net/spark-1.6.0-bin-hadoop2.6.tgz  && \
    cd /opt                                                                                     && \
    echo 'Extracting Spark ...'                                                                 && \
    tar -xf spark.tgz                                                                           && \
    mv spark-* spark                                                                            && \
    rm spark.tgz                                                                                && \
    cd /opt/spark/conf                                                                          && \
    sed 's/INFO/ERROR/' log4j.properties.template > log4j.properties                            && \
    echo $(hostname) > slaves                                                                   && \
    cd /opt                                                                                     && \
    echo 'Getting SparkDatasets/SparkCode from GitHub ...'                                      && \
    git clone https://github.com/dserban/SparkDatasets.git                                      && \
    git clone https://github.com/dserban/SparkCode.git                                          && \
    echo 'Building container, this may take a while ...'

ENV SPARK_HOME=/opt/spark                             \
    PYSPARK_PYTHON=/opt/anaconda/bin/python           \
    IPYTHON_OPTS='notebook --no-browser --ip=0.0.0.0' \
    PATH=/opt/anaconda/bin:/opt/spark/bin:$PATH

CMD ['/opt/launcher.sh']

# docker build -t sparkworkshop github.com/dserban/SparkWorkshop
# docker run -p 8888:8888 -p 4040:4040 -it dserban/sparkworkshop sh -c /opt/launcher.sh
#
