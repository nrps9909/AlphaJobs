# 職缺查詢與公司統計系統

這是一個現代化的職缺查詢系統，提供職缺搜尋和公司薪資統計功能。

## 🚀 技術棧

- **後端**: Ruby on Rails API
- **前端**: Angular 17
- **資料庫**: MongoDB (雲端)
- **容器化**: Docker & Docker Compose
- **部署**: Heroku

## 📋 功能特色

1. **職缺列表顯示**
   - 顯示所有職缺資訊
   - 包含公司名稱和薪資範圍

2. **關鍵字搜尋**
   - 即時搜尋職缺名稱
   - 支援中文搜尋

3. **公司統計資訊**
   - 各公司平均薪資
   - 高薪職缺數量統計（薪資下限 > 10萬）

## 🛠️ 本地開發環境設置

### 前置需求
- Docker & Docker Compose
- Git

### 快速開始

1. 克隆專案
```bash
git clone <repository-url>
cd homework
```

3. 設定環境變數
在 `docker-compose.yml` 中更新 MongoDB 連線字串：
```yaml
MONGODB_URI=mongodb+srv://your-username:your-password@cluster.mongodb.net/job_portal
```

4. 啟動服務
```bash
docker-compose up -d
```

5. 初始化資料庫
```bash
docker-compose exec backend rails runner "load 'scripts/seed_database.rb'"
```

6. 訪問應用
- 前端: http://localhost:4200
- 後端 API: http://localhost:3000/api/v1

## 📦 API 端點

### 職缺相關
- `GET /api/v1/jobs` - 取得所有職缺
- `GET /api/v1/jobs/search?keyword={keyword}` - 搜尋職缺

### 公司統計
- `GET /api/v1/companies/statistics` - 取得公司統計資訊

### 資料初始化
- `POST /api/v1/seed` - 從 JSON 檔案初始化資料庫

## 🏗️ 專案結構

```
homework/
├── backend/               # Rails API 後端
│   ├── app/
│   │   ├── controllers/  # API 控制器
│   │   └── models/       # 資料模型
│   ├── config/           # 設定檔
│   └── scripts/          # 工具腳本
├── frontend/             # Angular 前端
│   ├── src/
│   │   ├── app/         # Angular 應用
│   │   └── assets/      # 靜態資源
│   └── Dockerfile
├── data/                 # 測試資料
│   └── jobs_data.json
├── docker-compose.yml    # Docker Compose 設定
└── README.md
```

## 🚀 部署到 Heroku

1. 安裝 Heroku CLI

2. 登入 Heroku
```bash
heroku login
```

3. 創建 Heroku 應用
```bash
heroku create your-app-name
```

4. 設定 MongoDB Atlas
- 在 MongoDB Atlas 創建免費叢集
- 取得連線字串
- 設定 Heroku 環境變數：
```bash
heroku config:set MONGODB_URI="your-mongodb-connection-string"
```

5. 部署應用
```bash
git push heroku main
```

## 🧪 測試資料

系統包含預設的測試資料（`data/jobs_data.json`），包括：
- 3 家公司：台積電、鴻海、聯發科
- 14 個職缺
- 各種薪資範圍的工作

## 📝 注意事項

- 確保 MongoDB 連線字串正確設定
- 首次執行需要初始化資料庫
- 前端開發伺服器預設在 4200 port
- 後端 API 預設在 3000 port

## 🤝 貢獻

歡迎提交 Issue 和 Pull Request！

## 📄 授權

MIT License
