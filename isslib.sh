# ISS Art bash library  v.1.2.0

# display a standartized message
function msg {
  DATE=$(date "+%Y-%m-%d %H:%M:%S")
  echo -e "\n-----------------------------------------------------"
  echo -e " ${DATE} - ${1}"
}

# display a meassge and exit with a code
function exitMsg {
  msg "${1}"
  exit ${2:-0}
}

# display a standartized error message
function errorMsg {
  exitMsg "[!] Error: ${1}" "${2:-1}"
}

# start measuring of the run time
# ${1} - any value to display the starting message
function runTimeBegin {
  iss_runTimeBegin=`date +%s`
  if [ -n "${1}" ]; then
    msg "Execution started at `date +%T`."
  fi
}

# finish measuring of the run time
# ${1} - any value to display the finishing message
function runTimeEnd {
  iss_runTimeEnd=`date +%s`
  iss_runTime=$(( ${iss_runTimeEnd} - ${iss_runTimeBegin} ))
  if [ -n "${1}" ]; then
    msg "Execution time was ${iss_runTime} seconds."
  else
    runTime=${iss_runTime}
  fi
}
