# User Manual - OpenClaw Contract Management

## Overview

OpenClaw Contract Management is a Business Central SaaS extension that handles contract-based recurring billing. It allows you to create customer contracts, automatically generate billing schedules, and convert unbilled periods into sales invoices.

---

## Getting Started

### Prerequisites
- Business Central SaaS environment
- OpenClaw Contract Management extension installed
- AL Extension for VS Code (for development)

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/johntaylormfc/openclaw-contract-management.git
   ```

2. Open in VS Code with AL Extension installed

3. Update `app.json` with your publisher name and ID

4. Configure `launch.json` for your Business Central sandbox:
   ```json
   {
     "profiles": {
       "Sandbox": {
         "server": "https://api.businesscentral.dynamics.com",
         "tenant": "your-tenant-id",
         "company": "Your Company"
       }
     }
   }
   ```

5. Press **F5** to publish to your sandbox

---

## Using the Extension

### 1. Creating a Contract

1. Open **Contract Header List** (Page 50100)
2. Click **New** to create a contract
3. Fill in the required fields:

| Field | Description |
|-------|-------------|
| Contract No. | Enter a contract number or use No. Series |
| Sell-to Customer | Select the customer |
| Bill-to Customer | Select billing customer (defaults to sell-to) |
| Start Date | Contract start date |
| End Date | Contract end date |
| Billing Frequency | Select: Onetime, Daily, Weekly, Monthly, Quarterly, Semiannual, Annual |
| Interval | Number of periods (e.g., 1 = every period, 2 = every 2 periods) |
| Align to Period | Enable to align billing to calendar boundaries |
| Payment Terms | Select payment terms for invoices |

4. Click **Release** to activate the contract

### 2. Adding Contract Lines

1. From the Contract Header, click **Lines** or navigate to **Contract Line List** (Page 50102)
2. Click **New** to add a line

**For Item Lines:**
| Field | Description |
|-------|-------------|
| Type | Select **Item** |
| No. | Select the item to bill |
| Description | Auto-fills from item, can be overridden |
| Quantity | Quantity to bill |
| Unit Price | Price per unit (auto-fills from item) |
| Line Discount % | Optional discount |

**For Comment Lines:**
| Field | Description |
|-------|-------------|
| Type | Select **Comment** |
| Description | Enter your comment |

3. Lines with Type = Item will generate billing schedule lines
4. Lines with Type = Comment are non-billable notes

### 3. Generating Billing Details

Once contract lines are created, generate the billing schedule:

1. Open the **Contract Header Card**
2. Click **Generate Billing Details**
3. The system creates billing lines for each period based on:
   - Contract start/end dates
   - Billing Frequency
   - Interval
   - Align to Period setting
4. Navigate to **Contract Billing List** (Page 50104) to view generated billing lines

**Billing Line Fields:**
| Field | Description |
|-------|-------------|
| Period Start Date | Start of billing period |
| Period End Date | End of billing period |
| Amount | Calculated amount for this period |
| Status | Unbilled, Invoiced, Credited, Cancelled |

### 4. Creating Invoices

To invoice unbilled billing lines:

**Option A: From Contract**
1. Open the **Contract Header Card**
2. Click **Create Sales Invoice**
3. Set the **AsOfDate** (cutoff date for billing)
4. Select **Post Mode**:
   - *Create Only* - Creates draft invoice
   - *Create and Post* - Creates and posts invoice
5. Click **OK**

**Option B: Batch Process**
1. Search for **Create Sales Docs from Contract Billing**
2. Set filters as needed:
   - Customer No.
   - Contract No.
   - Billing Date Range
   - Currency Code
3. Set AsOfDate and Post Mode
4. Click **OK**

### 5. Viewing Invoices

Once invoiced:
- **Sales Document No.** shows the created invoice
- **Posted Invoice No.** shows after posting
- **Status** changes to Invoiced

---

## Managing Contracts

### Release a Contract
Click **Release** on the Contract Header to activate billing and invoicing.

### Close a Contract
Click **Close** when the contract ends. This prevents further invoicing.

### Recalculate Billing
If you change dates, quantities, or prices on unbilled lines:
1. The system detects the change
2. Click **Recalculate Billing** to regenerate unbilled billing lines
3. Already invoiced lines remain unchanged

---

## Important Notes

### Billing Line Immutability
- **Invoiced billing lines are immutable** - they remain linked to the invoice
- Only **unbilled** lines can be modified or deleted
- To change invoiced billing, create a credit memo manually

### Proration (Not in MVP)
- Current version does not support proration
- All billing amounts are calculated based on full periods
- Proration is planned for future release

### Consolidation
- Invoices are consolidated by customer
- All unbilled lines for a customer are grouped into one invoice

### Holds (Not in MVP)
- Contract-level holds are not implemented
- All unbilled lines are available for invoicing

---

## Troubleshooting

### Billing lines not generating
- Ensure contract status is **Released**
- Ensure contract lines have Type = Item
- Ensure Start Date and End Date are set

### Invoice not creating
- Check that there are unbilled billing lines
- Ensure billing date is on or before AsOfDate
- Verify contract is not closed

### Amount mismatch
- Sum of billing lines should equal contract line amount
- The last billing line may be adjusted for rounding

---

## Support

For issues or questions:
- Open an issue on GitHub: https://github.com/johntaylormfc/openclaw-contract-management
- Email: support@bcdev.co.uk

---

## Appendix: Page Reference

| Page ID | Name | Purpose |
|---------|------|---------|
| 50100 | Contract Header List | List all contracts |
| 50101 | Contract Header Card | Create/edit contract |
| 50102 | Contract Line List | List lines for contract |
| 50103 | Contract Line Card | Create/edit line |
| 50104 | Contract Billing List | View billing schedule |
| 50105 | Contract Billing Card | View/edit billing line |

---

*Last Updated: 2026-03-03*
*Version: 1.0.0*
