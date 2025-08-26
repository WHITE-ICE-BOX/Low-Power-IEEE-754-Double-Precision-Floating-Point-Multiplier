專案講解

1.路徑 : Low-Power-IEEE-754-Double-Precision-Floating-Point-Multiplier/RTL/Floating_Point_Number_Multiplier/
內容介紹 : 
  實現 64 bit IEEE-754 乘法器，並針對功耗進行深度優化。
  原始 SPEC 為低於 2 mW，本設計採用 Shift-and-Add 演算法取代平行乘法結構，最終量測功耗 0.7196 mW，位居同儕前 1%。

2.路徑 : Low-Power-IEEE-754-Double-Precision-Floating-Point-Multiplier/RTL/other/
內容介紹 :
  Gate_Level_Encoded_Multiplier：實現閘級編碼技術。
  Transformer_Attention Unit：針對注意力機制構建專用硬體加速模組。
  Sorting_the_Areas_of_Heptagons：設計面積排序單元，支援多筆七邊形資料排序。
  Coordinate_calculator：開發三角形內部整數座標掃描與驗證 FSM。

3.路徑 : Low-Power-IEEE-754-Double-Precision-Floating-Point-Multiplier/Synthesis/
內容介紹 :
  在 Cadence Genus 中匯入 RTL 與 SDC，設定 1 GHz 時脈及多角落、多模式 (multi-corner, multi-mode) 約束。
  自動選用低功耗 standard cell，產出 gate-level netlist 並檢視初步面積與功耗報告。

4.路徑 : Low-Power-IEEE-754-Double-Precision-Floating-Point-Multiplier/Netlist_syn/
內容介紹 :
  驗證Synthesis後轉換成Gate_Level的電路是否正確，若無誤則進入APR

5.路徑 : Low-Power-IEEE-754-Double-Precision-Floating-Point-Multiplier/innovus/
內容介紹 :
  利用Cadence EDA Tool Innovus 完成 floorplanning、I/O macro 佈局與 clock tree synthesis (CTS)。
  執行 placement、routing，並以 TCL/Optimus 腳本反覆修正 DRC/ERC 例外。

6.路徑 : Low-Power-IEEE-754-Double-Precision-Floating-Point-Multiplier/Netlist/
內容介紹 :
  APR之後需要驗證電路在實際加入各種DELAY資訊之後是否可以正常運作

7.路徑 : Low-Power-IEEE-754-Double-Precision-Floating-Point-Multiplier/DRC,LVS
內容介紹 :
  Calibre PEX 擷取寄生，重跑 STA 與 power analysis。
  Calibre DRC/LVS 最終簽核，輸出 GDSII、netlist、timing & power 報告。

8.路徑 : Low-Power-IEEE-754-Double-Precision-Floating-Point-Multiplier/RESULT/
內容介紹 :
  程式碼整理 (Code Organization & Circuit Overview)
  包含功耗 / 面積 / 效能以及過程
  詳細解釋電路運作原理以及程式設計說明

關鍵工具
Verilog / SDC / TCL • Cadence NC-Verilog, nWave, Verdi, Genus, Innovus • Mentor Calibre (PEX, DRC/LVS)
