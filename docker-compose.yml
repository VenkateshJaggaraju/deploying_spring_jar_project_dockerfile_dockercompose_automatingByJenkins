version: "3.3"

services:
  db:
    image: mysql:8.0
    container_name: mysql-db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: appdb
      MYSQL_USER: appuser
      MYSQL_PASSWORD: apppass
    ports:
      - "3307:3306"
    healthcheck:
      test: ["CMD", "mysqladmin", "ping", "-h", "localhost"]
      interval: 10s
      timeout: 5s
      retries: 5

  app:
    image: karthikan123/spring_project2003:v1
    container_name: springboot-app
    depends_on:
      db:
        condition: service_healthy
    ports:
      - "8085:8080"
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://db:3306/appdb
      SPRING_DATASOURCE_USERNAME: appuser
      SPRING_DATASOURCE_PASSWORD: apppass
    restart: always
