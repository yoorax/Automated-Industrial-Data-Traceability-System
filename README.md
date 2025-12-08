# Automated Industrial Data Traceability & Performance Monitoring System

## 1. Introduction
This project was conducted as part of a Master's thesis in Mechanical Engineering, Robotics, and Innovative Materials. It addresses a critical need within the **MCP (Mono-Calcium Phosphate) workshop** at the OCP Safi industrial complex: the digitalization of the bagging line's performance monitoring.

The primary objective was to move from a manual, reactive management style to a data-driven, proactive approach by designing and deploying a "Full-Stack" engineering solution for real-time data traceability and automated KPI analysis.

## 2. Situation
The bagging line in the MCP storage hall is a critical final step in the production chain, packaging the product into 25kg bags using FFS (Form-Fill-Seal) machines and robotic palletizers.

In the operational context, the line operates on a flexible schedule, typically running between 8 to 14 hours a day depending on demand. Regarding data recording, operators and technicians previously relied on manual logs or basic, non-standardized records to track production numbers and machine stops.

## 3. The Problem
Despite the critical nature of the line, there was no structured or centralized system for tracking operational data. This led to several significant issues:

* **Lack of Traceability:** There was no reliable history of when or why the machine stopped, making it impossible to identify recurring failures.
* **Inability to Measure Performance:** Without accurate time-stamped data, it was impossible to calculate standard industrial KPIs such as OEE (Overall Equipment Effectiveness), MTBF (Mean Time Between Failures), or MTTR (Mean Time To Repair).
* **Reactive Maintenance:** Maintenance interventions were driven by urgent breakdowns rather than data-backed preventive strategies, leading to avoidable downtime and efficiency losses.

## 4. Proposed Solution
To resolve these issues, I designed and implemented a custom **Data Traceability and Performance Monitoring System**. The solution utilizes a three-tier architecture to bridge the gap between the shop floor and management:

* **Front-End (Data Collection):** User-friendly Excel interfaces powered by VBA for standardized manual data entry by operators.
* **Back-End (Storage & Processing):** A centralized SQL Server Express database to store raw data and automatically perform complex KPI calculations using Stored Procedures and Triggers.
* **Visualization (Analytics):** An interactive Microsoft Power BI dashboard connected directly to the database for real-time reporting and decision support.

## 5. Action & Implementation

### Phase 1: Data Architecture & Standardization
Before writing code, I structured the analysis based on the **AFNOR NF E 60-182 standard** for production time decomposition. This ensured that all metrics (Total Time, Opening Time, Net Time, Useful Time) were calculated according to recognized industrial norms.

### Phase 2: Front-End Development (Excel & VBA)
I created three dedicated forms using VBA to capture data at the source:

* **Planned Stops Form:** For logging scheduled breaks, maintenance, and meetings.
* **Unplanned Stops Form:** For capturing breakdowns with detailed failure modes (Assembly, Sub-assembly, Component, Failure Type).
* **Production Form:** For entering total bags produced and non-conforming units (quality rejects).

**Key Technical Feature:** I used VBA and ADO (ActiveX Data Objects) to build a pipeline that securely transfers data from the Excel sheets directly into the SQL Server database with a single click, handling data type conversion and cleaning automatically.

### Phase 3: Back-End Automation (SQL Server)
This is the "engine" of the system. Instead of calculating KPIs in Excel or Power BI, I automated the logic inside the database for reliability:

* **Relational Schema:** Designed tables for `Arrets_Planifier`, `Arrets_Non_Planifier`, `Sacs_Produit`, and dedicated tables for calculated KPIs.
* **Automated Calculation (Triggers):** I wrote SQL Triggers that fire automatically upon every new data insertion. These triggers execute Stored Procedures that:
    * **Calculate Cycle Times:** (Required Time, Gross Operating Time, Net Time).
    * **Compute Maintenance KPIs:** Updates MTBF, MTTR, Failure Rate, and Reactivity Rate instantly.
    * **Compute Production KPIs:** Updates OEE (TRS), Availability, Performance, and Quality rates.
    * **Pareto Logic:** Automatically aggregates failure durations by category to populate a dedicated `Pareto_2080` table for root cause analysis.

### Phase 4: Data Visualization (Power BI)
I connected Power BI to the SQL database via **Direct Import** to build a comprehensive dashboard with specific views:

* **Maintenance Page:** Visualizes MTBF/MTTR trends and reactivity.
* **Production Page:** Displays OEE (TRS), Economic Return (TRE), and Quality rates.
* **Cycle Analysis Page:** Breakdowns the total time using donut charts to visualize losses.
* **Pareto Page:** A dynamic 80/20 diagram to instantly identify the top causes of downtime.

### Phase 5: Data Security
To prevent data loss, I implemented an automated backup system. A batch script (`.bat`) runs daily via Windows Task Scheduler to dump the SQL database, compress it with 7-Zip, and synchronize it to a Google Drive folder.

## 6. Results
The system was tested with real production data from June 17 to June 20, yielding significant operational insights:

* **Automated & Accurate KPIs:** The system successfully calculated complex metrics without human intervention. For example, it tracked an OEE (TRS) fluctuating between 37.8% and 64.5%, providing a clear baseline for improvement.
* **Root Cause Identification:** The automated Pareto analysis immediately identified that the **"Bag Opening Group"** and **"Film Opening System"** were responsible for over **50%** of all unplanned downtime.
* **Maintenance Efficiency:** The system revealed a variable MTTR (Mean Time To Repair) ranging from 29 to 42 minutes, highlighting specific days where intervention times degraded.
* **Quality Control:** The data confirmed a high-quality rate (96-99%), validating the production process stability despite the mechanical downtime.

## 7. Conclusion & Impact
This project successfully transformed a manual, opaque monitoring process into a robust, digital ecosystem. By leveraging Excel, VBA, SQL Server, and Power BI, I delivered a solution that not only ensures full data traceability but also empowers the OCP maintenance and production teams to make data-driven decisions.

### Key Achievements:
* **Predictive Maintenance:** Created interactive Power BI dashboards enabling early diagnostics and predictive maintenance strategies through advanced data analysis.
* **Operational Efficiency:** Fully automated quality reporting, eliminating over **14 hours per week** of manual data entry work.
* **Data Centralization:** Achieved **100% centralization** of quality and operational data with secure, real-time access.
* **Strategic Analysis:** Successfully identified the **4 root causes** responsible for **80%** of production defects (Pareto Analysis).
* **Change Management:** Conducted training for **6+ technicians**, ensuring the complete adoption and sustainability of the digital system.

