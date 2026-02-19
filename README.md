# BC Dev Credit Control

Credit Control management extension for Dynamics 365 Business Central (SaaS).

## Features

- **Credit Controller Management** - Assign users as credit controllers
- **Customer Mapping** - Assign customers to specific credit controllers
- **Enhanced Notes** - Add detailed notes/comments to customer ledger entries
- **Next Action Tracking** - Set next action dates with full audit trail
- **Promise to Pay** - Track promised payment dates and amounts
- **Dispute Management** - Flag and track disputed amounts
- **Aged Debt Report** - By credit controller
- **Full Audit Trail** - All actions logged

## Manual Deployment

### Prerequisites
- VS Code with AL Language extension
- Business Central Sandbox

### Steps

1. **Clone the repo**
   ```powershell
   git clone https://github.com/johntaylormfc/BC-Dev-Credit-Control.git
   cd BC-Dev-Credit-Control
   ```

2. **Open in VS Code**
   ```powershell
   code .
   ```

3. **Build** (F5 or Ctrl+Shift+B)

4. **Publish to Sandbox**
   ```powershell
   # Using BcContainerHelper
   Publish-BcContainerApp -containerName "YourContainer" -appFile ".\output\YourApp.app" -skipVerification -sync -install
   ```

## Extension Structure

```
src/
├── Table/           # Data tables
├── TableExtension/  # Extensions to standard tables
├── Page/            # UI pages
├── Codeunit/        # Business logic
└── Report/          # Reports
```

## Tables

| ID | Name |
|----|------|
| 50100 | Credit Controller |
| 50101 | Customer Credit Controller |
| 50102 | Credit Action Log |
| 50103 | Credit Controller Note |

## License

MIT
