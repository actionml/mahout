SCALA_VERSION ?= 2.11.11
HADOOP_HOME ?= /usr/local/hadoop

M2_DEFINES  = -Phadoop2 -DskipTests -Dspark.version=$(SPARK_VERSION)
M2_DEFINES += -Dscala.version=$(SCALA_VERSION) -Dscala.compat.version=$(basename $(SCALA_VERSION))

all: build

build:
ifeq ($(SPARK_VERSION),)
	$(error SPARK_VERSION environment variable is not given!)
endif
	@export HADOOP_HOME=$(HADOOP_HOME) && \
	mvn clean package $(M2_DEFINES)
