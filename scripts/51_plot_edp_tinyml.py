#!/usr/bin/env python3
import csv, os
import matplotlib.pyplot as plt

root = os.path.dirname(os.path.dirname(__file__))
src = os.path.join(root, "results", "phase3_summary_energy.csv")
out = os.path.join(root, "results", "fig_tinyml_edp.png")

labels=[]; edps=[]
with open(src) as f:
    r=csv.DictReader(f)
    for row in r:
        if row['workload']!='tinyml_kws': continue
        labels.append(f"{row['core']}-{row['dvfs']}-L2{row['l2']}-d{row['drowsy']}")
        edps.append(float(row['edp']))

plt.figure()
plt.bar(labels, edps)
plt.ylabel('EDP (J·s)')
plt.title('TinyML: EDP by configuration')
plt.xticks(rotation=60, ha='right')
plt.tight_layout()
plt.savefig(out)
print(f"[plot] wrote {out}")

