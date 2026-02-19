# BC Dev Credit Control - User Guide

## Overview

BC Dev Credit Control is a Business Central extension that helps credit controllers manage and track customer debts, promises to pay, and collection activities.

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

1. Go to the customer's credit history
2. View:
   - Previous limit
   - New limit
   - Change date
   - Who made the change
   - Reason for change

---

## Credit Hold

### Putting a Customer on Credit Hold

When a customer exceeds their credit limit or has overdue balances, you can put them on credit hold:

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

For UK businesses, you can verify companies using Companies House data:

1. Open a Customer Card
2. Look for the **Companies House** section (if enabled)
3. Enter the Company Registration Number
4. The system will:
   - Verify the company exists and is active
   - Get incorporation date
   - Get company type (LTD, PLC, LLP, etc.)
   - Return a credit score (0-100)
   - **Suggest a credit limit** based on company age and score

### Credit Score

The system calculates a score (0-100) based on:
- Company age
- Filing history
- Industry risk factors

Recommended actions based on score:
- 0-30: High risk, require prepayment
- 31-60: Medium risk, limited credit
- 61-100: Low risk, standard credit terms

---

## Daily Use

### Viewing Customer Ledger Entries with Credit Control

1. Go to **Customer Ledger Entries**
2. You'll see additional columns:
   - Credit Controller
   - Collection Score
   - Next Action Date
   - Promise To Pay Date
3. Use the **Credit Control** menu to:
   - Set Next Action
   - Add Note
   - Promise to Pay
   - View Action Log

### Setting Next Action

1. Open a Customer Ledger Entry
2. Fill in **Next Action Date** - When action is needed
3. Fill in **Next Action** - Description of what to do
4. The entry will appear on your dashboard until resolved

### Recording Promise to Pay

1. Open the Customer Ledger Entry
2. Fill in **Promise To Pay Date** - When customer promises payment
3. Fill in **Promise To Pay Amount** - Expected amount
4. The promise is tracked in **Promise to Pay Tracking**

---

## Dashboards and Reports

### Credit Controller Role Center

The extension adds a **Credit Controller** Role Center with:

- **Headline KPIs**:
  - Overdue Total - Amount overdue today
  - Customers Requiring Action - Entries needing attention
  - Promises Due This Week - Promises due soon
  - Total Outstanding - All open amounts

- **Quick Links** to:
  - Customers Requiring Action
  - Overdue Entries
  - Promises Due
  - Aged Debt Report
  - Collection Metrics

### Reports

#### Aged Debt by Credit Controller
Shows outstanding debt grouped by credit controller.

**To run:**
1. Search for **Aged Debt by Credit Controller**
2. Set the ending date
3. Click Preview or Print

#### Collection Metrics
Shows collection performance including:
- Days Sales Outstanding (DSO)
- Promise kept rates
- Aged debt breakdown
- Collection scores

---

## Promise to Pay Tracking

### Creating a Promise

1. Open a Customer Ledger Entry
2. Set **Promise To Pay Date**
3. Set **Promise To Pay Amount**
4. A promise record is automatically created

### Tracking Promises

1. Go to **Promise to Pay Tracking**
2. View all promises:
   - **Pending** - Not yet due
   - **Kept** - Customer paid as promised
   - **Broken** - Customer didn't pay
   - **Partial** - Customer paid less than promised

### Recording Payment

1. Open **Promise to Pay Tracking**
2. When customer pays:
   - Mark as **Kept** (full payment)
   - Mark as **Broken** (no payment)
   - Mark as **Partial** (partial payment)

---

## Action Log

All credit control activities are logged in the **Action Log**.

To view:
1. Search for **Credit Action Log**
2. Filter by:
   - Customer
   - Document
   - User
   - Date range

The log tracks:
- Notes added
- Actions created/completed
- Promises to pay
- Disputes raised/resolved
- Credit status changes
- Credit limit changes
- Customer assignments
- Escalations
- Credit holds applied/removed

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

### Daily Tasks
1. Check Role Center headlines
2. Review entries with Next Action Date = today
3. Follow up on promises due
4. Check for overdue entries

### Weekly Tasks
1. Review aged debt report
2. Check collection metrics
3. Review customers with "Review Required" status
4. Follow up on broken promises

### Credit Limit Management
- Set appropriate credit limits based on company history
- Review credit limits quarterly
- Use Companies House lookup for new customers
- Put high-risk customers on credit hold promptly

### Tips
- Set realistic Next Action Dates
- Log all customer contacts as notes
- Use the Action Log for audit trail
- Update Credit Status when circumstances change
- Review overdue entries at least weekly
- Monitor credit utilization % - act before 80%

---

## Troubleshooting

### Credit Controller Not Showing in List
- Ensure the User ID matches the BC user exactly
- Check that Active = true

### Cannot See Credit Control Fields
- Ensure extension is installed
- Refresh the page
- Check permissions

### Promise Not Tracking
- Make sure Promise To Pay Date is set on the ledger entry

### Credit Hold Not Working
- Check that Credit Limit is set on the customer
- Verify the customer is in the Customer Credit Controller table

### Companies House Lookup Not Working
- Requires API key configuration (contact your administrator)
- Only works for UK registered companies

---

## Support

For issues or feature requests:
- GitHub: https://github.com/johntaylormfc/BC-Dev-Credit-Control
