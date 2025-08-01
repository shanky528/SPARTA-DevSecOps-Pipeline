# DevSecOps Pipeline – Group Project

## Overview
This project demonstrates the design and implementation of a **modern DevSecOps automation pipeline**.  
It integrates:
- Continuous Integration / Continuous Delivery (CI/CD)
- Automated security testing (SAST and DAST)
- Infrastructure as Code (IaC)
- Continuous monitoring and incident response

The pipeline builds, tests, scans, and deploys a **Python Flask web application** as an example workload.

---

## Objectives
- Automate software build, test, and deployment using Jenkins.
- Integrate **SonarQube (SAST)** for static analysis and **OWASP ZAP (DAST)** for dynamic analysis.
- Use **Terraform** for automated infrastructure provisioning.
- Use **Prometheus + Alertmanager** for monitoring and alerting.
- Provide an **incident response workflow** for pipeline and production failures.

---

## Tools and Rationale

### CI/CD – **Jenkins**
- Industry-standard CI/CD tool
- Easy to integrate with GitHub, SonarQube, ZAP, Terraform
- Large plugin ecosystem

### Security Testing – **SonarQube & OWASP ZAP**
- **SonarQube:** Detects vulnerabilities, bugs, and code smells early (SAST)
- **OWASP ZAP:** Tests running applications for security weaknesses (DAST)

### IaC – **Terraform**
- Infrastructure provisioning with declarative templates
- Version control for infrastructure
- Supports multi-cloud and on-premises

### Monitoring – **Prometheus & Alertmanager**
- Prometheus: Metrics-based monitoring
- Alertmanager: Automated notifications on resource spikes or failures

---

## High-Level Architecture

```text
Developer Push (GitHub)
        |
        v
     Jenkins
  (Build & Test)
        |
        v
  SonarQube Scan (SAST)
        |
        v
Provision Environment (Terraform)
        |
        v
 Deploy App to Test Server
        |
        v
  OWASP ZAP Scan (DAST)
        |
        v
  Monitoring (Prometheus + Alertmanager)


