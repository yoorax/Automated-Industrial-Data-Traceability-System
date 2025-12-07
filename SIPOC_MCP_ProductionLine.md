# **SIPOC\_ANALYSIS** 

## **1. INTRODUCTION**

This document provides a detailed **SIPOC (Suppliers, Inputs, Process, Outputs, Customers)** analysis of the Monocalcium Phosphate (MCP) production process at the **OCP Safi industrial site**. This analysis defines the boundaries of the production line and served as the foundation for the **Automated Industrial Data Traceability System** project.

The process is systematically broken down into **eight sequential stages**, starting from the preparation of raw materials up to the final packaging and dispatch of the product.

---
## **2. SIPOC WorkFlow Illustration**

<img width="2752" height="1536" alt="SIPOC_WorkFlow" src="https://github.com/user-attachments/assets/85e2cf8e-5b43-4c1c-9944-cc4b57270f68" />

## **3. DETAILED SIPOC BREAKDOWN**

### **STAGE 1: PREPARATION OF LIME PULP**

| Component | Description |
| :--- | :--- |
| **Suppliers (S)** | Silos A/B (Limestone, $\text{CaCO}_3$), Washing Tank. |
| **Inputs (I)** | Quicklime ($\text{CaO} >53.5\%$, density $1400 \text{ kg/m}^3$), Demineralized Water ($\text{H}_2\text{O}$). |
| **Process (P)** | Mixing in an agitated tank; Density controlled to $1664 \text{ kg/m}^3$; Temperature maintained at $60-70^{\circ}\text{C}$. |
| **Outputs (O)** | Homogeneous Lime Pulp. |
| **Customers (C)** | Pre-reactor unit (for Acidulation). |

---

### **STAGE 2: ACIDULATION (PHOSPHORIC ACID REACTION)**

| Component | Description |
| :--- | :--- |
| **Suppliers (S)** | $\text{H}_3\text{PO}_4$ Storage Tank. |
| **Inputs (I)** | Lime Pulp, Phosphoric Acid ($52-54\% \text{ P}_2\text{O}_5$). |
| **Process (P)** | Exothermic chemical reaction ($\text{CaO} + 2\text{H}_3\text{PO}_4 \rightarrow \text{Ca}(\text{H}_2\text{PO}_4)_2$); $\text{pH}$ controlled at 3.0-3.5; Temp control ($80-90^{\circ}\text{C}$), Reaction time 20-30 min. |
| **Outputs (O)** | Reaction Mixture (MCP Slurry/Suspension). |
| **Customers (C)** | Granulation Unit (Spinden). |

---

### **STAGE 3: GRANULATION (SPINDEN)**

| Component | Description |
| :--- | :--- |
| **Suppliers (S)** | Pre-reactor, Fines Recycling Line (materials $<1.5 \text{mm}$). |
| **Inputs (I)** | MCP Reaction Mixture, Recycled Fines. |
| **Process (P)** | Atomization (spraying) inside rotary drum; Granule formation (target size 1.5-2.2mm); Moisture content set at $\approx 8\%$. |
| **Outputs (O)** | Wet MCP Granules. |
| **Customers (C)** | Dryer Tube. |

---

### **STAGE 4: DRYING AND DUST COLLECTION**

| Component | Description |
| :--- | :--- |
| **Suppliers (S)** | Combustion Chamber (Hot Air $<100^{\circ}\text{C}$). |
| **Inputs (I)** | Wet Granules (8% humidity). |
| **Process (P)** | Rotary drying (Input T° $200-250^{\circ}\text{C}$, Output T° $\le 100^{\circ}\text{C}$); Dust capture via Cyclones (efficiency $>95\%$). |
| **Outputs (O)** | Dry MCP (final humidity $<3\%$), Captured Dust. |
| **Customers (C)** | Vibrating Screens. |

---

### **STAGE 5: SCREENING AND CLASSIFICATION**

| Component | Description |
| :--- | :--- |
| **Suppliers (S)** | Dryer Tube. |
| **Inputs (I)** | Dry MCP, Residual Dust. |
| **Process (P)** | Double-deck Vibrating Screening (2.2mm and 1.5mm); Recycling of fines/oversize. |
| **Outputs (O)** | Classified MCP (90\% minimum in 1.5-2.2mm range). |
| **Customers (C)** | Cooler unit. |

---

### **STAGE 6: COOLING**

| Component | Description |
| :--- | :--- |
| **Suppliers (S)** | Air Treatment Unit (Dry/Filtered Air). |
| **Inputs (I)** | Hot MCP ($\le 100^{\circ}\text{C}$). |
| **Process (P)** | Fluidized bed cooling (Target output T° $40^{\circ}\text{C}$); Final dedusting via bag filters. |
| **Outputs (O)** | Stabilized MCP ($\approx 40^{\circ}\text{C}$, dust-free). |
| **Customers (C)** | Storage Silos (Conveyor system). |

---

### **STAGE 7: STORAGE IN SILOS**

| Component | Description |
| :--- | :--- |
| **Suppliers (S)** | Cooling Line. |
| **Inputs (I)** | Stabilized, Dry, Cooled MCP. |
| **Process (P)** | Storage in Silos C and D (Capacity $800 \text{ tonnes}$ each); Controlled environment and fluidization. |
| **Outputs (O)** | Stable MCP inventory. |
| **Customers (C)** | Bagging Line (FFS) or Big Bag/Bulk Loading. |

---

### **STAGE 8: ENSACHAGE (FFS BAGGING LINE)**

| Component | Description |
| :--- | :--- |
| **Suppliers (S)** | Silos C/D, PE Film Supplier, Pallet Stock. |
| **Inputs (I)** | Stable MCP, Polyethylene (PE) Film, Empty Pallets. |
| **Process (P)** | FFS Machine (Form, Fill $25\text{kg} \pm 0.08\text{kg}$, Seal $140^{\circ}\text{C}$); 5-axis Robot Palletizing ($8 \text{ layers} \times 5 \text{ bags} = 40 \text{ bags}$); Stretch wrapping. |
| **Outputs (O)** | Pallets of $40 \text{ bags}$ (Net weight $1 \text{ Tonne} \pm 2\text{kg}$). |
| **Customers (C)** | Final Customers / Logistics and Shipping. |

