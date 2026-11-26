
# IA 462 Lab 4 — Software Supply Chain Security

## Repository Overview

This repository demonstrates software supply chain security using a Python Flask application, Docker, and GitHub Actions. The goal is to improve dependency security, build reproducibility, and vulnerability detection through automated security controls.

## Supply Chain Security Controls

### 1. Pinning vs. Floating Dependencies

Flask and Werkzeug are pinned to exact versions in requirements.txt. The requirements.lock file includes dependency hashes to verify package integrity. The Docker base image is pinned to a SHA256 digest to improve build reproducibility.

### 2. GitHub Dependency Security Tools

The GitHub Dependency Graph, Dependabot alerts, Dependabot security updates, secret scanning, and push protection are enabled. Dependabot is configured to check Python dependencies, Docker images, and GitHub Actions weekly.

Branch protection is configured as a final security control to require pull requests, approval, successful status checks, and conversation resolution before merging into main.

### 3. Dependency Confusion & Supply Chain Attacks

Exact dependency versions and hash verification reduce the risk of unexpected or tampered packages. Secret scanning and push protection help prevent accidental exposure of sensitive credentials.

### 4. Securing Dependencies in GitHub Actions

Third-party GitHub Actions are pinned to full commit SHAs instead of floating version tags. Workflow permissions are restricted to the access required for each task.

### 5. Software Bill of Materials (SBOM)

Syft generates an SBOM containing the packages installed in the Docker image. Local SBOM snapshots are stored in the sboms/ directory in SPDX, CycloneDX, and table formats.

An additional SPDX SBOM was exported directly from the GitHub Dependency Graph to document repository-level dependencies.

### 6. Integrating Dependency Scanning into CI/CD

The automated security pipeline performs four main tasks:

- Builds the Docker image.
- Scans the container for vulnerabilities using Trivy.
- Generates an SBOM using Syft.
- Audits Python dependencies using pip-audit.

The pipeline successfully passed after vulnerable dependencies and container packages were addressed.

### 7. GitHub's Dependency Review Action

Dependency Review checks pull requests for vulnerable dependencies and prohibited licenses. Dependencies with high or critical severity findings cause the review to fail.

## How to Reproduce the Vulnerable PR Demo

1. Create a branch named test/introduce-vulnerable-dep.
2. Change Flask and Werkzeug in requirements.txt to version 2.0.0.
3. Regenerate requirements.lock.
4. Commit and push the changes.
5. Open a pull request against main.
6. Observe the failed Dependency Review, pip-audit, and Trivy checks.
7. Close the pull request without merging.

During the demonstration, pip-audit detected 24 known vulnerabilities across two packages. The vulnerable pull request was closed without merging, and the main branch remained successful.

## Conclusion

This lab demonstrates how dependency pinning, hash verification, automated vulnerability scanning, SBOM generation, and GitHub security controls work together to reduce software supply chain risks.
