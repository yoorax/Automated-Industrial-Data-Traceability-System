# Industrial Performance Tracking & Analytics System

## 1. Introduction
This project was conducted as part of a Master's thesis in Mechanical Engineering, Robotics, and Innovative Materials. [cite_start]It addresses a critical need within the **MCP (Mono-Calcium Phosphate) workshop** at the OCP Safi industrial complex: the digitalization of the bagging line's performance monitoring[cite: 73, 172, 173, 174, 315].

[cite_start]The primary objective was to move from a manual, reactive management style to a data-driven, proactive approach by designing and deploying a "Full-Stack" engineering solution for real-time data traceability and automated KPI analysis[cite: 74, 75, 743, 3928, 3944].

## 2. Situation
[cite_start]The bagging line in the MCP storage hall is a critical final step in the production chain, packaging the product into 25kg bags using FFS (Form-Fill-Seal) machines and robotic palletizers[cite: 433, 476, 481].

In the operational context, the line operates on a flexible schedule, typically running between 8 to 14 hours a day depending on demand. [cite_start]Regarding the data recording part, the operators and technicians relied on manual logs or basic, non-standardized records to track production numbers and machine stops[cite: 749, 750, 752, 978].

## 3. The Problem
Despite the critical nature of the line, there was no structured or centralized system for tracking operational data. [cite_start]This led to several significant issues[cite: 733, 738]:

* [cite_start]**Lack of Traceability:** There was no reliable history of when or why the machine stopped, making it impossible to identify recurring failures[cite: 74, 733].
* [cite_start]**Inability to Measure Performance:** Without accurate time-stamped data, it was impossible to calculate standard industrial KPIs such as OEE (Overall Equipment Effectiveness), MTBF (Mean Time Between Failures), or MTTR (Mean Time To Repair)[cite: 733, 737].
* [cite_start]**Reactive Maintenance:** Maintenance interventions were driven by urgent breakdowns rather than data-backed preventive strategies, leading to avoidable downtime and efficiency losses[cite: 671, 676, 677].

## 4. Proposed Solution
To resolve these issues, I designed and implemented a custom **Data Traceability and Performance Monitoring System**. [cite_start]The solution utilizes a three-tier architecture to bridge the gap between the shop floor and management[cite: 75, 3930]:

* [cite_start]**Front-End (Data Collection):** User-friendly Excel interfaces powered by VBA for standardized manual data entry by operators[cite: 981, 1224].
* [cite_start]**Back-End (Storage & Processing):** A centralized SQL Server Express database to store raw data and automatically perform complex KPI calculations using Stored Procedures and Triggers[cite: 76, 78, 1789, 2332].
* [cite_start]**Visualization (Analytics):** An interactive Microsoft Power BI dashboard connected directly to the database for real-time reporting and decision support[cite: 79, 3766, 3777].

## 5. Action & Implementation

### Phase 1: Data Architecture & Standardization
[cite_start]Before writing code, I structured the analysis based on the **AFNOR NF E 60-182 standard** for production time decomposition[cite: 762, 769]. [cite_start]This ensured that all metrics (Total Time, Opening Time, Net Time, Useful Time) were calculated according to recognized industrial norms[cite: 762, 763, 770].

### Phase 2: Front-End Development (Excel & VBA)
I created three dedicated forms using VBA to capture data at the source:

* [cite_start]**Planned Stops Form:** For logging scheduled breaks, maintenance, and meetings[cite: 996, 997].
* [cite_start]**Unplanned Stops Form:** For capturing breakdowns with detailed failure modes (Assembly, Sub-assembly, Component, Failure Type)[cite: 1086, 1089].
* [cite_start]**Production Form:** For entering total bags produced and non-conforming units (quality rejects)[cite: 1195, 1197].

[cite_start]**Key Technical Feature:** I used **VBA and ADO (ActiveX Data Objects)** to build a pipeline that securely transfers data from the Excel sheets directly into the SQL Server database with a single click, handling data type conversion and cleaning automatically[cite: 1229, 1230, 1231].

### Phase 3: Back-End Automation (SQL Server)
This is the "engine" of the system. [cite_start]Instead of calculating KPIs in Excel or Power BI, I automated the logic inside the database for reliability[cite: 2284, 2285]:

* [cite_start]**Relational Schema:** Designed tables for `Arrets_Planifier`, `Arrets_Non_Planifier`, `Sacs_Produit`, and dedicated tables for calculated KPIs[cite: 2289, 2291, 2337, 2339].
* **Automated Calculation (Triggers):** I wrote SQL **Triggers** that fire automatically upon every new data insertion. [cite_start]These triggers execute **Stored Procedures** that[cite: 2332, 2333, 2340]:
    * [cite_start]**Calculate Cycle Times:** (Required Time, Gross Operating Time, Net Time)[cite: 2290, 2344].
    * [cite_start]**Compute Maintenance KPIs:** Updates MTBF, MTTR, Failure Rate, and Reactivity Rate instantly[cite: 2573, 2580, 2593].
    * [cite_start]**Compute Production KPIs:** Updates OEE (TRS), Availability, Performance, and Quality rates[cite: 2832, 2838, 2869].
    * [cite_start]**Pareto Logic:** Automatically aggregates failure durations by category to populate a dedicated `Pareto_2080` table for root cause analysis[cite: 3082, 3083, 3120].

### Phase 4: Data Visualization (Power BI)
[cite_start]I connected Power BI to the SQL database via **Direct Import** to build a comprehensive dashboard with specific views[cite: 3777, 3778, 3779]:

* [cite_start]**Maintenance Page:** visualizes MTBF/MTTR trends and reactivity[cite: 3810, 3811].
* [cite_start]**Production Page:** Displays OEE (TRS), Economic Return (TRE), and Quality rates[cite: 3839, 3840, 3845].
* [cite_start]**Cycle Analysis Page:** Breakdowns the total time using donut charts to visualize losses[cite: 3864, 3865].
* [cite_start]**Pareto Page:** A dynamic 80/20 diagram to instantly identify the top causes of downtime[cite: 3887, 3890].

### Phase 5: Data Security
To prevent data loss, I implemented an automated backup system. [cite_start]A batch script (`.bat`) runs daily via Windows Task Scheduler to dump the SQL database, compress it with 7-Zip, and synchronize it to a Google Drive folder[cite: 76, 78, 3709, 3714, 3725].

## 6. Results
[cite_start]The system was tested with real production data from June 17 to June 20, yielding significant operational insights[cite: 3164]:

* **Automated & Accurate KPIs:** The system successfully calculated complex metrics without human intervention. [cite_start]For example, it tracked an **OEE (TRS)** fluctuating between **37.8% and 64.5%**, providing a clear baseline for improvement[cite: 3643, 3670].
* [cite_start]**Root Cause Identification:** The automated Pareto analysis immediately identified that the **"Bag Opening Group"** and **"Film Opening System"** were responsible for over **50%** of all unplanned downtime[cite: 3696, 3697].
* [cite_start]**Maintenance Efficiency:** The system revealed a variable **MTTR (Mean Time To Repair)** ranging from **29 to 42 minutes**, highlighting specific days where intervention times degraded[cite: 3679].
* [cite_start]**Quality Control:** The data confirmed a high-quality rate (96-99%), validating the production process stability despite the mechanical downtime[cite: 3668].

## 7. Conclusion & Impact
This project successfully transformed a manual, opaque monitoring process into a robust, digital ecosystem. [cite_start]By leveraging Excel, VBA, SQL Server, and Power BI, I delivered a solution that not only ensures full data traceability but also empowers the OCP maintenance and production teams to make data-driven decisions[cite: 3937, 3948].

### Key Achievements:
* [cite_start]**Predictive Maintenance:** Created interactive Power BI dashboards enabling early diagnostics and predictive maintenance strategies through advanced data analysis[cite: 3939, 3951].
* **Operational Efficiency:** Fully automated quality reporting, eliminating over **14 hours per week** of manual data entry work.
* [cite_start]**Data Centralization:** Achieved **100% centralization** of quality and operational data with secure, real-time access[cite: 3936].
* [cite_start]**Strategic Analysis:** Successfully identified the **4 root causes** responsible for **80%** of production defects (Pareto Analysis)[cite: 3699, 3700, 3953].
* **Change Management:** Conducted training for **6+ technicians**, ensuring the complete adoption and sustainability of the digital system.
