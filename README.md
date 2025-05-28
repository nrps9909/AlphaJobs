# Job Portal - 職缺查詢與公司統計系統

**Job Portal** 是一個現代化的求職平台，旨在提供流暢的職缺搜索體驗以及富有洞察力的公司薪資統計數據。該平台採用前後端分離架構，後端使用 Ruby on Rails 构建強大的 API，前端則使用 Angular 打造交互式用戶界面。

## ✨ 主要功能

*   **🔍 職缺瀏覽與搜索**：
    *   實時列出所有已發布的職缺。
    *   支持通過關鍵詞快速篩選和搜索職缺標題。
*   **📊 公司薪資統計**：
    *   展示各公司的平均薪資水平。
    *   統計並顯示每家公司高薪職位（例如，最低年薪超過特定閾值）的數量。
*   **🔄 數據初始化**：
    *   提供 API 端點，可從預設的 JSON 數據源快速填充或重置數據庫，方便開發與演示。

## 🛠️ 技術棧

| 組件     | 技術                                                                 |
| :------- | :------------------------------------------------------------------- |
| **後端** | Ruby on Rails 7 (API 模式), Mongoid (MongoDB ODM), Puma, Rack CORS     |
| **前端** | Angular 17, TypeScript, RxJS, Nginx (Docker 環境中)                   |
| **數據庫** | MongoDB (推薦雲端部署如 MongoDB Atlas)                               |
| **容器化** | Docker, Docker Compose (用於本地開發)                                |
| **部署**   | Heroku (已配置 `app.json` 和 `Procfile`)                             |

## 🚀 開始使用 (本地開發)

### 📋 先決條件

*   [Docker](https://www.docker.com/get-started) (版本 20.x 或更高)
*   [Docker Compose](https://docs.docker.com/compose/install/) (版本 1.29.x 或更高)
*   (可選) [Ruby](https://www.ruby-lang.org/en/documentation/installation/), [Rails](https://rubyonrails.org/), [Node.js](https://nodejs.org/), [Angular CLI](https://angular.io/cli) (若需在容器外進行某些操作)

### ⚙️ 安裝與配置

1.  **克隆本倉庫**：
    ```bash
    git clone https://github.com/nrps9909/job-portal.git
    cd job-portal
    ```

2.  **配置環境變量**：
    在專案根目錄下，複製 `.env.example` (如果提供) 或手動創建一個名為 `.env` 的文件，並填寫以下內容。**此文件包含敏感信息，已被 `.gitignore` 忽略，請勿提交到版本控制。**

    ```ini
    # .env (本地開發環境變量)

    # MongoDB Atlas 連接信息 (請替換為你自己的憑證和集群信息)
    MONGODB_USER=nrps9909
    MONGODB_PASSWORD=YOUR_ATLAS_PASSWORD # << 替換為你的 Atlas 密碼
    MONGODB_CLUSTER_HOST=alphaloan.8hg5896.mongodb.net # << 你的 Atlas 集群主機
    MONGODB_DATABASE=job_portal # 你的數據庫名稱
    MONGODB_APP_NAME=alphaloan # (可選) 你的應用名稱標識

    # Rails 開發環境的 SECRET_KEY_BASE
    # 可以通過在 backend 目錄運行 `bundle exec rails secret` 生成一個
    DEV_SECRET_KEY_BASE=替換為一個長且隨機的字符串
    ```
    *   **獲取 `DEV_SECRET_KEY_BASE`**: 在 `backend` 目錄下運行 `bundle exec rails secret` 命令，並將輸出的密鑰粘貼到 `.env` 文件中。如果本地沒有 Ruby 環境，可以在 Docker 容器啟動後進入容器生成。

3.  **構建並啟動 Docker 容器**：
    此命令將根據 `docker-compose.yml` 的配置，構建後端和前端服務的 Docker 鏡像，並在後台啟動它們。
    ```bash
    sudo docker-compose up --build -d
    ```
    *   後端 Rails API 將運行在 `http://localhost:3000`。
    *   前端 Angular 應用 (由 Nginx 服務) 將運行在 `http://localhost:4200`。

4.  **初始化數據庫 (數據播種)**：
    為了讓應用有初始數據進行展示和測試，請執行以下命令調用後端 API 來填充數據庫：
    ```bash
    curl -X POST http://localhost:3000/api/v1/seed
    ```
    成功後，你將收到 `{"message":"Database seeded successfully"}` 的響應。數據源來自 `data/jobs_data.json`。

5.  **訪問應用程序**：
    *   **前端界面**：在你的網頁瀏覽器中打開 `http://localhost:4200`。
    *   **後端 API (示例)**：
        *   所有職缺：`http://localhost:3000/api/v1/jobs`
        *   公司統計：`http://localhost:3000/api/v1/companies/statistics`

### 🐳 常用的 Docker Compose 命令

*   **啟動所有服務 (後台模式)**： `sudo docker-compose up -d`
*   **停止所有服務**： `sudo docker-compose stop`
*   **停止並移除容器、網絡和匿名卷**： `sudo docker-compose down -v`
*   **重新構建鏡像並啟動**： `sudo docker-compose up --build -d`
*   **查看所有服務的實時日誌**： `sudo docker-compose logs -f`
*   **查看特定服務的日誌**： `sudo docker-compose logs -f backend` (或 `frontend`)
*   **進入後端容器的 Rails Console**： `sudo docker-compose exec backend bundle exec rails c`
*   **進入後端容器的 Shell 環境**： `sudo docker-compose exec backend bash`

## 📖 API 端點參考

| 方法 | 路徑                               | 描述                         |
| :--- | :--------------------------------- | :--------------------------- |
| GET  | `/api/v1/jobs`                     | 獲取所有職缺列表             |
| GET  | `/api/v1/jobs/search?keyword=:term`| 根據關鍵詞 `:term` 搜索職缺 |
| GET  | `/api/v1/companies/statistics`     | 獲取公司統計數據             |
| POST | `/api/v1/seed`                     | 從 JSON 文件初始化數據庫     |

## ☁️ Heroku 部署指南

此應用已配置為可部署至 Heroku 平台。

### 準備工作

1.  確保已安裝 [Heroku CLI](https://devcenter.heroku.com/articles/heroku-cli) 並成功登錄 (`heroku login`)。
2.  你的專案已使用 Git 進行版本控制。

### 部署步驟

1.  **創建 Heroku 應用**：
    ```bash
    heroku create your-unique-app-name --buildpack heroku/nodejs --buildpack heroku/ruby
    ```
    *   `your-unique-app-name` 替換為你想要的應用名稱。
    *   我們明確指定了 Node.js buildpack (用於構建 Angular) 和 Ruby buildpack (用於運行 Rails)。Heroku 會按指定順序執行它們。

2.  **添加 MongoDB 數據庫插件**：
    從 Heroku Dashboard 或通過 CLI 為你的應用添加一個 MongoDB 插件 (例如，MongoDB Atlas 的 Heroku Add-on 是推薦的選擇)。這將自動為你的應用設置 `MONGODB_URI` 環境配置變量。

3.  **設置必要的環境配置變量 (Config Vars)**：
    *   **`RAILS_MASTER_KEY`**: 這是解密 `config/credentials.yml.enc` 的主密鑰。
        ```bash
        # 1. 確保你的 backend/config/master.key 文件存在且包含正確的密鑰。
        #    此文件絕對不能提交到 Git！
        # 2. 設置到 Heroku:
        heroku config:set RAILS_MASTER_KEY=$(cat backend/config/master.key) --app your-unique-app-name
        ```
    *   **`SECRET_KEY_BASE`**: 用於 Rails session 和 message verifiers。
        ```bash
        # 在本地 backend 目錄下生成一個適用於生產的密鑰
        # bundle exec rails secret
        # 然後將生成的密鑰設置到 Heroku:
        heroku config:set SECRET_KEY_BASE=your_generated_production_secret_key --app your-unique-app-name
        ```
    *   **`RAILS_ENV`**: 確保設置為 `production`。
        ```bash
        heroku config:set RAILS_ENV=production --app your-unique-app-name
        ```
    *   **(重要安全)** **`CORS_ORIGINS` 或配置 CORS**:
        為了安全，生產環境的 CORS `origins` 應限制為你的前端應用域名 (即 `https://your-unique-app-name.herokuapp.com`)。
        你需要在 `backend/config/initializers/cors.rb` 中修改 `origins` 的值，使其可以從環境變量讀取，或者在 Heroku 上直接配置一個允許的來源列表。
        一個簡單（但不推薦用於嚴格生產）的方法是暫時保持 `origins '*'`，但請注意其安全隱患。
        更好的方法是：
        ```ruby
        # backend/config/initializers/cors.rb
        Rails.application.config.middleware.insert_before 0, Rack::Cors do
          allow do
            origins ENV.fetch('CORS_ORIGINS') { '*' }.split(',') # 從環境變量讀取，默認為 '*'
            resource '*',
              headers: :any,
              methods: [:get, :post, :put, :patch, :delete, :options, :head]
          end
        end
        ```
        然後在 Heroku 設置 `CORS_ORIGINS`:
        ```bash
        heroku config:set CORS_ORIGINS=https://your-unique-app-name.herokuapp.com --app your-unique-app-name
        ```

4.  **配置前端靜態文件服務**：
    Heroku 的 Ruby buildpack 默認由 Rails (Puma) 服務所有請求。你需要確保 Angular 的構建產物被 Rails 服務。
    *   **構建步驟**：`heroku/nodejs` buildpack 需要運行 `npm run build` (或 `yarn build`) 來編譯 Angular 應用。確保 `frontend/package.json` 中的 `build` 腳本正確配置為生產構建。
    *   **產物移動**：你需要一個機制 (例如，在 `frontend/package.json` 的 `postbuild` 腳本，或者 Heroku 的 `bin/heroku-postbuild` 腳本) 將 `frontend/dist/frontend/` (或你的 Angular 輸出目錄) 下的內容複製到 Rails 後端的 `public/` 目錄下。
        例如，在 `frontend/package.json` 的 `scripts` 中添加：
        ```json
        "scripts": {
          "ng": "ng",
          "start": "ng serve",
          "build": "ng build --configuration production",
          "postbuild": "cp -a dist/frontend/. ../backend/public/", // << 將產物複製到後端 public
          "watch": "ng build --watch --configuration development"
        },
        ```
        或者在專案根目錄創建 `bin/heroku-postbuild` (確保有執行權限 `chmod +x bin/heroku-postbuild`)：
        ```bash
        #!/bin/bash
        echo "-----> Running Heroku postbuild script"
        # 構建前端 (如果 buildpack 沒自動做，或者你想控制順序)
        # cd frontend
        # npm install
        # npm run build
        # cd ..

        echo "-----> Copying frontend build to backend public directory"
        rm -rf backend/public/* # 清理舊文件 (可選)
        cp -a frontend/dist/frontend/. backend/public/
        echo "-----> Frontend assets copied"
        ```
        Heroku 的 Node.js buildpack 通常會查找並執行 `heroku-postbuild` 腳本。
    *   **Rails 路由**：配置 Rails 以服務 `index.html` 並處理客戶端路由。
        在 `backend/config/routes.rb` 中，確保 API 路由之後有：
        ```ruby
        get '*path', to: 'application#fallback_index_html', constraints: ->(request) do
          !request.xhr? && request.format.html?
        end
        ```
        在 `backend/app/controllers/application_controller.rb` 中：
        ```ruby
        class ApplicationController < ActionController::API
          def fallback_index_html
            render file: 'public/index.html'
          end
        end
        ```

5.  **推送到 Heroku 進行部署**：
    ```bash
    git push heroku main # (或你的主分支)
    ```
    Heroku 將執行 buildpacks，運行 `release` 階段命令 (來自 `Procfile`)，然後啟動 `web` 進程。

6.  **(可選) 手動執行 Release Phase 命令**：
    `Procfile` 中的 `release: cd backend && bundle exec rake db:mongoid:create_indexes` 應會自動運行。
    如果需要手動播種數據 (僅建議首次部署或測試時，且注意安全性)：
    ```bash
    heroku run bash --app your-unique-app-name
    # 進入容器後
    # cd backend
    # curl -X POST http://localhost:$PORT/api/v1/seed # PORT 會由 Heroku 設置
    # exit
    ```
    或者，如果你的 API 端點可以從外部訪問（不推薦用於無保護的 seed 端點）：
    ```bash
    curl -X POST https://your-unique-app-name.herokuapp.com/api/v1/seed
    ```

7.  **打開應用**：
    ```bash
    heroku open --app your-unique-app-name
    ```
    並檢查 Heroku 日誌：
    ```bash
    heroku logs --tail --app your-unique-app-name
    ```

## 🔮 未來可能的改進

*   **用戶認證與授權**：為 API 端點添加保護機制 (如 JWT, Devise)。
*   **更精細的錯誤處理**：在前端和後端提供更友好和詳細的錯誤信息。
*   **單元與集成測試**：為後端邏輯和前端組件編寫全面的測試用例。
*   **分頁與加載更多**：對於大量職缺或公司數據，實現分頁或無限滾動。
*   **高級搜索過濾**：提供更豐富的職缺搜索篩選條件 (如地點、薪資範圍、公司等)。
*   **UI/UX 優化**：持續改進用戶界面和用戶體驗。
*   **生產環境日誌與監控**：集成更專業的日誌和應用性能監控服務。

## 🤝 貢獻

(如果你希望其他人貢獻，可以在此處添加貢獻指南)

## 📜 許可證

本專案採用 [MIT 許可證](LICENSE)。