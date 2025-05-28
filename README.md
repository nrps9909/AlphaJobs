# Alphajobs - 阿發甲 | 工作查詢網

## [網站本人!!!](https://alphajobs-0fa68111ce13.herokuapp.com/)

**AlphaJobs** 是一個現代化的求職平台，旨在提供流暢的職缺搜尋體驗以及富有洞察力的公司薪資統計數據。該平台採用前後端分離架構，後端使用 Ruby on Rails 構建強大的 API，前端則使用 Angular 打造互動式使用者介面。

## ✨ 主要功能

* **🔍 職缺瀏覽與搜尋**：

  * 即時列出所有已發布的職缺。
  * 支援透過關鍵字快速篩選與搜尋職缺標題。
* **📊 公司薪資統計**：

  * 顯示各公司的平均薪資水準。
  * 統計並顯示每家公司高薪職位（例如，最低年薪超過特定門檻）的數量。
* **🔄 資料初始化**：

  * 提供 API 端點，可從預設的 JSON 資料來源快速填充或重置資料庫，方便開發與展示。

## 🛠️ 技術棧

| 組件      | 技術                                                          |
| :------ | :---------------------------------------------------------- |
| **後端**  | Ruby on Rails 7（API 模式）、Mongoid（MongoDB ODM）、Puma、Rack CORS |
| **前端**  | Angular 17、TypeScript、RxJS、Nginx（Docker 環境中）                |
| **資料庫** | MongoDB（推薦雲端部署如 MongoDB Atlas）                              |
| **容器化** | Docker、Docker Compose（用於本地開發）                               |
| **部署**  | Heroku（已配置 `app.json` 與 `Procfile`）                         |

## 🚀 開始使用（本地開發）

### 📋 先決條件

* [Docker](https://www.docker.com/get-started)（版本 20.x 或更高）
* [Docker Compose](https://docs.docker.com/compose/install/)（版本 1.29.x 或更高）
* （可選）[Ruby](https://www.ruby-lang.org/en/documentation/installation/)、[Rails](https://rubyonrails.org/)、[Node.js](https://nodejs.org/)、[Angular CLI](https://angular.io/cli)（若需在容器外進行某些操作）

### ⚙️ 安裝與配置

1. **複製本倉庫**：

   ```bash
   git clone https://github.com/nrps9909/job-portal.git
   cd job-portal
   ```

2. **配置環境變數**：
   在專案根目錄下，複製 `.env.example`（如果提供）或手動建立一個名為 `.env` 的檔案，並填寫以下內容。**此檔案包含敏感資訊，已被 `.gitignore` 忽略，請勿提交到版本控制。**

   ```ini
   # .env（本地開發環境變數）

   # MongoDB Atlas 連線資訊（請替換為你自己的憑證與叢集資訊）
   MONGODB_USER=YOU
   MONGODB_PASSWORD=YOUR_ATLAS_PASSWORD # << 替換為你的 Atlas 密碼
   MONGODB_CLUSTER_HOST=XXX.NET # << 你的 Atlas 叢集主機
   MONGODB_DATABASE=DATABASE # 你的資料庫名稱
   MONGODB_APP_NAME=APPNAME #（可選）你的應用名稱識別

   # Rails 開發環境的 SECRET_KEY_BASE
   # 可透過在 backend 目錄執行 `bundle exec rails secret` 產生
   DEV_SECRET_KEY_BASE=替換為一個長且隨機的字串
   ```

3. **建構並啟動 Docker 容器**：
   根據 `docker-compose.yml` 的設定建構並啟動前後端服務。

   ```bash
   sudo docker-compose up --build -d
   ```

   * 後端 Rails API 將運行於 `http://localhost:3000`。
   * 前端 Angular 應用（由 Nginx 提供服務）將運行於 `http://localhost:4200`。

4. **初始化資料庫（資料播種）**：
   執行以下指令調用後端 API 初始化資料庫：

   ```bash
   curl -X POST http://localhost:3000/api/v1/seed
   ```

   成功後會收到 `{"message":"Database seeded successfully"}` 的回應。資料來源為 `data/jobs_data.json`。

5. **存取應用程式**：

   * **前端介面**：瀏覽器開啟 `http://localhost:4200`
   * **後端 API（範例）**：

     * 所有職缺：`http://localhost:3000/api/v1/jobs`
     * 公司統計：`http://localhost:3000/api/v1/companies/statistics`

### 🐳 常用 Docker Compose 指令

* **啟動所有服務（背景模式）**： `sudo docker-compose up -d`
* **停止所有服務**： `sudo docker-compose stop`
* **移除容器、網路與匿名卷**： `sudo docker-compose down -v`
* **重新建構並啟動**： `sudo docker-compose up --build -d`
* **查看所有服務的即時日誌**： `sudo docker-compose logs -f`
* **查看指定服務日誌**： `sudo docker-compose logs -f backend`（或 `frontend`）
* **進入後端容器的 Rails Console**： `sudo docker-compose exec backend bundle exec rails c`
* **進入後端容器的 Shell 環境**： `sudo docker-compose exec backend bash`

## 📖 API 端點參考

| 方法   | 路徑                                  | 描述                 |
| :--- | :---------------------------------- | :----------------- |
| GET  | `/api/v1/jobs`                      | 取得所有職缺列表           |
| GET  | `/api/v1/jobs/search?keyword=:term` | 透過關鍵字 `:term` 搜尋職缺 |
| GET  | `/api/v1/companies/statistics`      | 取得公司統計資料           |
| POST | `/api/v1/seed`                      | 從 JSON 檔初始化資料庫     |

## 🔮 未來可能的改進

* **使用者驗證與授權**：為 API 端點新增保護機制（如 JWT、Devise）。
* **更精細的錯誤處理**：前後端提供更友善與詳細的錯誤提示。
* **單元與整合測試**：撰寫完整的後端邏輯與前端元件測試。
* **分頁與載入更多**：針對大量資料實作分頁或無限滾動。
* **進階搜尋篩選**：加入更多搜尋條件（如地點、薪資區間、公司等）。
* **UI/UX 優化**：持續改善使用者介面與體驗。
* **生產環境日誌與監控**：整合專業日誌與效能監控服務。

## 📜 授權條款

本專案採用 [MIT 授權條款](LICENSE)。
