clear
export ROOT=$(pwd)

# gedit ~/.bashrc
# module load cadence/xcelium*
module purge
module load cadence/genus/251
module load cadence/innovus/251 

export CDS_AUTO_64BIT="ALL"

export cons="${ROOT}/constraints"
export lyt="${ROOT}/layout"
export lib="${ROOT}/lib"
export logs="${ROOT}/logs"
export scr="${ROOT}/scripts"
export src="${ROOT}/src"
export syn="${ROOT}/synthesis"
export tests="${ROOT}/src/tests"

export work_dir="${ROOT}/work"
#------------------------------------

if [ "$1" = "cfg" ]; then
    read -p "Novo tech node [XH180 | TC65N | 22FDX]: " tech_node_used
    echo $tech_node_used > .tech_node
    echo "Saved!"
    exit 0
fi

if [ -f .tech_node ]; then
    tech_node_used=$(cat .tech_node)
else
    tech_node_used="XH180"
fi

export tech_node_used
export design=${2}

# ------------------------------------

if [ ! -d "$work_dir" ]; then
  mkdir -p "$work_dir"
fi
cd $work_dir

check_file() {
  if [ -z "$design" ]; then
  echo -e "\033[1;31mError: Missing design name\033[0m"
  echo "Type ./run.sh -h"
  exit 1
  fi
  if [ ! -f "$1" ]; then
    echo -e "\033[1;31mError: File not found -> $1\033[0m"
    exit 1
  fi
}
check_dir() {
  if [ -z "$design" ]; then
  echo -e "\033[1;31mError: Missing design name\033[0m"
  echo "Type ./run.sh -h"
  exit 1
  fi
  if [ ! -d "$1" ]; then
    echo -e "\033[1;31mError: Directory not found -> $1\033[0m"
    exit 1
  fi
}

check_point() {
  if [ -z "$design" ]; then
  echo -e "\033[1;31mError: Missing design name\033[0m"
  echo "Type ./run.sh -h"
  exit 1
  fi
  if [ ! -d "$1" ]; then
    echo -e "\033[1;31mError: Checkpoint not found -> {$2}\033[0m"
    echo "Missing argument?"
    echo -e "\033[1;31mType ./run.sh -h\033[0m"
    exit 1
  fi
}

case ${1} in
  x)
    check_file "${src}/${design}.sv"
    check_file "${tests}/${design}_tb.sv"

    module load cadence/xcelium/2503
    xrun -clean
    echo -e "\033[1;33mExecuting HDL simulation...\033[0m"
    xrun -f ${scr}/xrun.conf
  ;;
  xs)
    check_file "${syn}/${design}_${tech_node_used}/${design}.v"
    check_file "${tests}/${design}_tb.sv"

    module load cadence/xcelium/2503
    xrun -clean
    echo -e "\033[1;33mExecuting Post-Synthesis simulation...\033[0m"
    # xmsdfc -iocondsort -compile ${scr}/cmd/deliverables/${DESIGNS}.sdf
    xrun -f ${scr}/xrun_syn.conf
  ;;
  xl)
    check_file "${lyt}/${design}_${tech_node_used}/${design}_lyt.v"
    check_file "${tests}/${design}_tb.sv"

    module load cadence/xcelium/2503
    xrun -clean
    echo -e "\033[1;33mExecuting Post-P&R simulation...\033[0m"
    xrun -f ${scr}/xrun_lyt.conf 
  ;;
  xg)
    check_file "${src}/${design}.sv"
    check_file "${tests}/${design}_tb.sv"

    module load cadence/xcelium/2503
    xrun -clean
    echo -e "\033[1;33mExecuting HDL simulation with gui...\033[0m"
    xrun -gui -f ${scr}/xrun.conf
  ;;
  xc)
    check_file "${src}/${design}.sv"
    check_file "${tests}/${design}_tb.sv"

    module load cadence/xcelium/2503
    echo -e "\033[1;33mCompiling HDL...\033[0m"
    xrun -compile ${src}/${design}.sv ${tests}/${design}_tb.sv
  ;;
  xe)
    check_file "${src}/${design}.sv"
    check_file "${tests}/${design}_tb.sv"

    module load cadence/xcelium/2503
    echo -e "\033[1;33mElaborating HDL...\033[0m"
    xrun -elaborate ${src}/${design}.sv ${tests}/${design}_tb.sv
  ;;
  g) 
    check_file "${src}/${design}.sv"

    echo -e "\033[1;33mExecuting logic synthesis...\033[0m"
    genus -a -o -logs "${logs}/genus.log" \
    -f ${scr}/logic_synt.tcl
  ;;
  gg)
    echo -e "\033[1;33mExecuting Genus...\033[0m"
    genus -a -o -logs "${logs}/genus.log"
  ;;
  gd)
    echo -e "\033[1;33mExecuting Genus Database...\033[0m"
    genus -a -o -logs "${logs}/genus.log" -db ${syn}/${design}_${tech_node_used}/checkpoint/${design}.enc
  ;;
  i)
    check_file "${syn}/${design}_${tech_node_used}/${design}.v"

    echo -e "\033[1;33mExecuting Physical Synthesis...\033[0m";
    innovus -stylus -abort_on_error -overwrite -log "${logs}/innovus.log ${logs}/innovus.cmd" \
    -files ${scr}/phy_synt.tcl
  ;;
  id)
    check_point "${lyt}/${design}_${tech_node_used}/checkpoint/${design}_${3}.enc" "${3}"

    echo -e "\033[1;33mLoading Innovus DataBase...\033[0m";
    innovus -stylus -abort_on_error -overwrite -db ${lyt}/${design}_${tech_node_used}/checkpoint/${design}_${3}.enc
  ;;
  ii)
    echo -e "\033[1;33mExecuting Innovus...\033[0m";
    innovus -stylus -abort_on_error -overwrite
  ;;
  all)    
    echo -e "\033[1;33mExecuting logic synthesis...\033[0m"
    genus -a -o -b -logs "${logs}/genus.log ${logs}/genus.cmd" \
    -f ${scr}/logic_synt.tcl
    
    echo -e "\033[1;33mExecuting pyshical synthesis...\033[0m";
    innovus -stylus -abort_on_error -overwrite -log "${logs}/innovus.log ${logs}/innovus.cmd" \
    -files ${scr}/phy_synt.tcl
  ;;
  -h)
    echo -e "\033[1;36mScript Help\033[0m";
    echo "Usage: ./run.sh <option> <design_name> <aditional_args>"
    echo ""
    echo "Options:"
    echo "  x    - HDL simulation"
    echo "  xs   - Post-synthesis simulation"
    echo "  xl   - Post-layout simulation"
    echo "  xg   - Xcelium simulation with GUI"
    echo "  xc   - Xcelium compile (design and testbench)"
    echo "  xe   - Xcelium elaborate"
    echo "  g    - Scripted synthesis"
    echo "  i    - Scripted place and route"
    echo "  id   - Innovus with database (Need to specify the checkpoint as 3rd argument)"
    echo "  ii   - Just Innovus"
    echo "  all  - Full flow (logical + physical synthesis)"
    echo ""
    echo "Arguments:"
    echo "  <design_name>   Name of the design to be used"
    echo ""
    echo "Example:"
    echo "  ./run.sh x my_design"
  ;;
  -dbg)
    echo -e "\033[1;33m[Debug mode]\033[0m";
    echo $tech_node_used
    echo $tech_node
  ;;
  *)
    echo -e "\033[1;31mError: Unknown argument \"${1}\"\033[0m"
    echo "Type ./run.sh -h"
esac
