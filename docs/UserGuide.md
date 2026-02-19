# BC Dev Credit Control - User Guide

## Overview

BC Dev Credit Control is a comprehensive Business Central extension for credit management, debt collection, and accounts receivable control.

---

## Getting Started

### Installing the Extension

1. Open Business Central
2. Go to **Extension Management**
3. Upload and install the `BC Dev Credit Control` app
4. The extension will add a new Role Center and pages

### Initial Setup

1. Go to **Credit Control Setup** (search in the menu)
2. Configure:
   - Default Action Days (recommended: 7)
   - Auto-Escalate Days (recommended: 14)
   - Email settings for reminders
   - Collection scoring thresholds

---

## Setting Up Credit Controllers

### Creating Credit Controllers

1. Go to **Credit Controllers** (search in the menu)
2. Click **New**
3. Enter:
   - **User ID** - The BC user who will be a credit controller
   - **Name** - Full name
   - **Email** - Email address
   - **Default Action Days** - Days until action required (optional)

### Assigning Customers to Credit Controllers

1. Go to **Customer Credit Controllers**
2. Click **New**
3. Select the **Customer No.**
4. Select the **Credit Controller**
5. Set **Credit Status** (Approved, On Hold, Review Required, etc.)
6. Optionally set a **Credit Limit**

---

## Credit Limit Management

### Setting Credit Limits

1. Go to **Customer Credit Controllers**
2. Select the customer
3. Enter a **Credit Limit** amount
4. This overrides the customer's default credit limit

### Viewing Customer Credit Limits

1. Go to **Customer Credit Limits**
2. View all customers with:
   - Credit Limit
   - Current Balance
   - Outstanding Orders
   - **Available Credit** (calculated)
   - **Utilization %** (percentage of limit used)

### Credit Limit History

All credit limit changes are tracked:

1. View the customer's credit history
2. See:
   - Previous limit
   - New limit
   - Change date
   - Who made the change
   - Reason for change

---

## Credit Hold

### Putting a Customer on Credit Hold

When a customer exceeds their credit limit or has overdue balances:

1. Go to **Customer Credit Limits**
2. Select the customer
3. Click **Put On Credit Hold**
4. The customer will be blocked from new orders until released

### Removing Credit Hold

1. Go to **Customer Credit Limits**
2. Select the customer
3. Click **Remove Credit Hold**

---

## Companies House Lookup (UK)

### Verifying New Customers

For UK businesses, verify companies using Companies House data:

1. Open a Customer Card
2. Enter the Company Registration Number
3. The system will:
   - Verify the company exists and is active
   - Get incorporation date
   - Get company type (LTD, PLC, LLP, etc.)
   - Return a credit score (0-100)
   - **Suggest a credit limit** based on company age and score

### Credit Score

Based on:
- Company age
- Filing history
- Industry risk factors

Recommendations:
- 0-30: High risk, require prepayment
- 31-60: Medium risk, limited credit
- 61-100: Low risk, standard credit terms

---

## Payment Terms Recommendations

### Getting Recommendations

The system analyzes payment history and recommends payment terms:

1. Go to **Customer Card**
2. Run the payment terms recommendation function
3. See recommended terms based on:
   - Average days to pay
   - On-time payment rate
   - Payment behavior score

### Payment Behavior Score (0-100)

- 80-100: Excellent payer
- 60-79: Good payer
- 40-59: Average payer
- 20-39: Slow payer
- 0-19: Poor payer

---

## Interest Calculator

### Calculating Interest on Overdue Balances

1. Go to **Interest Calculator**
2. Enter:
   - Overdue amount
   - Days overdue
   - Interest rate (default: 8% statutory)
3. View calculated interest and total

### Interest Invoice

Generate interest invoices for overdue accounts:
- Automatically calculates interest
- Creates sales invoice for interest charges
- Uses customer's payment behavior to set appropriate rate

---

## Collections Agency

### Setting Up Agencies

1. Go to **Collections Agencies** (create if needed)
2. Enter:
   - Agency Code
   - Agency Name
   - Contact details
   - Commission percentage
   - File format preference (CSV, XML, Fixed Width)

### Sending to Collections

1. Identify customers 60+ days overdue
2. Go to **Collections Export**
3. Select agency
4. Export customer details

### Tracking Recoveries

1. Go to **Collections Agency Entries**
2. View:
   - All accounts sent to collections
   - Status (Pending, Sent, Withdrawn, Recovered, Partial)
   - Recovery amounts
   - Commission due

---

## Multi-Currency Support

### Viewing Currency Exposure

For customers with foreign currency:

1. Go to **Currency Exposure**
2. View per-currency exposure:
   - Outstanding amount in original currency
   - Outstanding amount in LCY
   - Credit limit in LCY
   - Last updated timestamp

### Total Exposure

View total exposure across all currencies converted to local currency.

---

## Customer Statement

### Generating Statements

1. Go to **Customer Credit Statement**
2. Select:
   - Customer No.
   - Statement Date
   - Whether to show aged summary
3. Preview or print

### Statement Contents

- Customer details and statement date
- Credit limit and available credit
- Itemized ledger entries with:
  - Document numbers
  - Posting dates
  - Due dates
  - Amounts
  - Days overdue
- Aged summary (optional)
- Payment stub

---

## Daily Use

### Viewing Customer Ledger Entries with Credit Control

1. Go to **Customer Ledger Entries**
2. See additional columns:
   - Credit Controller
   - Collection Score
   - Next Action Date
   - Promise To Pay Date
3. Use **Credit Control** menu to:
   - Set Next Action
   - Add Note
   - Promise to Pay
   - View Action Log

### Setting Next Action

1. Open a Customer Ledger Entry
2. Fill in **Next Action Date**
3. Fill in **Next Action** description
4. Entry appears on dashboard until resolved

### Recording Promise to Pay

1. Open Customer Ledger Entry
2. Set **Promise To Pay Date**
3. Set **Promise To Pay Amount**
4. Tracked in **Promise to Pay Tracking**

---

## Dashboards and Reports

### Credit Controller Role Center

- **Headline KPIs**:
  - Overdue Total
  - Customers Requiring Action
  - Promises Due This Week
  - Total Outstanding

- **Quick Links** to all major pages

### Reports

#### Aged Debt by Credit Controller
Grouped by credit controller.

#### Collection Metrics
- Days Sales Outstanding (DSO)
- Promise kept rates
- Aged debt breakdown
- Collection scores

#### Customer Credit Statement
Branded statements to send to customers.

---

## Promise to Pay Tracking

### Status Options

- **Pending** - Not yet due
- **Kept** - Customer paid as promised
- **Broken** - Customer didn't pay
- **Partial** - Customer paid less than promised

### Recording Payment

Mark promises as Kept, Broken, or Partial when payment is received.

---

## Action Log

All activities logged:
- Notes added
- Actions created/completed
- Promises to pay
- Disputes raised/resolved
- Credit status changes
- Credit limit changes
- Credit holds applied/removed
- Collections sent

---

## Credit Status Options

| Status | Meaning |
|--------|---------|
| (Blank) | Not reviewed |
| Approved | Credit approved |
| On Hold | Payment issues |
| Review Required | Needs review |
| Rejected | Credit rejected |
| Credit Limit Exceeded | Over limit |
| Payment Plan | On payment plan |
| Disputed | Amount disputed |
| Closed | Account closed |

---

## Best Practices

### Daily
1. Check Role Center headlines
2. Review entries with Next Action Date = today
3. Follow up on promises due
4. Check for overdue entries

### Weekly
1. Review aged debt report
2. Check collection metrics
3. Review customers with "Review Required" status
4. Follow up on broken promises
5. Review credit limit utilization

### Monthly
1. Review payment terms recommendations
2. Consider sending accounts to collections
3. Generate customer statements
4. Review interest charged

---

## Troubleshooting

### Credit Controller Not Showing
- Ensure User ID matches BC user exactly
- Check that Active = true

### Cannot See Credit Control Fields
- Ensure extension is installed
- Refresh the page
- Check permissions

### Promise Not Tracking
- Make sure Promise To Pay Date is set

### Credit Hold Not Working
- Check Credit Limit is set
- Verify customer in Credit Controller table

### Companies House Lookup Not Working
- Requires API key (contact administrator)
- Only works for UK companies

---

## Support

GitHub: https://github.com/johntaylormfc/BC-Dev-Credit-Control
