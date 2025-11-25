# Spring Boot Demo Application

A lightweight web application built with Spring Boot and containerized with Docker for easy deployment anywhere. This project demonstrates modern application development practices using containerization technology to ensure consistent behavior across different environments.

## What You Need

Just install Docker Desktop [https://www.docker.com/products/docker-desktop] on your computer. Docker handles everything else automatically, including downloading the application, setting up the runtime environment, and managing all dependencies.

## Running the Application

Pull and run the application image from Docker Hub using this command:

**docker run -p 8080:8080 shoebmoehyd/sbapp:1.0**

Open your web browser and visit **http://localhost:8080** to see the application running. The application starts within seconds and runs in an isolated container environment on your machine.

## How It Works

Docker downloads the pre-built application image from Docker Hub, which contains everything needed to run the application - the compiled code, Java runtime, and all necessary libraries. It then starts the application on your computer and makes it accessible through your web browser on port 8080. No complicated setup, configuration, or manual installation of Java required. The containerized approach ensures the application runs the same way on any system that has Docker installed.

## For Developers

Want to customize the application? Build it yourself using Maven, then create your own Docker image and run it locally. You can modify the code, rebuild the image with your changes, and deploy it anywhere Docker runs - whether on your laptop, a server, or cloud platforms like AWS, Azure, or Google Cloud. This workflow mirrors how professional development teams build, test, and deploy applications in production environments.

## Technology Stack

**Spring Boot** powers the web application framework, providing a robust platform for building enterprise-grade Java applications with minimal configuration. **Docker** handles containerization and deployment, packaging the application and its dependencies into a portable container that runs consistently anywhere. **Java 17** provides the runtime environment with modern language features and performance improvements.