## K8s-SpringBoot-Service

### 프로젝트 개요

Kubernetes를 활용해 Spring Boot 애플리케이션을 배포하고, LoadBalancer와 NodePort를 통해 서비스를 노출하는 방법을 구현했습니다. 

이를 통해 고가용성 및 확장성을 갖춘 클라우드 네이티브 인프라 환경을 구축했으며, Kubernetes의 오케스트레이션 기능을 활용해 효율적이고 안정적인 운영을 목표로 했습니다.

### 🥅 프로젝트 목표

Kubernetes를 활용한 Spring Boot 애플리케이션 배포 및 비용 절감

## 🛠️ Stack

| Category                  | Technology                                                                 |
|---------------------------|---------------------------------------------------------------------------|
| 🐳 **Containerization**    | ![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white) |
| ☸️ **Orchestration**       | ![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white) |
| ☁️ **Cloud & DevOps**      | ![Docker Hub](https://img.shields.io/badge/Docker%20Hub-0db7ed?style=for-the-badge&logo=docker&logoColor=white) |
| ⚙️ **Backend Framework**   | ![Spring Boot](https://img.shields.io/badge/Spring%20Boot-6DB33F?style=for-the-badge&logo=spring&logoColor=white) |
| 🛠 **Build Tool**          | ![Gradle](https://img.shields.io/badge/Gradle-02303A?style=for-the-badge&logo=gradle&logoColor=white) |
| 🧑‍💻 **Programming Language** | ![Java](https://img.shields.io/badge/Java-007396?style=for-the-badge&logo=java&logoColor=white) |
| 🐧 **Operating System**    | ![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=white) ![Ubuntu](https://img.shields.io/badge/Ubuntu-E95420?style=for-the-badge&logo=ubuntu&logoColor=white) |
| 📡 **Networking**          | ![Load Balancer](https://img.shields.io/badge/Load%20Balancer-0078D4?style=for-the-badge&logo=azure-load-balancer&logoColor=white) |


## 📖 Process

1. Spring Boot 애플리케이션 빌드

```
./gradlew build
```

Gradle을 사용하여 JAR 파일을 생성


2. Docker 이미지 빌드 (Dockerfile 사용)

```
docker build -t wonho/springboot-app:latest .
```

JAR 파일을 포함한 Spring Boot Docker 이미지 생성

3. Docker Hub 로그인

```
docker login
```
Docker Hub에 로그인하여 컨테이너 이미지를 업로드할 준비

4. Docker Hub에 이미지 푸시

```
docker push dnjsgh1204/springboot-app:latest
```

빌드한 이미지를 Docker Hub에 업로드

6. Kubernetes Deployment 생성 (deployment.yaml 적용)

```
kubectl apply -f deployment.yaml
```
deployment.yaml을 적용하여 Spring Boot 애플리케이션을 Kubernetes에 배포

7. 서비스 노출 (Service 설정)

- LoadBalancer 방식 적용 (클라우드 환경에서 사용 가능)

```
kubectl apply -f service-loadbalance.yaml
```

- NodePort 방식 적용 (로컬 환경 또는 클러스터 내부에서 사용 가능)

```
kubectl apply -f service-nodeport.yaml
```
두 개의 서비스 설정 파일(service-loadbalance.yaml, service-nodeport.yaml)을 사용하여 외부에서 접근 가능하도록 설정

8.배포 확인 및 서비스 테스트

```
kubectl get pods
kubectl get svc
curl 192.168.49.2:30001/fisa1  # NodePort를 통한 접근 테스트
```

9.  kubernetes에서 애플리케이션 배포

- Deployment 생성: springboot-app을 실행하는 Kubernetes Deployment를 생성

- Service 설정: LoadBalancer와 NodePort 방식을 활용하여 외부에서 접근 가능하도록 설정

---

### 결과


![image](https://github.com/user-attachments/assets/b7f65b19-3314-4103-883b-e71c8e3d4d04)

![image](https://github.com/user-attachments/assets/07aa9a56-bae3-4a42-a8ca-35b9db552804)

- Spring Boot 애플리케이션을 Kubernetes에 배포하고, NodePort와 LoadBalancer 서비스를 통해 외부 접근을 테스트하였습니다. 

- kubectl get pods 및 kubectl get svc로 배포 상태를 확인하고, curl 192.168.49.2:30001/fisa1 요청이 성공적으로 응답함을 확인하였습니다.


## 💻Code File

```
# deployment.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  name: springboot-app
spec:
  replicas: 2  # 실행할 Pod의 개수 (2개의 복제본을 실행)
  selector:
    matchLabels:
      app: springboot-app  # 이 레이블을 가진 Pod를 선택
  template:
    metadata:
      labels:
        app: springboot-app  # Pod에 해당 레이블을 부여
    spec:
      containers:
      - name: springboot-app
        image: dnjsgh1204/springboot-app:latest  # Docker Hub에서 가져올 이미지
        ports:
        - containerPort: 8080  # 컨테이너에서 사용할 포트

```

```
# service-loadbalancer.yaml

apiVersion: v1
kind: Service
metadata:
  name: springboot-app-service-loadbalancer
spec:
  selector:
    app: springboot-app
  ports:
    - protocol: TCP
      port: 80   # 외부에서 접근할 포트
      targetPort: 8089  # 컨테이너 내 Spring Boot 포트
  type: LoadBalancer  # 외부 IP 할당

```

```
# service-nodeport.yaml

apiVersion: v1
kind: Service
metadata:
  name: springboot-app-service-nodeport
spec:
  selector:
    app: springboot-app
  ports:
    - protocol: TCP
      port: 80    # 외부에서 접근할 포트
      targetPort: 8089  # 컨테이너 내 포트
      nodePort: 30001  # 노드의 포트 (외부에서 접근할 수 있게 설정)
  type: NodePort   # 로컬 클러스터 외부 접근

```

```
# Dockerfile

# 기본 이미지 설정 (Java 17 기반)
FROM openjdk:17-jdk-slim

# 애플리케이션의 JAR 파일을 컨테이너에 복사
ARG JAR_FILE=step07_cicd-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} app.jar

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "/app.jar"]

# 컨테이너의 8080 포트 열기
EXPOSE 8080

```

## 💥 TroubleShooting


![image](https://github.com/user-attachments/assets/95a9e661-b46e-4156-9741-5466e9ccef26)

```
wonho@ubuntu:~/01.service$ curl 192.168.49.2:30001
curl: (7) Failed to connect to 192.168.49.2 port 30001 after 0 ms: Couldn't connect to server
```

### 🔍 원인
- Spring Boot 서버의 실행 포트와 Kubernetes 서비스(NodePort)의 targetPort가 일치하지 않음.

- Deployment의 containerPort와 Service의 targetPort가 서로 다를 경우 요청이 정상적으로 전달되지 않음.

### ✅ 해결 방법
Spring Boot 실행 포트 확인

```
kubectl logs <springboot-app-pod>
```
- 로그에서 Tomcat started on port XXXX 확인

<br>

Service 설정 수정 (service-nodeport.yaml)

```
ports:
  - protocol: TCP
    port: 80
    targetPort: <Spring Boot 실행 포트>  # Tomcat이 실행된 포트로 변경
    nodePort: 30001
```

<br>

- Service 재배포

```
kubectl apply -f service-nodeport.yaml
```
<br>


- 연결 확인

```
curl 192.168.49.2:30001
```

- 결과 : 서비스 포트와 애플리케이션 실행 포트의 일관성을 유지하는 것이 중요