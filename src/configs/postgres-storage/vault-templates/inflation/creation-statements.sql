-- DATABASES
GRANT CONNECT ON DATABASE inflation TO "{{name}}";

-- SCHEMAS
GRANT USAGE ON SCHEMA inflation TO "{{name}}";

-- TABLES
GRANT SELECT ON TABLE inflation."decade_stats" TO "{{name}}";
GRANT SELECT ON TABLE inflation."with_decades" TO "{{name}}";
GRANT SELECT ON TABLE inflation."inflation_data" TO "{{name}}";
GRANT SELECT ON TABLE inflation."country_list" TO "{{name}}";
GRANT SELECT ON TABLE inflation."indicator_list" TO "{{name}}";

-- FUNCTIONS
GRANT EXECUTE ON FUNCTION inflation."view_multi_country" TO "{{name}}";
