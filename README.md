# OpenClaw Contract Management

Business Central SaaS extension for managing contracts and recurring billing.

## Overview

This extension provides contract management and recurring billing functionality for Business Central SaaS. It includes:

- **Contract Header** - Contract-level defaults and control flags
- **Contract Line** - Item/resource-level billing setup
- **Contract Billing** - Actual billable periods for invoice generation

## Features

### Core Functionality

1. **Contract Creation**
   - Create contract headers with customer, dates, frequency, and payment terms
   - Add contract lines with items, quantities, and pricing

2. **Billing Period Generation**
   - Automatically generate billing details from line/header dates and frequency
   - Support for: Onetime, Daily, Weekly, Monthly, Quarterly, Semiannual, Annual
   - Month alignment option for monthly billing

3. **Recalculation**
   - Automatically rebuild unbilled details when header/line values change
   - Billed details remain immutable

4. **Invoice Generation**
   - Create sales invoices from due billing details
   - Group by customer (simplified for MVP)
   - Support for create-only or create-and-post modes

## Tables

| Table ID | Name | Description |
|----------|------|-------------|
| 50100 | Contract Header | Contract-level defaults and status |
| 50101 | Contract Line | Line-level billing setup |
| 50102 | Contract Billing | Billable periods |

## Codeunits

| Codeunit ID | Name | Description |
|-------------|------|-------------|
| 50100 | Contract Billing Mgt. | Billing detail generation and management |
| 50101 | Contract Invoice Mgt. | Invoice creation from billing |

## Pages

| Page ID | Name | Type |
|---------|------|------|
| 50100 | Contract Header List | List |
| 50101 | Contract Header Card | Card |
| 50102 | Contract Line List | List |
| 50103 | Contract Line Card | Card |
| 50104 | Contract Billing List | List |
| 50105 | Contract Billing Card | Card |

## Installation

1. Clone this repository
2. Open in VS Code with AL Extension installed
3. Update `app.json` with your publisher name
4. Configure `launch.json` for your Business Central sandbox
5. Press F5 to publish to your sandbox

## Usage

### Creating a Contract

1. Open **Contract Header List** page
2. Create new contract with:
   - Contract No.
   - Sell-to Customer
   - Start Date / End Date
   - Frequency (Monthly, Quarterly, etc.)
   - Interval (e.g., 1 for every period, 2 for every 2 periods)
3. Add contract lines with items and pricing

### Generating Billing Details

1. Open the contract
2. Click **Generate Billing Details** action
3. Billing periods will be created based on dates and frequency

### Creating Invoices

1. Run the **CreateSalesDocsFromContractBilling** function
2. Specify the AsOfDate (cutoff date for billing)
3. Select post mode (Create Only or Create and Post)

## MVP Limitations

- Consolidation is simplified to by-customer only
- No proration implemented (future feature)
- No hold/resume or termination workflows
- No advanced usage-based billing

## Development

This extension is built for Business Central SaaS (API pages only, no classic objects).

### Building

```bash
# Using AL CLI
alc /project:./src /package:./output
```

### Publishing

1. Update launch.json with your sandbox credentials
2. Press F5 in VS Code

## License

MIT License
