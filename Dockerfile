FROM growerp/flutter-sdk-image

# Set working directory
WORKDIR /app

# Copy your project files to the container
COPY . /app

# Change ownership of the copied files
USER root
RUN chown -R mobiledevops:mobiledevops /app
USER mobiledevops

# Get Flutter dependencies and build
RUN flutter pub get
RUN flutter build apk --release
