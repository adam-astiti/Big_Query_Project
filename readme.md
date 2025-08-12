# Automated Sales Data Pipeline with Google Cloud & Looker Studio
**A serverless data pipeline on Google Cloud that automates sales data processing and provides real-time analysis in a Looker Studio dashboard**.

This project demonstrates an end-to-end, event-driven architecture to solve a common business problem: transforming raw, daily data into actionable insights for performance tracking and risk mitigation.

![UK Online shop KPI](https://github.com/user-attachments/assets/486d7af4-073d-441d-a86f-8d85b3844e10)

To view the dashboard click here: [Live Looker Studio Dashboard](https://lookerstudio.google.com/s/u7OH8nC8i3E)

## Technical Highlights

### **Category and	Technology / Skill**
- **Cloud Platform** :	Google Cloud Platform (GCP)
- **Core Services**	: Cloud Functions (2nd Gen),  Cloud Scheduler,  Pub/Sub,  Google Cloud Services
- **Data Warehouse**	: BigQuery
- **BI & Visualization**	: Looker Studio
- **Language & Libs**	: Python (Pandas, google-cloud-storage)
- **Architecture**	: Serverless, Event-Driven, Decoupled

## How It Works: The Automated Workflow
The pipeline automates the following workflow:
<img width="844" height="408" alt="image" src="https://github.com/user-attachments/assets/3b7b779d-f2bd-4980-8874-5c48669cf446" />

1. **Daily Trigger**: **Cloud Scheduler** initiates the pipeline on a set schedule (daily at 1 AM).

2. **Message Sent**: The scheduler publishes a message to a **Pub/Sub topic**.

3. **Data Processed**:
     - A **Cloud Function**, subscribed to the topic, is triggered. It runs a **Python script** to:

    - **Read a master sales file** from Google Cloud Storage (GCS).

    - **Simulate a new daily batch** by sampling the data.

    - **Update data** in the google cloud bucket

4.  **Data Visualized**:

    - **BigQuery** automatically ingests the new file.

    - A **Looker Studio dashboard**, connected to a BigQuery, updates automatically, showing the latest sales and risk metrics.
  
## Key Features & Business Impact
1. **Automated KPI and Risk Monitoring**: The dashboard proactively show KPI, sales and revenue, customer RFM segmentation, identifies which products are most frequently canceled, helping to pinpoint quality or fulfillment issues.

2. **Cost-Efficient & Scalable**: Built entirely on serverless components, the pipeline costs virtually nothing at this scale and can handle significant increases in data volume without reconfiguration.

3. **Data-Driven Decision Making**: Provides a single source of truth for sales and cancellation trends, enabling faster, more informed business decisions.

## To Replicate This Project
<details>
<summary>Click to expand the detailed setup instructions</summary>

1. **Google Cloud Setup**
    - **Enable APIs**: In your GCP project, enable Cloud Functions, Cloud Scheduler, Pub/Sub, Cloud Storage, BigQuery, and Eventarc.

    - **Create GCS Bucket**: Create a bucket and a folder inside it named Daily_update.

    - **Upload Data**: Upload Online_Retail.csv to the root of your bucket.

    - **Create Pub/Sub Topic**: Create a topic named simulate-daily-job.

2. **Deploy Cloud Function**
    - Go to Cloud Functions, click **CREATE FUNCTION (2nd gen)**.

    - **Set the Trigger to Eventarc** > Cloud Pub/Sub, and select the simulate-daily-job topic.

    - For the code, use main.py and requirements.txt.

    - **Set the Entry point** to simulate_daily_update.

    - **Deploy.**

3. **Deploy Cloud Scheduler**
    - Go to Cloud Scheduler, click **CREATE JOB.**

    - **Set the Frequency** (e.g., 0 2 * * *) and your Timezone.

    - **Set the Target type** to Pub/Sub and select the simulate-daily-job topic.

    - **Create.**

</details>

## Dataset Overview
<details>
<summary>Click to expand the Dataset Overview</summary>
This project uses the Online Retail II dataset, which contains transactional data for a UK-based e-commerce business.

- **Data Type**:	Transactional Sales Data
- **Origin** :	UK-Based Online Retailer
- **Timeframe**:	1 years of data
- **Rows**:	~540,000 line items
- **Columns**:	InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country

## Key Feature for Analysis
The most critical feature of this dataset is that it includes both successful sales and canceled orders.

- **Successful Sales**: Represented by positive quantities.

- **Canceled Orders**: Identified by invoice numbers starting with "C" and negative quantities.

This dual nature is what makes a meaningful risk analysis possible, allowing the project to move beyond simple sales reporting to identify and quantify sources of lost revenue.
</details>

## Bussiness Insight and Impact Summary
<details>
<summary>Click to expand the Bussiness Insight and Impact Summary</summary>
  
### Dashboard Summary
This Project involved creating an executive-level dashboard in Looker Studio to analyze one year of sales data for a UK-based online retailer. The goal was to identify key business drivers and deliver actionable strategic recommendations based on the findings.

### Key Business Insights & Impact
My analysis uncovered four critical insights that directly impact business strategy:

1. **Seasonal Revenue Peak**: The business generates $9.75M annually, with a massive revenue spike in Q4 (peaking at $1.5M in November). Impact: All marketing and inventory planning should be focused on maximizing this predictable holiday rush.

2. **The 80/20 Customer Rule**: An elite group of "Champion" and "Loyal" customers constitute over 80% of total revenue. Impact: This justifies creating a VIP retention program to protect the core of the business.

3. **"Hero Product" Identification**: A few key products drive the majority of sales. Surprisingly, DOTCOM POSTAGE is one of an exceptionally profitable item, and the company maintains a 98.3% order completion rate, indicating operational excellence. Impact: Marketing should focus on promoting these hero products, and the shipping fee strategy should be recognized as a profit center.

4. **Operational Revenue Leakage**: The company lost nearly **$900,000** not from product returns, but from controllable operational costs like Amazon fees and manual write-offs. Impact: This highlights an immediate opportunity to increase profitability by investigating and standardizing internal financial processes.
</details>
