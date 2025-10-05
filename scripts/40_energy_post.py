#!/usr/bin/env python3
import csv, os, sys

ROOT = "/home/carlos/projects/gem5"
OUT_DATA = os.path.join(ROOT, "gem5-data", "SmartEdgeAI", "results")
OUT_IOT  = os.path.join(ROOT, "iot", "results")

src = os.path.join(OUT_DATA, "summary.csv")
dst_data = os.path.join(OUT_DATA, "summary_energy.csv")
dst_iot  = os.path.join(OUT_IOT,  "summary_energy.csv")

# modeling constants (document in your Methods)
EPI_PJ = {'big':200.0,'little':80.0,'hybrid':104.0}  # pJ/inst
E_MEM_PJ = 600.0                                      # pJ per L2 miss
DROWSY_SCALE = 0.85                                   # 15% energy drop when drowsy=1

rows=[]
with open(src) as f:
    r=csv.DictReader(f)
    for row in r:
        insts=float(row['insts'])
        secs=float(row['sim_seconds'])
        core=row['core']; drowsy=int(row['drowsy'])
        epi=EPI_PJ.get(core, EPI_PJ['little'])
        mr=float(row['l2_miss_rate']) if row['l2_miss_rate'] else 0.0

        l2_misses = mr * insts
        energy_J = (epi*1e-12)*insts + (E_MEM_PJ*1e-12)*l2_misses
        if drowsy==1:
            energy_J *= DROWSY_SCALE

        power_W = energy_J/secs if secs>0 else 0.0
        edp = energy_J * secs  # J*s

        row.update({
            'energy_J': f"{energy_J:.6f}",
            'power_W': f"{power_W:.6f}",
            'edp': f"{edp:.6e}",
            'epi_model_pJ': f"{epi:.1f}",
        })
        rows.append(row)

for path in (dst_data, dst_iot):
    with open(path, 'w', newline='') as f:
        w=csv.DictWriter(f, fieldnames=list(rows[0].keys()))
        w.writeheader(); w.writerows(rows)
print(f"[energy] wrote {dst_data} and mirrored to {dst_iot}")

