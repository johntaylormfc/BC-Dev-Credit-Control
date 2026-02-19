# BC Dev Credit Control

Credit Control management extension for Dynamics 365 Business Central (SaaS).

## Features

### Core Features
- **Credit Controller Management** - Assign users as credit controllers
- **Customer Mapping** - Assign customers to specific credit controllers
- **Enhanced Notes** - Add detailed notes/comments to customer ledger entries
- **Next Action Tracking** - Set next action dates with full audit trail
- **Promise to Pay** - Track promised payment dates and amounts
- **Dispute Management** - Flag and track disputed amounts

### Additional Features (Based on Market Research)
- Aged debt profiling by credit controller
- Collection score calculation
- Credit status tracking (Approved, On Hold, Review Required)
- Full action audit log
- Private/internal notes option

## Architecture

```
src/
├── Table/           # Data tables
├── TableExtension/  # Extensions to standard tables
├── Page/            # UI pages
├── Codeunit/        # Business logic
└── Report/          # Reports
```

## Getting Started

### Prerequisites
- Visual Studio Code
- AL Language Extension (v12+)
- Business Central SaaS Sandbox (version 25)

### Local Development

1. Clone the repository
2. Open in VS Code
3. Press F5 to launch the sandbox

### Building

```powershell
# Using AL-Go (recommended)
./build.ps1
```

## CI/CD Pipeline

### Option 1: GitHub Actions + Azure DevOps (Recommended for SaaS)

This extension uses GitHub Actions for CI/CD:

1. **Build**: On push to master, GitHub Actions builds the extension in Azure DevOps
2. **Test**: Runs automated tests
3. **Deploy**: Triggers local Docker rebuild via webhook

#### Setup

1. Configure Azure DevOps connection (see secrets below)
2. Set up GitHub webhook for local rebuild

### Option 2: Local Docker Rebuild on Push

For local testing, set up the webhook server:

```bash
# Start webhook server
cd cicd
python3 webhook-server.py

# Or use Docker
docker-compose up -d
```

### Required GitHub Secrets

Configure these in your GitHub repository settings:

- `AZURE_TENANT_ID` - Azure AD tenant
- `AZURE_CLIENT_ID` - Service principal ID
- `AZURE_CLIENT_SECRET` - Service principal secret
- `AZURE_SUBSCRIPTION_ID` - Azure subscription
- `GITHUB_WEBHOOK_SECRET` - Webhook secret (optional)

## Tables

| Table ID | Name | Description |
|----------|------|-------------|
| 50100 | Credit Controller | Credit controller user definitions |
| 50101 | Customer Credit Controller | Customer to credit controller mapping |
| 50102 | Credit Action Log | Audit trail of all actions |
| 50103 | Credit Controller Note | Detailed notes on ledger entries |

## Table Extensions

- **Cust. Ledger Entry** - Adds credit control fields (Next Action, Promise to Pay, etc.)

## Codeunits

- **Credit Control Management** (50100) - Business logic for credit control operations

## Reports

- **Aged Debt by Credit Controller** - Aged debt report grouped by credit controller

## License

MIT
