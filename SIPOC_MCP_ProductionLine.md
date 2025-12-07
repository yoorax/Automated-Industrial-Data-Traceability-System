# 🏭 **SIPOC\_ANALYSIS.MD** 🏭

## **1. INTRODUCTION**

This document provides a detailed **SIPOC (Suppliers, Inputs, Process, Outputs, Customers)** analysis of the Monocalcium Phosphate (MCP) production process at the **OCP Safi industrial site**. This analysis defines the boundaries of the production line and served as the foundation for the **Automated Industrial Data Traceability System** project.

[cite_start]The process is systematically broken down into **eight sequential stages**, starting from the preparation of raw materials up to the final packaging and dispatch of the product [cite: 327-428].

---

## **2. DETAILED SIPOC BREAKDOWN**

### **STAGE 1: PREPARATION OF LIME PULP**

| Component | Description |
| :--- | :--- |
| **Suppliers (S)** | [cite_start]Silos A/B (Limestone, $\text{CaCO}_3$), Washing Tank [cite: 335-337]. |
| **Inputs (I)** | [cite_start]Quicklime ($\text{CaO} >53.5\%$, density $1400 \text{ kg/m}^3$), Demineralized Water ($\text{H}_2\text{O}$) [cite: 339-340]. |
| **Process (P)** | [cite_start]Mixing in an agitated tank[cite: 342]; [cite_start]Density controlled to $1664 \text{ kg/m}^3$[cite: 342]; [cite_start]Temperature maintained at $60-70^{\circ}\text{C}$[cite: 343]. |
| **Outputs (O)** | Homogeneous Lime Pulp. |
| **Customers (C)** | [cite_start]Pre-reactor unit (for Acidulation)[cite: 347]. |

---

### **STAGE 2: ACIDULATION (PHOSPHORIC ACID REACTION)**

| Component | Description |
| :--- | :--- |
| **Suppliers (S)** | $\text{H}_3\text{PO}_4$ Storage Tank. |
| **Inputs (I)** | [cite_start]Lime Pulp, Phosphoric Acid ($52-54\% \text{ P}_2\text{O}_5$)[cite: 349]. |
| **Process (P)** | [cite_start]Exothermic chemical reaction ($\text{CaO} + 2\text{H}_3\text{PO}_4 \rightarrow \text{Ca}(\text{H}_2\text{PO}_4)_2$)[cite: 352]; [cite_start]$\text{pH}$ controlled at 3.0-3.5[cite: 352]; [cite_start]Temp control ($80-90^{\circ}\text{C}$), Reaction time 20-30 min[cite: 352]. |
| **Outputs (O)** | [cite_start]Reaction Mixture (MCP Slurry/Suspension)[cite: 353]. |
| **Customers (C)** | [cite_start]Granulation Unit (Spinden)[cite: 353]. |

---

### **STAGE 3: GRANULATION (SPINDEN)**

| Component | Description |
| :--- | :--- |
| **Suppliers (S)** | [cite_start]Pre-reactor, Fines Recycling Line (materials $<1.5 \text{mm}$)[cite: 356]. |
| **Inputs (I)** | [cite_start]MCP Reaction Mixture, Recycled Fines[cite: 357]. |
| **Process (P)** | [cite_start]Atomization (spraying) inside rotary drum[cite: 359]; [cite_start]Granule formation (target size 1.5-2.2mm)[cite: 360]; [cite_start]Moisture content set at $\approx 8\%$[cite: 361]. |
| **Outputs (O)** | [cite_start]Wet MCP Granules[cite: 362]. |
| **Customers (C)** | [cite_start]Dryer Tube[cite: 363]. |

---

### **STAGE 4: DRYING AND DUST COLLECTION**

| Component | Description |
| :--- | :--- |
| **Suppliers (S)** | [cite_start]Combustion Chamber (Hot Air $<100^{\circ}\text{C}$)[cite: 365]. |
| **Inputs (I)** | [cite_start]Wet Granules (8% humidity)[cite: 366]. |
| **Process (P)** | [cite_start]Rotary drying (Input T° $200-250^{\circ}\text{C}$, Output T° $\le 100^{\circ}\text{C}$)[cite: 368]; [cite_start]Dust capture via Cyclones (efficiency $>95\%$)[cite: 369]. |
| **Outputs (O)** | [cite_start]Dry MCP (final humidity $<3\%$) [cite: 371][cite_start], Captured Dust[cite: 372]. |
| **Customers (C)** | [cite_start]Vibrating Screens[cite: 372]. |

---

### **STAGE 5: SCREENING AND CLASSIFICATION**

| Component | Description |
| :--- | :--- |
| **Suppliers (S)** | [cite_start]Dryer Tube[cite: 374]. |
| **Inputs (I)** | [cite_start]Dry MCP, Residual Dust[cite: 375]. |
| **Process (P)** | [cite_start]Double-deck Vibrating Screening (2.2mm and 1.5mm)[cite: 377]; [cite_start]Recycling of fines/oversize[cite: 379]. |
| **Outputs (O)** | [cite_start]Classified MCP (90\% minimum in 1.5-2.2mm range)[cite: 382]. |
| **Customers (C)** | [cite_start]Cooler unit[cite: 384]. |

---

### **STAGE 6: COOLING**

| Component | Description |
| :--- | :--- |
| **Suppliers (S)** | [cite_start]Air Treatment Unit (Dry/Filtered Air)[cite: 386]. |
| **Inputs (I)** | [cite_start]Hot MCP ($\le 100^{\circ}\text{C}$)[cite: 387]. |
| **Process (P)** | [cite_start]Fluidized bed cooling (Target output T° $40^{\circ}\text{C}$)[cite: 389]; [cite_start]Final dedusting via bag filters[cite: 389]. |
| **Outputs (O)** | [cite_start]Stabilized MCP ($\approx 40^{\circ}\text{C}$, dust-free)[cite: 391]. |
| **Customers (C)** | [cite_start]Storage Silos (Conveyor system)[cite: 392]. |

---

### **STAGE 7: STORAGE IN SILOS**

| Component | Description |
| :--- | :--- |
| **Suppliers (S)** | [cite_start]Cooling Line[cite: 394]. |
| **Inputs (I)** | [cite_start]Stabilized, Dry, Cooled MCP[cite: 395]. |
| **Process (P)** | [cite_start]Storage in Silos C and D (Capacity $800 \text{ tonnes}$ each)[cite: 397]; [cite_start]Controlled environment and fluidization[cite: 397]. |
| **Outputs (O)** | [cite_start]Stable MCP inventory[cite: 399]. |
| **Customers (C)** | [cite_start]Bagging Line (FFS) or Big Bag/Bulk Loading[cite: 400]. |

---

### **STAGE 8: ENSACHAGE (FFS BAGGING LINE)**

| Component | Description |
| :--- | :--- |
| **Suppliers (S)** | [cite_start]Silos C/D, PE Film Supplier, Pallet Stock [cite: 403-404, 408]. |
| **Inputs (I)** | [cite_start]Stable MCP, Polyethylene (PE) Film, Empty Pallets [cite: 407-408]. |
| **Process (P)** | [cite_start]FFS Machine (Form, Fill $25\text{kg} \pm 0.08\text{kg}$, Seal $140^{\circ}\text{C}$) [cite: 411-413]; [cite_start]5-axis Robot Palletizing ($8 \text{ layers} \times 5 \text{ bags} = 40 \text{ bags}$)[cite: 416]; [cite_start]Stretch wrapping[cite: 417]. |
| **Outputs (O)** | [cite_start]Pallets of $40 \text{ bags}$ (Net weight $1 \text{ Tonne} \pm 2\text{kg}$)[cite: 418]. |
| **Customers (C)** | [cite_start]Final Customers / Logistics and Shipping[cite: 419]. |
