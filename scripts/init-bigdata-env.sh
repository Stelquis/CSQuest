# ===================================================================
# 大数据开发环境初始化 
# 自动检测最新版，一键配置 Java/Spark/Scala/SBT
# 运行: 
#    bash /workspace/scripts/init-bigdata-env.sh
# ===================================================================

set -e

SPARK_HOME="/opt/spark"
SCALA_HOME="/opt/scala"
SBT_HOME="/opt/sbt"

# 版本自动检测（支持环境变量覆盖，检测失败则中断）
detect_latest() {
  case "${1}" in
    scala) curl -sL "https://www.scala-lang.org/files/archive/" | grep -oP 'scala-2\.12\.\d+\.tgz' | sort -V | tail -1 | grep -oP '2\.12\.\d+' ;;
    spark) curl -sL "https://archive.apache.org/dist/spark/" | grep -oP 'spark-3\.5\.\d+/' | sort -V | tail -1 | grep -oP '3\.5\.\d+' ;;
    sbt)   curl -sL "https://api.github.com/repos/sbt/sbt/releases/latest" | python3 -c "import sys,json; print(json.load(sys.stdin).get('tag_name','').lstrip('v'))" ;;
  esac 2>/dev/null
}
SCALA_VERSION="${SCALA_VERSION:-$(detect_latest scala)}"
SPARK_VERSION="${SPARK_VERSION:-$(detect_latest spark)}"
SBT_VERSION="${SBT_VERSION:-$(detect_latest sbt)}"
HADOOP_VERSION="3"
echo "  版本: Scala ${SCALA_VERSION} / Spark ${SPARK_VERSION} / SBT ${SBT_VERSION}"

SCALA_DL_URL="https://www.scala-lang.org/files/archive/scala-${SCALA_VERSION}.tgz"
SPARK_DL_URL="https://mirrors.huaweicloud.com/apache/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz"
SBT_DL_URL="https://github.com/sbt/sbt/releases/download/v${SBT_VERSION}/sbt-${SBT_VERSION}.tgz"

echo "--- Java 21 ---"

if command -v java &>/dev/null; then
    echo "⏭️  Java 已安装: $(java -version 2>&1 | head -1)"
else
    echo "📦 正在安装 OpenJDK 21..."
    apt-get update -qq > /dev/null 2>&1
    apt-get install -y -qq openjdk-21-jdk > /dev/null 2>&1
    echo "✅ Java 安装完成: $(java -version 2>&1 | head -1)"
fi

if [ -z "$JAVA_HOME" ]; then
    export JAVA_HOME=$(dirname $(dirname $(readlink -f $(which java))))
fi
echo "   JAVA_HOME: $JAVA_HOME"
echo "--- Scala $SCALA_VERSION ---"

if command -v scala &>/dev/null && scala -version 2>&1 | grep -q "$SCALA_VERSION"; then
    echo "⏭️  Scala 已安装: $(scala -version 2>&1)"
else
    echo "📦 正在下载 Scala $SCALA_VERSION..."
    curl -fSL --progress-bar "$SCALA_DL_URL" | tar xz -C /opt
    [ -d "${SCALA_HOME}" ] && rm -rf "${SCALA_HOME}"
    mv /opt/scala-${SCALA_VERSION} ${SCALA_HOME}

    export PATH="${SCALA_HOME}/bin:$PATH"

    echo "✅ Scala 安装完成: $(scala -version 2>&1)"
fi
echo "   SCALA_HOME: $SCALA_HOME"
echo "--- Apache Spark $SPARK_VERSION ---"

if [ -f "${SPARK_HOME}/bin/spark-submit" ] && ${SPARK_HOME}/bin/spark-submit --version 2>&1 | grep -q "version ${SPARK_VERSION}"; then
    echo "⏭️  Spark 已安装: $(${SPARK_HOME}/bin/spark-submit --version 2>&1 | grep -i version | head -1)"
else
    echo "📦 正在下载 Spark $SPARK_VERSION (Hadoop $HADOOP_VERSION)..."
    curl -fSL --progress-bar "$SPARK_DL_URL" | tar xz -C /opt
    [ -d "${SPARK_HOME}" ] && rm -rf "${SPARK_HOME}"
    mv /opt/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} ${SPARK_HOME}

    # 配置 spark-env.sh
    cat > ${SPARK_HOME}/conf/spark-env.sh << SPARK_EOF
export JAVA_HOME=${JAVA_HOME}
export SCALA_HOME=${SCALA_HOME}
export SPARK_HOME=${SPARK_HOME}
SPARK_EOF
    chmod +x ${SPARK_HOME}/conf/spark-env.sh

    echo "✅ Spark 安装完成"
fi

export PATH="${SPARK_HOME}/bin:${SPARK_HOME}/sbin:$PATH"
echo "   SPARK_HOME: $SPARK_HOME"
echo "--- SBT $SBT_VERSION ---"

if command -v sbt &>/dev/null; then
    echo "⏭️  SBT 已安装: $(sbt --version 2>&1 | head -1)"
else
    echo "📦 正在下载 SBT $SBT_VERSION..."
    curl -fSL --progress-bar "$SBT_DL_URL" | tar xz -C /opt

    export PATH="${SBT_HOME}/bin:$PATH"

    echo "✅ SBT 安装完成"
fi
echo "--- 环境变量 ---"

cat > /etc/profile.d/bigdata.sh << ENV_EOF
export JAVA_HOME=${JAVA_HOME}
export SCALA_HOME=${SCALA_HOME}
export SPARK_HOME=${SPARK_HOME}
export PATH=\${SPARK_HOME}/bin:\${SPARK_HOME}/sbin:\${SCALA_HOME}/bin:\${SBT_HOME}/bin:\$PATH
ENV_EOF

echo "✅ 环境变量已写入 /etc/profile.d/bigdata.sh"
echo "--- 环境验证 ---"

echo "☕ Java:  $(java -version 2>&1 | head -1)"
echo "🔴 Scala: $(scala -version 2>&1 || echo '未安装')"
if [ -d "$SPARK_HOME" ]; then
    echo "⚡ Spark: $(${SPARK_HOME}/bin/spark-submit --version 2>&1 | grep -i 'version' | head -1)"
else
    echo "⚡ Spark: 未安装"
fi
echo "🔧 SBT:   $(command -v sbt &>/dev/null && sbt --version 2>&1 | head -1 || echo '未安装')"
echo "============================================================"
echo "  大数据开发环境配置完成"
echo "============================================================"
echo "  Java 21 / Scala ${SCALA_VERSION} / Spark ${SPARK_VERSION} / SBT ${SBT_VERSION}"
echo "  代码: /workspace/BigData/Spark/code/"
echo "============================================================"
