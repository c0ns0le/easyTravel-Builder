#!/bin/bash
ET_SRC_URL=${ET_SRC_URL:-"https://s3.amazonaws.com/easytravel/dT63/easyTravel-2.0.0.2217-src.zip"}

ET_SRC_HOME=/tmp
ET_SRC_CF_HOME="${ET_SRC_HOME}/CustomerFrontend"
ET_SRC_BB_HOME="${ET_SRC_HOME}/BusinessBackend"
ET_SRC_LG_HOME="${ET_SRC_HOME}/com.dynatrace.uemload"

ET_BUILD_HOME=${ET_BUILD_HOME:-$(pwd)/build}
ET_CF_BUILD_HOME="${ET_BUILD_HOME}/${ET_CF_BUILD_HOME:-frontend}"
ET_BB_BUILD_HOME="${ET_BUILD_HOME}/${ET_BB_BUILD_HOME:-backend}"
ET_LG_BUILD_HOME="${ET_BUILD_HOME}/${ET_LG_BUILD_HOME:-loadgen}"
ET_CF_BUILD_LIB_HOME="${ET_CF_BUILD_HOME}/lib"

cd ${ET_SRC_HOME}

# Download easyTravel sources
curl -L -o easyTravel-src.zip ${ET_SRC_URL}

# Unarchive and build easyTravel sources
unzip ./easyTravel-src.zip
ant -f ./Distribution war
cd ${ET_SRC_HOME}/Distribution/dist

# Deploy easyTravel build artifacts into the workspace
mkdir -p ${ET_BB_BUILD_HOME}
cp -v ./business/business.war ${ET_BB_BUILD_HOME}

mkdir -p ${ET_CF_BUILD_HOME} ${ET_CF_BUILD_LIB_HOME}
cp -v ./customer/customer.war                    ${ET_CF_BUILD_HOME}
cp -v ./customer/webapp/WEB-INF/lib/jsf-api.jar  ${ET_CF_BUILD_LIB_HOME}
cp -v ./customer/webapp/WEB-INF/lib/jsf-impl.jar ${ET_CF_BUILD_LIB_HOME}

mkdir -p ${ET_LG_BUILD_HOME}
tar -cvzf ${ET_LG_BUILD_HOME}/loadgen.tar.gz \
          ./lib/commons-cli-*.jar \
          ./lib/commons-lang*.jar \
          ./lib/commons-logging-*.jar \
          ./lib/guava-*.jar \
          ./lib/httpclient-*.jar \
          ./lib/httpcore-*.jar \
          ./lib/metrics-core-*.jar \
          ./lib/metrics-json-*.jar \
          ./lib/metrics-jvm-*.jar \
          ./lib/metrics-servlets-*.jar \
          ./lib/mvel*.jar \
          ./lib/nekohtml-*.jar \
          ./lib/xercesImpl-*.jar \
          ./lib/xml-apis-*.jar \
          ./resources/easyTravel.properties \
          ./resources/easyTravelConfig.properties \
          ./com.dynatrace.easytravel.commons.jar \
          ./uemload.jar