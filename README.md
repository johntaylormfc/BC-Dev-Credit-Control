# BC Dev Credit Control

Credit Control management extension for Dynamics 365 Business Central (SaaS).

## Features

- Credit Controller user assignment
- Customer credit controller mapping
- Enhanced notes/comments on Customer Ledger Entries
- Next Action tracking with dates
- Full audit trail on all actions
- Aged debt profiling
- Promise-to-pay tracking
- Activity logging

## Getting Started

### Prerequisites

- Visual Studio Code
- AL Language Extension
- Business Central SaaS Sandbox

### Building

```powershell
./build.ps1
```

## CI/CD

This project uses GitHub Actions for CI/CD. On push to main:
1. Build runs in Azure DevOps
2. Extension is published to your local Docker container for testing

## License

MIT
