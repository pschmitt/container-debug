# Agent notes

This repository builds a small container image with command-line tools for
debugging container and Kubernetes environments.

- Build locally with `docker build -t pschmitt/debug .`.
- The `main` push workflow builds and publishes the image through
  [ci-workflows](https://github.com/pschmitt/ci-workflows); do not change
  publication settings without an explicit request.
- Before changing CI, check for a reusable workflow or action there and
  preserve the caller's existing behavior and check coverage.
- There is no dedicated automated test suite. Smoke-test changes using the
  Docker and Kubernetes examples in `README.md` where appropriate.
