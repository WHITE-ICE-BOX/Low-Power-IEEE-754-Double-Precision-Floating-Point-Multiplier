# 🔬 Low-Power IEEE-754 Double Precision Floating Point Multiplier

本專案實作 **64-bit IEEE-754 浮點數乘法器**，針對功耗進行深度優化。  
原始 SPEC 為 **功耗低於 2 mW**，本設計採用 **Shift-and-Add 演算法** 取代平行乘法結構，  
最終量測功耗 **0.7196 mW**，位居同儕 **前 1%**。  

---

## 📂 專案結構與內容介紹

### 1. RTL 設計
- **路徑**：`RTL/Floating_Point_Number_Multiplier/`  
- **內容**：  
  - 實現 64-bit IEEE-754 乘法器  
  - 採用 Shift-and-Add 降低功耗
  
---

### 2. Synthesis
- **路徑**：`Synthesis/`  
- **內容**：  
  - 使用 **Cadence Genus** 匯入 RTL 與 SDC  
  - 設定 **1 GHz** 時脈，支援 **multi-corner / multi-mode (MCMM)**  
  - 自動選用 **低功耗 standard cell**  
  - 產生 **gate-level netlist**，並檢視初步 **面積 / 功耗報告**  

---

### 3. Gate-Level Netlist 驗證
- **路徑**：`Netlist_syn/`  
- **內容**：  
  - 驗證 Synthesis 轉換後的 Gate-Level 電路是否正確  
  - 確認正確後，進入 APR 階段  

---

### 4. APR (Place & Route)
- **路徑**：`innovus/`  
- **內容**：  
  - 使用 **Cadence Innovus** 完成：
    - Floorplanning / I/O macro 佈局  
    - Clock Tree Synthesis (CTS)  
    - Placement & Routing  
  - 搭配 **TCL / Optimus** 腳本，反覆修正 DRC/ERC  

---

### 5. Netlist 驗證
- **路徑**：`Netlist/`  
- **內容**：  
  - 在 APR 之後，驗證電路於 **延遲資訊 (delay info)** 下能否正常運作  

---

### 6. DRC / LVS & PEX
- **路徑**：`DRC,LVS`  
- **內容**：  
  - **Calibre PEX**：寄生擷取、STA、power analysis  
  - **Calibre DRC/LVS**：最終簽核，輸出：  
    - GDSII  
    - Netlist  
    - Timing & Power 報告  

---

### 7. 專案成果
- **路徑**：`RESULT/`  
- **內容**：  
  - 程式碼整理 (Code Organization & Circuit Overview)  
  - 功耗 / 面積 / 效能結果  
  - 電路運作原理與程式設計細節  

---

## 🛠️ 使用工具與環境
- **語言**：Verilog / SDC / TCL  
- **模擬工具**：Cadence NC-Verilog, nWave, Verdi  
- **綜合 (Synthesis)**：Cadence Genus  
- **APR (Place & Route)**：Cadence Innovus  
- **驗證**：Mentor Calibre (PEX, DRC/LVS)  

---

## 📊 專案亮點
- ✅ **低功耗設計**：功耗降至 **0.7196 mW**，優於原始 SPEC  
- ✅ **多樣化子模組**：包含浮點乘法器、Transformer Attention、幾何計算單元  
- ✅ **完整 ASIC Flow**：RTL → Synthesis → APR → DRC/LVS → GDSII  
