#!/usr/bin/env python3
import csv, os
import matplotlib.pyplot as plt
from collections import defaultdict

root = os.path.dirname(os.path.dirname(__file__))
src = os.path.join(root, "results", "phase3_summary_energy.csv")
out = os.path.join(root, "results", "fig_epi_across_workloads.png")

epi_by_core = defaultdict(list)
with open(src) as f:
    r=csv.DictReader(f)
    for row in r:
        insts=float(row['insts']); energy=float(row['energy_J'])
        epi = 1e12*energy/insts if insts>0 else 0.0
        epi_by_core[row['core']].append(epi)

cores=['big','little','hybrid']
vals=[sum(epi_by_core[c])/max(1,len(epi_by_core[c])) for c in cores]

plt.figure()
plt.bar(cores, vals)
plt.ylabel('EPI (pJ/inst)')
plt.title('Energy per Instruction across Workloads (avg by core mode)')
plt.tight_layout()
plt.savefig(out)
print(f"[plot] wrote {out}")

