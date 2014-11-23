bash test_combination.sh >dummy
awk -f analysis.awk dummy > analysis_output
rm dummy
