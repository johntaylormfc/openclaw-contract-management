# Business Specification

## Overview Central Contract Management -

This document defines the functional specification for the OpenClaw Contract Management extension for Business Central SaaS.

## 1. Purpose

Build a Business Central SaaS extension to:
- Record **customer contracts** (header + lines)
- Generate a **billing schedule** (billing detail lines) per contract line across a date range
- Support **aligned-to-period** (month/quarter/year) billing frequency
- Provide an **invoicing worksheet** to invoice unbilled billing lines into standard BC sales invoices

---

## 2. Glossary

| Term | Definition |
|------|------------|
| **Contract** | Agreement with a customer over a start/end date |
| **Contract Line** | Item/service line (billable) or comment line (non-billable) |
| **Billing Schedule** | Generated periods for each billable contract line |
| **Billing Line** | Individual billable period record |
| **Unbilled** | Billing line has not been invoiced |
| **Invoiced** | Billing line has been linked to a sales invoice |
| **Frequency** | How often billing occurs (Monthly, Quarterly, etc.) |
| **Align to Period** | Whether to align billing to calendar period boundaries |

---

## 3. Functional Requirements

### 3.1 Contract Header

**Key Fields:**
| Field | Type | Description |
|-------|------|-------------|
| Contract No. | Code(20) | Contract number (No. Series) |
| Sell-to Customer No. | Code(20) | Customer selling to |
| Bill-to Customer No. | Code(20) | Customer billing to |
| Start Date | Date | Contract start date |
| End Date | Date | Contract end date |
| Billing Frequency | Option | Onetime, Daily, Weekly, Monthly, Quarterly, Semiannual, Annual |
| Interval | Integer | Number of periods between billing (e.g., 1 = every period, 2 = every 2 periods) |
| Align to Period | Boolean | Align billing to calendar month/quarter/year boundaries |
| Status | Option | Open, Released, Closed |
| Currency Code | Code(10) | Currency for billing |
| Payment Terms Code | Code(10) | Payment terms for invoices |

**Key Behavior:**
- Release validates required fields
- Changing dates prompts to recalculate billing schedule
- Status controls whether contract lines can be invoiced

### 3.2 Contract Lines

**Key Fields:**
| Field | Type | Description |
|-------|------|-------------|
| Contract No. | Code(20) | Parent contract |
| Line No. | Integer | Line sequence |
| Type | Option | Item, Resource, Comment |
| No. | Code(20) | Item or Resource number |
| Description | Text(100) | Line description |
| Quantity | Decimal | Quantity to bill |
| Unit Price | Decimal | Price per unit |
| Line Discount % | Decimal | Discount percentage |
| Line Amount | Decimal | Calculated line amount |
| Start Date | Date | Line start date (defaults from header) |
| End Date | Date | Line end date (defaults from header) |
| Billing Frequency | Option | Override header frequency (optional) |
| Deferral Code | Code(10) | BC Deferral Template for deferred revenue |

**Key Behavior:**
- Item and Resource lines generate billing schedule lines
- Comment lines do not generate billing
- Date/qty/price changes trigger schedule recalculation for unbilled lines only

### 3.3 Contract Billing (Billing Lines)

**Key Fields:**
| Field | Type | Description |
|-------|------|-------------|
| Contract No. | Code(20) | Parent contract |
| Contract Line No. | Integer | Parent line |
| Billing Line No. | Integer | Sequence number |
| Period Start Date | Date | Billing period start |
| Period End Date | Date | Billing period end |
| Amount | Decimal | Billing amount |
| Status | Option | Unbilled, Invoiced, Credited, Cancelled |
| Sales Document Type | Option | Quote, Order, Invoice, Credit Memo |
| Sales Document No. | Code(20) | Linked sales document |
| Sales Line No. | Integer | Linked sales line |
| Posted Invoice No. | Code(20) | Posted invoice reference |

**Allocation Rule:**
- Sum of billing amounts per contract line must equal contract line amount

### 3.4 Invoice Generation

**Features:**
- Pull all eligible unbilled billing lines
- Exclude lines where contract is on hold
- Filter by billing date, customer, contract, currency
- Create standard BC Sales Invoices
- Support create-only or create-and-post modes
- Group invoices by customer

---

## 4. Technical Specification

### 4.1 Tables

| Table ID | Name | Description |
|----------|------|-------------|
| 50100 | Contract Header | Contract-level defaults and status |
| 50101 | Contract Line | Line-level billing setup |
| 50102 | Contract Billing | Billable periods |

### 4.2 Codeunits

| Codeunit ID | Name | Description |
|-------------|------|-------------|
| 50100 | Contract Billing Mgt. | Billing detail generation and management |
| 50101 | Contract Invoice Mgt. | Invoice creation from billing |

### 4.3 Pages

| Page ID | Name | Type |
|---------|------|------|
| 50100 | Contract Header List | List |
| 50101 | Contract Header Card | Card |
| 50102 | Contract Line List | List |
| 50103 | Contract Line Card | Card |
| 50104 | Contract Billing List | List |
| 50105 | Contract Billing Card | Card |

### 4.4 API Pages (for SaaS)

| Page ID | Name | Description |
|---------|------|-------------|
| 50110 | API Contract Header | OData API for contracts |
| 50111 | API Contract Line | OData API for lines |
| 50112 | API Contract Billing | OData API for billing |

---

## 5. MVP Limitations

- **Consolidation**: Simplified to by-customer grouping only
- **Proration**: Not implemented (future feature)
- **Hold/Resume**: Not implemented (future feature)
- **Termination**: Not implemented (future feature)
- **Usage-based billing**: Not implemented (future feature)
- **Multi-currency**: Basic support only
- **Credit memos**: Manual creation required

---

## 6. Future Enhancements (v2)

- Proration support (Actual Daily, 30/360, Monthly Aligned)
- Contract termination with billing adjustment
- Hold/resume contract lines
- Credit memo generation for invoiced periods
- Usage-based billing integration
- Advanced reporting
- Multi-currency support
- Dimensions support

---

## 7. Integration Points

- **Sales Invoice**: Creates standard BC sales invoices
- **Deferral Templates**: Supports BC deferral templates for revenue recognition
- **Customers**: Links to standard BC customer tables
- **Items/Resources**: Links to standard BC item and resource tables
