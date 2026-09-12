# Usiamo 'jammy' al posto di 'alpine' perché supporta i processori ARM64
FROM eclipse-temurin:25-jdk-jammy
COPY target/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]