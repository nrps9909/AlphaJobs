# 多階段建構 Dockerfile
# 第一階段：建置前端
FROM node:18-slim as frontend-builder

WORKDIR /frontend
COPY frontend/package*.json ./
# 修改：安裝所有依賴，包括 devDependencies，以便 Angular CLI 可用
RUN npm ci

COPY frontend/ ./
RUN npm run build -- --configuration production

# 第二階段：建置後端和最終映像
FROM ruby:3.2-slim

# 安裝必要的系統依賴
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# 設置環境變數
ENV RAILS_ENV=production \
    BUNDLE_WITHOUT="development:test" \
    BUNDLE_DEPLOYMENT="true" \
    LANG=en_US.UTF-8 \
    RAILS_LOG_TO_STDOUT=enabled \
    RAILS_SERVE_STATIC_FILES=enabled \
    MALLOC_ARENA_MAX=2 \
    WEB_CONCURRENCY=2

WORKDIR /app

# 安裝 Ruby 依賴
COPY backend/Gemfile backend/Gemfile.lock ./
RUN gem install bundler -v "~> 2.0" && \
    bundle config set --local without 'development test' && \
    bundle install --jobs $(nproc) --retry 3

# 複製後端程式碼
COPY backend/ ./

# 從前端建構階段複製建置產物
COPY --from=frontend-builder /frontend/dist/frontend ./public

# 創建必要的目錄
RUN mkdir -p tmp/pids log

# Rails assets precompile (對於 API-only 應該會快速跳過)
RUN bundle exec rake assets:precompile || true

# 健康檢查
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s --retries=3 \
  CMD curl -f http://localhost:${PORT:-3000}/api/v1/jobs || exit 1

EXPOSE 3000

# 使用 shell 形式以支持環境變數替換
CMD bundle exec puma -C config/puma.rb