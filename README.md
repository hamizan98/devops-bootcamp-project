# DevOps Bootcamp Final Project - jangaiman

## 1. Project Overview
Projek ini menunjukkan implementasi Automasi Infrastruktur (Terraform), Konfigurasi (Ansible), dan Keselamatan (Cloudflare Tunnel).

## 2. Infrastructure Architecture
- **Web Server**: Host aplikasi di `https://web.jangaiman.com`
- **Monitoring Server**: Host Prometheus & Grafana di `https://monitoring.jangaiman.com`
- **Security**: Monitoring server tidak mempunyai akses awam (No Public IP Access) dan dilindungi oleh Cloudflare Tunnel.

## 3. Monitoring Stack
- **Prometheus**: Mengumpul metrik dari Web Server.
- **Grafana**: Dashboard (ID: 1860) memaparkan metrik CPU, RAM, dan Disk secara real-time.

## 4. CI/CD Pipeline
- Menggunakan **GitHub Actions** untuk automasi deployment.
- Dokumentasi di-host menggunakan **GitHub Pages**.
