# 使用標準 Java 17 映像檔
FROM eclipse-temurin:17-jdk

WORKDIR /app

# 1. 下載 OpenTelemetry Java Agent (負責攔截請求，送往 Cloud Trace)
RUN curl -L -O https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar

# 2. 下載 Google Cloud Profiler Agent (負責描繪 CPU/Memory 火焰圖)
RUN mkdir -p /opt/cprof && \
    curl -L -O https://storage.googleapis.com/cloud-profiler/java/latest/profiler_java_agent.tar.gz && \
    tar -xzf profiler_java_agent.tar.gz -C /opt/cprof && \
    rm profiler_java_agent.tar.gz

# 複製編譯好的 Spring Boot JAR 檔
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# 設定環境變數讓 OTel 知道要把 Trace 送給 GCP
ENV OTEL_TRACES_EXPORTER=google_cloud

# 啟動時掛載 Agent (這行是魔法發生的地方！)
CMD ["java", \
     "-javaagent:/app/opentelemetry-javaagent.jar", \
     "-agentpath:/opt/cprof/profiler_java_agent.so=-cprof_service=momo-checkout-service,-cprof_service_version=1.0.0", \
     "-jar", "app.jar"]
