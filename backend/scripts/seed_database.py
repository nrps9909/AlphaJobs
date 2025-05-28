import requests
import json
import os

def seed_database():
    # 讀取 JSON 檔案
    with open('../data/jobs_data.json', 'r', encoding='utf-8') as file:
        data = json.load(file)
    
    # API endpoint
    api_url = os.environ.get('API_URL', 'http://localhost:3000/api/v1/seed')
    
    # 發送 POST 請求
    try:
        response = requests.post(api_url, json=data)
        if response.status_code == 201:
            print("資料庫初始化成功！")
        else:
            print(f"錯誤：{response.status_code} - {response.text}")
    except Exception as e:
        print(f"連接錯誤：{e}")

if __name__ == "__main__":
    seed_database()
