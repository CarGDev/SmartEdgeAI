#!/usr/bin/env python3
import csv
import os
from collections import defaultdict

import matplotlib.pyplot as plt

ROOT = "/home/carlos/projects/gem5"
OUT_DATA = os.path.join(ROOT, "gem5-data", "SmartEdgeAI", "results")
OUT_IOT = os.path.join(ROOT, "iot", "results")
src = os.path.join(OUT_DATA, "summary_energy.csv")
out_data = os.path.join(OUT_DATA, "fig_epi_across_workloads.png")
out_iot = os.path.join(OUT_IOT, "fig_epi_across_workloads.png")

epi_by_core = defaultdict(list)
with open(src) as f:
    r = csv.DictReader(f)
    for row in r:
        insts = float(row["insts"])
        energy = float(row["energy_J"])
        epi = 1e12 * energy / insts if insts > 0 else 0.0
        epi_by_core[row["core"]].append(epi)

cores = ["big", "little", "hybrid"]
vals = [sum(epi_by_core[c]) / max(1, len(epi_by_core[c])) for c in cores]

plt.figure()
plt.bar(cores, vals)
plt.ylabel("EPI (pJ/inst)")
plt.title("Energy per Instruction across workloads (avg by core mode)")
plt.tight_layout()
plt.savefig(out_data)
plt.savefig(out_iot)
print(f"[plot] wrote {out_data} and mirrored to {out_iot}")
