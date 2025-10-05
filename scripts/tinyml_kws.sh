cat > /home/carlos/projects/gem5/gem5-run/tinyml_kws << 'SH'
#!/bin/bash
# placeholder workload; swap later for your real binary
for i in $(seq 1 2000000); do :; done
echo "tinyml_kws: done"
SH
chmod +x /home/carlos/projects/gem5/gem5-run/tinyml_kws

