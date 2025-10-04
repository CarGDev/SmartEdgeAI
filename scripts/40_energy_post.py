#!/usr/bin/env python3
import csv, sys, os

root = os.path.dirname(os.path.dirname(__file__))
src = os.path.join(root, "results", "phase3_summary.csv")
dst = os.path.join(root, "results", "phase3_summary_energy.csv")

# === your modeling constants (document in Methods) ===
EPI_PJ = {'big': 200.0, 'little': 80.0, 'hybrid': 104.0}  # pJ/inst
E_MEM_PJ = 600.0                                          # pJ per L2 miss
DROWSY_SCALE = 0.85                                       # 15% energy reduction when drowsy=1

rows=[]
with open(src) as f:
    r=csv.DictReader(f)
    for row in r:
        insts = float(row['insts'])
        secs  = float(row['sim_seconds'])
        core  = row['core']
        drowsy= int(row['drowsy'])
        epi_pJ= EPI_PJ.get(core, EPI_PJ['little'])

        mr = float(row['l2_miss_rate']) if row['l2_miss_rate'] else 0.0
        l2_misses = mr * insts  # proxy; replace with MPKI-based calc if available

        energy_instr = (epi_pJ * 1e-12) * insts
        energy_mem   = (E_MEM_PJ * 1e-12) * l2_misses
        energy_J     = energy_instr + energy_mem
        if drowsy == 1:
            energy_J *= DROWSY_SCALE

        power_W = energy_J / secs if secs > 0 else 0.0
        edp = energy_J * secs   # CORRECT EDP

        row.update({
            'energy_J': f"{energy_J:.6f}",
            'power_W':  f"{power_W:.6f}",
            'edp':      f"{edp:.6e}",
            'epi_model_pJ': f"{epi_pJ:.1f}",
        })
        rows.append(row)

with open(dst, 'w', newline='') as f:
    w=csv.DictWriter(f, fieldnames=list(rows[0].keys()))
    w.writeheader(); w.writerows(rows)

print(f"[energy] wrote {dst}")

