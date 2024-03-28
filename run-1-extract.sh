#!/bin/sh
if [ -e pmd-bin-6.55.0 ]
then
	echo "pmd-bin-6.55.0 found"
else
	echo "pmd-bin-6.55.0 not found"
	wget https://github.com/pmd/pmd/releases/download/pmd_releases%2F6.55.0/pmd-bin-6.55.0.zip
	unzip pmd-bin-6.55.0.zip
fi
pmd-bin-6.55.0/bin/run.sh pmd --minimum-priority 5 --fail-on-violation false -d force-app -R custom-vs-standard-ruleset.xml -f csv -l apex -r transform/in/PmdReport.csv -z force-app/main/default
pmd-bin-6.55.0/bin/run.sh cpd --minimum-tokens 65 --dir force-app/main/default --language apex --format csv_with_linecount_per_file > transform/in/CpdReport.csv