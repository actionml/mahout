SCALA_VERSION ?= 2.11.11
HADOOP_HOME ?= /usr/local/hadoop
M2_REPO ?= /usr/local/share/mahout-m2-repo

M2_DEFINES  = -Phadoop2 -DskipTests -Dspark.version=$(SPARK_VERSION)
M2_DEFINES += -Dscala.version=$(SCALA_VERSION) -Dscala.compat.version=$(basename $(SCALA_VERSION))

BUILT_JARS = $(wildcard *.jar)

DEPLOY_DEFINES = -Durl=file://$(M2_REPO) -DgroupId=org.apache.mahout

.PHONY: all prereq build deploy

all: build deploy

prereq:
ifeq ($(SPARK_VERSION),)
	$(error SPARK_VERSION environment variable is not given!)
endif

build: prereq
	@export HADOOP_HOME=$(HADOOP_HOME) && \
	mvn clean package $(M2_DEFINES)

deploy:
	@$(MAKE) $(patsubst %,__%,$(BUILT_JARS))

__%.jar:
	@version=`echo $* | sed -rn 's/.*-(([0-9]|\.)+).*/\1/p'` ;\
		artifact=`echo $* | sed -rn 's/(.*)-([0-9]|\.)+.*/\1/p'` ;\
		\
		mvn deploy:deploy-file $(DEPLOY_DEFINES) -DartifactId=$$artifact -Dversion=$$version -Dfile=$*.jar
