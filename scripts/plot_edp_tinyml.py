#!/usr/bin/env python3
import csv
import os

import matplotlib.pyplot as plt

ROOT = "/home/carlos/projects/gem5"
OUT_DATA = os.path.join(ROOT, "gem5-data", "SmartEdgeAI", "results")
OUT_IOT = os.path.join(ROOT, "iot", "results")
src = os.path.join(OUT_DATA, "summary_energy.csv")
out_data = os.path.join(OUT_DATA, "fig_tinyml_edp.png")
out_iot = os.path.join(OUT_IOT, "fig_tinyml_edp.png")

labels = []
edps = []
with open(src) as f:
    r = csv.DictReader(f)
    for row in r:
        if row["workload"] != "tinyml_kws":
            continue
        labels.append(f"{row['core']}-{row['dvfs']}-L2{row['l2']}-d{row['drowsy']}")
        edps.append(float(row["edp"]))

plt.figure()
plt.bar(labels, edps)
plt.ylabel("EDP (J·s)")
plt.title("TinyML: EDP by configuration")
plt.xticks(rotation=60, ha="right")
plt.tight_layout()
plt.savefig(out_data)
plt.savefig(out_iot)
print(f"[plot] wrote {out_data} and mirrored to {out_iot}")
