FROM ruby:3.2

WORKDIR /app

# 安裝依賴
RUN apt-get update -qq && apt-get install -y nodejs

# 設定 bundler
RUN gem install bundler

# 複製 Gemfile
COPY Gemfile* ./

# 安裝 gems
RUN bundle install

# 複製應用程式
COPY . .

# 創建必要目錄
RUN mkdir -p log tmp/pids

# 暴露端口
EXPOSE 3000

# 啟動指令
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
