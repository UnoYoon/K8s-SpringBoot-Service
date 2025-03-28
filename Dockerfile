# 기본 이미지 설정 (Java 17 기반)
FROM openjdk:17-jdk-slim

# 애플리케이션의 JAR 파일을 컨테이너에 복사
ARG JAR_FILE=step07_cicd-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} app.jar

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "/app.jar"]

# 컨테이너의 8080 포트 열기
EXPOSE 8080
