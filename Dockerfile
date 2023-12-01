FROM growerp/flutter-sdk-image
WORKDIR /app
COPY . /app
RUN chmod -R 777 /app

# Adjust file permissions for specific directories

# Add similar lines for other necessary directories

RUN flutter pub get
RUN flutter build apk --release
