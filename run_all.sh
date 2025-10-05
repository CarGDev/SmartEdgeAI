#!/bin/bash
set -eu

# SmartEdgeAI Master Script
# Runs the complete sequence from README.md

echo "=========================================="
echo "SmartEdgeAI - Complete Workflow"
echo "=========================================="

# Function to run a step with error checking
run_step() {
    local step_name="$1"
    local command="$2"
    local check_command="$3"
    
    echo ""
    echo "🔄 Step: $step_name"
    echo "Command: $command"
    echo "----------------------------------------"
    
    if eval "$command"; then
        echo "✅ $step_name completed successfully"
        
        if [ -n "$check_command" ]; then
            echo "🔍 Checking results..."
            eval "$check_command"
        fi
    else
        echo "❌ $step_name FAILED"
        echo "Please check the error messages above and fix the issue before continuing."
        echo "You can run individual steps manually to debug."
        exit 1
    fi
}

# Function to check if a file exists and has content
check_file() {
    local file="$1"
    local description="$2"
    
    if [ -f "$file" ]; then
        local size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null || echo "0")
        if [ "$size" -gt 0 ]; then
            echo "✅ $description: $file ($size bytes)"
            return 0
        else
            echo "⚠️  $description: $file (empty)"
            return 1
        fi
    else
        echo "❌ $description: $file (not found)"
        return 1
    fi
}

# Step 0: Check Prerequisites
run_step "Check Prerequisites" \
    "sh scripts/check_gem5.sh" \
    "echo 'Prerequisites check completed'"

# Step 1: Setup Environment
run_step "Setup Environment" \
    "sh scripts/env.sh" \
    "check_file 'logs/env.txt' 'Environment log'"

# Step 2: Build Workloads
run_step "Build Workloads" \
    "sh scripts/build_workloads.sh" \
    "ls -la /home/carlos/projects/gem5/gem5-run/ | grep -E '(tinyml_kws|sensor_fusion|aes_ccm|attention_kernel)'"

# Step 3: Test Single Run
run_step "Test Single Run" \
    "sh scripts/run_one.sh tinyml_kws big high 0 1MB" \
    "check_file '/home/carlos/projects/gem5/gem5-data/SmartEdgeAI/results/tinyml_kws_big_high_l21MB_d0/stats.txt' 'Stats file'"

# Step 4: Run Full Matrix
run_step "Run Full Matrix" \
    "sh scripts/sweep.sh" \
    "ls -la /home/carlos/projects/gem5/gem5-data/SmartEdgeAI/results/ | wc -l"

# Step 5: Extract Statistics
run_step "Extract Statistics" \
    "sh scripts/extract_csv.sh" \
    "check_file '/home/carlos/projects/gem5/gem5-data/SmartEdgeAI/results/summary.csv' 'Summary CSV'"

# Step 6: Compute Energy Metrics
run_step "Compute Energy Metrics" \
    "python3 scripts/energy_post.py" \
    "check_file '/home/carlos/projects/gem5/gem5-data/SmartEdgeAI/results/summary_energy.csv' 'Energy CSV'"

# Step 7: Generate Plots
run_step "Generate EPI Plot" \
    "python3 scripts/plot_epi.py" \
    "check_file '/home/carlos/projects/gem5/gem5-data/SmartEdgeAI/results/fig_epi_across_workloads.png' 'EPI Plot'"

run_step "Generate EDP Plot" \
    "python3 scripts/plot_edp_tinyml.py" \
    "check_file '/home/carlos/projects/gem5/gem5-data/SmartEdgeAI/results/fig_tinyml_edp.png' 'EDP Plot'"

# Step 8: Bundle Logs
run_step "Bundle Logs" \
    "sh scripts/bundle_logs.sh" \
    "check_file 'logs/TERMINAL_EXCERPTS.txt' 'Terminal excerpts' && check_file 'logs/STATS_EXCERPTS.txt' 'Stats excerpts'"

# Step 9: Generate Delta Analysis (Optional)
echo ""
echo "🔄 Step: Generate Delta Analysis (Optional)"
echo "Command: python3 scripts/diff_table.py"
echo "----------------------------------------"
if python3 scripts/diff_table.py; then
    echo "✅ Delta Analysis completed successfully"
    check_file 'results/phase3_drowsy_deltas.csv' 'Delta analysis CSV'
else
    echo "⚠️  Delta Analysis failed (this is optional)"
fi

echo ""
echo "=========================================="
echo "🎉 SmartEdgeAI Workflow Complete!"
echo "=========================================="
echo ""
echo "📊 Results Summary:"
echo "• Simulation results: /home/carlos/projects/gem5/gem5-data/SmartEdgeAI/results/"
echo "• Logs: /home/carlos/projects/gem5/gem5-data/SmartEdgeAI/logs/"
echo "• Mirrored results: results/"
echo "• Mirrored logs: logs/"
echo ""
echo "📈 Generated Files:"
echo "• summary.csv - Raw simulation statistics"
echo "• summary_energy.csv - Energy and power calculations"
echo "• fig_epi_across_workloads.png - Energy per instruction plot"
echo "• fig_tinyml_edp.png - Energy-delay product plot"
echo "• TERMINAL_EXCERPTS.txt - Simulation output excerpts"
echo "• STATS_EXCERPTS.txt - Statistics excerpts"
echo ""
echo "🔍 To view results:"
echo "• CSV files: head -5 results/summary_energy.csv"
echo "• Plots: open results/fig_*.png"
echo "• Logs: cat logs/TERMINAL_EXCERPTS.txt"
