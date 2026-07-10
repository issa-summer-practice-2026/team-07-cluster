FROM node:lts AS frontend-builder
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/ .
RUN npm run build

FROM python:3.11-slim
WORKDIR /app
COPY backend/requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY backend/ ./backend
COPY --from=frontend-builder /app/frontend/dist ./frontend/dist

ARG APP_VERSION="unknown"
ENV APP_VERSION=${APP_VERSION}

ENV HOST=0.0.0.0
EXPOSE 8000
WORKDIR /app/backend
CMD ["python", "-m", "app"]