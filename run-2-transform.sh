#!/bin/sh
sqlite3 transform/pat-custom-tracker.db <<EOF
.read transform/CREATE_TABLES.sql

.mode csv
.import --skip 1 transform/in/PmdReport.csv PmdReport
.import --skip 1 transform/in/CpdReport.csv CpdReport

.mode column
.read transform/TRANSFORM.sql

.mode csv
.separator , "\n"

.output transform/out/1_MetadataFile__c.csv
SELECT * FROM MetadataFile__c;
.output stdout

.output transform/out/2_RuleSetResult__c.csv
SELECT * FROM RuleSetResult__c;
.output stdout

.output transform/out/3_RuleResult__c.csv
SELECT * FROM RuleResult__c;
.output stdout

.quit
EOF