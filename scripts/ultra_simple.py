#!/usr/bin/env python3
# Ultra-simple gem5 configuration for SmartEdgeAI
import argparse, m5
from m5.objects import *

# Parse arguments
ap = argparse.ArgumentParser()
ap.add_argument("--cmd", required=True)
ap.add_argument("--mem", default="16GB")
ap.add_argument("--l2", default="1MB")
ap.add_argument("--dvfs", choices=["high","low"], default="high")
ap.add_argument("--drowsy", type=int, choices=[0,1], default=0)
ap.add_argument("--core", choices=["big","little","hybrid"], default="big")
ap.add_argument("--outdir", default="m5out")
args = ap.parse_args()

# Create system
system = System()
system.clk_domain = SrcClockDomain(clock="2GHz" if args.dvfs == "high" else "1GHz", 
                                   voltage_domain=VoltageDomain(voltage="1.0V" if args.dvfs == "high" else "0.8V"))
system.mem_mode = "timing"
system.mem_ranges = [AddrRange(args.mem)]

# Create CPU based on core type
if args.core == "big":
    system.cpu = O3CPU()
elif args.core == "little":
    system.cpu = TimingSimpleCPU()
else:  # hybrid
    system.cpu = O3CPU()

# Create memory bus
system.membus = SystemXBar()

# Connect CPU to memory bus directly (no caches for simplicity)
system.cpu.icache_port = system.membus.cpu_side_ports
system.cpu.dcache_port = system.membus.cpu_side_ports

# Create memory controller
system.mem_ctrl = SimpleMemory()
system.mem_ctrl.range = system.mem_ranges[0]
system.mem_ctrl.port = system.membus.mem_side_ports

# Connect system port
system.system_port = system.membus.cpu_side_ports

# Create workload using the simplest approach
system.cpu.workload = SEWorkload.init_compatible("hello")
system.cpu.workload.executable = args.cmd
system.cpu.createThreads()

# Create root and run simulation
root = Root(full_system=False, system=system)
m5.instantiate()

print("[SmartEdgeAI] Starting simulation...")
exit_event = m5.simulate()
print(f"[SmartEdgeAI] Exiting @ tick {m5.curTick()} because {exit_event.getCause()}")
