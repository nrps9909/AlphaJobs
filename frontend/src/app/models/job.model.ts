export interface Job {
  id: string;
  title: string;
  description: string;
  min_salary: number;
  max_salary: number;
  company: {
    id: string;
    name: string;
  };
}
