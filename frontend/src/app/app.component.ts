import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { JobService } from './services/job.service';
import { CompanyService } from './services/company.service';
import { Job } from './models/job.model';
import { CompanyStats } from './models/company.model';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [CommonModule, FormsModule],
  template: `
    <div class="container">
      <h1>職缺查詢與公司統計系統</h1>
      
      <div class="glass-card">
        <div class="tab-container">
          <button 
            class="tab-button" 
            [class.active]="activeTab === 'jobs'"
            (click)="activeTab = 'jobs'">
            職缺列表
          </button>
          <button 
            class="tab-button" 
            [class.active]="activeTab === 'stats'"
            (click)="activeTab = 'stats'">
            公司統計
          </button>
        </div>

        <div *ngIf="activeTab === 'jobs'">
          <div class="search-box">
            <input 
              type="text" 
              class="search-input" 
              placeholder="搜尋職缺名稱..."
              [(ngModel)]="searchKeyword"
              (keyup.enter)="searchJobs()">
            <button class="search-button" (click)="searchJobs()">搜尋</button>
          </div>

          <div *ngIf="loading" class="loading">載入中...</div>
          
          <div *ngIf="!loading && jobs.length === 0" class="no-results">
            沒有找到相關職缺
          </div>

          <div *ngIf="!loading && jobs.length > 0">
            <div class="job-card" *ngFor="let job of jobs">
              <div class="job-title">{{ job.title }}</div>
              <div class="company-name">{{ job.company.name }}</div>
              <div class="salary-range">
                NT$ {{ job.min_salary | number }} - {{ job.max_salary | number }}
              </div>
              <div style="margin-top: 0.5rem; color: #666;">
                {{ job.description }}
              </div>
            </div>
          </div>
        </div>

        <div *ngIf="activeTab === 'stats'">
          <div *ngIf="loadingStats" class="loading">載入統計資料中...</div>
          
          <div *ngIf="!loadingStats" class="stats-grid">
            <div class="stat-card" *ngFor="let stat of companyStats">
              <div class="stat-company">{{ stat.name }}</div>
              <div class="stat-value">NT$ {{ stat.average_salary | number }}</div>
              <div class="stat-label">平均薪資</div>
              <div style="margin-top: 1rem;">
                <div class="stat-value">{{ stat.high_salary_jobs_count }}</div>
                <div class="stat-label">高薪職缺數量 (>10萬)</div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  `,
  styles: []
})
export class AppComponent implements OnInit {
  activeTab: 'jobs' | 'stats' = 'jobs';
  jobs: Job[] = [];
  companyStats: CompanyStats[] = [];
  searchKeyword = '';
  loading = false;
  loadingStats = false;

  constructor(
    private jobService: JobService,
    private companyService: CompanyService
  ) {}

  ngOnInit() {
    this.loadJobs();
    this.loadCompanyStats();
  }

  loadJobs() {
    this.loading = true;
    this.jobService.getJobs().subscribe({
      next: (jobs) => {
        this.jobs = jobs;
        this.loading = false;
      },
      error: (error) => {
        console.error('Error loading jobs:', error);
        this.loading = false;
      }
    });
  }

  loadCompanyStats() {
    this.loadingStats = true;
    this.companyService.getStatistics().subscribe({
      next: (stats) => {
        this.companyStats = stats;
        this.loadingStats = false;
      },
      error: (error) => {
        console.error('Error loading statistics:', error);
        this.loadingStats = false;
      }
    });
  }

  searchJobs() {
    if (this.searchKeyword.trim()) {
      this.loading = true;
      this.jobService.searchJobs(this.searchKeyword).subscribe({
        next: (jobs) => {
          this.jobs = jobs;
          this.loading = false;
        },
        error: (error) => {
          console.error('Error searching jobs:', error);
          this.loading = false;
        }
      });
    } else {
      this.loadJobs();
    }
  }
}
