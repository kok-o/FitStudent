# Build Stage
FROM debian:stable-slim AS build

# Install dependencies
RUN apt-get update && apt-get install -y curl git unzip xz-utils libglu1-mesa

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"
RUN flutter doctor

# Copy and build
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --release --base-href /

# Run Stage
FROM nginx:stable-alpine
COPY --from=build /app/build/web /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
