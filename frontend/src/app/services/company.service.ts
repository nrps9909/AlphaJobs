import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { CompanyStats } from '../models/company.model';

@Injectable({
  providedIn: 'root'
})
export class CompanyService {
  private apiUrl = '/api/v1';

  constructor(private http: HttpClient) {}

  getStatistics(): Observable<CompanyStats[]> {
    return this.http.get<CompanyStats[]>(`${this.apiUrl}/companies/statistics`);
  }
}
