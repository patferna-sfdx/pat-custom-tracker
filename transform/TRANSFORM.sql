INSERT INTO PmdReport
SELECT 
    "1" as "Problem",
    "" as "Package",
    substr(Cpd."occ1_file", instr(Cpd."occ1_file", "/classes")+1, length(Cpd."occ1_file")-instr(Cpd."occ1_file", "/classes")) as "File",
    "3" as "Priority",
    Cpd."occ1_line" as "Line",
    "Between lines " || Cpd."occ1_line" || " and " || CAST(CAST(Cpd."occ1_line" AS INTEGER) + CAST(Cpd."occ1_nblines" AS INTEGER) AS TEXT) || " ("  || Cpd."tokens" || " tokens)" as "Description",
    "Design" as "Rule set",
    "Copy Paste" as "Rule"
FROM CpdReport Cpd;

INSERT INTO PmdReport
SELECT 
    "1" as "Problem",
    "" as "Package",
    substr(Cpd."occ2_file", instr(Cpd."occ2_file", "/classes")+1, length(Cpd."occ2_file")-instr(Cpd."occ2_file", "/classes")) as "File",
    "3" as "Priority",
    Cpd."occ2_line" as "Line",
    "Between lines " || Cpd."occ2_line" || " and " || CAST(CAST(Cpd."occ2_line" AS INTEGER) + CAST(Cpd."occ2_nblines" AS INTEGER) AS TEXT) || " ("  || Cpd."tokens" || " tokens)" as "Description",
    "Design" as "Rule set",
    "Copy Paste" as "Rule"
FROM CpdReport Cpd;

INSERT INTO PmdReport
SELECT 
    "1" as "Problem",
    "" as "Package",
    substr(Cpd."occ3_file", instr(Cpd."occ3_file", "/classes")+1, length(Cpd."occ3_file")-instr(Cpd."occ3_file", "/classes")) as "File",
    "3" as "Priority",
    Cpd."occ3_line" as "Line",
    "Between lines " || Cpd."occ3_line" || " and " || CAST(CAST(Cpd."occ3_line" AS INTEGER) + CAST(Cpd."occ3_nblines" AS INTEGER) AS TEXT) || " ("  || Cpd."tokens" || " tokens)" as "Description",
    "Design" as "Rule set",
    "Copy Paste" as "Rule"
FROM CpdReport Cpd
WHERE Cpd."occurrences" = 3;

UPDATE PmdReport
SET File = File || "-meta.xml"
WHERE "Rule set" != 'Custom Apex Rules';

INSERT INTO PmdReportV2
SELECT 
	*, 
	ROW_NUMBER() OVER(PARTITION BY pmd."File" ORDER BY pmd."File", pmd."Rule set", pmd."Rule") AS "Index"
FROM PmdReport pmd;

INSERT INTO MetadataFile__c
SELECT DISTINCT
	substr(substr(File, instr(File, "/")+1, length(File)-instr(File, "/")), 1, 80) as "Name",
	substr(File, instr(File, "/")+1, length(File)-instr(File, "/")) as "ExternalId__c",
    substr(File, 1, instr(File, "/")-1) as "Type__c"
FROM PmdReportV2 pmd
GROUP BY File, pmd."Rule set";

INSERT INTO RuleSetResult__c
SELECT DISTINCT
    strftime('%Y%m%d', DATE('now')) || "-" || substr(File, instr(File, "/")+1, length(File)-instr(File, "/"))
	|| "-" ||
	CASE
		WHEN pmd."Rule set" = 'Custom Apex Rules' AND instr(Rule, 'LowCode') > 0 THEN 'LowCode vs ProCode'
		WHEN pmd."Rule set" = 'Custom Apex Rules' AND instr(Rule, 'ProCode') > 0 THEN 'LowCode vs ProCode'
		ELSE pmd."Rule set"
	END
	as "ExternalId__c",
    strftime('%Y-%m-%d', DATE('now')) as "ReportDate__c",
	substr(File, instr(File, "/")+1, length(File)-instr(File, "/")) as "MetadataFile__r.ExternalId__c",
	CASE
		WHEN pmd."Rule set" = 'Custom Apex Rules' AND instr(Rule, 'LowCode') > 0 THEN 'LowCode vs ProCode'
		WHEN pmd."Rule set" = 'Custom Apex Rules' AND instr(Rule, 'ProCode') > 0 THEN 'LowCode vs ProCode'
		ELSE pmd."Rule set"
	END AS "Type__c"
FROM PmdReportV2 pmd
GROUP BY File, pmd."Rule set", Rule;

INSERT INTO RuleResult__c
SELECT
    strftime('%Y%m%d', DATE('now'))
	|| "-" || substr(File, instr(File, "/")+1, length(File)-instr(File, "/"))
	|| "-" ||
	CASE
		WHEN pmd."Rule set" = 'Custom Apex Rules' AND instr(Rule, 'LowCode') > 0 THEN 'LowCode vs ProCode'
		WHEN pmd."Rule set" = 'Custom Apex Rules' AND instr(Rule, 'ProCode') > 0 THEN 'LowCode vs ProCode'
		ELSE pmd."Rule set"
	END
	as "RuleSetResult__r.ExternalId__c",
    strftime('%Y%m%d', DATE('now'))
	|| "-" || substr(File, instr(File, "/")+1, length(File)-instr(File, "/"))
	|| "-" || pmd."Index" as "ExternalId__c",
    pmd."Index" as "Problem__c",
    Line as "Line__c",
    Description as "Description__c",
    Rule as "Name",
	substr(File, instr(File, "/")+1, length(File)-instr(File, "/")) as "MetadataFile__r.ExternalId__c",
	CASE
		WHEN Priority = '5' AND instr(Rule, 'LowCode') > 0 THEN CAST(Priority AS INTEGER)+1
		ELSE Priority
	END AS "Priority__c"
FROM PmdReportV2 pmd
GROUP BY File, pmd."Index", Rule, Line, Priority, Description;