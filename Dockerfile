FROM growerp/flutter-sdk-image

# Set working directory
WORKDIR /app

# Copy your project files to the container
COPY . /app

# Change ownership of the copied files
USER root
RUN apt-get update && apt-get install -y sqlite3 libsqlite3-dev
ENV LD_LIBRARY_PATH="/usr/lib/x86_64-linux-gnu/:${LD_LIBRARY_PATH}"
RUN chown -R mobiledevops:mobiledevops /app
USER mobiledevops

# Get Flutter dependencies and build
RUN flutter pub get

