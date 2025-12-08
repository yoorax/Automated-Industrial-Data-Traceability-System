# Automated Industrial Data Traceability & Performance Monitoring System

## 1. Introduction
This project was conducted as part of a Master's thesis in Mechanical Engineering, Robotics, and Innovative Materials. It addresses a critical need within the **MCP (Mono-Calcium Phosphate) workshop** at the OCP Safi industrial complex: the digitalization of the bagging line's performance monitoring.

The primary objective was to move from a manual, reactive management style to a data-driven, proactive approach by designing and deploying a "Full-Stack" engineering solution for real-time data traceability and automated KPI analysis.

## 2. Situation
The bagging line in the MCP storage hall is a critical final step in the production chain, responsible for packaging the finished product into 25kg bags before distribution. The process relies on a complex series of equipment operating in sequence to ensure efficiency and quality.

### Equipment Flow & Process Description
The production line follows a linear flow from bulk storage to the final wrapped pallet:

| Equipment | Function | Specifics |
| :--- | :--- | :--- |
| **1. Silos (A & B)** | Bulk storage of finished MCP product. | 800-ton capacity each. |
| **2. Vibrating Screening System** | Filters product and removes metallic contaminants. | Particle size $\le$ 2.2 mm. |
| **3. Screw Conveyor** | Horizontal transport from silo outlet. | Feeds the bucket elevator. |
| **4. Bucket Elevator** | Vertical lifting mechanism. | Transports product to the upper weighing level. |
| **5. Weighing/Buffer Hopper** | Temporary storage and flow regulation. | Ensures constant feed to the bagging machine. |
| **6. FFS Bagging Machine** | Forms, Fills, and Seals bags automatically. | Model: Payper ASSAC L10 (25 kg bags). |
| **7. Dust Filtration System** | Captures airborne particles. | Protects sensitive equipment and operators. |
| **8. Bag Conveyor** | Transport of sealed bags. | Moves bags towards the labeling station. |
| **9. Automatic Labeling Machine** | Product traceability. | Applies tickets with date and batch info. |
| **10. Pallet Dispenser** | Pallet preparation. | Automatically feeds empty pallets onto the line. |
| **11. Robotic Palletizer** | Stacking of bags onto pallets. | Payper 5-Axis Robot (40 bags/pallet). |
| **12. Pallet Conveyor** | Heavy load transport. | Moves full pallets to the wrapping station. |
| **13. Stretch Hood Machine** | Pallet protection and stability. | Wraps the pallet in a protective plastic hood. |
| **14. Forklift** | Final logistics. | Transports finished pallets to the storage zone. |

In the operational context, this line operates on a flexible schedule, typically running between 8 to 14 hours a day depending on demand. Regarding data recording, operators and technicians previously relied on manual logs or basic, non-standardized records to track production numbers and machine stops.

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

**Key Technical Feature:** I used **VBA and ADO (ActiveX Data Objects)** to build a pipeline that securely transfers data from the Excel sheets directly into the SQL Server database with a single click, handling data type conversion and cleaning automatically.

### Phase 3: Back-End Automation (SQL Server)
This is the "engine" of the system. Instead of calculating KPIs in Excel or Power BI, I automated the logic inside the database for reliability:

* **Relational Schema:** Designed tables for `Arrets_Planifier`, `Arrets_Non_Planifier`, `Sacs_Produit`, and dedicated tables for calculated KPIs.
* **Automated Calculation (Triggers):** I wrote SQL **Triggers** that fire automatically upon every new data insertion. These triggers execute **Stored Procedures** that:
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

* **Automated & Accurate KPIs:** The system successfully calculated complex metrics without human intervention. For example, it tracked an **OEE (TRS)** fluctuating between **37.8% and 64.5%**, providing a clear baseline for improvement.
* **Root Cause Identification:** The automated Pareto analysis immediately identified that the **"Bag Opening Group"** and **"Film Opening System"** were responsible for over **50%** of all unplanned downtime.
* **Maintenance Efficiency:** The system revealed a variable **MTTR (Mean Time To Repair)** ranging from **29 to 42 minutes**, highlighting specific days where intervention times degraded.
* **Quality Control:** The data confirmed a high-quality rate (96-99%), validating the production process stability despite the mechanical downtime.

## 7. Conclusion & Impact
This project successfully transformed a manual, opaque monitoring process into a robust, digital ecosystem. By leveraging Excel, VBA, SQL Server, and Power BI, I delivered a solution that not only ensures full data traceability but also empowers the OCP maintenance and production teams to make data-driven decisions.

### Key Achievements:
* **Predictive Maintenance:** Created interactive Power BI dashboards enabling early diagnostics and predictive maintenance strategies through advanced data analysis.
* **Operational Efficiency:** Fully automated quality reporting, eliminating over **14 hours per week** of manual data entry work.
* **Data Centralization:** Achieved **100% centralization** of quality and operational data with secure, real-time access.
* **Strategic Analysis:** Successfully identified the **4 root causes** responsible for **80%** of production defects (Pareto Analysis).
* **Change Management:** Conducted training for **6+ technicians**, ensuring the complete adoption and sustainability of the digital system.

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
<img width="995" height="550" alt="image" src="https://github.com/user-attachments/assets/44f2d25e-fcaf-4ad9-a087-10c4dd3b49e9" />

* **Unplanned Stops Form:** For capturing breakdowns with detailed failure modes (Assembly, Sub-assembly, Component, Failure Type).
<img width="1362" height="559" alt="image" src="https://github.com/user-attachments/assets/2784df35-8b7d-44c8-879b-856c0bc182b5" />

* **Production Form:** For entering total bags produced and non-conforming units (quality rejects).
<img width="920" height="527" alt="image" src="https://github.com/user-attachments/assets/66d29d45-4c1c-4bc7-8daf-c2c2fc4e488a" />

* All operational data logged by technicians and operators using the Excel Front-End interfaces (for Planned Stops, Unplanned Stops, and Production counts) is initially saved and stored temporarily within dedicated verification worksheets in the same Excel workbook . At the end of the two shifts, when the line is closed for the day, a final validation step is performed directly on these staging worksheets. This crucial manual check ensures accuracy, allows for the removal of any immediate input errors, and guarantees data integrity before permanent commitment. Only after making sure all collected data is correct and complete is the automated macro activated.
<img width="923" height="486" alt="image" src="https://github.com/user-attachments/assets/92e875d4-8745-49ca-9564-39167d1b11bf" />

<img width="1111" height="471" alt="image" src="https://github.com/user-attachments/assets/335afc98-e3f0-4767-a8c4-78f467c776cd" />

<img width="1052" height="367" alt="image" src="https://github.com/user-attachments/assets/ca2a7d62-8781-47c6-bcd5-e8f19de4d76d" />

* I used VBA and ADO (ActiveX Data Objects) to build a pipeline that securely transfers data from these validated Excel worksheets directly into the SQL Server database with a single click, handling data type conversion and cleaning automatically

### Phase 3: Back-End Automation (SQL Server)
This is the "engine" of the system. Instead of calculating KPIs in Excel or Power BI, I automated the logic inside the database for reliability:

* **Relational Schema:** Designed tables for `Arrets_Planifies`, `Arrets_Non_Planifies`, `Sacs_Produit`, and dedicated tables for calculated KPIs.
* **Automated Calculation (Triggers):** I wrote SQL Triggers that fire automatically upon every new data insertion. These triggers execute Stored Procedures that:
    * **Calculate the Production Cycle Times:** (Required Time, Gross Operating Time, Net Time).
  <img width="1085" height="495" alt="image" src="https://github.com/user-attachments/assets/8a0a5eda-d961-4929-bc0c-30abc14bd023" />
  <img width="1092" height="243" alt="image" src="https://github.com/user-attachments/assets/66e2e1e6-875d-4178-98ca-536a956ac3cf" />

    * **Compute Maintenance KPIs:** Updates MTBF, MTTR, Failure Rate, and Reactivity Rate instantly.
  <img width="1092" height="449" alt="image" src="https://github.com/user-attachments/assets/08754f83-9a94-4a07-a1f2-c48dd9490d51" />

    * **Compute Production KPIs:** Updates OEE (TRS), Availability, Performance, and Quality rates.
  <img width="1097" height="521" alt="image" src="https://github.com/user-attachments/assets/c4e6a07f-e5ba-4cb0-b10c-f1bc7dad8dcc" />

  <img width="1125" height="538" alt="image" src="https://github.com/user-attachments/assets/60e364cc-2e27-4691-8995-428e43528c47" />

    * **Pareto Logic:** Automatically aggregates failure durations by category to populate a dedicated `Pareto_2080` table for root cause analysis.
<img width="1020" height="331" alt="image" src="https://github.com/user-attachments/assets/a27393ee-8547-4a68-b782-89646109c03b" />

### Phase 4: Data Visualization (Power BI)
I connected Power BI to the SQL database via **Direct Import** to build a comprehensive dashboard with specific views:

* **Maintenance Page:** Visualizes MTBF/MTTR trends and reactivity.
<img width="1090" height="651" alt="image" src="https://github.com/user-attachments/assets/618a1222-cc9b-4c27-abcb-ffdf316dd7a3" />

* **Production Page:** Displays OEE (TRS), Economic Return (TRE), and Quality rates.
<img width="908" height="532" alt="image" src="https://github.com/user-attachments/assets/58d6a2f0-5bca-429e-a28a-9f2001da1de6" />
<img width="1090" height="647" alt="image" src="https://github.com/user-attachments/assets/2b26e7e5-8cf7-4197-b927-37a964a1e700" />

* **Production Cycle Times Analysis Page:** Breakdowns the total time using donut charts to visualize losses.
<img width="990" height="558" alt="image" src="https://github.com/user-attachments/assets/6d527142-5076-473f-9b0b-26cd76a88a82" />

* **Pareto Page:** A dynamic 80/20 diagram to instantly identify the top causes of downtime.
<img width="1057" height="591" alt="image" src="https://github.com/user-attachments/assets/5cc23682-2b25-44cb-ae90-967cebc8c6d7" />

### Phase 5: Data Security
To prevent data loss, I implemented an automated backup system. A batch script (`.bat`) runs daily via Windows Task Scheduler to dump the SQL database, compress it with 7-Zip, and synchronize it to a Google Drive folder.

## 6. Results
The system was tested with real production data from June 17 to June 20, yielding significant operational insights:

* **Automated & Accurate KPIs:** The system successfully calculated complex metrics without human intervention. For example, it tracked an OEE (TRS) fluctuating between 37.8% and 64.5%, providing a clear baseline for improvement.
* **Root Cause Identification:** The automated Pareto analysis immediately identified that the **"Bag Opening Group"** and **"Film Opening System"** were responsible for over **50%** of all unplanned downtime.
* **Maintenance Efficiency:** The system revealed a variable MTTR (Mean Time To Repair) ranging from 29 to 42 minutes, highlighting specific days where intervention times degraded.
* **Quality Control:** The data confirmed a high-quality rate (88-92%), validating the production process stability despite the mechanical downtime.

## 7. Conclusion & Impact
This project successfully transformed a manual, opaque monitoring process into a robust, digital ecosystem. By leveraging Excel, VBA, SQL Server, and Power BI, I delivered a solution that not only ensures full data traceability but also empowers the OCP maintenance and production teams to make data-driven decisions.

### Key Achievements:
* **Predictive Maintenance:** Created interactive Power BI dashboards enabling early diagnostics and predictive maintenance strategies through advanced data analysis.
* **Operational Efficiency:** Fully automated quality reporting, eliminating over **14 hours per week** of manual data entry work.
* **Data Centralization:** Achieved **100% centralization** of quality and operational data with secure, real-time access.
* **Strategic Analysis:** Successfully identified the **4 root causes** responsible for **80%** of production defects (Pareto Analysis).
* **Change Management:** Conducted training for **6+ technicians**, ensuring the complete adoption and sustainability of the digital system.

