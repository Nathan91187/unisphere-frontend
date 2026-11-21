# UniSphere

UniSphere is a Flutter-based campus platform that helps university students discover events, explore clubs, and connect with their campus community.

## Tech Stack

- Flutter & Dart
- BLoC / Cubit
- Clean Architecture
- Java & Spring Boot
- PostgreSQL
- Firebase Authentication
- Cloudinary

## Features

- User authentication
- Event discovery, search, and filtering
- Event creation and management
- Event registration
- Club discovery and membership
- Club management and role administration
- User profiles

## Architecture

UniSphere follows a client-server architecture. The Flutter application communicates with a Spring Boot REST API, which handles business logic and data management using PostgreSQL.

Firebase Authentication handles user authentication, while Cloudinary manages image uploads.

## Deployment

- **Backend:** Render
- **Database:** Neon PostgreSQL

## Backend

The backend is maintained in a separate repository alongside the Flutter application.

- **Backend Repository:** [UniSphere Backend](<https://github.com/Nathan91187/unisphere-backend>)
