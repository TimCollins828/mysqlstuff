-- RUN THIS SCRIPT AFTER PRODUCTION RELEASE

-- ASSUMPTION 
--	1. NON PROD FILE SERVER (hrewwnonprdfs01)
--  2. REPORTING SERVER IS HRDEVAP1026.  *This will change once we SSRS 2014 is setup.
--  3. New 2014 SQL Server name is HREWWDEVDB1218 instance is DEV1*
--  *special note. due to OA team using dev1 front of EAPS applications.  We will use dev2 front end and point it to hrewwdevdb1218\dev1 instance.


USE EAPS
GO

-- UPDATE HELPFILES

UPDATE HelpFiles
SET FilePath = REPLACE(FilePath, '\\hrinffp1001\Output\Production\prd\eaps\Help', '\\hrewwnonprdfs01\Output\Development\dev2\eaps\Help')

-- UPDATE TM_FORMS_METADATA

UPDATE TM_FORMS_METADATA
SET FILE_PATH = replace(FILE_PATH, '\\hrinffp1001.WASHDC.STATE.SBU\ElectronicDocuments\Production\prd\', '\\hrewwnonprdfs01.WASHDC.STATE.SBU\ElectronicDocuments\Development\dev2\')

UPDATE TM_FORMS_METADATA
SET PDF_FILE_PATH = replace(PDF_FILE_PATH, '\\hrinffp1001.WASHDC.STATE.SBU\ElectronicDocuments\Production\prd\', '\\hrewwnonprdfs01.WASHDC.STATE.SBU\ElectronicDocuments\Development\dev2\')

-- UPDATE EAPS_REPORT_METADATA 

UPDATE EAPS_REPORT_METADATA 
SET REPORT_PARAMETERS = '<root>
  <reportServerUrl>https://hrdev.hr.state.sbu/Reportserver</reportServerUrl>
  <parameter>
    <fieldName type="JOB_GUID" display="0" required="1">JOB_GUID</fieldName>
  </parameter>
  <reportPath>/EAPS/MClass/JobReportForm</reportPath>
  <reportName>JobReport</reportName>
</root>'
WHERE REPORT_NAME = 'JobReport' and DATABASE_NAME = 'CAJE'

UPDATE EAPS_REPORT_METADATA 
SET REPORT_PARAMETERS = '<root>
  <reportServerUrl>https://hrdev.hr.state.sbu/Reportserver</reportServerUrl>
  <parameter>
    <fieldName type="POSITION_DESCRIPTION_GUID" display="0" required="1">POSITION_DESCRIPTION_GUID</fieldName>
  </parameter>
  <reportPath>/EAPS/MClass/DS298Form</reportPath>
  <reportName>DS298</reportName>
</root>'
WHERE REPORT_NAME = 'DS298' and DATABASE_NAME = 'CAJE'

UPDATE EAPS_REPORT_METADATA 
SET REPORT_PARAMETERS = '<root>
  <reportServerUrl>https://hrdev.hr.state.sbu/Reportserver</reportServerUrl>
  <parameter>
    <fieldName type="searchForLastName" display="1" required="0">name</fieldName>
    <fieldName type="contactType" display="1" required="0">acptsContactTypeID</fieldName>
    <fieldName type="regionDescription" display="1" required="0">acptsRegionID</fieldName>
    <fieldName type="province" display="1" required="0">acptsProvince</fieldName>
    <fieldName type="site" display="1" required="0">acptsSiteID</fieldName>
    <spName>ACPTS_rptContactInfo</spName>
  </parameter>
  <reportName>Contact Type</reportName>
</root>'
WHERE REPORT_NAME = 'Contact Information' and DATABASE_NAME = 'EAPS'

UPDATE EAPS_REPORT_METADATA 
SET REPORT_PARAMETERS = '<root>
  <reportServerUrl>https://hrdev.hr.state.sbu/Reportserver</reportServerUrl>
  <parameter>
    <fieldName type="searchForLastName" display="1" required="0">name</fieldName>
    <fieldName type="regionDescription" display="1" required="0">acptsRegionID</fieldName>
    <fieldName type="acptsAgency" display="1" required="0">acptsAgency</fieldName>
    <fieldName type="employeeType" display="1" required="0">acptsEmployeeTypeID</fieldName>
    <fieldName type="province" display="1" required="0">acptsProvince</fieldName>
    <fieldName type="site" display="1" required="0">acptsSiteID</fieldName>
    <fieldName type="startDate" display="1" required="0">acptsStartDate</fieldName>
    <fieldName type="endDate" display="1" required="0">acptsEndDate</fieldName>
  </parameter>
  <spName>ACPTS_rptEntryLevelPersonnel</spName>
  <reportName>Entry Level Personnel</reportName>
</root>'
WHERE REPORT_NAME = 'Entry Level Personnel' and DATABASE_NAME = 'EAPS'

UPDATE EAPS_REPORT_METADATA 
SET REPORT_PARAMETERS = '<root>
  <reportServerUrl>https://hrdev.hr.state.sbu/Reportserver</reportServerUrl>
  <parameter>
    <fieldName type="searchForLastName" display="1" required="0">name</fieldName>
    <fieldName type="site" display="1" required="0">acptsSiteID</fieldName>
    <fieldName type="acptsAgency" display="1" required="0">acptsAgency</fieldName>
    <fieldName type="province" display="1" required="0">acptsProvince</fieldName>
    <fieldName type="regionDescription" display="1" required="0">acptsRegionID</fieldName>
    <fieldName type="documentType" display="1" required="0">acptsDocumentTypeID</fieldName>
    <fieldName type="expirationFromDate" display="1" required="0">acptsExpirationFromDate</fieldName>
    <fieldName type="expirationToDate" display="1" required="0">acptsExpirationToDate</fieldName>
    <spName>ACPTS_rptExpiringTravelDocs</spName>
  </parameter>
  <reportName>Expiration Travel Documents</reportName>
</root>'
WHERE REPORT_NAME = 'Expiring Travel Documents' and DATABASE_NAME = 'EAPS'

UPDATE EAPS_REPORT_METADATA 
SET REPORT_PARAMETERS = '<root>
  <reportServerUrl>https://hrdev.hr.state.sbu/Reportserver</reportServerUrl>
  <parameter>
    <fieldName type="searchForLastName" display="1" required="0">name</fieldName>
    <fieldName type="site" display="1" required="0">acptsSiteID</fieldName>
    <fieldName type="acptsAgency" display="1" required="0">acptsAgency</fieldName>
    <fieldName type="province" display="1" required="0">acptsProvince</fieldName>
  </parameter>
  <spName>ACPTS_rptPersonnelbyAgency</spName>
  <reportName>Personnel by Agency</reportName>
</root>'
WHERE REPORT_NAME = 'Personnel by Agency' and DATABASE_NAME = 'EAPS'

UPDATE EAPS_REPORT_METADATA 
SET REPORT_PARAMETERS = '<root>
  <reportServerUrl>https://hrdev.hr.state.sbu/Reportserver</reportServerUrl>
  <parameter>
    <fieldName type="searchForLastName" display="1" required="0">name</fieldName>
    <fieldName type="site" display="1" required="0">acptsSiteID</fieldName>
    <fieldName type="regionDescription" display="1" required="0">acptsRegionID</fieldName>
    <fieldName type="acptsAgency" display="1" required="0">acptsAgency</fieldName>
    <fieldName type="province" display="1" required="0">acptsProvince</fieldName>
    <fieldName type="siteArrivalDate" display="1" required="0">acptsSiteArrivalDate</fieldName>
    <fieldName type="siteDepartureDate" display="1" required="0">acptsSiteDepartureDate</fieldName>
  </parameter>
  <spName>ACPTS_rptPersonnelMovements</spName>
  <reportName>Personnel Movement</reportName>
</root>'
WHERE REPORT_NAME = 'Personnel Movement' and DATABASE_NAME = 'EAPS'

UPDATE EAPS_REPORT_METADATA 
SET REPORT_PARAMETERS = '<root>
  <reportServerUrl>https://hrdev.hr.state.sbu/Reportserver</reportServerUrl>
  <parameter>
    <fieldName type="searchForLastName" display="1" required="0">name</fieldName>
    <fieldName type="startDate" display="1" required="0">acptsStartDate</fieldName>
    <fieldName type="endDate" display="1" required="0">acptsEndDate</fieldName>
    <fieldName type="regionDescription" display="1" required="0">acptsRegionID</fieldName>
    <fieldName type="province" display="1" required="0">acptsProvince</fieldName>
    <fieldName type="site" display="1" required="0">acptsSiteID</fieldName>
    <fieldName type="acptsAgency" display="1" required="0">acptsAgency</fieldName>
  </parameter>
  <spName>ACPTS_rptRegionPosAssign</spName>
  <reportName>Personnel</reportName>
</root>'
WHERE REPORT_NAME = 'Personnel Report' and DATABASE_NAME = 'EAPS'

UPDATE EAPS_REPORT_METADATA 
SET REPORT_PARAMETERS = '<root>
  <reportServerUrl>https://hrdev.hr.state.sbu/Reportserver</reportServerUrl>
  <parameter>
    <fieldName type="searchForLastName" display="1" required="0">name</fieldName>
    <fieldName type="site" display="1" required="0">acptsSiteID</fieldName>
    <fieldName type="position" display="1" required="0">acptsPositionID</fieldName>
    <fieldName type="regionDescription" display="1" required="0">acptsRegionID</fieldName>
    <fieldName type="acptsAgency" display="1" required="0">acptsAgency</fieldName>
    <fieldName type="province" display="1" required="0">acptsProvince</fieldName>
    <fieldName type="employeeType" display="1" required="0">acptsEmployeeTypeID</fieldName>
  </parameter>
  <spName>ACPTS_rptSiteDiscrepancy</spName>
  <reportName>Site Discrepancy</reportName>
</root>'
WHERE REPORT_NAME = 'Site Discrepancy' and DATABASE_NAME = 'EAPS'

-- STD_APPLICATION

UPDATE STD_APPLICATION
SET EMAIL_OVERRIDE_TXT = 'HREAPSAlerts@state.gov'

UPDATE STD_APPLICATION
SET APP_VERSION_TXT = REPLACE(APP_VERSION_TXT, 'PROD', 'DEV')


-- EAPS_Config
UPDATE EAPS_Config
SET EAPS_Config_Type_Value = 'HREAPSAlerts@state.gov'
WHERE EAPS_Config_Type = 'LCQ_EMAIL_OVERRIDE_ACCOUNT'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = 'HREAPSAlerts@state.gov'
WHERE EAPS_Config_Type = 'MCLASS_EMAIL_OVERRIDE_ACCOUNT'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = 'HREAPSAlerts@state.gov'
WHERE EAPS_Config_Type = 'TV_EMAIL_OVERRIDE_ACCOUNT'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value ='https://hrdev.hr.state.sbu/Reportserver'
WHERE EAPS_Config_Type = 'TM_REPORT_SERVER_URL'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value ='https://hrdev.hr.state.sbu/Reportserver'
WHERE EAPS_Config_Type = 'EAPS_REPORT_SERVER_URL'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value ='https://hrdev.hr.state.sbu/Reportserver/ReportService.asmx'
WHERE EAPS_Config_Type = 'EAPS_REPORT_MANAGER_URL'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = 'https://hrdev.hr.state.sbu/dev2/OPS'
WHERE EAPS_Config_Type = 'OPS_URL_ROOT'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = 'HREAPS@state.gov'
WHERE EAPS_Config_Type = 'OPS_EMAIL_CHARLESTON_MAILBOX'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = 'HREAPS@state.gov'
WHERE EAPS_Config_Type = 'OPS_EMAIL_FROM_ACCOUNT'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = 'HREAPSAlerts@state.gov'
WHERE EAPS_Config_Type = 'TMPDFSERVICE_DS1707MailList'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = 'HREAPSAlerts@state.gov'
WHERE EAPS_Config_Type = 'TMPDFSERVICE_TM5CableMailList'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = 'https://hrdev.hr.state.sbu/dev2/gsr/'
WHERE EAPS_Config_Type = 'ESERVICES_URL'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = 'HREAPSAlerts@state.gov'
WHERE EAPS_Config_Type = 'TMPDFSERVICE_DS1552MailList'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = '\\hrewwnonprdfs01.washdc.state.sbu\ElectronicDocuments\Development\dev2\tm\tmfive\'
WHERE EAPS_Config_Type = 'TMPDFSERVICE_TM5CablePDFWritePath'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = 'https://hrdev.hr.state.sbu/dev2/hrsar/'
WHERE EAPS_Config_Type = 'HRSAR_URL'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = '\\hrewwnonprdfs01.washdc.state.sbu\ElectronicDocuments\Development\dev2\tm\tmeight\'
WHERE EAPS_Config_Type = 'TMPDFSERVICE_TM8CablePDFWritePath'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = 'Data Source=HREWWDEVDB1218\DEV1;Database=EAPS;Integrated Security=SSPI;'
WHERE EAPS_Config_Type = 'TMPDFSERVICE_Connection'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = 'HREAPSAlerts@state.gov'
WHERE EAPS_Config_Type = 'TMPDFSERVICE_TM8CableMailList'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = 'https://hrdev.hr.state.sbu/dev2/eaps/'
WHERE EAPS_Config_Type = 'EAPS_URL'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = '\\hrewwnonprdfs01.washdc.state.sbu\ElectronicDocuments\Development\dev2\tm\ds1707\'
WHERE EAPS_Config_Type = 'TMPDFSERVICE_DS1707PdfFileWritePath'


UPDATE EAPS_Config
SET EAPS_Config_Type_Value = '\\hrewwnonprdfs01.washdc.state.sbu\Output\Development\dev2\eaps\'
WHERE EAPS_Config_Type = 'EAPS_DIR'


UPDATE EAPS_Config
SET EAPS_Config_Type_Value = 'https://hrdev.hr.state.sbu/dev2/eaps/'
WHERE EAPS_Config_Type = 'LEP_WEB_SERVER_PATH'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = '\\hrewwnonprdfs01.washdc.state.sbu\ElectronicDocuments\Development\dev2\tm\ds1552\'
WHERE EAPS_Config_Type = 'TMPDFSERVICE_DS1552PdfFileWritePath'

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = 'HREAPS@state.gov'
WHERE EAPS_Config_TYPE = 'ADMIN_EMAIL_FROM_ADDRESS' 

UPDATE EAPS_Config
SET EAPS_Config_Type_Value = 'HREAPSAlertsNonProd@state.gov'
WHERE EAPS_Config_TYPE = 'ADMIN_EMAIL_OVERRIDE_ACCOUNT' 


-- ADMIN_POSTCOMPLETE
UPDATE ADMIN_POSTCOMPLETE
SET INTEREST_TXT = ''

-- EAPS_BATCH_SCHEDULE
UPDATE dbo.EAPS_BATCH_SCHEDULE
SET IS_ACTIVE = 0


UPDATE dbo.EAPS_BATCH_SCHEDULE
SET IS_ACTIVE = 1
WHERE BATCH_SCHEDULE_GUID = 'ccd946d8-41f6-43f0-a0dc-60f2b3203945'

UPDATE EAPS_API_HOST SET Query = REPLACE(Query, '.PRD', '.DEV2')



