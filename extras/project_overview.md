# EXOME Project Overview

The **EXOME** project appears to be a local clone or monorepo containing the source code for the entire **Home Assistant** ecosystem. It includes the Core logic, Frontend interface, and Supervisor for managing the system.

## Directory Structure

### `core` (Home Assistant Core)
- **Language**: Python (requires >= 3.13)
- **Version**: `2026.2.0.dev0` (Development version)
- **Path**: `l:\shared F\EXOME\core`
- **Description**: The heart of Home Assistant. It manages all the integrations, automations, and state logic.
- **Key Files**: `pyproject.toml` (dependencies & config), `homeassistant/` (source code).

### `frontend` (Home Assistant Frontend)
- **Language**: TypeScript / JavaScript (Node.js)
- **Version**: `1.0.0`
- **Path**: `l:\shared F\EXOME\frontend`
- **Description**: The web interface for Home Assistant by Nabu Casa.
- **Key Files**: `package.json` (NPM dependencies), `src/` (source code), `hassio/`, `gallery/`, `cast/`, `demo/` (sub-projects).

### `supervisor` (Home Assistant Supervisor)
- **Language**: Python
- **Path**: `l:\shared F\EXOME\supervisor`
- **Description**: Manages the Home Assistant Core and Add-ons on Home Assistant OS/Supervised installations.
- **Key Files**: `setup.py`, `supervisor/` (source code), `Dockerfile`.

### Others
- **`operating-system`**: Likely contains the build scripts and configuration for Home Assistant OS (Buildroot based).
- **`developers.home-assistant`**: Documentation source for the developer portal.
- **`home-assistant.io`**: Source for the main Home Assistant website.

## Summary
The project is a comprehensive collection of the major components that make up the Home Assistant platform. It allows for full-stack development, from the backend logic in Python to the frontend UI in TypeScript, and system management via the Supervisor.
