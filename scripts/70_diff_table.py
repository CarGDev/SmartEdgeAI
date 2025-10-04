#!/usr/bin/env python3
import csv, os
root = os.path.dirname(os.path.dirname(__file__))
src = os.path.join(root, "results", "phase3_summary_energy.csv")
dst = os.path.join(root, "results", "phase3_drowsy_deltas.csv")

# group by key without drowsy; compare d0 vs d1
from collections import defaultdict
bykey = defaultdict(dict)

with open(src) as f:
    r=csv.DictReader(f)
    for row in r:
        key = (row['workload'], row['core'], row['dvfs'], row['l2'])
        bykey[key][row['drowsy']] = row

rows=[]
for k, d in bykey.items():
    if '0' in d and '1' in d:
        a=d['0']; b=d['1']
        e0=float(a['energy_J']); e1=float(b['energy_J'])
        edp0=float(a['edp']);    edp1=float(b['edp'])
        rows.append({
            'workload':k[0],'core':k[1],'dvfs':k[2],'l2':k[3],
            'energy_drop_%': f"{100*(e0-e1)/e0:.2f}",
            'edp_drop_%':    f"{100*(edp0-edp1)/edp0:.2f}"
        })

with open(dst,'w',newline='') as f:
    w=csv.DictWriter(f, fieldnames=list(rows[0].keys()))
    w.writeheader(); w.writerows(rows)

print(f"[delta] wrote {dst}")

