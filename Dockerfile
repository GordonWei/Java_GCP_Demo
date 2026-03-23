# ==========================================
# 第一階段：編譯階段 (Builder Stage)
# ==========================================
FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

# 先複製 pom.xml 並下載相依套件 (利用 Docker 快取機制加速後續建置)
COPY pom.xml .
RUN mvn dependency:go-offline

# 複製原始碼並進行編譯
COPY src ./src
RUN mvn clean package -DskipTests

# ==========================================
# 第二階段：執行階段 (Runtime Stage)
# ==========================================
FROM eclipse-temurin:17-jdk
WORKDIR /app

# 1. 下載 OTel Agent
RUN curl -L -O https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar

# 2. 下載 GCP Profiler Agent
RUN mkdir -p /opt/cprof && \
    curl -L -O https://storage.googleapis.com/cloud-profiler/java/latest/profiler_java_agent.tar.gz && \
    tar -xzf profiler_java_agent.tar.gz -C /opt/cprof && \
    rm profiler_java_agent.tar.gz

# 3. ★ 從第一階段 (builder) 複製編譯好的 JAR 檔過來
COPY --from=builder /app/target/*.jar app.jar

# 4. 設定環境變數與啟動指令
ENV OTEL_TRACES_EXPORTER=google_cloud

CMD ["java", \
     "-javaagent:/app/opentelemetry-javaagent.jar", \
     "-agentpath:/opt/cprof/profiler_java_agent.so=-cprof_service=momo-checkout-service,-cprof_service_version=1.0.0", \
     "-jar", "app.jar"]
