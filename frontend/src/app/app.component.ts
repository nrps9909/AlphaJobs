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
            (click)="setActiveTab('jobs')">
            職缺列表
          </button>
          <button
            class="tab-button"
            [class.active]="activeTab === 'stats'"
            (click)="setActiveTab('stats')">
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

          <div *ngIf="!loadingStats && (!companyStats || companyStats.length === 0)" class="no-results">
            目前沒有公司統計資料。
          </div>

          <div *ngIf="!loadingStats && companyStats && companyStats.length > 0" class="stats-grid">
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
  styles: [] // <--- 修正點：確保這是一個有效的空數組
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
    console.log('AppComponent OnInit: Initializing component and loading data.');
    this.loadJobs();
    this.loadCompanyStats();
  }

  setActiveTab(tabName: 'jobs' | 'stats') {
    console.log(`setActiveTab: Changing tab to "${tabName}". Current companyStats count: ${this.companyStats?.length}`);
    this.activeTab = tabName;
  }

  loadJobs() {
    console.log('loadJobs: Attempting to load jobs.');
    this.loading = true;
    this.jobService.getJobs().subscribe({
      next: (jobs) => {
        console.log('loadJobs: Successfully received jobs data.', jobs);
        this.jobs = jobs;
        this.loading = false;
      },
      error: (error) => {
        console.error('loadJobs: Error loading jobs.', error);
        this.loading = false;
      }
    });
  }

  loadCompanyStats() {
    console.log('loadCompanyStats: Attempting to load company statistics.');
    this.loadingStats = true;
    this.companyService.getStatistics().subscribe({
      next: (stats) => {
        console.log('loadCompanyStats: Successfully received company statistics data.', stats);
        this.companyStats = stats;
        console.log('loadCompanyStats: this.companyStats after assignment.', this.companyStats);
        this.loadingStats = false;
      },
      error: (error) => {
        console.error('loadCompanyStats: Error loading company statistics.', error);
        this.companyStats = [];
        this.loadingStats = false;
      }
    });
  }

  searchJobs() {
    console.log(`searchJobs: Attempting to search jobs with keyword "${this.searchKeyword}".`);
    if (this.searchKeyword.trim()) {
      this.loading = true;
      this.jobService.searchJobs(this.searchKeyword).subscribe({
        next: (jobs) => {
          console.log('searchJobs: Successfully received search results.', jobs);
          this.jobs = jobs;
          this.loading = false;
        },
        error: (error) => {
          console.error('searchJobs: Error searching jobs.', error);
          this.loading = false;
        }
      });
    } else {
      console.log('searchJobs: Keyword is empty, loading all jobs instead.');
      this.loadJobs();
    }
  }
}