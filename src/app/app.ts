import {Component, OnInit, signal} from '@angular/core';
import { RouterOutlet } from '@angular/router';
import {environment} from '../environments/environment';
import {Environment} from '@angular/cli/lib/config/workspace-schema';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet],
  templateUrl: './app.html',
  standalone: true,
  styleUrl: './app.css'
})
export class App implements OnInit {


  protected readonly title = signal('env-app');
  api_url?: string;
  env?: string;
  env_process?: string;


  ngOnInit(): void {
    this.api_url = JSON.stringify(environment);
    this.env = JSON.stringify(import.meta.env);
    this.env_process = JSON.stringify(process.env);
  }

}
