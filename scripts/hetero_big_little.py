# scripts/hetero_big_little.py
# Minimal SmartEdgeAI heterogeneous ARM system
# Supports --cmd, --mem, --l2, --dvfs, and --drowsy
# Generates valid stats.txt for all workloads

import argparse, m5
from m5.objects import *

# -------------------------------
# Argument parsing
# -------------------------------
ap = argparse.ArgumentParser()
ap.add_argument("--cmd", required=True)
ap.add_argument("--mem", default="16GB")
ap.add_argument("--l2", default="1MB")
ap.add_argument("--dvfs", choices=["high","low"], default="high")
ap.add_argument("--drowsy", type=int, choices=[0,1], default=0)
args = ap.parse_args()

# -------------------------------
# Clock & Voltage (DVFS)
# -------------------------------
v = VoltageDomain(voltage="1.0V" if args.dvfs == "high" else "0.8V")
clk = "2GHz" if args.dvfs == "high" else "1GHz"

system = System(
    clk_domain=SrcClockDomain(clock=clk, voltage_domain=v),
    mem_mode="timing",
    mem_ranges=[AddrRange(args.mem)]
)

# -------------------------------
# CPU cluster: 1 big + 2 little
# -------------------------------
big = O3CPU(cpu_id=0)
little1 = TimingSimpleCPU(cpu_id=1)
little2 = TimingSimpleCPU(cpu_id=2)
system.cpu = [big, little1, little2]

# -------------------------------
# Cache hierarchy
# -------------------------------
class L1I(Cache): size = "32kB"
class L1D(Cache): size = "32kB"
class L2(Cache):  size = args.l2

system.l2bus = L2XBar()
for c in system.cpu:
    c.icache = L1I()
    c.dcache = L1D()
    c.icache.cpu_side = c.icache_port
    c.dcache.cpu_side = c.dcache_port
    c.icache.mem_side = system.l2bus.slave
    c.dcache.mem_side = system.l2bus.slave

system.l2 = L2()
system.membus = SystemXBar()
system.l2.cpu_side = system.l2bus.master
system.l2.mem_side = system.membus.slave

# -------------------------------
# Drowsy cache behavior
# -------------------------------
if args.drowsy:
    system.l2.tag_latency = 24
    system.l2.data_latency = 24

# -------------------------------
# Memory controller
# -------------------------------
system.mem_ctrl = DDR3_1600_8x8()
system.mem_ctrl.range = system.mem_ranges[0]
system.mem_ctrl.port = system.membus.master
system.system_port = system.membus.slave

# -------------------------------
# Workload setup
# -------------------------------
proc = Process()
proc.executable = args.cmd
proc.cmd = [args.cmd]
proc.env = {'GLIBC_TUNABLES': 'glibc.pthread.rseq=0'}
for c in system.cpu:
    c.workload = proc
    c.createThreads()

# -------------------------------
# Instantiate and simulate
# -------------------------------
root = Root(full_system=False, system=system)
m5.instantiate()
print("[SmartEdgeAI] Starting simulation...")
exit_event = m5.simulate()
print(f"[SmartEdgeAI] Exiting @ tick {m5.curTick()} because {exit_event.getCause()}")

