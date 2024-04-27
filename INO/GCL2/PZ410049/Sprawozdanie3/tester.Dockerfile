FROM java_builder
RUN mvn test > /test_logs.txt 2>&1
RUN cp /test_logs.txt .