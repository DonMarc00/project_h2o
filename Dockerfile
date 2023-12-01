FROM growerp/flutter-sdk-image
WORKDIR /app
COPY . /app

# Adjust file permissions for specific directories

# Add similar lines for other necessary directories

USER root
RUN flutter pub get
RUN flutter build apk --release

USER mobiledevops
