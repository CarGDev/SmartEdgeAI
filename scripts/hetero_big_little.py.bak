# Simple heterogeneous big.LITTLE configuration for SmartEdgeAI
import m5
from m5.objects import *

system = System()
system.clk_domain = SrcClockDomain(clock="1GHz", voltage_domain=VoltageDomain())
system.mem_mode = "timing"
system.mem_ranges = [AddrRange("512MB")]

# two LITTLE + one BIG
system.cpu = [TimingSimpleCPU(cpu_id=i) for i in range(3)]
system.membus = SystemXBar()

for cpu in system.cpu:
    cpu.icache_port = system.membus.slave
    cpu.dcache_port = system.membus.slave

system.system_port = system.membus.slave
system.mem_ctrl = DDR3_1600_8x8()
system.mem_ctrl.range = system.mem_ranges[0]
system.mem_ctrl.port = system.membus.master

system.workload = SEWorkload.init_compatible("hello")
for cpu in system.cpu:
    cpu.workload = system.workload
    cpu.createThreads()

root = Root(full_system=False, system=system)
m5.instantiate()
print("=== SmartEdgeAI big.LITTLE configuration loaded ===")
exit_event = m5.simulate()
print("Exit:", exit_event.getCause())
