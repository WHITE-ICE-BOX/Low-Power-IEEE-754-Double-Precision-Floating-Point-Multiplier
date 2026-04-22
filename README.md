# Low-Power IEEE-754 Double-Precision Floating-Point Multiplier

> 64-bit IEEE-754 Double-Precision FP Multiplier — Full RTL-to-GDSII ASIC Implementation
> **Measured Power: 0.7196 mW (-64% vs. 2 mW target, Top 1% among peers)** @ 1 GHz

![Status](https://img.shields.io/badge/Flow-RTL--to--GDSII-brightgreen)
![Clock](https://img.shields.io/badge/Clock-1%20GHz-blue)
![Power](https://img.shields.io/badge/Power-0.7196%20mW-success)
![Standard](https://img.shields.io/badge/IEEE%20754-Compliant-orange)

---

## Key Results

| Metric | Value | Note |
|--------|-------|------|
| **Power** | **0.7196 mW** | **-64 % vs. 2 mW SPEC / Top 1 %** |
| **Clock** | 1 GHz | Post-PnR Timing Closed |
| **Standard** | IEEE-754 Double-Precision (64-bit) | Full compliance |
| **Process** | TSMC N16 ADFP | Cell-based |
| **Flow Coverage** | RTL → Synthesis → APR → Sign-off → GDSII | Independent, end-to-end |
| **EDA** | Cadence (Genus / Innovus / Tempus / Verdi) · Siemens Calibre | |

---

## Design Highlights

- 🔧 **Shift-and-Add Architecture** — replaces parallel Wallace-tree multiplier, drastically reducing switching activity on the partial-product network.
- ⚡ **Low-Power Techniques** — Clock Gating (ICG), Operand Isolation, Resource Sharing, Multi-Vt Cell Selection, Low-Power Synthesis.
- 🎯 **Aggressive Timing Target** — 1 GHz post-route timing closed with MCMM (multi-corner / multi-mode).
- ✅ **Clean Sign-off** — Calibre DRC / LVS / LPE Clean, post-layout simulation aligned with RTL.
- 📊 **Quantified Verification** — RTL vs. Post-Layout netlist + SDF back-annotated functional / timing check.

---

## ASIC Flow

```
┌───────────┐   ┌───────────┐   ┌────────────┐   ┌─────────────┐   ┌─────────────┐   ┌────────┐
│  Verilog  │──▶│  Genus    │──▶│  Gate-Level│──▶│   Innovus   │──▶│   Calibre   │──▶│ GDSII  │
│    RTL    │   │ Synthesis │   │   Sim      │   │ APR + CTS   │   │ DRC/LVS/LPE │   │Sign-off│
└───────────┘   └───────────┘   └────────────┘   └─────────────┘   └─────────────┘   └────────┘
      │              │                                   │                  │
   SDC/TCL       Low-Power                           Post-route          PEX +
   Constraints   Optimization                        Hold ECO            STA
```

| Stage | Tool | Deliverable |
|-------|------|-------------|
| **RTL Design** | Verilog | Shift-and-Add IEEE-754 multiplier |
| **Simulation** | NC-Verilog / Verdi / nWave | Functional verification |
| **Synthesis** | Cadence Genus | Gate-level netlist, PPA report, MCMM setup |
| **Gate-Level Sim** | NC-Verilog | Post-synthesis functional check |
| **APR / PnR** | Cadence Innovus | Floorplan, CTS, Placement, Routing, Antenna / Hold ECO |
| **Post-Layout Sim** | NC-Verilog + SDF | Timing-annotated verification |
| **PEX / STA** | Calibre PEX + Tempus | Parasitic-aware timing / power analysis |
| **Sign-off** | Siemens Calibre | DRC, LVS, LPE Clean — GDSII ready |

---

## Repository Structure

```
.
├── RTL/Floating_Point_Number_Multiplier/   # 64-bit IEEE-754 Shift-and-Add RTL
├── Synthesis/                              # Genus scripts, SDC constraints, reports
├── Netlist_syn/                            # Post-synthesis gate-level netlist + sim
├── innovus/                                # Innovus APR scripts (Floorplan / CTS / Route)
├── Netlist/                                # Post-APR netlist + timing-annotated sim
├── DRC,LVS/                                # Calibre DRC / LVS / LPE + GDSII
└── RESULT/                                 # Final PPA reports + design documentation
```

---

## Tools & Environment

| Category | Tools |
|----------|-------|
| **RTL / Simulation** | Verilog, NC-Verilog, Verdi, nWave |
| **Synthesis** | Cadence Genus |
| **Physical Design** | Cadence Innovus |
| **STA / Parasitic** | Cadence Tempus, Calibre PEX |
| **Sign-off Verification** | Siemens Calibre (DRC / LVS / LPE) |
| **Languages** | Verilog, SDC, TCL |

---

## What Was Demonstrated

This project demonstrates the ability to **independently drive a full ASIC front-end-to-GDSII flow**, with special emphasis on low-power datapath design:

- Writing clean, synthesizable IEEE-754 compliant RTL.
- Setting up SDC timing constraints (including MCMM and false-path handling).
- Driving logic synthesis with explicit low-power optimization (ICG, operand isolation, resource sharing).
- Executing Innovus APR with antenna-rule ECO and post-route hold fixing.
- Calibre DRC / LVS / LPE sign-off, parasitic-aware STA, and post-layout simulation.
- Producing reproducible PPA reports that survive reviewer scrutiny.

---

## Contact

**Po-Chun Huang (黃柏鈞 / Barkie)** — Zhubei, Hsinchu, Taiwan
📧 [barkie.huang@gmail.com](mailto:barkie.huang@gmail.com)
🔗 GitHub: [WHITE-ICE-BOX](https://github.com/WHITE-ICE-BOX)

> M.S. student at National Chung Cheng University CSIE, specializing in
> digital IC front-end design and ASIC system integration.
