INSERT INTO MetadataFile__c
SELECT
    substr(substr(File, instr(File, "/")+1, length(File)-instr(File, "/")), 1, 80) as "Name",
    substr(File, instr(File, "/")+1, length(File)-instr(File, "/")) as "ExternalId__c",
    substr(File, 1, instr(File, "/")-1) as "Type__c"
FROM PmdReport;

INSERT INTO RuleSetResult__c
SELECT
    strftime('%Y%m%d', DATE('now')) || "-" || substr(File, instr(File, "/")+1, length(File)-instr(File, "/")) as "ExternalId__c",
    strftime('%Y-%m-%d', DATE('now')) as "ReportDate__c",
    substr(File, instr(File, "/")+1, length(File)-instr(File, "/")) as "MetadataFile__r.ExternalId__c",
    pmd."Rule set" as "Type__c"
FROM PmdReport pmd;

INSERT INTO RuleResult__c
SELECT
    strftime('%Y%m%d', DATE('now')) || "-" || substr(File, instr(File, "/")+1, length(File)-instr(File, "/")) as "RuleSetResult__r.ExternalId__c",
    strftime('%Y%m%d', DATE('now')) || "-" || substr(File, instr(File, "/")+1, length(File)-instr(File, "/")) || "-" || Problem as "ExternalId__c",
    Problem as "Problem__c",
    Line as "Line__c",
    Description as "Description__c",
    Rule as "Name",
    substr(File, instr(File, "/")+1, length(File)-instr(File, "/")) as "MetadataFile__r.ExternalId__c",
    Priority as "Priority__c"
FROM PmdReport pmd;

