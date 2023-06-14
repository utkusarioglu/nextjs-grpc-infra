-- FUNCTIONS
REVOKE ALL ON FUNCTION inflation."view_multi_country" FROM "{{name}}";

-- TABLES
REVOKE ALL ON TABLE inflation."decade_stats" FROM "{{name}}";
REVOKE ALL ON TABLE inflation."with_decades" FROM "{{name}}";
REVOKE ALL ON TABLE inflation."inflation_data" FROM "{{name}}";
REVOKE ALL ON TABLE inflation."country_list" FROM "{{name}}";
REVOKE ALL ON TABLE inflation."indicator_list" FROM "{{name}}";

-- SCHEMAS
REVOKE ALL ON SCHEMA inflation FROM "{{name}}";

-- DATABASES
REVOKE ALL ON DATABASE inflation FROM "{{name}}";
